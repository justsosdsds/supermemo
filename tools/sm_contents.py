"""Decode info/contents.dat — 37-byte records forming the element tree.

Field layout verified against a collection with 1 root + 4 children
(element ids 1, 2, 3, 4, 6 created via the original UI):

  +0   u8    flags        0 = root, 1 = child
  +1   u16   parent       1-based element ordinal (0 for the root)
  +3   u16   (0)
  +5   u16   first_child  only meaningful on the root
  +7   u16   (0)
  +9   u16   last_child   only meaningful on the root
  +11  u16   (0)
  +13  u16   prev_sibling
  +15  u16   (0)
  +17  u16   next_sibling
  +19  u16   (0)
  +21  u16   child_count
  ...
  +36  u8    (0)

The int32 view looks misaligned because the values are 16-bit with zero
high words; reading as int16 from offset 1 makes the sibling chain exact:
  rec1 next=3, rec2 prev=2 next=4, rec3 prev=3 next=5, rec4 prev=4 next=0
"""

import struct, sys, json, os


def read_contents(root):
    p = os.path.join(root, 'info', 'contents.dat')
    if not os.path.exists(p):
        return []
    b = open(p, 'rb').read()
    n = len(b) // 37
    out = []
    for i in range(n):
        r = b[i * 37:(i + 1) * 37]
        out.append(dict(
            index=i,
            flags=r[0],
            parent=struct.unpack_from('<H', r, 1)[0],
            first_child=struct.unpack_from('<H', r, 5)[0],
            last_child=struct.unpack_from('<H', r, 9)[0],
            prev_sibling=struct.unpack_from('<H', r, 13)[0],
            next_sibling=struct.unpack_from('<H', r, 17)[0],
            child_count=struct.unpack_from('<H', r, 21)[0],
        ))
    return out


def build_tree(root):
    """map element ordinal (1-based) -> children ordinals, following next_sibling"""
    recs = read_contents(root)
    by_ord = {r['index'] + 1: r for r in recs}
    children = {}
    for ord_, r in by_ord.items():
        kids = []
        cur = r['first_child']
        guard = 0
        while cur and guard < 500:
            kids.append(cur)
            nxt = by_ord.get(cur, {}).get('next_sibling', 0)
            if nxt == cur:
                break
            cur = nxt
            guard += 1
        if kids:
            children[ord_] = kids
    return recs, children


if __name__ == '__main__':
    root = sys.argv[1] if len(sys.argv) > 1 else r'F:\SMCollections\ABC'
    recs, children = build_tree(root)
    print('=== contents.dat decoded (%d records) ===' % len(recs))
    print('%-6s %-6s %-6s %-6s %-6s %-6s %s' % (
        'ord', 'flags', 'parent', 'first', 'last', 'kids', 'prev/next'))
    for r in recs:
        print('%-6d %-6d %-6d %-6d %-6d %-6d %d/%d' % (
            r['index'] + 1, r['flags'], r['parent'], r['first_child'],
            r['last_child'], r['child_count'],
            r['prev_sibling'], r['next_sibling']))
    print()
    print('=== tree ===')
    for parent, kids in sorted(children.items()):
        print('  ordinal %d -> children %s' % (parent, kids))
