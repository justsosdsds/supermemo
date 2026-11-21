import zipfile, re, sys

Z = r'F:\Downloads\sm20-re-main.zip'
z = zipfile.ZipFile(Z)
name = sys.argv[1] if len(sys.argv) > 1 else 'sm20-re-main/REVERSE_ENGINEERING_REPORT.md'
limit = int(sys.argv[2]) if len(sys.argv) > 2 else 0
text = z.read(name).decode('utf-8', 'replace')
lines = text.splitlines()
print('# file:', name, 'lines:', len(lines))
print()
if limit == 0:
    for ln in lines:
        if ln.startswith('#'):
            print(ln)
else:
    print('\n'.join(lines[:limit]))
