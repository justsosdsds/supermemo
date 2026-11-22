"""Cloze: turn a keyword into a deletion and produce a child Item.

Historical sample observations (EXTEST_base / EXTEST; not a clean single-operation oracle).
Current writes are experimental; see IR_STATUS.md and TEXT_REGISTRY_EVIDENCE.md:

  parent body         <SPAN class=cloze>[...]</SPAN> replaces the keyword,
                      and an outer <SPAN class=extract> is normalised to <SPAN>
  child body          keeps the real keyword wrapped in
                      <SPAN class=clozed>keyword</SPAN>  (note the trailing d)
  child element       elementType = 0x01 (Item), unknownbyte1 = 0x01
  child components    TWO html components:
                        comp1  geo 100/57/9701/7848   displayAt 255  rid = item text
                        comp2  geo 100/7961/4989/1495 displayAt 223  rid = keyword text
  text records        titleTextId  = single-line form, placeholder collapsed to [.]
                      comp1.rid   = multi-line form, placeholder is [...]
                      comp2.rid   = the keyword itself
  (verified across slots 2/3/4 of EXTEST: titles carry no CRLF, component text does)

Only the target topic and the newly created child are written. Existing
children are not rewritten merely because they contain the same keyword.

NOT decoded and copied from the template: +10 unknownId, +28 AF[6], +103 ordinal[5]
"""
import os, struct, sys, argparse
from sm_selection import locate
from sm_transaction import commit_files, assert_ready
import smwrite as W

CLOZE_OPEN = b'<SPAN class=cloze>'          # parent side: 'cloze' (no d)
CLOZE_CLOSE = b'</SPAN>'
CLOZED_OPEN = b'<SPAN class=clozed>'        # child side: 'clozed' (with d)
DELETION = b'[...]'
TITLE_DELETION = b'[.]'


def single_line(text_bytes):
    """Title form: CRLF folded to spaces, placeholder collapsed."""
    t = text_bytes.replace(b'\r\n', b' ').replace(b'\n', b' ')
    return t.replace(DELETION, TITLE_DELETION)


def mark_parent_body(body, keyword, occurrence=None, byte_offset=None):
    """Parent gets <SPAN class=cloze>[...]</SPAN>; outer extract span normalised."""
    kw = keyword.encode('utf-8')
    pos = locate(body, kw, occurrence, byte_offset)
    out = body[:pos] + CLOZE_OPEN + DELETION + CLOZE_CLOSE + body[pos + len(kw):]
    out = out.replace(b'<SPAN class=extract>', b'<SPAN>')
    out = out.replace(b'<FONT class=extract>', b'<FONT>')
    return out


def cloze(coll, topic_id, keyword, dry_run=False, occurrence=None, byte_offset=None, experimental_registry=False):
    if not experimental_registry:
        return None, ('Text registry indexes are not fully reconstructed; use only a disposable copy '
                      'with --experimental-registry for research')
    coll = os.path.abspath(coll)
    assert_ready(coll)
    P = W.paths(coll)
    info = W.load(P['info'])
    cont = W.load(P['cont'])
    comp = W.load(P['comp'])
    rtx = W.load(P['rtx'])
    mem = W.load(P['mem'])
    ptr = W.load(P['ptr'])

    els = W.parse_elements(info)
    candidates = [e for e in els if e['title_id'] == topic_id and topic_id != -1]
    if len(candidates) > 1:
        return None, 'title id is shared by multiple elements; cannot select safely'
    topic = candidates[0] if candidates else None
    if topic is None:
        return None, 'topic %d not found' % topic_id

    body_path = os.path.join(P['eldir'], '%d.HTM' % topic['slot'])
    if not os.path.exists(body_path):
        return None, 'topic has no HTM body'

    # ---- 1. parent markup ----
    body = bytes(W.load(body_path))
    try:
        pos = locate(body, keyword, occurrence, byte_offset)
        marked = mark_parent_body(body, keyword, byte_offset=pos)
    except ValueError as e:
        return None, str(e)

    item_bytes = marked                                   # multi-line form
    title_bytes = single_line(marked)                     # single-line form
    keyword_bytes = keyword.encode('utf-8')

    # ---- 2. text records ----
    item_text_id = W.add_text(rtx, mem, ptr, item_bytes, experimental=True)
    title_text_id = item_text_id if title_bytes == item_bytes \
        else W.add_text(rtx, mem, ptr, title_bytes, experimental=True)
    kw_text_id = W.add_text(rtx, mem, ptr, keyword_bytes, experimental=True)

    # ---- 3. component block: two html components ----
    free = W.find_free_slot(els)
    slot_no = free['slot'] if free else len(els) + 1
    comp_pos = len(comp)
    block = W.build_block(
        slot_no,
        [W.GEO_CLOZE_Q, W.GEO_CLOZE_A],
        [item_text_id, kw_text_id])
    comp += block

    # ---- 4. element ----
    erec = W.new_element_record(topic, W.TYPE_ITEM, title_text_id, comp_pos)
    if free:
        idx = (free['slot'] - 1) * W.DIM
        info[idx:idx + W.DIM] = erec
    else:
        info += erec

    # ---- 5. contents ----
    conts = W.parse_contents(cont)
    child_ord = slot_no
    while len(conts) < child_ord:
        conts.append(dict(raw=bytes(W.CONTENT)))
    crec = bytearray(conts[child_ord - 1]['raw'])
    struct.pack_into('<H', crec, 1, topic['slot'])
    for off in (5, 9, 13, 17):
        struct.pack_into('<H', crec, off, 0)
    conts[child_ord - 1]['raw'] = bytes(crec)
    W.attach_child(conts, topic['slot'], child_ord)

    # Keep the answer in the new child's body; never rewrite existing siblings.
    child_body_path = os.path.join(P['eldir'], '%d.HTM' % slot_no)
    child_body = (body[:pos] + CLOZED_OPEN + keyword_bytes + CLOZE_CLOSE
                  + body[pos + len(keyword_bytes):])
    touched = ['%d.HTM' % slot_no]
    if not dry_run:
        commit_files(coll, {
            P['rtx']: rtx, P['mem']: mem, P['ptr']: ptr,
            P['comp']: comp, P['info']: info,
            P['cont']: W.concat_contents(conts),
            body_path: marked, child_body_path: child_body,
        })

    return dict(slot=slot_no, parent=topic_id, title_id=title_text_id,
                item_text_id=item_text_id, kw_text_id=kw_text_id,
                comp_pos=comp_pos, comp_len=len(block), reused=bool(free),
                child_marked=touched), None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('collection')
    parser.add_argument('topic_id', type=int)
    parser.add_argument('keyword')
    parser.add_argument('--dry', action='store_true')
    parser.add_argument('--experimental-registry', action='store_true',
                        help='unverified registry indexes; disposable copies only')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--occurrence', type=int, help='1-based visible literal match')
    group.add_argument('--byte-offset', type=int, help='UTF-8 source byte offset')
    args = parser.parse_args()
    res, err = cloze(args.collection, args.topic_id, args.keyword, args.dry,
                     args.occurrence, args.byte_offset, args.experimental_registry)
    if err:
        print('ERROR:', err)
        return 2
    print('cloze ok')
    for k in ('slot', 'parent', 'title_id', 'item_text_id', 'kw_text_id',
              'comp_pos', 'comp_len', 'reused', 'child_marked'):
        print('  %-13s %s' % (k, res[k]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
