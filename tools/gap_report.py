"""Quantify the gap between the skeleton exe and the original binary."""
import json, glob, os, re, collections

BASE = r'F:\Projects\逆向'
DFM = os.path.join(BASE, 'work', 'dfm_json')

missing_binary = collections.Counter()
img_refs = collections.Counter()
per_form = {}

for fn in sorted(glob.glob(os.path.join(DFM, '*.json'))):
    root = json.load(open(fn, encoding='utf-8'))
    name = root['cls']
    acc = {'bin': 0, 'img': 0}

    def walk(n):
        if n['cls'] in ('TImage', 'TImageList', 'TPaintBox'):
            acc['img'] += 1
        for k, (t, v) in n['props']:
            if t == 'binary':
                acc['bin'] += 1
                missing_binary['%s.%s' % (n['cls'], k)] += 1
            if t == 'ident' and k == 'ImageIndex':
                img_refs[n['cls']] += 1
        for c in n['children']:
            walk(c)
    walk(root)
    per_form[name] = (acc['bin'], acc['img'])

print('== binary properties dropped (pictures / glyphs / imagelist payload) ==')
tot = sum(missing_binary.values())
print('total binary props:', tot)
for k, v in missing_binary.most_common(15):
    print('  %-42s %d' % (k, v))

print('\n== ImageIndex references (icons with no source list image) ==')
print('total:', sum(img_refs.values()))
for k, v in img_refs.most_common(10):
    print('  %-24s %d' % (k, v))

print('\n== per-form image/binary counts (top 12) ==')
for k, (b, i) in sorted(per_form.items(), key=lambda x: -(x[1][0] + x[1][1]))[:12]:
    print('  %-22s binary=%-4d imgcomp=%d' % (k, b, i))

units = glob.glob(os.path.join(BASE, 'sm19src', 'units', '*.pas'))
total_proc = 0
empty = 0
for p in units:
    txt = open(p, encoding='utf-8').read()
    e = len(re.findall(r'begin\r?\nend;', txt))
    total_proc += len(re.findall(r'^procedure ', txt, re.M)) + len(re.findall(r'^    procedure ', txt, re.M))
    empty += e
print('\n== skeleton implementation ==')
print('units: %d   event methods (empty bodies): %d' % (len(units), empty))

payload = os.path.join(BASE, 'extracted', 'SuperMemo19_payload.exe')
data = open(payload, 'rb').read()
print('\n== original binary ==')
print('size: %d bytes (%.2f MB)' % (len(data), len(data) / 1048576))
print('DFM forms: %d' % data.count(b'TPF0'))
print('custom resource types: 39  (2.8 MB, e.g. CVCL/SM-MM)')
print('string table entries: 51   bitmaps: 84   icons: 4   cursors: 21')
print('imports: 20 DLLs')
