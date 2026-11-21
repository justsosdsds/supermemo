"""Re-download a single range strictly (206 required), then assemble and verify."""
import urllib.request, os, sys

URL = ('https://phoenixnap.dl.sourceforge.net/project/lazarus/Lazarus%20Windows%2064%20bits/'
       'Lazarus%203.0/lazarus-3.0-fpc-3.2.2-win64.exe')
OUT = r'F:\Projects\逆向\_tmp\lazarus-setup.exe'
PARTS = OUT + '.parts'
TOTAL = 213787538
THREADS = 16

idx = int(sys.argv[1]) if len(sys.argv) > 1 else 4
chunk = TOTAL // THREADS + 1
start = idx * chunk
end = min(TOTAL - 1, start + chunk - 1)
want = end - start + 1
part = os.path.join(PARTS, 'part%02d' % idx)
if os.path.exists(part):
    os.remove(part)

for attempt in range(20):
    try:
        req = urllib.request.Request(URL, headers={'Range': 'bytes=%d-%d' % (start, end), 'User-Agent': 'curl/8'})
        with urllib.request.urlopen(req, timeout=90) as r:
            code = r.status
            if code != 206:
                raise IOError('server ignored Range, status %s' % code)
            data = b''
            while True:
                chunkb = r.read(1 << 16)
                if not chunkb:
                    break
                data += chunkb
        print('got', len(data), 'want', want, flush=True)
        if len(data) == want:
            open(part, 'wb').write(data)
            print('part written', flush=True)
            break
    except Exception as ex:
        print('attempt', attempt, type(ex).__name__, ex, flush=True)

if not os.path.exists(part) or os.path.getsize(part) != want:
    print('FAILED part', idx, flush=True)
    sys.exit(1)

sizes = {}
for i in range(THREADS):
    p = os.path.join(PARTS, 'part%02d' % i)
    if os.path.exists(p):
        sizes[i] = os.path.getsize(p)
print('sizes', sizes, 'sum', sum(sizes.values()), 'expect', TOTAL)
if sum(sizes.values()) != TOTAL:
    print('size mismatch, abort', flush=True)
    sys.exit(1)

with open(OUT, 'wb') as out:
    for i in range(THREADS):
        with open(os.path.join(PARTS, 'part%02d' % i), 'rb') as f:
            out.write(f.read())
print('assembled', os.path.getsize(OUT), flush=True)
head = open(OUT, 'rb').read(2)
print('magic', head, flush=True)
