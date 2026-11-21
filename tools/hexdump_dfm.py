import struct, sys

p = r'F:\Projects\逆向\work\dfm_raw\002_0.dfm.bin'
b = open(p, 'rb').read()
print('len', len(b), 'head', b[:4])
for i in range(0, 420, 16):
    chunk = b[i:i+16]
    print('%04x  %s  %s' % (i, chunk.hex(' '), ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)))
