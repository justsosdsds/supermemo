import struct, re

p = r'G:\SuperMemo19_Unlocked_Setup.exe'
data = open(p, 'rb').read()
print('file size', len(data))

# find all MZ/PE pairs
mz = [m.start() for m in re.finditer(b'MZ', data)]
pe = [m.start() for m in re.finditer(b'PE\x00\x00', data)]
print('MZ count', len(mz), 'sample', [hex(x) for x in mz[:12]])
print('PE count', len(pe), 'sample', [hex(x) for x in pe[:12]])
valid = []
for m in mz:
    if m + 0x40 > len(data):
        continue
    try:
        e = struct.unpack_from('<I', data, m + 0x3C)[0]
    except Exception:
        continue
    if 0 < e < 0x400 and data[m + e:m + e + 4] == b'PE\0\0':
        valid.append(m)
print('valid PE images:', [hex(v) for v in valid])

def dump(off, n=256, label=''):
    print('--- %s @ %s ---' % (label, hex(off)))
    for i in range(0, n, 16):
        chunk = data[off + i:off + i + 16]
        print('%08x  %s  %s' % (off + i, chunk.hex(' '), ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)))

for sig in (b'Inno Setup Setup Data', b'Inno Setup Messages', b'InnoSetupLdr'):
    for m in re.finditer(re.escape(sig), data):
        dump(m.start(), 192, sig.decode())

# Inno 5.x setup data header: signature string then fields; look for known ASCII with version
i = data.find(b'Inno Setup Setup Data (5.5.7)')
print('setup data at', hex(i))
dump(i - 32, 256, 'setup data ctx')
