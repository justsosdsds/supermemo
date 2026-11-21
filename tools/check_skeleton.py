"""Static sanity check of the generated skeleton: name collisions and lfm grammar."""
import os, glob, re, json, collections

UNITS = r'F:\Projects\逆向\sm19src\units'

BASE_METHODS = set('''create destroy free show hide close setfocus repaint invalidate
afterconstruction beforedestruction classtype classname tostring equals getnamepath
safecallexception newinstance freeinstance defaulthandler dispatch defaulthandler
setparentcomponent getparentcomponent hasparent executemenu getchildren
findcomponent getchildowner getchildparent loaded notification setname
getowner showmodal showintaskbar bringtofront sendtoback setbounds
setdesigning setinline updating endupdate beginupdate getenabled
insertcontrol removecontrol realign controlcount insertcomponent
removecomponent destroycomponents findchildcontrol gettaborderlist
definedproperties getdispservername'''.split())

rows = []
problems = collections.defaultdict(list)
for pas in sorted(glob.glob(os.path.join(UNITS, '*.pas'))):
    text = open(pas, encoding='utf-8').read()
    unit = os.path.basename(pas)[:-4]
    cls = re.search(r'^\s{2}(\w+) = class\(TForm\)', text, re.M)
    if not cls:
        problems['no_class'].append(unit)
        continue
    cls = cls.group(1)
    fields = re.findall(r'^\s{4}(&?\w+): (\w+);$', text, re.M)
    procs = re.findall(r'^\s{4}procedure (&?\w+)\(([^)]*)\);$', text, re.M)
    fnames = [f[0].lstrip('&') for f in fields]
    pnames = [p[0].lstrip('&') for p in procs]
    dupf = [k for k, v in collections.Counter(fnames).items() if v > 1]
    dupp = [k for k, v in collections.Counter(pnames).items() if v > 1]
    clash = sorted(set(fnames) & set(pnames))
    basem = sorted(n for n in set(fnames) | set(pnames) if n.lower() in BASE_METHODS)
    if dupf:
        problems['dup_field'].append((unit, dupf))
    if dupp:
        problems['dup_proc'].append((unit, dupp))
    if clash:
        problems['field_proc_clash'].append((unit, clash))
    if basem:
        problems['base_method_clash'].append((unit, basem))
    types = sorted({t for _, t in fields})
    rows.append((unit, cls, len(fields), len(procs), types))

print('units:', len(rows), 'fields:', sum(r[2] for r in rows), 'procs:', sum(r[3] for r in rows))
for k, v in problems.items():
    print('\n== %s (%d) ==' % (k, len(v)))
    for item in v[:12]:
        print('  ', item)
alltypes = collections.Counter()
for r in rows:
    for t in r[4]:
        alltypes[t] += 1
print('\nfield types used:', len(alltypes))
