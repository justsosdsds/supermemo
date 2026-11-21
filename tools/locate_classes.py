"""Locate where LCL defines each VCL class so unit mappings can be corrected."""
import re, os, json, glob, collections

ROOTS = [r'C:\lazarus\lcl', r'C:\lazarus\components']
classes = set()
for fn in glob.glob(r'F:\Projects\逆向\work\dfm_json\*.json'):
    root = json.load(open(fn, encoding='utf-8'))

    def walk(n):
        classes.add(n['cls'])
        for c in n['children']:
            walk(c)
    walk(root)

forms = set()
for fn in glob.glob(r'F:\Projects\逆向\work\dfm_json\*.json'):
    root = json.load(open(fn, encoding='utf-8'))
    forms.add(root['cls'])

targets = sorted(c for c in classes if c not in forms)
found = {}
name_re = {}
for c in targets:
    name_re.setdefault(c, re.compile(r'\b' + re.escape(c) + r'\s*=\s*class\b'))

files = []
for r in ROOTS:
    for dirpath, dirnames, filenames in os.walk(r):
        if 'lib' in dirpath.lower() or 'units' in dirpath.lower():
            continue
        for f in filenames:
            if f.endswith('.pas'):
                files.append(os.path.join(dirpath, f))
print('scanning', len(files), 'pas files')

content = {}
for f in files:
    try:
        content[f] = open(f, encoding='utf-8', errors='replace').read()
    except Exception:
        pass

for c in targets:
    pat = name_re[c]
    for f, txt in content.items():
        if pat.search(txt):
            found.setdefault(c, []).append(f)

print('\n== class -> defining file ==')
missing = []
for c in targets:
    locs = found.get(c, [])
    uniq = sorted({os.path.basename(l) for l in locs})
    if not uniq:
        missing.append(c)
        print('  %-24s MISSING' % c)
    else:
        print('  %-24s %s' % (c, ', '.join(uniq[:4])))
print('\nmissing count', len(missing), missing)
json.dump({c: [os.path.basename(l) for l in found.get(c, [])] for c in targets},
          open(r'F:\Projects\逆向\work\class_units.json', 'w', encoding='utf-8'), indent=1)
