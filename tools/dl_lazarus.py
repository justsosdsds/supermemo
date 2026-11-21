"""Resumable parallel downloader for the Lazarus installer (16 ranges)."""
import urllib.request, os, sys, threading, time

URL = ('https://phoenixnap.dl.sourceforge.net/project/lazarus/Lazarus%20Windows%2064%20bits/'
       'Lazarus%203.0/lazarus-3.0-fpc-3.2.2-win64.exe')
OUT = r'F:\Projects\逆向\_tmp\lazarus-setup.exe'
PARTS = OUT + '.parts'
THREADS = 16
TOTAL = 213787538


def fetch(i, start, end, results):
    part = os.path.join(PARTS, 'part%02d' % i)
    want = end - start + 1
    for attempt in range(40):
        have = os.path.getsize(part) if os.path.exists(part) else 0
        if have >= want:
            results[i] = True
            return
        rng = 'bytes=%d-%d' % (start + have, end)
        try:
            req = urllib.request.Request(URL, headers={'Range': rng, 'User-Agent': 'curl/8'})
            with urllib.request.urlopen(req, timeout=90) as r:
                with open(part, 'ab') as f:
                    while True:
                        chunk = r.read(1 << 16)
                        if not chunk:
                            break
                        f.write(chunk)
        except Exception as ex:
            print('part %d attempt %d at %d/%d: %s' % (i, attempt, have, want, type(ex).__name__), flush=True)
            time.sleep(1.5)
    results[i] = os.path.getsize(part) >= want if os.path.exists(part) else False


def main():
    os.makedirs(PARTS, exist_ok=True)
    chunk = TOTAL // THREADS + 1
    jobs = []
    for i in range(THREADS):
        s = i * chunk
        e = min(TOTAL - 1, s + chunk - 1)
        if s <= e:
            jobs.append((i, s, e))
    results = {}
    ths = []
    for i, s, e in jobs:
        t = threading.Thread(target=fetch, args=(i, s, e, results), daemon=True)
        t.start()
        ths.append(t)
    while any(t.is_alive() for t in ths):
        time.sleep(20)
        done = sum(os.path.getsize(os.path.join(PARTS, 'part%02d' % i))
                   for i, s, e in jobs if os.path.exists(os.path.join(PARTS, 'part%02d' % i)))
        print('progress %.1f / 203.9 MB' % (done / 1048576), flush=True)
    for t in ths:
        t.join()
    ok = all(results.get(i) for i, s, e in jobs)
    print('all parts ok:', ok, flush=True)
    if not ok:
        return 1
    with open(OUT, 'wb') as out:
        for i, s, e in jobs:
            with open(os.path.join(PARTS, 'part%02d' % i), 'rb') as f:
                out.write(f.read())
    print('assembled', os.path.getsize(OUT), flush=True)
    return 0


if __name__ == '__main__':
    sys.exit(main())
