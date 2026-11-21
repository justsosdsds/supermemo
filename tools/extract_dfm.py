"""Extract DFM (TPF0) blobs from the carved sm19.exe resource section."""
import struct, os, sys, json

P = r'F:\Projects\逆向\extracted\SuperMemo19_payload.exe'
OUT = r'F:\Projects\逆向\work\dfm_raw'
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
print('sections:', {k: hex(v['raw']) for k, v in secs.items()})

rsrc = secs['.rsrc']
BASE = rsrc['raw']
RSRC_RVA = rsrc['va']


def rva2off(rva):
    for k, v in secs.items():
        if v['va'] <= rva < v['va'] + max(v['vsz'], v['rawsz']):
            return v['raw'] + (rva - v['va'])
    raise ValueError(hex(rva))


def read_name(off_base, value):
    # value with high bit = offset into name table
    if value & 0x80000000:
        o = off_base + (value & 0x7FFFFFFF)
        ln = struct.unpack_from('<H', data, o)[0]
        raw = data[o + 2:o + 2 + ln * 2]
        try:
            return raw.decode('utf-16le')
        except Exception:
            return raw.decode('latin1')
    return str(value)


def walk_dir(off_base, dir_off, depth, path):
    p = dir_off
    nnamed, nid = struct.unpack_from('<HH', data, p + 12)
    count = nnamed + nid
    out = []
    for i in range(count):
        eo = p + 16 + i * 8
        name_val, off_val = struct.unpack_from('<II', data, eo)
        name = read_name(off_base, name_val)
        sub = off_val & 0x7FFFFFFF
        is_dir = bool(off_val & 0x80000000)
        if is_dir:
            out.extend(walk_dir(off_base, off_base + sub, depth + 1, path + [name]))
        else:
            d = off_base + sub
            rva, size, cp, _ = struct.unpack_from('<IIII', data, d)
            off = rva2off(rva)
            out.append((path + [name], cp, off, size))
    return out


base_off = rva2off(RSRC_RVA)
entries = walk_dir(base_off, base_off, 0, [])
print('resource leaves:', len(entries))

RT = {'10': 'RCDATA', '6': 'STRING', '3': 'ICON', '2': 'BITMAP', '12': 'GROUP_CURSOR',
      '14': 'GROUP_ICON', '1': 'CURSOR', '24': 'MANIFEST', '16': 'VERSION', '4': 'MENU',
      '5': 'DIALOG', '9': 'ACCELERATOR', '17': 'DLGINCLUDE', '23': 'HTML'}

manifest = []
dfm_count = 0
for path, cp, off, size in entries:
    typeid = path[0]
    tname = RT.get(typeid, typeid)
    blob = data[off:off + size]
    is_dfm = typeid == '10' and blob[:4] == b'TPF0'
    rec = dict(type=typeid, type_name=tname, path=path, codepage=cp, size=size, is_dfm=is_dfm)
    if is_dfm:
        dfm_count += 1
        nm = path[-1]
        safe = ''.join(c if c.isalnum() or c in '_-.@' else '_' for c in nm) or 'unnamed'
        fn = os.path.join(OUT, '%03d_%s.dfm.bin' % (dfm_count, safe))
        open(fn, 'wb').write(blob)
        rec['file'] = fn
    manifest.append(rec)

json.dump(manifest, open(r'F:\Projects\逆向\work\rsrc_manifest.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)
print('DFM blobs:', dfm_count)
for m in manifest:
    if m['is_dfm']:
        print('  %-40s %7d  %s' % ('/'.join(m['path']), m['size'], m.get('file')))
