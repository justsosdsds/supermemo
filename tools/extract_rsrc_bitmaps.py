"""Extract BITMAP/ICON resources from the original payload and inspect sizes,
plus decode the Delphi glyph blobs ([4-byte len][BMP])."""
import struct, os, sys, json

BASE = r'F:\Projects\逆向'
P = os.path.join(BASE, 'extracted', 'SuperMemo19_payload.exe')
OUT = os.path.join(BASE, 'work', 'rsrc_bmp')
os.makedirs(OUT, exist_ok=True)
data = open(P, 'rb').read()

pe = struct.unpack_from('<I', data, 0x3C)[0]
nsec = struct.unpack_from('<H', data, pe + 6)[0]
optsize = struct.unpack_from('<H', data, pe + 20)[0]
secoff = pe + 24 + optsize
secs = {}
for i in range(nsec):
    o = secoff + i * 40
    name = data[o:o + 8].rstrip(b'\0').decode('latin1')
    vsz, va, rsz, ra = struct.unpack_from('<IIII', data, o + 8)
    secs[name] = dict(va=va, vsz=vsz, raw=ra, rawsz=rsz)


def rva2off(rva):
    for k, v in secs.items():
        if v['va'] <= rva < v['va'] + max(v['vsz'], v['rawsz']):
            return v['raw'] + (rva - v['va'])
    raise ValueError(hex(rva))


def read_name(base, value):
    if value & 0x80000000:
        o = base + (value & 0x7FFFFFFF)
        ln = struct.unpack_from('<H', data, o)[0]
        raw = data[o + 2:o + 2 + ln * 2]
        try:
            return raw.decode('utf-16le')
        except Exception:
            return raw.decode('latin1')
    return str(value)


def walk(base, doff, path, out):
    nnamed, nid = struct.unpack_from('<HH', data, doff + 12)
    for i in range(nnamed + nid):
        eo = doff + 16 + i * 8
        nv, ov = struct.unpack_from('<II', data, eo)
        nm = read_name(base, nv)
        sub = ov & 0x7FFFFFFF
        if ov & 0x80000000:
            walk(base, base + sub, path + [nm], out)
        else:
            d = base + sub
            rva, size, cp, _ = struct.unpack_from('<IIII', data, d)
            out.append((path + [nm], cp, rva2off(rva), size))


rsrc = secs['.rsrc']
base = rsrc['raw']
leaves = []
walk(base, base, [], leaves)

bmp = [l for l in leaves if l[0][0] == '2']
ico = [l for l in leaves if l[0][0] == '3']
print('BITMAP resources:', len(bmp), ' ICON:', len(ico))

rows = []
for path, cp, off, size in bmp:
    blob = data[off:off + size]
    if blob[:2] == b'BM':
        import struct as st
        w, h = st.unpack_from('<ii', blob, 18)
        bits = st.unpack_from('<H', blob, 28)[0]
        rows.append((path[-1], w, h, bits, size))
print('\n%-10s %6s %6s %5s %8s' % ('NAME', 'W', 'H', 'BITS', 'BYTES'))
for r in sorted(rows):
    print('%-10s %6d %6d %5d %8d' % r)

for path, cp, off, size in bmp:
    nm = ''.join(c if c.isalnum() or c in '_-' else '_' for c in path[-1])
    open(os.path.join(OUT, '%s.bmp' % nm), 'wb').write(data[off:off + size])
for path, cp, off, size in ico:
    nm = ''.join(c if c.isalnum() or c in '_-' else '_' for c in path[-1])
    open(os.path.join(OUT, 'ico_%s.ico' % nm), 'wb').write(data[off:off + size])
print('\nwrote bmp/ico to', OUT)

# decode glyph blobs
props = json.load(open(os.path.join(BASE, 'work', 'binprops.json'), encoding='utf-8'))
glyphs = [p for p in props if p['prop'] == 'Glyph.Data']
print('\nglyph blobs:', len(glyphs))
ok = 0
gout = os.path.join(BASE, 'work', 'glyphs')
os.makedirs(gout, exist_ok=True)
for g in glyphs:
    raw = bytes.fromhex(g['hex'])
    if len(raw) > 8 and raw[4:6] == b'BM':
        ln = struct.unpack_from('<I', raw, 0)[0]
        bmpblob = raw[4:4 + ln]
        g['bmp'] = bmpblob
        safe = ''.join(c if c.isalnum() or c in '_-' else '_' for c in '%s_%s' % (g['form'], g['comp']))
        open(os.path.join(gout, safe + '.bmp'), 'wb').write(bmpblob)
        ok += 1
print('decoded glyph BMPs:', ok)
json.dump([{k: v for k, v in g.items() if k != 'bmp'} for g in glyphs],
          open(os.path.join(BASE, 'work', 'glyphs.json'), 'w', encoding='utf-8'), indent=1)
