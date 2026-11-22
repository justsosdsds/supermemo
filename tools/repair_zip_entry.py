"""Repair a single corrupt entry inside a zip by fetching only its compressed
bytes with an HTTP Range request and inflating them locally.

The download was resumed several times, so one region of the archive has a bad
local file header. Everything else extracts fine, so re-downloading 543 MB for
a 22 MB payload is wasteful.
"""
import zipfile, zlib, struct, urllib.request, os, sys

ZIP = r'F:\Tools\ghidra_12.2.zip'
ENTRY = 'ghidra_12.2_PUBLIC/Ghidra/Features/Base/lib/Base.jar'
OUT = r'F:\Tools\ghidra_extract\ghidra_12.2_PUBLIC\Ghidra\Features\Base\lib\Base.jar'
URL = ('https://github.com/NationalSecurityAgency/ghidra/releases/download/'
       'Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip')
UA = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

z = zipfile.ZipFile(ZIP)
info = z.getinfo(ENTRY)
print('target : %s' % ENTRY)
print('  header_offset : %d' % info.header_offset)
print('  compress_size : %d' % info.compress_size)
print('  file_size     : %d' % info.file_size)
print('  method        : %d (8 = deflate)' % info.compress_type)

# A local file header is 30 bytes + name + extra; we need the compressed data
# that follows it. Fetch a window that definitely covers header + payload.
WINDOW = 30 + len(info.filename.encode()) + 4096
start = info.header_offset
end = start + WINDOW + info.compress_size
print('\nfetching bytes %d..%d (%.1f MB)' % (start, end, (end - start) / 1048576))

req = urllib.request.Request(URL, headers=dict(UA, Range='bytes=%d-%d' % (start, end)))
with urllib.request.urlopen(req, timeout=120) as r:
    blob = r.read()
print('received: %d bytes' % len(blob))

if blob[:4] != b'PK\x03\x04':
    print('ERROR: local header signature not found, got %r' % blob[:8])
    sys.exit(2)

# parse local file header
sig, ver, flags, method, mtime, mdate, crc, csize, usize, nlen, elen = struct.unpack(
    '<IHHHHHIIIHH', blob[:30])
name = blob[30:30 + nlen].decode('utf-8', 'replace')
data_off = 30 + nlen + elen
print('local header: name=%s method=%d csize=%d usize=%d crc=0x%08x' % (
    name, method, csize, usize, crc))
print('data offset within window: %d' % data_off)

if method != 8:
    print('ERROR: unexpected compression method %d' % method)
    sys.exit(3)

comp = blob[data_off:data_off + csize]
if len(comp) != csize:
    print('ERROR: short read: have %d want %d' % (len(comp), csize))
    sys.exit(4)

try:
    raw = zlib.decompress(comp, -15)
except Exception as e:
    print('ERROR: inflate failed: %s' % e)
    sys.exit(5)

print('inflated: %d bytes (expected %d)' % (len(raw), usize))
if len(raw) != usize:
    print('ERROR: size mismatch')
    sys.exit(6)

os.makedirs(os.path.dirname(OUT), exist_ok=True)
open(OUT, 'wb').write(raw)
print('\nwrote %s (%d bytes)' % (OUT, len(raw)))

# sanity: a jar is a zip
if raw[:4] == b'PK\x03\x04':
    print('OK: payload is a valid zip/jar')
else:
    print('WARNING: payload does not start with a zip signature')
