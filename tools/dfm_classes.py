import json, glob, os, collections

d = r'F:\Projects\逆向\work\dfm_json'
classes = collections.Counter()
field_types = collections.defaultdict(collections.Counter)
ev = collections.Counter()
propcount = collections.Counter()
allprops = collections.Counter()

for fn in sorted(glob.glob(os.path.join(d, '*.json'))):
    n = json.load(open(fn, encoding='utf-8'))

    def walk(node):
        classes[node['cls']] += 1
        for k, (t, v) in node['props']:
            allprops[k] += 1
            if k.startswith('On') and t == 'ident':
                ev[k] += 1
        for c in node['children']:
            walk(c)
    walk(n)

print('distinct classes:', len(classes))
for k, v in sorted(classes.items()):
    print('  %-28s %d' % (k, v))

print('\ndistinct props:', len(allprops))
for k, v in sorted(allprops.items()):
    print('  %-28s %d' % (k, v))
