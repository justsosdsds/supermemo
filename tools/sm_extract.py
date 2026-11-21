"""Extract: create a child element under a given parent element.

This is the core action of incremental reading — pull a fragment out of a
larger element and turn it into its own element, nested underneath.

  python sm_extract.py <collection> <parent_element_id> "text to extract"

Data written (all formats verified against collections the original accepts):
  ElementInfo.dat  new 118-byte record
  contents.dat     new 37-byte record with parent = the parent's ordinal,
                   spliced into that parent's sibling chain
  compon.dat       112-byte block cloned from an existing element
  Text.rtx/.mem/.ptr  new text record
"""
import struct, os, sys, datetime

DIM, CONTENT, MEMREC = 118, 37, 30


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def parse_elements(data):
    out = []
    for i in range(len(data) // DIM):
        r = bytes(data[i * DIM:(i + 1) * DIM])
        out.append(dict(raw=r, flags=r[0], kind=r[1],
                        id=struct.unpack_from('<H', r, 2)[0],
                        comp_off=struct.unpack_from('<I', r, 6)[0],
                        comp_size=struct.unpack_from('<H', r, 10)[0],
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


def parse_text_ids(data):
    ids = []
    i = 0
    while i < len(data):
        while i < len(data) and data[i] != 0:
            i += 1
        if i >= len(data):
            break
        i += 1
        if i + 4 > len(data):
            break
        ids.append(struct.unpack_from('<i', data, i)[0])
        i += 5
    return ids


def main(coll, parent_id, text):
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
        print('ERROR: parent element %d not found' % parent_id)
        return 1
    p_ord = parent['ordinal'] + 1   # +40 is 0-based; contents uses 1-based ordinals
    if p_ord < 1 or p_ord > len(conts):
        print('ERROR: parent ordinal %d outside contents table' % p_ord)
        return 1

    # ids must avoid both element ids and text ids
    text_ids = parse_text_ids(rtx)
    new_id = max(max(e['id'] for e in els),
                 max(text_ids) if text_ids else 0) + 1
    new_ord0 = max(e['ordinal'] for e in els) + 1   # 0-based, goes into ElementInfo
    new_ord = new_ord0 + 1                          # 1-based, goes into contents
    created = (datetime.datetime.now() - datetime.datetime(1899, 12, 30)).total_seconds() / 86400.0

    # template = an element that has a component block
    tpl = next((e for e in reversed(els) if e['comp_off'] != 0xFFFFFFFF and e['comp_size'] > 0), None)
    if tpl is None:
        print('ERROR: no element with a component block to clone')
        return 1

    # --- text record ---
    t_off = len(rtx)
    blob = text.encode('utf-8') + b'\x00' + struct.pack('<i', new_id) + b'\x01'
    rtx += blob
    mrec = bytearray(MEMREC)
    struct.pack_into('<i', mrec, 0, 1)
    struct.pack_into('<i', mrec, 4, 3)
    struct.pack_into('<i', mrec, 8, (t_off + 1) << 16)
    struct.pack_into('<i', mrec, 12, len(blob) << 16)
    struct.pack_into('<i', mrec, 16, new_id << 16)
    mem += mrec
    ptr += struct.pack('<i', new_id)

    # --- element record ---
    c_off = len(comp)
    block = bytearray(comp[tpl['comp_off']:tpl['comp_off'] + tpl['comp_size']])
    struct.pack_into('<i', block, 4, new_ord)
    comp += block

    erec = bytearray(tpl['raw'])
    erec[0] = 1              # child flag
    erec[1] = 1              # kind (same as other items in this collection)
    struct.pack_into('<H', erec, 2, new_id)
    struct.pack_into('<I', erec, 6, c_off)
    struct.pack_into('<H', erec, 10, tpl['comp_size'])
    struct.pack_into('<d', erec, 20, created)
    struct.pack_into('<i', erec, 40, new_ord0)
    info += bytes(erec)

    # --- contents record: parent = p_ord, appended then spliced ---
    crec = bytearray(CONTENT)
    struct.pack_into('<H', crec, 1, p_ord)
    struct.pack_into('<H', crec, 5, 0)
    struct.pack_into('<H', crec, 9, 0)
    struct.pack_into('<H', crec, 13, 0)
    struct.pack_into('<H', crec, 17, 0)
    struct.pack_into('<H', crec, 21, 0)
    cont += bytes(crec)
    conts = parse_contents(cont)

    # splice into the parent's child chain as the last child
    last_child = conts[p_ord - 1]['last']
    if last_child:
        # old last child now points to us
        r = bytearray(conts[last_child - 1]['raw'])
        struct.pack_into('<H', r, 17, new_ord)
        conts[last_child - 1]['raw'] = bytes(r)
        # we point back
        r = bytearray(conts[new_ord - 1]['raw'])
        struct.pack_into('<H', r, 13, last_child)
        conts[new_ord - 1]['raw'] = bytes(r)
    else:
        # parent had no children yet
        r = bytearray(conts[p_ord - 1]['raw'])
        struct.pack_into('<H', r, 5, new_ord)
        conts[p_ord - 1]['raw'] = bytes(r)

    pr = bytearray(conts[p_ord - 1]['raw'])
    struct.pack_into('<H', pr, 9, new_ord)              # last child = us
    kids = struct.unpack_from('<H', pr, 21)[0]
    struct.pack_into('<H', pr, 21, kids + 1)            # child count + 1
    conts[p_ord - 1]['raw'] = bytes(pr)

    out = bytearray()
    for c in conts:
        out += c['raw']

    save(info_p, info)
    save(cont_p, out)
    save(comp_p, comp)
    save(rtx_p, rtx)
    save(mem_p, mem)
    save(ptr_p, ptr)

    print('extracted element id=%d ordinal=%d under parent #%d (ordinal %d)'
          % (new_id, new_ord, parent_id, p_ord))
    print('text: %s' % text[:80])
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('usage: sm_extract.py <collection> <parent_element_id> "text"')
        sys.exit(1)
    sys.exit(main(sys.argv[1], int(sys.argv[2]), sys.argv[3]))
