"""Analyze the element records created by clicking Add new in the original."""
import struct, os

C = r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'


def dump_records(path, recsize, limit=6):
    p = os.path.join(C, path)
    b = open(p, 'rb').read()
    n = len(b) // recsize
    print('=' * 76)
    print('%s : %d bytes = %d records x %d bytes' % (path, len(b), n, recsize))
    print('=' * 76)
    recs = [b[i * recsize:(i + 1) * recsize] for i in range(n)]
    # field-by-field comparison
    for i, r in enumerate(recs[:limit]):
        print('rec %d: %s' % (i, r.hex(' ')))
    if n > 1:
        print('\nbytes that differ between rec0 and rec1:')
        diff = [j for j in range(min(len(recs[0]), len(recs[1])) if n > 1 else 0)
                if recs[0][j] != recs[1][j]]
        print('  offsets:', diff)
        for j in diff:
            print('    +%3d  0x%02x -> 0x%02x' % (j, recs[0][j], recs[1][j]))
    print()
    return recs


el = dump_records('info/ElementInfo.dat', 118)
co = dump_records('info/compon.dat', 116)
ct = dump_records('info/contents.dat', 37)

print('=' * 76)
print('interpretation probes')
print('=' * 76)
b = open(os.path.join(C, 'info/ElementInfo.dat'), 'rb').read()
for i in range(len(b) // 118):
    r = b[i * 118:(i + 1) * 118]
    ints = struct.unpack('<29i', r[:116])
    f = struct.unpack('<d', r[20:28])[0]
    print('rec %d: first ints=%s' % (i, ints[:8]))
    print('        double@20 = %.6f' % f)
    tail = r[110:118]
    print('        tail      = %s' % tail.hex(' '))
