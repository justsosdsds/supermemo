import os, sys, struct

C = r'F:\Projects\逆向\extracted\systems\ABC of SuperMemo 19'


def dump(path, limit=400):
    p = os.path.join(C, path)
    b = open(p, 'rb').read()
    print('=' * 74)
    print('%s  (%d bytes)' % (path, len(b)))
    print('=' * 74)
    for i in range(0, min(len(b), limit), 16):
        chunk = b[i:i + 16]
        hexs = ' '.join('%02x' % c for c in chunk)
        ascii_ = ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)
        print('%08x  %-47s  %s' % (i, hexs, ascii_))
    if len(b) > limit:
        print('... (%d more bytes)' % (len(b) - limit))
    print()


for f in ['collection.ini', 'info/ElementInfo.dat', 'info/contents.dat',
          'registry/Text.mem', 'registry/Text.rtx', 'registry/Text.lst',
          'registry/Text.ptr', 'registry/Concept.dat', 'registry/Concept.mem',
          'registry/Concept.rtx', 'registry/Tasklist.rtx', 'info/emptyslots.dat',
          'info/priority.sub', 'stats/total.dat']:
    try:
        dump(f)
    except Exception as ex:
        print('ERR', f, ex)

print('=' * 74)
print('systems .Kno index file')
print('=' * 74)
k = r'F:\Projects\逆向\extracted\systems\ABC of SuperMemo 19.Kno'
b = open(k, 'rb').read()
for i in range(0, min(len(b), 320), 16):
    chunk = b[i:i + 16]
    print('%08x  %-47s  %s' % (i, ' '.join('%02x' % c for c in chunk),
                               ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)))
