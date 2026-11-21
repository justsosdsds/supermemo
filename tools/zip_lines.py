import zipfile, sys

Z = r'F:\Downloads\sm20-re-main.zip'
z = zipfile.ZipFile(Z)
name = sys.argv[1]
start = int(sys.argv[2]) if len(sys.argv) > 2 else 1
end = int(sys.argv[3]) if len(sys.argv) > 3 else 120
lines = z.read(name).decode('utf-8', 'replace').splitlines()
for i, ln in enumerate(lines[start - 1:end], start):
    print('%4d| %s' % (i, ln))
