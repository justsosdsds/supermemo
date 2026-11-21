import re, sys
sys.path.insert(0, r'F:\Projects\逆向\tools')
from prune_lfm import load_dump, OBJ_RE, balance

path = r'F:\Projects\逆向\sm19src\units\uMyFindDlg.lfm'
allowed = load_dump(r'F:\Projects\逆向\sm19src\tools\props.txt')
lines = open(path, encoding='utf-8').read().splitlines()
stack = []
i = 0
while i < len(lines):
    raw = lines[i]
    s = raw.strip()
    m = OBJ_RE.match(s)
    if m:
        stack.append(m.group(3))
        print('%4d OBJ  %-30s stack=%s' % (i + 1, s[:30], stack[-2:]))
        i += 1
        continue
    if s == 'end':
        if stack:
            stack.pop()
        print('%4d END  stack now %s' % (i + 1, stack[-2:]))
        i += 1
        continue
    if '=' in s:
        key = s.split('=', 1)[0].strip()
        cls = stack[-1] if stack else 'TForm'
        props = allowed.get(cls) or allowed.get('TForm')
        keep = key in props or key.startswith('On')
        if not keep and '.' in key:
            keep = key.split('.')[0] in props
        if 'Margins' in key or i < 30:
            print('%4d PROP cls=%-16s key=%-22s keep=%s' % (i + 1, cls, key, keep))
        block = [raw]
        depth = balance(s)
        i += 1
        while i < len(lines) and depth > 0:
            block.append(lines[i])
            depth += balance(lines[i])
            i += 1
        continue
    i += 1
