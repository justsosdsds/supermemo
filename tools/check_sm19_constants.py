"""Check whether the SM-20 algorithm constants (x87 extended format) also
exist inside the 32-bit SuperMemo 19 binary — i.e. whether SM-19 uses the same
V2 formula that sm20-re reconstructed."""
import struct
from decimal import Decimal, getcontext, ROUND_FLOOR

getcontext().prec = 60


def ext80(value):
    """Encode a decimal literal as x87 80-bit extended (10 bytes)."""
    d = Decimal(str(value))
    sign = 0
    if d < 0:
        sign = 0x8000
        d = -d
    k = 0
    while d >= 2:
        d /= 2
        k += 1
    while d < 1:
        d *= 2
        k -= 1
    mant = int((d * (Decimal(2) ** 63)).to_integral_value(rounding=ROUND_FLOOR))
    exp = k + 16383
    return struct.pack('<QH', mant, sign | exp)


P = r'F:\Projects\逆向\extracted\SuperMemo19_payload.exe'
data = open(P, 'rb').read()

vals = ['9.29', '1.3', '1.0', '-0.08', '-0.31', '1.04', '0.07', '-1.88', '1.58',
        '600.0', '2.904', '500.0', '1000.0', '44530.0', '0.7', '2.0', '3.0', '12.0']
print('searching SM-19 payload for SM-20 constants in x87 extended (80-bit) form\n')
found = {}
for v in vals:
    pat = ext80(v)
    hits = []
    start = 0
    while len(hits) < 3:
        i = data.find(pat, start)
        if i < 0:
            break
        hits.append(i)
        start = i + 1
    found[v] = hits
    print('  %-8s ext80=%s  hits=%d  %s' % (
        v, pat.hex(' '), len(hits), [hex(h) for h in hits]))

print('\n--- also try 8-byte double with the value rounded through float ---')
for v in ['9.29', '1.3', '600.0', '500.0']:
    pat = struct.pack('<d', float(v))
    print('  %-6s double hits=%d' % (v, data.count(pat)))
