"""Repair every missing/corrupt entry by fetching only that entry's compressed
bytes with HTTP Range and inflating locally.

Walk the zip's central directory against the extracted tree; for each file whose
local header is invalid (or that is absent on disk) fetch just that region.
"""
import zipfile, zlib, struct, urllib.request, os, sys, time

ZIP = r'F:\Tools\ghidra_12.2.zip'
ROOT = r'F:\Tools\ghidra_extract'
URL = ('https://github.com/NationalSecurityAgency/ghidra/releases/download/'
       'Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip')
UA = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
PREFIX = 'ghidra_12.2_PUBLIC/'


def fetch(off, size, tries=4):
    for a in range(tries):
        try:
            req = urllib.request.Request(URL, headers=dict(UA, Range='bytes=%d-%d' % (off, off + size - 1)))
            with urllib.request.urlopen(req, timeout=90) as r:
                return r.read()
        except Exception as e:
            if a == tries - 1:
                raise
            time.sleep(1.5 * (a + 1))


def fix_entry(z, info):
    """Returns (status, bytes_written)."""
    rel = info.filename[len(PREFIX):]
    dest = os.path.join(ROOT, PREFIX.rstrip('/'), rel)
    # skip if already complete
    if os.path.exists(dest) and os.path.getsize(dest) == info.file_size:
        return ('ok', 0)

    start = info.header_offset
    # local header + name + extra + payload
    win = 30 + len(info.filename.encode()) + 8192 + max(info.compress_size, 64)
    blob = fetch(start, win)
    if blob[:4] != b'PK\x03\x04':
        return ('bad-sig', 0)
    sig, ver, flags, method, mtime, mdate, crc, csize, usize, nlen, elen = struct.unpack('<IHHHHHIIIHH', blob[:30])
    if csize != info.compress_size or usize != info.file_size:
        return ('size-mismatch', 0)
    doff = 30 + nlen + elen
    comp = blob[doff:doff + csize]
    if len(comp) != csize:
        return ('short', 0)
    if method == 0:
        raw = comp
    else:
        try:
            raw = zlib.decompress(comp, -15)
        except Exception as e:
            return ('inflate:' + str(e)[:30], 0)
    if len(raw) != usize:
        return ('len-mismatch', 0)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    open(dest, 'wb').write(raw)
    return ('repaired', len(raw))


def main():
    z = zipfile.ZipFile(ZIP)
    # only the small but structurally important files first
    wanted = []
    for info in z.infolist():
        if info.is_dir():
            continue
        n = info.filename
        if (n.endswith('Module.manifest') or n.endswith('application.properties')
                or n.endswith('.properties') or n.endswith('.xml')
                or n.endswith('.py') or '/data/' in n):
            wanted.append(info)

    print('candidates: %d' % len(wanted))
    stats = {}
    total_bytes = 0
    for i, info in enumerate(wanted):
        try:
            st, n = fix_entry(z, info)
        except Exception as e:
            st, n = 'fetch-fail', 0
        stats[st] = stats.get(st, 0) + 1
        total_bytes += n
        if st not in ('ok',) and n:
            print('  [%s] %s (%d bytes)' % (st, info.filename[len(PREFIX):], n), flush=True)
        if (i + 1) % 200 == 0:
            print('  ... %d/%d' % (i + 1, len(wanted)), flush=True)
    print()
    print('summary: %s' % stats)
    print('bytes repaired: %.1f MB' % (total_bytes / 1048576))


if __name__ == '__main__':
    main()
