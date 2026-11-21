"""Extract every binary property (glyphs, imagelist bitmaps, icons, pictures)
from the parsed DFM trees and identify their real container format."""
import json, glob, os, collections

BASE = r'F:\Projects\逆向'
DFM = os.path.join(BASE, 'work', 'dfm_json')
OUT = os.path.join(BASE, 'work', 'binprops')
os.makedirs(OUT, exist_ok=True)

items = []
for fn in sorted(glob.glob(os.path.join(DFM, '*.json'))):
    root = json.load(open(fn, encoding='utf-8'))
    form = root['cls']

    def walk(n, path):
        for k, (t, v) in n['props']:
            if t == 'binary':
                items.append(dict(form=form, comp=n['name'], cls=n['cls'],
                                  prop=k, hex=v, size=len(v) // 2))
        for c in n['children']:
            walk(c, path + [c['name']])
    walk(root, [root['name']])

print('binary props:', len(items))
heads = collections.Counter()
for it in items:
    raw = bytes.fromhex(it['hex'])
    it['raw'] = raw
    head = raw[:16].hex(' ')
    h4 = raw[:4]
    if h4[:2] == b'BM':
        fmt = 'BMP'
    elif h4[:4] == b'\x00\x00\x01\x00':
        fmt = 'ICO'
    elif h4[:8] == b'\x89PNG\r\n\x1a\n':
        fmt = 'PNG'
    elif h4 == b'\xff\xd8\xff\xe0':
        fmt = 'JPEG'
    else:
        fmt = 'unknown:' + head
    it['fmt'] = fmt
    heads[fmt.split(':')[0]] += 1

print(dict(heads))
for it in items[:14]:
    print('  %-14s %-18s %-22s %7d bytes  %s' % (
        it['form'], it['comp'], it['prop'], it['size'], it['fmt'][:40]))

print('\n== all formats ==')
for k, v in heads.most_common():
    print('  %-14s %d' % (k, v))

# write raw blobs
for i, it in enumerate(items):
    ext = {'BMP': 'bmp', 'ICO': 'ico', 'PNG': 'png', 'JPEG': 'jpg'}.get(it['fmt'].split(':')[0], 'bin')
    safe = ''.join(c if c.isalnum() or c in '_-' else '_' for c in '%s_%s_%s' % (it['form'], it['comp'], it['prop']))
    p = os.path.join(OUT, '%03d_%s.%s' % (i, safe, ext))
    open(p, 'wb').write(it['raw'])
    it['file'] = p
print('\nwrote', len(items), 'files to', OUT)
json.dump([{k: v for k, v in it.items() if k != 'raw'} for it in items],
          open(os.path.join(BASE, 'work', 'binprops.json'), 'w', encoding='utf-8'), indent=1)
