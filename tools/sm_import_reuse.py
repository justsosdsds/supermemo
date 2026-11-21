"""Prove the element-structure writer works by reusing an existing text slot.

The text registry is slot-indexed and its index tables (lst/ptr/mem) are not
fully decoded yet, so this variant adds NO new text record: it reuses the
orphan slot id=7 (created by an earlier clipboard experiment) and rewrites its
text with an equal-length string so all offsets stay valid.

If the original program then opens the collection without a registry error and
shows the new element, the element/contents/compon writers are correct and the
only remaining obstacle is the text index tables.
"""
import struct, os, sys, datetime

DIM, CONTENT, COMPON = 118, 37, 112


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def parse_elements(d):
    out = []
    for i in range(len(d) // DIM):
        r = bytes(d[i * DIM:(i + 1) * DIM])
        out.append(dict(slot=i, raw=r,
                        flags=r[0], kind=r[1],
                        id=struct.unpack_from('<H', r, 2)[0],
                        comp_off=struct.unpack_from('<I', r, 6)[0],
                        comp_size=struct.unpack_from('<H', r, 10)[0],
                        ordinal=struct.unpack_from('<i', r, 40)[0]))
    return out


def parse_contents(d):
    out = []
    for i in range(len(d) // CONTENT):
        r = bytes(d[i * CONTENT:(i + 1) * CONTENT])
        out.append(dict(raw=r, flags=r[0],
                        parent=struct.unpack_from('<H', r, 1)[0],
                        first=struct.unpack_from('<H', r, 5)[0],
                        last=struct.unpack_from('<H', r, 9)[0],
                        prev=struct.unpack_from('<H', r, 13)[0],
                        next=struct.unpack_from('<H', r, 17)[0],
                        kids=struct.unpack_from('<H', r, 21)[0]))
    return out


def find_text_record(data, wanted_id):
    """returns (text_start, text_end, id_pos, tail_pos) or None"""
    i = 0
    while i < len(data):
        start = i
        while i < len(data) and data[i] != 0:
            i += 1
        if i >= len(data):
            return None
        end = i
        idpos = i + 1
        if idpos + 4 > len(data):
            return None
        rid = struct.unpack_from('<i', data, idpos)[0]
        if rid == wanted_id:
            return start, end, idpos
        i = idpos + 4 + 1
    return None


def main(coll, reuse_id=7, new_text=None):
    info_p = os.path.join(coll, 'info', 'ElementInfo.dat')
    cont_p = os.path.join(coll, 'info', 'contents.dat')
    comp_p = os.path.join(coll, 'info', 'compon.dat')
    text_p = os.path.join(coll, 'registry', 'Text.rtx')

    els = parse_elements(load(info_p))
    conts = parse_contents(load(cont_p))
    comp = load(comp_p)
    text = load(text_p)

    if any(e['id'] == reuse_id for e in els):
        print('element %d already exists; pick another slot' % reuse_id)
        return 1

    rec = find_text_record(text, reuse_id)
    if rec is None:
        print('no text record with id', reuse_id)
        return 1
    tstart, tend, idpos = rec
    old_len = tend - tstart
    old_text = bytes(text[tstart:tend]).decode('utf-8', 'replace')
    print('reusing text slot id=%d, %d bytes: %r' % (reuse_id, old_len, old_text[:50]))

    if new_text is None:
        new_text = 'Reused slot proof: element written by the engine.'
    raw_new = new_text.encode('utf-8')
    if len(raw_new) > old_len:
        raw_new = raw_new[:old_len]
    raw_new = raw_new + b' ' * (old_len - len(raw_new))
    text[tstart:tend] = raw_new
    save(text_p, text)
    print('text rewritten in place (equal length %d)' % old_len)

    template = None
    for e in reversed(els):
        if e['comp_off'] != 0xFFFFFFFF and e['comp_size'] > 0:
            template = e
            break
    if template is None:
        print('no component template')
        return 1

    root = next(c for c in conts if c['parent'] == 0)
    root_ord = 1
    next_ord = max(e['ordinal'] for e in els) + 1
    created = (datetime.datetime(2026, 11, 21) - datetime.datetime(1899, 12, 30)).total_seconds() / 86400.0

    comp_off = len(comp)
    comp += comp[template['comp_off']:template['comp_off'] + template['comp_size']]

    erec = bytearray(template['raw'])
    erec[0] = 1
    erec[1] = 1
    struct.pack_into('<H', erec, 2, reuse_id)
    struct.pack_into('<I', erec, 6, comp_off)
    struct.pack_into('<H', erec, 10, template['comp_size'])
    struct.pack_into('<d', erec, 20, created)
    struct.pack_into('<i', erec, 40, next_ord)
    info = load(info_p)
    info += bytes(erec)
    save(info_p, info)

    crec = bytearray(root['raw'])
    struct.pack_into('<H', crec, 1, root_ord)
    struct.pack_into('<H', crec, 5, 0)
    struct.pack_into('<H', crec, 9, 0)
    struct.pack_into('<H', crec, 13, len(conts))
    struct.pack_into('<H', crec, 17, 0)
    struct.pack_into('<H', crec, 21, 0)
    cont = load(cont_p)
    cont += bytes(crec)
    save(cont_p, cont)
    save(comp_p, comp)

    # relink siblings
    conts = parse_contents(load(cont_p))
    kid = []
    cur = conts[root_ord - 1]['first']
    guard = 0
    while cur and guard < 500:
        kid.append(cur)
        cur = conts[cur - 1]['next']
        guard += 1
    kid.append(next_ord)
    rr = bytearray(conts[root_ord - 1]['raw'])
    struct.pack_into('<H', rr, 5, kid[0])
    struct.pack_into('<H', rr, 9, kid[-1])
    struct.pack_into('<H', rr, 21, len(kid))
    conts[root_ord - 1]['raw'] = bytes(rr)
    for i, o in enumerate(kid):
        r = bytearray(conts[o - 1]['raw'])
        struct.pack_into('<H', r, 13, kid[i - 1] if i > 0 else 0)
        struct.pack_into('<H', r, 17, kid[i + 1] if i + 1 < len(kid) else 0)
        conts[o - 1]['raw'] = bytes(r)
    out = bytearray()
    for c in conts:
        out += c['raw']
    save(cont_p, out)

    print('added element id=%d ordinal=%d (no new text records)' % (reuse_id, next_ord))
    return 0


if __name__ == '__main__':
    coll = sys.argv[1] if len(sys.argv) > 1 else r'F:\SMCollections\ABC'
    rid = int(sys.argv[2]) if len(sys.argv) > 2 else 7
    sys.exit(main(coll, rid))
