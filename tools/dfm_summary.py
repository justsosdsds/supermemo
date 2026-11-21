import json, glob, os, collections

d = r'F:\Projects\逆向\work\dfm_json'
rows = []
classes = collections.Counter()
props = collections.Counter()
events = collections.Counter()
for fn in sorted(glob.glob(os.path.join(d, '*.json'))):
    n = json.load(open(fn, encoding='utf-8'))

    def walk(node, depth=0):
        classes[node['cls']] += 1
        for k, (t, v) in node['props']:
            props[k] += 1
            if k.startswith('On') and t == 'ident':
                events[k] += 1
        for c in node['children']:
            walk(c, depth + 1)

    walk(n)
    total = 0

    def count(node):
        return 1 + sum(count(c) for c in node['children'])
    rows.append((os.path.basename(fn)[:-5], n['cls'], n['name'], count(n)))

print('%-14s %-24s %-22s %6s' % ('FILE', 'CLASS', 'NAME', 'NODES'))
for r in rows:
    print('%-14s %-24s %-22s %6d' % r)
print('\ntotal nodes', sum(r[3] for r in rows))
print('\n== component classes (%d distinct) ==' % len(classes))
for k, v in classes.most_common(60):
    print('  %-30s %d' % (k, v))
print('\n== event handlers (%d distinct) ==' % len(events))
for k, v in events.most_common(30):
    print('  %-24s %d' % (k, v))
print('\n== property names (%d distinct) ==' % len(props))
for k, v in props.most_common(80):
    print('  %-30s %d' % (k, v))
