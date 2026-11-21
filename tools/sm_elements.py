"""Element-level reader for a SuperMemo collection.

Verified against a collection where elements were created through the original
UI's "Add new" button:

  info/ElementInfo.dat   118-byte records, element id at offset +2 (uint16)
  registry/Text.rtx      element title pool: <title> NUL <int32 element_id> <byte>
  registry/Concept.rtx   concept path pool, same framing

The cross-file join is: Text record .a  ==  ElementInfo record .id
"""
import struct, os, json, sys


def read_elements(root):
    root = os.path.normpath(root)
    info = os.path.join(root, 'info', 'ElementInfo.dat')
    if not os.path.exists(info):
        return []
    b = open(info, 'rb').read()
    recsize = 118
    n = len(b) // recsize
    out = []
    for i in range(n):
        r = b[i * recsize:(i + 1) * recsize]
        out.append(dict(
            slot=i,
            flags=r[0],
            kind=r[1],
            id=struct.unpack_from('<H', r, 2)[0],
            comp_offset=struct.unpack_from('<I', r, 6)[0],
            comp_size=struct.unpack_from('<H', r, 10)[0],
            raw_tail=r[110:118].hex(),
        ))
    return out


def read_titles(root):
    p = os.path.join(root, 'registry', 'Text.rtx')
    if not os.path.exists(p):
        return {}
    b = open(p, 'rb').read()
    titles = {}
    i = 0
    while i < len(b):
        start = i
        while i < len(b) and b[i] != 0:
            i += 1
        if i >= len(b):
            break
        raw = b[start:i]
        i += 1
        cid = 0
        if i + 4 <= len(b):
            cid = struct.unpack_from('<i', b, i)[0]
            i += 4
        if i < len(b):
            i += 1
        try:
            text = raw.decode('utf-8')
        except UnicodeDecodeError:
            text = raw.decode('cp1252', 'replace')
        titles[cid] = text
    return titles


def list_collection(root):
    els = read_elements(root)
    titles = read_titles(root)
    for e in els:
        e['title'] = titles.get(e['id'], '<no title>')
    return els


if __name__ == '__main__':
    root = sys.argv[1] if len(sys.argv) > 1 else r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'
    els = list_collection(root)
    print('collection:', root)
    print('elements:', len(els))
    print()
    print('%-5s %-6s %-6s %-10s %-8s %s' % ('slot', 'flags', 'id', 'comp_off', 'comp_sz', 'title'))
    for e in els:
        print('%-5d %-6d %-6d %-10d %-8d %s' % (
            e['slot'], e['flags'], e['id'], e['comp_offset'], e['comp_size'], e['title']))
