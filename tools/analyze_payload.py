import pefile, os, re, hashlib

p = r'F:\Projects\逆向\extracted\SuperMemo19_payload.exe'
pe = pefile.PE(p, fast_load=True)
pe.parse_data_directories(directories=[
    pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_IMPORT'],
    pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_EXPORT'],
    pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_RESOURCE'],
    pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_TLS'],
])
print('Machine:', pefile.MACHINE_TYPE[pe.FILE_HEADER.Machine])
print('TimeDateStamp:', pe.FILE_HEADER.dump_dict()['TimeDateStamp'])
print('Subsystem:', pefile.SUBSYSTEM_TYPE[pe.OPTIONAL_HEADER.Subsystem])
print('ImageBase: %08x  EntryPoint: %08x  SizeOfImage: %08x' % (
    pe.OPTIONAL_HEADER.ImageBase, pe.OPTIONAL_HEADER.AddressOfEntryPoint, pe.OPTIONAL_HEADER.SizeOfImage))
print('DLL:', bool(pe.FILE_HEADER.Characteristics & 0x2000))

print('\n== imports ==')
if hasattr(pe, 'DIRECTORY_ENTRY_IMPORT'):
    for e in pe.DIRECTORY_ENTRY_IMPORT:
        print('  %-24s %d funcs' % (e.dll.decode(), len(e.imports)))
else:
    print('  none')

print('\n== resources (top level) ==')
def walk(entry, depth=0, path=''):
    for ent in entry:
        nm = ent.name.string.decode('utf-16le', 'ignore') if ent.name else str(ent.id)
        if hasattr(ent, 'directory'):
            if depth < 1:
                print('  %s%s/' % ('  '*depth, nm))
            walk(ent.directory, depth+1, path + nm + '/')
if hasattr(pe, 'DIRECTORY_ENTRY_RESOURCE'):
    walk(pe.DIRECTORY_ENTRY_RESOURCE)

print('\n== version info ==')
try:
    for fi in pe.FileInfo:
        for f in fi:
            if hasattr(f, 'StringTable'):
                for st in f.StringTable:
                    for k, v in st.entries.items():
                        print('   %-20s %s' % (k.decode('utf-8', 'ignore'), v.decode('utf-8', 'ignore')))
except Exception as ex:
    print('  err', ex)

data = open(p, 'rb').read()
print('\n== markers ==')
for sig, label in [(b'UPX', 'UPX'), (b'.themida', 'Themida'), (b'VMProtect', 'VMProtect'),
                   (b'BSJB', '.NET metadata BSJB'), (b'mscoree', 'mscoree (CLR host)'),
                   (b'Borland', 'Borland'), (b'CodeGear', 'CodeGear'), (b'Embarcadero', 'Embarcadero'),
                   (b'TMainMenu', 'VCL TMainMenu'), (b'TMemo', 'VCL TMemo')]:
    print('  %-24s %d' % (label, data.count(sig)))

# Delphi version detection via known RTTI strings
for m in re.finditer(rb'Embarcadero|Delphi (?:1[0-9]|2[0-9])', data):
    s = data[max(0, m.start()-40):m.start()+60]
    print('  ctx:', re.sub(rb'[^\x20-\x7e]', b'.', s).decode())
    break
print('\nstrings with version-ish:')
for s in sorted(set(re.findall(rb'[ -~]{5,}', data))):
    t = s.decode()
    if any(k in t for k in ('Delphi', 'Embarcadero', 'Borland', 'SuperMemo 19', 'sm19')):
        print('  ', t[:100])
