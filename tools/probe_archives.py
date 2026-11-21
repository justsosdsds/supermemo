import zipfile, os, sys

cands = [r'F:\Projects\GROVE存档.apk', r'F:\Projects\Grove-settings-inline-drawers-source.zip']
for p in cands:
    print('=' * 70)
    if not os.path.exists(p):
        print(p, 'MISSING')
        continue
    print(p, os.path.getsize(p), 'bytes')
    try:
        z = zipfile.ZipFile(p)
        names = z.namelist()
        print('entries:', len(names))
        tops = {}
        for n in names:
            k = n.split('/')[0] + ('/' if '/' in n else '')
            tops[k] = tops.get(k, 0) + 1
        for k, v in sorted(tops.items(), key=lambda x: -x[1])[:30]:
            print('  %5d  %s' % (v, k))
        print('--- first 40 ---')
        for n in names[:40]:
            print('   -', n)
    except Exception as e:
        print('ERR', e)
