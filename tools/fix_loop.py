"""Iteratively fix compile errors: collect duplicate identifiers, extend the
blacklist, regenerate, rebuild. Also reports non-duplicate errors for triage."""
import subprocess, re, os, sys, json, time

BASE = r'F:\Projects\逆向'
PY = r'C:\Users\25335\AppData\Local\Programs\Python\Python312\python.exe'
LAZ = r'C:\lazarus\lazbuild.exe'
BLACKLIST = os.path.join(BASE, 'work', 'name_blacklist.json')
LOG = os.path.join(BASE, 'work', 'build.log')


def run(cmd):
    p = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8', errors='replace')
    return p.stdout + p.stderr


def build():
    out = run([LAZ, '--build-all', os.path.join(BASE, 'sm19src', 'sm19.lpi')])
    open(LOG, 'w', encoding='utf-8').write(out)
    return out


def regen():
    run([PY, os.path.join(BASE, 'tools', 'gen_skeleton.py')])
    run([PY, os.path.join(BASE, 'tools', 'prune_lfm.py')])


def load_bl():
    if os.path.exists(BLACKLIST):
        return set(json.load(open(BLACKLIST, encoding='utf-8')))
    return set()


def save_bl(s):
    json.dump(sorted(s), open(BLACKLIST, 'w', encoding='utf-8'), indent=1)


bl = load_bl()
for it in range(40):
    out = build()
    if 'Linking' in out and 'Error:' not in out:
        print('BUILD OK after', it, 'iterations')
        break
    dups = re.findall(r'Duplicate identifier "([^"]+)"', out)
    notfound = re.findall(r'Identifier not found "([^"]+)"', out)
    other = [l for l in out.splitlines() if re.search(r'(Error|Fatal):', l)]
    new = [d for d in dups if d not in bl]
    print('iter %d: dups=%d new=%d notfound=%s' % (it, len(dups), len(new), sorted(set(notfound))[:6]), flush=True)
    if new:
        bl |= set(new)
        save_bl(bl)
        regen()
        continue
    print('\n== remaining errors ==')
    for l in other[:25]:
        print(l)
    break
print('blacklist size', len(bl))
