"""Move newly appended functions above the main block and drop stray declarations."""
P = r'F:\Projects\逆向\sm19alg\smcli.lpr'
lines = open(P, encoding='utf-8').read().split('\n')

names = ['function HtmlEscape(const S: string): string;',
         'procedure HtmlTree(C: TSMCollection; Ordinal, Depth: Integer; SL: TStringList);',
         'procedure CmdExportHtml(const Root, OutFile: string);']

# 1) find the block start: first line that begins a real implementation (followed by var/begin)
start = None
for i, l in enumerate(lines):
    if l.strip() in names:
        nxt = lines[i + 1].strip() if i + 1 < len(lines) else ''
        if nxt in ('var', 'begin'):
            start = i
            break
if start is None:
    print('implementation block not found')
    raise SystemExit(1)

# 2) find the end: the last 'end;' before the final 'end.'
end = None
for j in range(len(lines) - 1, start, -1):
    if lines[j].rstrip() == 'end;':
        end = j
        break
if end is None:
    print('end of block not found')
    raise SystemExit(1)

block = lines[start:end + 1]
rest = lines[:start] + lines[end + 1:]

# 3) drop stray declarations in the implementation part
clean = []
for i, l in enumerate(rest):
    if l.strip() in names:
        nxt = rest[i + 1].strip() if i + 1 < len(rest) else ''
        if nxt not in ('var', 'begin'):
            print('dropping stray declaration:', l.strip()[:50])
            continue
    clean.append(l)

# 4) insert before the main var block
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
print('reordered export-html block')
