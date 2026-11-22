"""Diff two component blocks byte by byte and try to align their structures.

Used to understand the 81-byte (one component) vs 112-byte (two components)
layouts that the original writes for a plain text element and a cloze item.

Prints:
  * every differing offset with both values
  * the longest common prefixes/suffixes, which delimit the repeated per-
    component records
  * a candidate split of the larger block on the byte pattern that starts each
    component

Usage:
  python diff_component.py <collection> <slot_a> <slot_b>
"""
import struct, os, sys


def load_blocks(coll):
    info = open(os.path.join(coll, 'info', 'ElementInfo.dat'), 'rb').read()
    comp = open(os.path.join(coll, 'info', 'compon.dat'), 'rb').read()
    out = {}
    for i in range(len(info) // 118):
        r = info[i * 118:(i + 1) * 118]
        off = struct.unpack_from('<I', r, 6)[0]
        sz = struct.unpack_from('<H', r, 10)[0]
        eid = struct.unpack_from('<H', r, 2)[0]
        if off != 0xFFFFFFFF and sz:
            out[i + 1] = dict(id=eid, off=off, size=sz, data=comp[off:off + sz])
    return out


def hexdump(b, base=0, width=16):
    for j in range(0, len(b), width):
        chunk = b[j:j + width]
        asc = ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)
        print('  %04x  %-*s  %s' % (base + j, width * 3, chunk.hex(' '), asc))


def main(coll, sa, sb):
    bl = load_blocks(coll)
    if sa not in bl or sb not in bl:
        print('slots available:', sorted(bl))
        return 2
    A, B = bl[sa], bl[sb]
    a, b = A['data'], B['data']
    print('slot %d  id=%d  size=%d' % (sa, A['id'], A['size']))
    print('slot %d  id=%d  size=%d' % (sb, B['id'], B['size']))
    print()
    print('=== block %d (slot %d) ===' % (A['size'], sa))
    hexdump(a)
    print()
    print('=== block %d (slot %d) ===' % (B['size'], sb))
    hexdump(b)
    print()

    n = min(len(a), len(b))
    diffs = [j for j in range(n) if a[j] != b[j]]
    print('=== differences within the common %d bytes ===' % n)
    for j in diffs:
        print('  +%-3d  0x%02x -> 0x%02x' % (j, a[j], b[j]))
    if not diffs:
        print('  (none)')
    print()

    # common prefix / suffix
    p = 0
    while p < n and a[p] == b[p]:
        p += 1
    s = 0
    while s < n - p and a[len(a) - 1 - s] == b[len(b) - 1 - s]:
        s += 1
    print('=== alignment ===')
    print('  common prefix length : %d' % p)
    print('  common suffix length : %d' % s)
    print('  middle A: %d bytes  %s' % (len(a) - p - s, a[p:len(a) - s].hex(' ')))
    print('  middle B: %d bytes  %s' % (len(b) - p - s, b[p:len(b) - s].hex(' ')))
    print()

    # look for a repeating marker that may start each component record
    for marker in (b'\x0d\x1c', b'\x00\x64'):
        pos = [j for j in range(len(b) - 1) if b[j:j + 2] == marker]
        print('  marker %s found at %s in block B' % (marker.hex(' '), pos))
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1], int(sys.argv[2]), int(sys.argv[3])))
