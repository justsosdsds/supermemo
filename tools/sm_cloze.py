"""Cloze: turn a keyword into a deletion and produce a child Item.

Verified against a measured original-program delta (EXTEST_base -> EXTEST):

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

Only the target topic and its DIRECT children are touched. A global keyword
replace would silently rewrite unrelated articles — it is never used here.

NOT decoded and copied from the template: +10 unknownId, +28 AF[6], +103 ordinal[5]
"""
import os, struct, sys
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


def mark_parent_body(body, keyword):
    """Parent gets <SPAN class=cloze>[...]</SPAN>; outer extract span normalised."""
    kw = keyword.encode('utf-8')
    pos = body.find(kw)
    if pos < 0:
        raise ValueError('keyword not found in the target body')
    out = body[:pos] + CLOZE_OPEN + DELETION + CLOZE_CLOSE + body[pos + len(kw):]
    out = out.replace(b'<SPAN class=extract>', b'<SPAN>')
    out = out.replace(b'<FONT class=extract>', b'<FONT>')
    return out


def cloze(coll, topic_id, keyword, dry_run=False):
    P = W.paths(coll)
    info = W.load(P['info'])
    cont = W.load(P['cont'])
    comp = W.load(P['comp'])
    rtx = W.load(P['rtx'])
    mem = W.load(P['mem'])
    ptr = W.load(P['ptr'])

    els = W.parse_elements(info)
    topic = next((e for e in els if e['title_id'] == topic_id), None)
    if topic is None:
        return None, 'topic %d not found' % topic_id

    body_path = os.path.join(P['eldir'], '%d.HTM' % topic['slot'])
    if not os.path.exists(body_path):
        return None, 'topic has no HTM body'

    # ---- 1. parent markup ----
    body = open(body_path, 'rb').read()
    try:
        marked = mark_parent_body(body, keyword)
    except ValueError as e:
        return None, str(e)

    item_bytes = marked                                   # multi-line form
    title_bytes = single_line(marked)                     # single-line form
    keyword_bytes = keyword.encode('utf-8')

    # ---- 2. text records ----
    item_text_id = W.add_text(rtx, mem, ptr, item_bytes)
    title_text_id = item_text_id if title_bytes == item_bytes \
        else W.add_text(rtx, mem, ptr, title_bytes)
    kw_text_id = W.add_text(rtx, mem, ptr, keyword_bytes)

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

    # ---- 6. child body: keyword wrapped in class=clozed ----
    child_body_written = False
    child_body_path = os.path.join(P['eldir'], '%d.HTM' % slot_no)
    # every body under this topic that still has the bare keyword gets the marker
    touched = []
    for e in els:
        if e['title_id'] == -1:
            continue
        is_topic = (e['slot'] == topic['slot'])
        is_child = struct.unpack_from('<H', conts[e['slot'] - 1]['raw'], 1)[0] == topic['slot']
        if not (is_topic or is_child):
            continue
        fp = os.path.join(P['eldir'], '%d.HTM' % e['slot'])
        if not os.path.exists(fp):
            continue
        cb = open(fp, 'rb').read()
        if CLOZED_OPEN in cb or keyword.encode('utf-8') not in cb:
            continue
        nb = cb.replace(keyword.encode('utf-8'), CLOZED_OPEN + keyword.encode('utf-8') + CLOZE_CLOSE, 1)
        if not dry_run:
            open(fp, 'wb').write(nb)
        touched.append('%d.HTM' % e['slot'])

    if not dry_run:
        W.save_atomic(P['rtx'], rtx)
        W.save_atomic(P['mem'], mem)
        W.save_atomic(P['ptr'], ptr)
        W.save_atomic(P['comp'], comp)
        W.save_atomic(P['info'], info)
        W.save_atomic(P['cont'], W.concat_contents(conts))
        open(body_path, 'wb').write(marked)

    return dict(slot=slot_no, parent=topic_id, title_id=title_text_id,
                item_text_id=item_text_id, kw_text_id=kw_text_id,
                comp_pos=comp_pos, comp_len=len(block), reused=bool(free),
                child_marked=touched), None


def main():
    if len(sys.argv) < 4:
        print('usage: sm_cloze.py <collection> <topic_element_id> "<keyword>" [--dry]')
        return 1
    res, err = cloze(sys.argv[1], int(sys.argv[2]), sys.argv[3], '--dry' in sys.argv)
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
