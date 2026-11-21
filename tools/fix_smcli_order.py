"""Move the CmdImport implementation above the main block and drop the stray
declaration that got inserted into the implementation section."""
P = r'F:\Projects\逆向\sm19alg\smcli.lpr'
lines = open(P, encoding='utf-8').read().split('\n')

# 1) find implementation start (procedure CmdImport ... followed by 'var')
impl_start = None
for i, l in enumerate(lines):
    if l.strip() == 'procedure CmdImport(const Root, QAPath: string);':
        nxt = lines[i + 1].strip() if i + 1 < len(lines) else ''
        if nxt == 'var':
            impl_start = i
            break
if impl_start is None:
    print('implementation not found')
    raise SystemExit(1)

# 2) find its end (matching 'end;' at column 0 followed by blank or 'end.')
impl_end = None
for j in range(impl_start + 1, len(lines)):
    if lines[j].rstrip() == 'end;':
        impl_end = j
        break
if impl_end is None:
    print('end not found')
    raise SystemExit(1)

block = lines[impl_start:impl_end + 1]
rest = lines[:impl_start] + lines[impl_end + 1:]

# 3) drop any remaining stray declaration of CmdImport in the implementation part
clean = []
for i, l in enumerate(rest):
    if l.strip() == 'procedure CmdImport(const Root, QAPath: string);':
        nxt = rest[i + 1].strip() if i + 1 < len(rest) else ''
        if nxt != 'var':
            print('dropping stray declaration at line', i + 1)
            continue
    clean.append(l)

# 4) insert the block right before the main var block
anchor = None
for i, l in enumerate(clean):
    if l.strip() == 'var' and i + 1 < len(clean) and 'cmd, root' in clean[i + 1]:
        anchor = i
        break
if anchor is None:
    print('main var block not found')
    raise SystemExit(1)

out = clean[:anchor] + [''] + block + [''] + clean[anchor:]
open(P, 'w', encoding='utf-8', newline='\n').write('\n'.join(out))
print('reordered CmdImport')
