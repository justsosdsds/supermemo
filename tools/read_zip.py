import zipfile, sys, os

Z = r'F:\Downloads\sm20-re-main.zip'
z = zipfile.ZipFile(Z)
for name in ['sm20-re-main/README.md']:
    print('=' * 78)
    print(name)
    print('=' * 78)
    print(z.read(name).decode('utf-8', 'replace'))
