"""Read the SM-19 algorithm data files (alg17/) and check whether they hold
the same 21x21x21 structure that sm20-re reconstructed."""
import struct, os, math

C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19\alg17'
for name in sorted(os.listdir(C)):
    p = os.path.join(C, name)
    size = os.path.getsize(p)
    print('%-28s %8d bytes   /8=%-8.1f /4=%.1f  /9261=%s' % (
        name, size, size / 8, size / 4,
        ('%.2f' % (size / 9261)) if 9261 else '-'))

def read_doubles(name):
    b = open(os.path.join(C, name), 'rb').read()
    return struct.unpack('<%dd' % (len(b) // 8), b)

def read_ints(name):
    b = open(os.path.join(C, name), 'rb').read()
    return struct.unpack('<%di' % (len(b) // 4), b)

print('\n=== StabilityIncrease.dat (21^3 doubles) ===')
v = read_doubles('StabilityIncrease.dat')
nz = [x for x in v if x != 0.0]
print('cells:', len(v), 'non-zero:', len(nz))
if nz:
    print('min %.6f  max %.6f  mean %.6f' % (min(nz), max(nz), sum(nz) / len(nz)))
    print('first 12 non-zero:', ['%.6f' % x for x in nz[:12]])
print('cell[0]=%.6f cell[1]=%.6f cell[21]=%.6f cell[441]=%.6f cell[-1]=%.6f'
      % (v[0], v[1], v[21], v[441], v[-1]))

print('\n=== Recall.dat (21^3 int32) ===')
r = read_ints('Recall.dat')
nzr = [x for x in r if x != 0]
print('cells:', len(r), 'non-zero:', len(nzr))
if nzr:
    print('min %d max %d sum %d' % (min(nzr), max(nzr), sum(nzr)))

print('\n=== RecallCases.dat ===')
rc = read_ints('RecallCases.dat')
print('non-zero:', len([x for x in rc if x != 0]))

print('\n=== StabilityIncreaseCases.dat ===')
sc = read_ints('StabilityIncreaseCases.dat')
print('non-zero:', len([x for x in sc if x != 0]))

print('\n=== FirstInterval.dat (assume 21*21*36 doubles) ===')
fi = read_doubles('FirstInterval.dat')
print('values:', len(fi), '  21*21*36 =', 21 * 21 * 36)
nzf = [x for x in fi if x != 0.0]
print('non-zero:', len(nzf))
if nzf:
    print('first 8:', ['%.6f' % x for x in nzf[:8]])
    print('min %.6f max %.6f' % (min(nzf), max(nzf)))

print('\n=== ForgettingCurve.dat ===')
fc = read_doubles('ForgettingCurve.dat')
print('values:', len(fc))
print(['%.6f' % x for x in fc[:12]])

print('\n=== DifficultyDistribution.dat (int32?) ===')
dd = read_ints('DifficultyDistribution.dat')
print('values:', len(dd), dd[:20])
