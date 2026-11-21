import struct, os, hashlib, datetime

src = r'G:\SuperMemo19_Unlocked_Setup.exe'
data = open(src, 'rb').read()


def parse_image(base, total_len):
    assert data[base:base+2] == b'MZ'
    e = struct.unpack_from('<I', data, base+0x3C)[0]
    pe = base + e
    assert data[pe:pe+4] == b'PE\0\0'
    machine, nsec = struct.unpack_from('<HH', data, pe+4)
    tstamp = struct.unpack_from('<I', data, pe+8)[0]
    optsize = struct.unpack_from('<H', data, pe+20)[0]
    chars = struct.unpack_from('<H', data, pe+22)[0]
    magic = struct.unpack_from('<H', data, pe+24)[0]
    subsystem = struct.unpack_from('<H', data, pe+24+68)[0]
    secoff = pe + 24 + optsize
    secs, maxend = [], 0
    for i in range(nsec):
        o = secoff + i*40
        name = data[o:o+8].rstrip(b'\0')[:8].decode('latin1', 'replace')
        vsz, va, rsz, ra = struct.unpack_from('<IIII', data, o+8)
        ch = struct.unpack_from('<I', data, o+36)[0]
        secs.append(dict(name=name, va=va, vsz=vsz, raw=ra, rawsz=rsz, ch=ch))
        if ra and rsz:
            maxend = max(maxend, ra + rsz)
    hdr_end = secoff + nsec*40
    maxend = max(maxend, hdr_end)
    info = dict(base=base, machine=machine, nsec=nsec, timestamp=tstamp,
                optsize=optsize, chars=chars, magic=magic, subsystem=subsystem,
                sections=secs, size=maxend)
    return info


info = parse_image(0x552c24, len(data))
print('machine %04x nsec %d optsize %d magic %04x subsystem %d' % (
    info['machine'], info['nsec'], info['optsize'], info['magic'], info['subsystem']))
print('timestamp', datetime.datetime.fromtimestamp(info['timestamp'], datetime.UTC))
for s in info['sections']:
    print('  %-8s va=%08x vsz=%08x raw=%08x rawsz=%08x ch=%08x' % (
        s['name'], s['va'], s['vsz'], s['raw'], s['rawsz'], s['ch']))
print('image size:', info['size'], hex(info['size']))

base = info['base']
size = info['size']
win = data[base:base+size]
outdir = r'F:\Projects\逆向\extracted'
os.makedirs(outdir, exist_ok=True)
out = os.path.join(outdir, 'SuperMemo19_payload.exe')
open(out, 'wb').write(win)
print('written', out, len(win), hashlib.sha256(win).hexdigest())
print('tailing 32 bytes:', data[base+size:base+size+32].hex(' '))
