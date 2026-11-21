import re

p = r'G:\SuperMemo19_Unlocked_Setup.exe'
with open(p, 'rb') as f:
    data = f.read()

# Inno Setup signatures
sigs = {
    b'Inno Setup Setup Data': 'Inno Setup Setup Data (compressed header/stream)',
    b'Inno Setup Messages': 'Inno Setup Messages',
    b'rDlPtS02': 'Inno 6 zlib chunk marker (rDlPtS02)',
    b'zlb': 'zlib stream',
    b'nsis': 'NSIS',
    b'ISETUP': 'ISETUP',
    b'InnoSetupLdr': 'InnoSetupLdr',
}
for s, label in sigs.items():
    idx = [m.start() for m in re.finditer(re.escape(s), data)][:6]
    print('%-42s count=%d offsets=%s' % (label, data.count(s), [hex(i) for i in idx]))

print('--- version resources / strings near tail ---')
tail = data[-4096:]
for enc, name in ((b'\x00', 'ascii-ish'),):
    pass

# find UTF-16 strings in last 1MB
seg = data[-1048576:]
u = re.findall(rb'(?:[\x20-\x7e]\x00){5,}', seg)
seen = []
for s in u:
    d = s.decode('utf-16le', 'ignore')
    if d not in seen:
        seen.append(d)
print('\n'.join('  ' + s for s in seen[:50]))

# ASCII strings mentioning Inno / SuperMemo
a = re.findall(rb'[\x20-\x7e]{6,}', data)
hits = [s.decode('latin1') for s in a if b'SuperMemo' in s or b'Inno' in s or b'setup' in s.lower()[:0]]
print('--- ascii hits (SuperMemo/Inno) ---')
for s in hits[:40]:
    print('  ', s[:120])
