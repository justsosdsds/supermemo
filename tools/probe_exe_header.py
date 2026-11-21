import os, sys, struct, hashlib, re

p = r'G:\SuperMemo19_Unlocked_Setup.exe'
print('exists:', os.path.exists(p))
if not os.path.exists(p):
    sys.exit(0)
st = os.stat(p)
print('size:', st.st_size, '(%.2f MB)' % (st.st_size / 1048576))
h = hashlib.sha256()
with open(p, 'rb') as f:
    for chunk in iter(lambda: f.read(1 << 20), b''):
        h.update(chunk)
print('sha256:', h.hexdigest())

with open(p, 'rb') as f:
    data = f.read(4 << 20)
    f.seek(0, 2)
    tail = b''
    f.seek(max(0, st.st_size - (2 << 20)))
    tail = f.read()

print('mz/dos header:', data[:2], data[:64].hex()[:80])
e_lfanew = struct.unpack_from('<I', data, 0x3C)[0]
print('e_lfanew:', hex(e_lfanew), 'sig:', data[e_lfanew:e_lfanew+4])
pe = e_lfanew
if data[pe:pe+4] == b'PE\0\0':
    machine, nsec, tstamp, _, _, chars, magic = struct.unpack_from('<HHIIIHH', data, pe+4)
    print('machine: %04x  sections: %d  optmagic: %04x  characteristics: %04x' % (machine, nsec, magic, chars))
    opt_size = struct.unpack_from('<H', data, pe+20)[0]
    sec_off = pe + 24 + opt_size
    for i in range(nsec):
        o = sec_off + i * 40
        name = data[o:o+8].rstrip(b'\0').decode('latin1')
        vsz, va, rsz, ra = struct.unpack_from('<IIII', data, o+8)
        print('  sec %-8s va=%08x vsz=%08x raw=%08x rawsz=%08x' % (name, va, vsz, ra, rsz))
    # subsystem / clr
    sub = struct.unpack_from('<H', data, pe+24+68)[0]
    print('subsystem:', sub)
    ddir = pe + 24 + 96
    # data directories start at offset 96 for PE32, 112 for PE32+
    ddoff = pe + 24 + (96 if magic == 0x10b else 112)
    for idx, nm in [(0,'export'),(1,'import'),(5,'reloc'),(6,'debug'),(14,'clr')]:
        rva, sz = struct.unpack_from('<II', data, ddoff + idx*8)
        if rva or sz:
            print('  dir %-7s rva=%08x size=%08x' % (nm, rva, sz))

for marker, label in [
    (b'Inno Setup', 'Inno Setup'),
    (b'Nullsoft', 'NSIS'),
    (b'InstallShield', 'InstallShield'),
    (b'WISE', 'Wise'),
    (b'MSI', 'MSI'),
    (b'7-Zip', '7z SFX'),
    (b'Borland', 'Borland'),
    (b'Delphi', 'Delphi'),
    (b'.NET', '.NET'),
    (b'This installation was built with Inno Setup', 'Inno banner'),
]:
    print('marker %-38s %s' % (label, data.count(marker)), 'tail:', tail.count(marker))

print('--- unicode strings in first 4MB (sample) ---')
u = re.findall(rb'(?:[\x20-\x7e]\x00){6,}', data)
dec = [s.decode('utf-16le', 'ignore') for s in u]
seen = []
for s in dec:
    if len(s) > 6 and s not in seen:
        seen.append(s)
print(len(seen), 'strings')
for s in seen[:60]:
    print('  ', s)
