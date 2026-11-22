"""Source navigation over contents.dat.

Confirmed by SuperMemoAssistant's ElementBase: ParentId / FirstChildId /
LastChildId / NextSiblingId / PrevSiblingId / DescendantCount all live in
contents.dat, which we already decode.  No extra field is involved.

  +1  parent            +5  first child      +9  last child
  +13 prev sibling      +17 next sibling     +21 descendant count

Commands
  sm_nav.py <collection> origin    <element_id>    walk up to the root article
  sm_nav.py <collection> extracts  <element_id>    list every descendant
  sm_nav.py <collection> children  <element_id>    direct children only
  sm_nav.py <collection> tree                      whole collection tree
"""
import os, struct, sys

DIM, CONTENT = 118, 37


def load(coll):
    info = open(os.path.join(coll, 'info', 'ElementInfo.dat'), 'rb').read()
    cont = open(os.path.join(coll, 'info', 'contents.dat'), 'rb').read()
    rtx = open(os.path.join(coll, 'registry', 'Text.rtx'), 'rb').read()

    els = []
    for i in range(len(info) // DIM):
        r = info[i * DIM:(i + 1) * DIM]
        els.append(dict(slot=i + 1, element_type=r[0],
                        title_id=struct.unpack_from('<i', r, 2)[0],
                        compon_pos=struct.unpack_from('<i', r, 6)[0]))

    rows = []
    for i in range(len(cont) // CONTENT):
        r = cont[i * CONTENT:(i + 1) * CONTENT]
        rows.append(dict(
            ordinal=i + 1,
            parent=struct.unpack_from('<H', r, 1)[0],
            first=struct.unpack_from('<H', r, 5)[0],
            last=struct.unpack_from('<H', r, 9)[0],
            prev=struct.unpack_from('<H', r, 13)[0],
            next=struct.unpack_from('<H', r, 17)[0],
            descendants=struct.unpack_from('<H', r, 21)[0]))

    texts = {}
    i = 0
    while i < len(rtx):
        st = i
        while i < len(rtx) and rtx[i] != 0:
            i += 1
        if i >= len(rtx):
            break
        raw = bytes(rtx[st:i])
        i += 1
        tid = struct.unpack_from('<i', rtx, i)[0] if i + 4 <= len(rtx) else -1
        i += 5
        texts.setdefault(tid, raw.replace(b'\x02', b''))
    return els, rows, texts


def label(els, texts, ordinal, width=64):
    if ordinal < 1 or ordinal > len(els):
        return '<?>'
    e = els[ordinal - 1]
    t = texts.get(e['title_id'], b'')
    try:
        s = t.decode('utf-8')
    except UnicodeDecodeError:
        s = t.decode('cp1252', 'replace')
    kind = {0: 'Topic', 1: 'Item', 4: 'Concept'}.get(e['element_type'], '?%d' % e['element_type'])
    if e['title_id'] == -1:
        return '[free slot %d]' % ordinal
    return '[ord%d] %-7s #%-3d %s' % (ordinal, kind, e['title_id'], (s[:width] + ('…' if len(s) > width else '')))


def find_ordinal_by_id(els, elem_id):
    for i, e in enumerate(els):
        if e['title_id'] == elem_id:
            return i + 1
    return 0


def cmd_origin(coll, elem_id):
    els, rows, texts = load(coll)
    o = find_ordinal_by_id(els, elem_id)
    if o == 0:
        print('element %d not found' % elem_id)
        return 2
    print('origin chain of #%d:' % elem_id)
    chain, guard = [], 0
    while o and guard < 40:
        chain.append(o)
        o = rows[o - 1]['parent']
        guard += 1
    for depth, ordv in enumerate(chain):
        print('  %s%s' % ('  ' * depth, label(els, texts, ordv)))
    if len(chain) > 1:
        print()
        print('root article is %s' % label(els, texts, chain[-1], 90))
    return 0


def cmd_children(coll, elem_id):
    els, rows, texts = load(coll)
    o = find_ordinal_by_id(els, elem_id)
    if o == 0:
        return 2
    kids, cur, guard = [], rows[o - 1]['first'], 0
    while cur and guard < 200:
        kids.append(cur)
        cur = rows[cur - 1]['next']
        guard += 1
    print('direct children of %s : %d' % (label(els, texts, o, 50), len(kids)))
    for k in kids:
        print('  ' + label(els, texts, k))
    return 0


def cmd_extracts(coll, elem_id):
    els, rows, texts = load(coll)
    o = find_ordinal_by_id(els, elem_id)
    if o == 0:
        return 2
    print('descendants of %s : %d (contents says %d)'
          % (label(els, texts, o, 50), rows[o - 1]['descendants'], rows[o - 1]['descendants']))

    out = []

    def walk(ordv, depth):
        cur, guard = rows[ordv - 1]['first'], 0
        while cur and guard < 200:
            out.append((cur, depth))
            walk(cur, depth + 1)
            cur = rows[cur - 1]['next']
            guard += 1

    walk(o, 1)
    for ordv, depth in out:
        print('  %s%s' % ('  ' * depth, label(els, texts, ordv)))
    print()
    print('walked %d, header claims %d -> %s'
          % (len(out), rows[o - 1]['descendants'],
             'match' if len(out) == rows[o - 1]['descendants'] else 'MISMATCH'))
    return 0


def cmd_tree(coll):
    els, rows, texts = load(coll)
    roots = [r['ordinal'] for r in rows if r['parent'] == 0]
    for root in roots:
        print(label(els, texts, root, 80))
        out = []

        def walk(ordv, depth):
            cur, guard = rows[ordv - 1]['first'], 0
            while cur and guard < 200:
                out.append((cur, depth))
                walk(cur, depth + 1)
                cur = rows[cur - 1]['next']
                guard += 1

        walk(root, 1)
        for ordv, depth in out:
            print('  ' + '  ' * depth + label(els, texts, ordv))
    return 0


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 2
    coll, cmd = sys.argv[1], sys.argv[2].lower()
    if cmd == 'tree':
        return cmd_tree(coll)
    if len(sys.argv) < 4:
        print('need an element id')
        return 2
    eid = int(sys.argv[3])
    if cmd == 'origin':
        return cmd_origin(coll, eid)
    if cmd == 'children':
        return cmd_children(coll, eid)
    if cmd == 'extracts':
        return cmd_extracts(coll, eid)
    print('unknown command', cmd)
    return 2


if __name__ == '__main__':
    sys.exit(main())
