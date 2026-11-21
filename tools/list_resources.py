import pefile

p = r'F:\Projects\逆向\extracted\SuperMemo19_payload.exe'
pe = pefile.PE(p, fast_load=True)
pe.parse_data_directories(directories=[
    pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_RESOURCE'],
])

RT = {1:'CURSOR',2:'BITMAP',3:'ICON',4:'MENU',5:'DIALOG',6:'STRING',7:'FONTDIR',8:'FONT',
      9:'ACCELERATOR',10:'RCDATA',11:'MESSAGETABLE',12:'GROUP_CURSOR',14:'GROUP_ICON',
      16:'VERSION',17:'DLGINCLUDE',19:'PLUGPLAY',20:'VXD',21:'ANICURSOR',22:'ANIICON',
      23:'HTML',24:'MANIFEST'}

rows = []
def walk(entry, depth, path):
    for ent in entry.entries:
        nm = ent.name.string.decode('utf-16le', 'ignore') if ent.name else str(ent.id)
        if hasattr(ent, 'directory'):
            walk(ent.directory, depth + 1, path + [nm])
        else:
            rows.append((path, nm, ent.data.struct.Size))

walk(pe.DIRECTORY_ENTRY_RESOURCE, 0, [])
agg = {}
for path, nm, size in rows:
    key = path[0] if path else '?'
    tname = RT.get(int(key), key) if key.isdigit() else key
    agg.setdefault(tname, [0, 0])
    agg[tname][0] += 1
    agg[tname][1] += size
print('%-16s %8s %10s' % ('TYPE', 'COUNT', 'BYTES'))
for k, v in sorted(agg.items(), key=lambda x: -x[1][1]):
    print('%-16s %8d %10d' % (k, v[0], v[1]))

print('\n== RCDATA / named user resources (top 40 by size) ==')
rd = [(p_, n, s) for p_, n, s in rows if p_ and p_[0] in ('10', 'RCDATA')]
for p_, n, s in sorted(rd, key=lambda x: -x[2])[:40]:
    print('  %-40s %8d' % ('/'.join(p_), s))
print('total RCDATA entries:', len(rd))
