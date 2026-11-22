"""Extract a selected paragraph into a child Topic — rebuilt on the verified
element/component layouts.

Historical sample observations (EXTEST_base / EXTEST; not a clean single-operation oracle).
Current writes are experimental; see IR_STATUS.md and TEXT_REGISTRY_EVIDENCE.md:

  body markup   "AAA first paragraph \r\n<P></P><SPAN class=extract>\r\n
                 <P>BBB second paragraph</P>\r\n<P></SPAN>CCC third paragraph"
                i.e. the previous paragraph's </P> is replaced by
                "space + CRLF + <P></P><SPAN class=extract> + CRLF", and </SPAN>
                is inserted right after the opening <P> of the NEXT paragraph.
  child element reuse of a free slot with titleTextId == -1
  child type     elementType = 0x00  (Topic)
  child record   +1 unknown1 = 0x01, +2 titleTextId = new text id,
                 +6 componPos = new offset in compon.dat
  component      ONE HTML component, geometry 100/200/9700/9300,
                 displayAt 255, registryId = the new text record
  contents       parent gains one child; kids = descendant count
  body file      elements\\<child slot>.HTM is written too

NOT decoded and therefore copied from the template verbatim:
  +10 unknownId, +28 AF[6], +103 ordinal[5]
"""
import os, struct, sys, argparse
from sm_selection import locate
from sm_transaction import commit_files, assert_ready
import smwrite as W


def wrap_selection(body, needle, occurrence=None, byte_offset=None):
    pos = locate(body, needle, occurrence, byte_offset)
    p_start = body.rfind(b'<P>', 0, pos)
    if p_start < 0:
        p_start = 0
    p_end = body.find(b'</P>', pos)
    p_end = len(body) if p_end < 0 else p_end + 4
    prev_close = body.rfind(b'</P>', 0, p_start)

    head = body[:prev_close] if prev_close >= 0 else body[:p_start]
    para = body[p_start:p_end]
    tail = body[p_end:]

    out = bytearray(head)
    out += b' \r\n<P></P><SPAN class=extract>\r\n'
    out += para
    if tail:
        out += b'\r\n<P></SPAN>'
        if tail.startswith(b'\r\n<P>'):
            tail = tail[len(b'\r\n<P>'):]
        elif tail.startswith(b'<P>'):
            tail = tail[3:]
    else:
        out += b'</SPAN>'
    out += tail
    return bytes(out)


def extract(coll, parent_id, selection, dry_run=False, occurrence=None, byte_offset=None, experimental_registry=False):
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
    candidates = [e for e in els if e['title_id'] == parent_id and parent_id != -1]
    if len(candidates) > 1:
        return None, 'title id is shared by multiple elements; cannot select safely'
    parent = candidates[0] if candidates else None
    if parent is None:
        return None, 'parent element %d not found' % parent_id

    free = W.find_free_slot(els)
    # template for undecoded fields: the parent itself
    template = parent

    # ---- 1. body markup ----
    body_path = os.path.join(P['eldir'], '%d.HTM' % parent['slot'])
    body_written = False
    wrapped = None
    if not os.path.exists(body_path):
        return None, 'parent has no HTM body'
    try:
        wrapped = wrap_selection(W.load(body_path), selection.encode('utf-8'), occurrence, byte_offset)
    except ValueError as exc:
        return None, str(exc)
    body_written = True

    # ---- 2. text records ----
    # Title text is the single-line form; the component's registryId is the
    # multi-line form.  For a one-paragraph extract they are identical and the
    # original reuses a single record (measured: slot3 titleId == comp rid).
    sel_bytes = selection.encode('utf-8')
    single = sel_bytes.replace(b'\r\n', b' ').replace(b'\n', b' ')
    new_text_id = W.add_text(rtx, mem, ptr, sel_bytes, experimental=True)
    title_id = new_text_id if single == sel_bytes else W.add_text(rtx, mem, ptr, single, experimental=True)

    # ---- 3. component block ----
    comp_pos = len(comp)
    slot_no = free['slot'] if free else len(els) + 1
    block = W.build_block(slot_no, [W.GEO_SINGLE], [new_text_id])
    comp += block

    # ---- 4. element record ----
    erec = W.new_element_record(template, W.TYPE_TOPIC, title_id, comp_pos)
    if free:
        idx = (free['slot'] - 1) * W.DIM
        info[idx:idx + W.DIM] = erec
    else:
        info += erec

    # ---- 5. contents ----
    conts = W.parse_contents(cont)
    child_ord = slot_no
    if child_ord > len(conts):
        while len(conts) < child_ord - 1:
            conts.append(dict(raw=bytes(W.CONTENT)))
        conts.append(dict(raw=bytes(W.CONTENT)))
    crec = bytearray(conts[child_ord - 1]['raw'])
    struct.pack_into('<H', crec, 1, parent['slot'])
    struct.pack_into('<H', crec, 5, 0)
    struct.pack_into('<H', crec, 9, 0)
    struct.pack_into('<H', crec, 13, 0)
    struct.pack_into('<H', crec, 17, 0)
    conts[child_ord - 1]['raw'] = bytes(crec)
    W.attach_child(conts, parent['slot'], child_ord)

    if not dry_run:
        changes = {P['rtx']: rtx, P['mem']: mem, P['ptr']: ptr,
                   P['comp']: comp, P['info']: info,
                   P['cont']: W.concat_contents(conts)}
        if body_written:
            changes[os.path.join(P['eldir'], '%d.HTM' % slot_no)] = wrapped
            changes[body_path] = wrapped
        commit_files(coll, changes)

    return dict(element_id=title_id, slot=slot_no, parent=parent_id,
                title_id=title_id, content_id=new_text_id,
                comp_pos=comp_pos, comp_len=len(block),
                reused=bool(free), markup=body_written), None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('collection')
    parser.add_argument('parent_id', type=int)
    parser.add_argument('selection')
    parser.add_argument('--dry', action='store_true')
    parser.add_argument('--experimental-registry', action='store_true',
                        help='unverified registry indexes; disposable copies only')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--occurrence', type=int)
    group.add_argument('--byte-offset', type=int)
    args = parser.parse_args()
    res, err = extract(args.collection, args.parent_id, args.selection, args.dry,
                       args.occurrence, args.byte_offset, args.experimental_registry)
    if err:
        print('ERROR:', err)
        return 2
    print('extract ok')
    for k in ('slot', 'parent', 'title_id', 'content_id', 'comp_pos', 'comp_len', 'reused', 'markup'):
        print('  %-10s %s' % (k, res[k]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
