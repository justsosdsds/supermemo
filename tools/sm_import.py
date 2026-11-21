"""Import Q&A pairs into a SuperMemo collection by writing the four files whose
formats are now decoded:

  info/ElementInfo.dat   118-byte records  (flags, kind, id, comp_off, comp_size,
                                            created@+20, interval@+32, ordinal@+40)
  info/contents.dat       37-byte records  (parent@+1, first@+5, last@+9,
                                            prev@+13, next@+17, kids@+21)
  info/compon.dat         112-byte records (magic 0xd431, ordinal@+4, 2 coord blocks)
  registry/Text.rtx       title pool: <text> NUL <int32 id> <byte>

Strategy: clone an existing leaf element as a template so all unknown fields
keep sensible values, then append new records and rebuild the sibling chain.
"""
import struct, os, sys, shutil, datetime

DIM = 118
CONTENT = 37
COMPON = 112


def load(path):
    return bytearray(open(path, 'rb').read())


def save(path, data):
    open(path, 'wb').write(bytes(data))


def parse_elements(data):
    out = []
    for i in range(len(data) // DIM):
        r = bytes(data[i * DIM:(i + 1) * DIM])
        out.append(dict(
            slot=i, raw=r,
            flags=r[0], kind=r[1],
            id=struct.unpack_from('<H', r, 2)[0],
            comp_off=struct.unpack_from('<I', r, 6)[0],
            comp_size=struct.unpack_from('<H', r, 10)[0],
            created=struct.unpack_from('<d', r, 20)[0],
            ordinal=struct.unpack_from('<i', r, 40)[0],
        ))
    return out


def parse_contents(data):
    out = []
    for i in range(len(data) // CONTENT):
        r = bytes(data[i * CONTENT:(i + 1) * CONTENT])
        out.append(dict(
            raw=r,
            flags=r[0],
            parent=struct.unpack_from('<H', r, 1)[0],
            first=struct.unpack_from('<H', r, 5)[0],
            last=struct.unpack_from('<H', r, 9)[0],
            prev=struct.unpack_from('<H', r, 13)[0],
            next=struct.unpack_from('<H', r, 17)[0],
            kids=struct.unpack_from('<H', r, 21)[0],
        ))
    return out


def parse_texts(data):
    """returns list of (text, id, tail_byte, raw_bytes)"""
    out = []
    i = 0
    while i < len(data):
        start = i
        while i < len(data) and data[i] != 0:
            i += 1
        if i >= len(data):
            break
        raw_text = bytes(data[start:i])
        i += 1
        cid = 0
        if i + 4 <= len(data):
            cid = struct.unpack_from('<i', data, i)[0]
            i += 4
        tail = data[i] if i < len(data) else 0
        i += 1
        try:
            text = raw_text.decode('utf-8')
        except UnicodeDecodeError:
            text = raw_text.decode('cp1252', 'replace')
        out.append((text, cid))
    return out


def write_text_pool(path, entries):
    buf = bytearray()
    for text, cid in entries:
        buf += text.encode('utf-8') + b'\x00'
        buf += struct.pack('<i', cid)
        buf += b'\x01'
    save(path, buf)


def parse_qa(path):
    pairs = []
    q = None
    for line in open(path, encoding='utf-8-sig'):
        s = line.strip()
        if not s:
            continue
        if s[:2].upper() == 'Q:':
            q = s[2:].strip()
        elif s[:2].upper() == 'A:' and q is not None:
            pairs.append((q, s[2:].strip()))
            q = None
    return pairs


def import_qa(coll, qa_file):
    info_p = os.path.join(coll, 'info', 'ElementInfo.dat')
    cont_p = os.path.join(coll, 'info', 'contents.dat')
    comp_p = os.path.join(coll, 'info', 'compon.dat')
    text_p = os.path.join(coll, 'registry', 'Text.rtx')

    els = parse_elements(load(info_p))
    conts = parse_contents(load(cont_p))
    comp = load(comp_p)
    texts = parse_texts(load(text_p))

    if not els:
        print('collection has no elements')
        return 1

    # template: the last leaf element (has a component block)
    template = None
    for e in reversed(els):
        if e['comp_off'] != 0xFFFFFFFF and e['comp_size'] > 0:
            template = e
            break
    if template is None:
        print('no element with components to clone')
        return 1

    root = next((c for c in conts if c['parent'] == 0), conts[0])
    root_ord = 1

    pairs = parse_qa(qa_file)
    print('Q&A pairs:', len(pairs))

    text_ids = [cid for (_t, cid) in texts]
    max_id = max(max(e['id'] for e in els), max(text_ids) if text_ids else 0)
    max_ord = max(e['ordinal'] for e in els)
    next_id = max_id + 1
    next_ord = max_ord + 1
    created = (datetime.datetime(2026, 11, 21) - datetime.datetime(1899, 12, 30)).total_seconds() / 86400.0

    added = []
    for q, a in pairs:
        comp_off = len(comp)
        block = bytearray(comp[template['comp_off']:template['comp_off'] + template['comp_size']])
        # +4 holds (element ordinal + 1); the cloned block still carries the
        # template's value, so rewrite it for the new element
        struct.pack_into('<i', block, 4, next_ord + 1)
        comp += block

        rec = bytearray(template['raw'])
        rec[0] = 1           # child flag
        rec[1] = 1
        struct.pack_into('<H', rec, 2, next_id)
        struct.pack_into('<I', rec, 6, comp_off)
        struct.pack_into('<H', rec, 10, template['comp_size'])
        struct.pack_into('<d', rec, 20, created)
        struct.pack_into('<i', rec, 40, next_ord)

        crec = bytearray(root['raw'])
        struct.pack_into('<H', crec, 1, root_ord)
        struct.pack_into('<H', crec, 5, 0)
        struct.pack_into('<H', crec, 9, 0)
        struct.pack_into('<H', crec, 13, next_ord - 1)   # prev sibling
        struct.pack_into('<H', crec, 17, 0)              # next sibling
        struct.pack_into('<H', crec, 21, 0)

        added.append(dict(id=next_id, ordinal=next_ord,
                          elem=bytes(rec), content=bytes(crec),
                          q=q, a=a))
        next_id += 1
        next_ord += 1

    # append records
    info = load(info_p)
    for x in added:
        info += x['elem']
    save(info_p, info)

    cont = load(cont_p)
    for x in added:
        cont += x['content']
    save(cont_p, cont)
    save(comp_p, comp)

    # rebuild root's child pointers + sibling links
    conts = parse_contents(load(cont_p))
    kid_ords = []
    cur = conts[root_ord - 1]['first']
    guard = 0
    while cur and guard < 500:
        kid_ords.append(cur)
        cur = conts[cur - 1]['next']
        guard += 1
    for x in added:
        kid_ords.append(x['ordinal'])
    # relink
    root_rec = bytearray(conts[root_ord - 1]['raw'])
    struct.pack_into('<H', root_rec, 5, kid_ords[0])
    struct.pack_into('<H', root_rec, 9, kid_ords[-1])
    struct.pack_into('<H', root_rec, 21, len(kid_ords))
    conts[root_ord - 1]['raw'] = bytes(root_rec)
    for i, o in enumerate(kid_ords):
        rec = bytearray(conts[o - 1]['raw'])
        struct.pack_into('<H', rec, 13, kid_ords[i - 1] if i > 0 else 0)
        struct.pack_into('<H', rec, 17, kid_ords[i + 1] if i + 1 < len(kid_ords) else 0)
        conts[o - 1]['raw'] = bytes(rec)
    out = bytearray()
    for c in conts:
        out += c['raw']
    save(cont_p, out)

    if os.environ.get('SM_NO_TEXT') == '1':
        print('text pool untouched (SM_NO_TEXT=1)')
        print('imported %d elements (ids %d..%d)' % (len(added), added[0]['id'], added[-1]['id']))
        return 0

    # append text records properly: rtx + mem + ptr (lst left alone — verified
    # that the original program accepts it that way)
    mem_p = os.path.join(coll, 'registry', 'Text.mem')
    ptr_p = os.path.join(coll, 'registry', 'Text.ptr')
    rtx = load(text_p)
    mem = load(mem_p)
    ptr = load(ptr_p)
    for x in added:
        offset = len(rtx)
        blob = (x['q'] + ' :: ' + x['a']).encode('utf-8') + b'\x00'
        blob += struct.pack('<i', x['id']) + b'\x01'
        rtx += blob
        rec = bytearray(30)
        struct.pack_into('<i', rec, 0, 1)
        struct.pack_into('<i', rec, 4, 3)
        struct.pack_into('<i', rec, 8, (offset + 1) << 16)
        struct.pack_into('<i', rec, 12, len(blob) << 16)
        struct.pack_into('<i', rec, 16, x['id'] << 16)
        mem += rec
        ptr += struct.pack('<i', x['id'])
    save(text_p, rtx)
    save(mem_p, mem)
    save(ptr_p, ptr)
    print('text registry: rtx %d bytes, mem %d records, ptr %d entries'
          % (len(rtx), len(mem) // 30, len(ptr) // 4))

    print('imported %d elements (ids %d..%d)' % (len(added), added[0]['id'], added[-1]['id']))
    return 0


if __name__ == '__main__':
    coll = sys.argv[1] if len(sys.argv) > 1 else r'F:\SMCollections\ABC'
    qa = sys.argv[2] if len(sys.argv) > 2 else r'F:\SMImport\import_qa.txt'
    sys.exit(import_qa(coll, qa))
