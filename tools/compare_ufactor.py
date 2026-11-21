"""Compare the SM-19 on-disk StabilityIncrease matrix against the SM-20
U-factor table recovered by sm20-re."""
import struct, os

C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19\alg17'
b = open(os.path.join(C, 'StabilityIncrease.dat'), 'rb').read()
v = struct.unpack('<%dd' % (len(b) // 8), b)

UFACTOR_SM20 = [
    13.822076, 8.212571, 6.056511, 4.879609, 4.126662,
    3.598557, 3.205138, 2.899285, 2.653822, 2.451912,
    2.282528, 2.138131, 2.013379, 1.904376, 1.808207,
    1.722649, 1.645970, 1.576804, 1.514055, 1.456836,
]


def cell(r, s, d):
    return v[r * 441 + s * 21 + d]


print('=== SM-19 StabilityIncrease matrix rows (R=0) ===')
for s in (0, 1, 2, 3):
    row = [cell(0, s, d) for d in range(20)]
    print('S=%d: %s' % (s, ' '.join('%9.6f' % x for x in row[:10])))

print('\n=== row S=0 vs SM-20 U-factor table ===')
print('%-4s %12s %12s %10s' % ('D', 'SM-19 S=0', 'SM-20 UFACT', 'ratio'))
for d in range(10):
    a = cell(0, 0, d)
    b20 = UFACTOR_SM20[d]
    print('%-4d %12.6f %12.6f %10.6f' % (d, a, b20, a / b20 if b20 else 0))

print('\n=== row S=1 vs SM-20 U-factor table ===')
print('%-4s %12s %12s %10s' % ('D', 'SM-19 S=1', 'SM-20 UFACT', 'ratio'))
for d in range(10):
    a = cell(0, 1, d)
    b20 = UFACTOR_SM20[d]
    print('%-4d %12.6f %12.6f %10.6f' % (d, a, b20, a / b20 if b20 else 0))

print('\n=== does any row exactly equal the SM-20 table? ===')
for s in range(21):
    row = [cell(0, s, d) for d in range(20)]
    if all(abs(row[d] - UFACTOR_SM20[d]) < 1e-5 for d in range(20)):
        print('  exact match at R=0 S=%d' % s)
print('\n=== who equals 13.822076 (SM-20 U[0]) in the matrix? ===')
hits = [(i, x) for i, x in enumerate(v) if abs(x - 13.822076) < 1e-6]
for i, x in hits[:10]:
    print('  cell idx %6d -> R=%d S=%d D=%d' % (i, i // 441, (i % 441) // 21, i % 21))
