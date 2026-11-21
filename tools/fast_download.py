"""Multi-threaded segmented downloader with resume support.

Splits the remote file into N byte ranges, fetches them concurrently and
writes each chunk at its own offset, so an interrupted run can resume.
"""
import os, sys, threading, time, urllib.request, urllib.error

URL = ('https://github.com/NationalSecurityAgency/ghidra/releases/download/'
       'Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip')
OUT = r'F:\Tools\ghidra_12.2.zip'
THREADS = 16
CHUNK = 4 * 1024 * 1024      # 4 MB per request
UA = {'User-Agent': 'Mozilla/5.0'}


def head_size():
    req = urllib.request.Request(URL, headers=UA, method='HEAD')
    with urllib.request.urlopen(req, timeout=30) as r:
        return int(r.headers['Content-Length'])


def fetch_range(start, end, attempt=0):
    """Return bytes [start, end] inclusive."""
    req = urllib.request.Request(URL, headers=dict(UA, Range='bytes=%d-%d' % (start, end)))
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return r.read()
    except Exception as e:
        if attempt < 4:
            time.sleep(1.5 * (attempt + 1))
            return fetch_range(start, end, attempt + 1)
        raise


lock = threading.Lock()
done_bytes = [0]
start_time = [time.time()]


def worker(ranges, fh, total):
    for (s, e) in ranges:
        try:
            data = fetch_range(s, e)
        except Exception as exc:
            with lock:
                print('  chunk %d-%d FAILED: %s' % (s, e, exc))
            continue
        with lock:
            fh.seek(s)
            fh.write(data)
            fh.flush()
            done_bytes[0] += len(data)
            elapsed = time.time() - start_time[0]
            speed = done_bytes[0] / elapsed / 1024 / 1024 if elapsed > 0 else 0
            pct = 100.0 * done_bytes[0] / total
            print('  %5.1f%%  %6.1f MB / %.0f MB  %.2f MB/s' % (
                pct, done_bytes[0] / 1048576, total / 1048576, speed), flush=True)


def main():
    total = head_size()
    print('remote size: %d bytes (%.0f MB)' % (total, total / 1048576))

    have = os.path.getsize(OUT) if os.path.exists(OUT) else 0
    print('local file : %d bytes (%.0f MB)' % (have, have / 1048576))

    # build the missing ranges, skipping what we already have contiguously
    ranges = []
    pos = have
    while pos < total:
        end = min(pos + CHUNK - 1, total - 1)
        ranges.append((pos, end))
        pos = end + 1
    print('pending chunks: %d (%.0f MB to fetch)' % (
        len(ranges), sum(e - s + 1 for s, e in ranges) / 1048576))

    if not ranges:
        print('already complete')
        return 0

    mode = 'r+b' if have else 'wb'
    with open(OUT, mode) as fh:
        # bucket the ranges round-robin so every thread gets a fair share
        buckets = [[] for _ in range(THREADS)]
        for i, r in enumerate(ranges):
            buckets[i % THREADS].append(r)
        threads = [threading.Thread(target=worker, args=(b, fh, total))
                   for b in buckets if b]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

    final = os.path.getsize(OUT)
    print('final size: %d bytes (%.0f MB) — expected %d' % (
        final, final / 1048576, total))
    return 0 if final == total else 1


if __name__ == '__main__':
    sys.exit(main())
