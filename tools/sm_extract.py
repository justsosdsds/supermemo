"""Extract a text range from a topic into a child element.

Behaviour reconstructed from a measured before/after diff of the original
program (EXTEST_base vs EXTEST after one Alt+X on the middle paragraph).

MEASURED FACTS (verified by byte diff, not inferred from names)

  parent body  elements\\2.HTM
    before: AAA first paragraph</P>\\r\\n<P>BBB second paragraph</P>\\r\\n<P>CCC third paragraph
    after : AAA first paragraph\\r\\n<P></P><SPAN class=extract>\\r\\n
            <P>BBB second paragraph</P>\\r\\n<P></SPAN>CCC third paragraph
    => the closing </P> of the paragraph BEFORE the selection is removed and
       replaced by "\\r\\n<P></P><SPAN class=extract>\\r\\n"; the selected
       paragraph keeps its own <P>..</P>; "</SPAN>" is inserted immediately
       after the opening <P> of the paragraph AFTER the selection.

  new element
    * reuses the free slot (kind=3 / id=65535) instead of appending a record
    * kind = 1 (Item)              -- NOT a Topic
    * rep  = 1, pack = 0x00010006  -- inherited/initialised, not a clean zero
    * parent's contents gains one child (kids 0 -> 1, first/last -> new)

  markup constants confirmed present in the binary as UTF-16:
    '<SPAN class=extract' 0x00b2f74c   '<span class=extract>' 0x00b51a64
    '</span>'                          '.Extract {BACKGROUND-COLOR: #44C2FF;}'

PROVISIONAL (replicated from the single measured sample, rule not confirmed)
  * rep=1 / pack=0x00010006 initialisation for a never-studied extract

NOT DONE YET
  * A-Factor inheritance (binary has NewExtractAFactor with 'Inheriance' checks)
  * behaviour when several paragraphs are selected at once
"""
import struct, os, sys, datetime

DIM, CONTENT, MEMREC = 118, 37, 30
FREE_ID = 65535
KIND_ITEM, KIND_TOPIC, KIND_FREE = 1, 2, 3


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def parse_elements(data):
    out = []
    for i in range(len(data) // DIM):
        r = bytes(data[i * DIM:(i + 1) * DIM])
        out.append(dict(slot=i, raw=r, flags=r[0], kind=r[1],
                        id=struct.unpack_from('<H', r, 2)[0],
                        comp_off=struct.unpack_from('<I', r, 6)[0],
                        comp_size=struct.unpack_from('<H', r, 10)[0],
                        rep=struct.unpack_from('<i', r, 12)[0],
                        pack=struct.unpack_from('<I', r, 16)[0],
                        ordinal=struct.unpack_from('<i', r, 40)[0]))
    return out


def parse_contents(data):
    out = []
    for i in range(len(data) // CONTENT):
        r = bytes(data[i * CONTENT:(i + 1) * CONTENT])
        out.append(dict(raw=r,
                        parent=struct.unpack_from('<H', r, 1)[0],
                        first=struct.unpack_from('<H', r, 5)[0],
                        last=struct.unpack_from('<H', r, 9)[0],
                        prev=struct.unpack_from('<H', r, 13)[0],
                        next=struct.unpack_from('<H', r, 17)[0],
                        kids=struct.unpack_from('<H', r, 21)[0]))
    return out


def text_ids(rtx):
    ids, i = [], 0
    while i < len(rtx):
        while i < len(rtx) and rtx[i] != 0:
            i += 1
        if i >= len(rtx):
            break
        i += 1
        if i + 4 > len(rtx):
            break
        ids.append(struct.unpack_from('<i', rtx, i)[0])
        i += 5
    return ids


def wrap_selection(body, needle):
    """Reproduce the measured markup insertion byte for byte."""
    pos = body.find(needle)
    if pos < 0:
        raise ValueError('selection text not present in the topic body')

    p_start = body.rfind(b'<P>', 0, pos)
    if p_start < 0:
        p_start = 0
    p_end = body.find(b'</P>', pos)
    if p_end < 0:
        p_end = len(body)
    else:
        p_end += 4

    prev_close = body.rfind(b'</P>', 0, p_start)

    head = body[:prev_close] if prev_close >= 0 else body[:p_start]
    para = body[p_start:p_end]
    tail = body[p_end:]

    out = bytearray(head)
    out += b'\r\n<P></P><SPAN class=extract>\r\n'
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


def extract(coll, parent_id, selection, dry_run=False):
    info_p = os.path.join(coll, 'info', 'ElementInfo.dat')
    cont_p = os.path.join(coll, 'info', 'contents.dat')
    comp_p = os.path.join(coll, 'info', 'compon.dat')
    rtx_p = os.path.join(coll, 'registry', 'Text.rtx')
    mem_p = os.path.join(coll, 'registry', 'Text.mem')
    ptr_p = os.path.join(coll, 'registry', 'Text.ptr')

    info = load(info_p)
    cont = load(cont_p)
    comp = load(comp_p)
    rtx = load(rtx_p)
    mem = load(mem_p)
    ptr = load(ptr_p)

    els = parse_elements(info)
    conts = parse_contents(cont)
    parent = next((e for e in els if e['id'] == parent_id), None)
    if parent is None:
        return None, 'parent element %d not found' % parent_id

    free = next((e for e in els if e['kind'] == KIND_FREE and e['id'] == FREE_ID), None)
    reused = free is not None

    used = set(e['id'] for e in els if e['id'] != FREE_ID) | set(text_ids(rtx))
    new_id = (max(used) + 1) if used else 1
    new_ord0 = max((e['ordinal'] for e in els), default=0) + 1
    new_ord = (free['slot'] + 1) if reused else (len(els) + 1)

    # ---- parent body markup ----
    body_changed = False
    body_file = os.path.join(coll, 'elements', '%d.HTM' % (parent['slot'] + 1))
    if os.path.exists(body_file):
        body = open(body_file, 'rb').read()
        wrapped = wrap_selection(body, selection.encode('utf-8'))
        if not dry_run:
            open(body_file, 'wb').write(wrapped)
        body_changed = True

    # ---- text record ----
    t_off = len(rtx)
    blob = selection.encode('utf-8') + b'\x00' + struct.pack('<i', new_id) + b'\x01'
    rtx += blob
    mrec = bytearray(MEMREC)
    struct.pack_into('<i', mrec, 0, 1)
    struct.pack_into('<i', mrec, 4, 3)
    struct.pack_into('<i', mrec, 8, (t_off + 1) << 16)
    struct.pack_into('<i', mrec, 12, len(blob) << 16)
    struct.pack_into('<i', mrec, 16, new_id << 16)
    mem += mrec
    ptr += struct.pack('<i', new_id)

    # ---- element record ----
    tpl = next((e for e in reversed(els) if e['comp_off'] != 0xFFFFFFFF and e['comp_size'] > 0), None)
    if tpl is None:
        return None, 'no component block to clone'
    c_off = len(comp)
    blk = bytearray(comp[tpl['comp_off']:tpl['comp_off'] + tpl['comp_size']])
    struct.pack_into('<i', blk, 4, new_ord)
    comp += blk

    erec = bytearray(free['raw'] if reused else tpl['raw'])
    slot_index = free['slot'] if reused else len(info) // DIM
    erec[0] = 0x00
    erec[1] = KIND_ITEM
    struct.pack_into('<H', erec, 2, new_id)
    struct.pack_into('<I', erec, 6, c_off)
    struct.pack_into('<H', erec, 10, tpl['comp_size'])
    struct.pack_into('<i', erec, 12, 1)            # PROVISIONAL (measured=1)
    struct.pack_into('<I', erec, 16, 0x00010006)   # PROVISIONAL (measured)
    now = (datetime.datetime.now() - datetime.datetime(1899, 12, 30)).total_seconds() / 86400.0
    struct.pack_into('<d', erec, 20, now)
    struct.pack_into('<i', erec, 40, new_ord0)

    if reused:
        info[slot_index * DIM:(slot_index + 1) * DIM] = erec
    else:
        info += bytes(erec)

    # ---- contents ----
    p_ord = parent['slot'] + 1        # contents rows follow ElementInfo slot order
    n_cont = len(cont) // CONTENT
    if reused and new_ord <= n_cont:
        crec = bytearray(cont[(new_ord - 1) * CONTENT:new_ord * CONTENT])
        struct.pack_into('<H', crec, 1, p_ord)
        struct.pack_into('<H', crec, 5, 0)
        struct.pack_into('<H', crec, 9, 0)
        struct.pack_into('<H', crec, 13, 0)
        struct.pack_into('<H', crec, 17, 0)
        struct.pack_into('<H', crec, 21, 0)
        cont[(new_ord - 1) * CONTENT:new_ord * CONTENT] = crec
    else:
        crec = bytearray(CONTENT)
        struct.pack_into('<H', crec, 1, p_ord)
        cont += bytes(crec)
        n_cont += 1

    conts = parse_contents(cont)
    if new_ord > len(conts):
        return None, 'internal: contents row %d missing' % new_ord

    last = conts[p_ord - 1]['last']
    if last:
        r = bytearray(conts[last - 1]['raw'])
        struct.pack_into('<H', r, 17, new_ord)
        conts[last - 1]['raw'] = bytes(r)
        r = bytearray(conts[new_ord - 1]['raw'])
        struct.pack_into('<H', r, 13, last)
        conts[new_ord - 1]['raw'] = bytes(r)
    pr = bytearray(conts[p_ord - 1]['raw'])
    if last == 0:
        struct.pack_into('<H', pr, 5, new_ord)
    struct.pack_into('<H', pr, 9, new_ord)
    struct.pack_into('<H', pr, 21, conts[p_ord - 1]['kids'] + 1)
    conts[p_ord - 1]['raw'] = bytes(pr)

    out = bytearray()
    for c in conts:
        out += c['raw']

    if not dry_run:
        # write order matters: text pool first, then element/contents/compon so a
        # partial failure leaves the collection readable rather than half-linked
        save(rtx_p, rtx)
        save(mem_p, mem)
        save(ptr_p, ptr)
        save(comp_p, comp)
        save(info_p, info)
        save(cont_p, out)

    return dict(new_id=new_id, new_ordinal=new_ord, slot=slot_index + 1,
                reused=reused, parent=parent_id, body_markup=body_changed), None


def main():
    if len(sys.argv) < 4:
        print('usage: sm_extract.py <collection> <parent_element_id> "<selection>" [--dry]')
        return 1
    res, err = extract(sys.argv[1], int(sys.argv[2]), sys.argv[3], dry_run='--dry' in sys.argv)
    if err:
        print('ERROR:', err)
        return 2
    print('extract ok')
    print('  new element : id=%d ordinal=%d slot=%d' % (res['new_id'], res['new_ordinal'], res['slot']))
    print('  parent      : #%d' % res['parent'])
    print('  slot reused : %s' % ('yes (free slot %d)' % res['slot'] if res['reused'] else 'no (appended)'))
    print('  body markup : %s' % ('written' if res['body_markup'] else 'skipped'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
