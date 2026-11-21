"""Prune LFM files to the published properties LCL provides.

Line-oriented and structure-safe: object/end nesting is tracked, and multi-line
property values (lists and collections, possibly nested) are consumed by
bracket balancing so their inner lines are never re-interpreted.
"""
import os, glob, re, sys, collections

UNITS = r'F:\Projects\逆向\sm19src\units'
PROP_DUMP = r'F:\Projects\逆向\sm19src\tools\props.txt'

OBJ_RE = re.compile(r'^(object|inherited)\s+([A-Za-z0-9_&]*)\s*:\s*([A-Za-z0-9_]+)')


def load_dump(path):
    allowed = {}
    for line in open(path, encoding='utf-8', errors='replace'):
        line = line.rstrip('\n')
        if '=' not in line:
            continue
        cls, val = line.split('=', 1)
        if val.startswith('<'):
            allowed[cls.strip()] = set()
        else:
            allowed[cls.strip()] = {p for p in val.split(',') if p}
    return allowed


VALUE_MAP = {
    # Delphi enum names that LCL spells differently or lacks
    'tbsTextButton': 'tbsButton',
}

QUOTED = re.compile(r"'(?:[^']|'')*'")


def strip_quoted(line):
    return QUOTED.sub("''", line)


def balance(line):
    s = strip_quoted(line)
    return s.count('<') + s.count('(') - s.count('>') - s.count(')')


def map_values(line):
    m = re.match(r'^(\s*[A-Za-z0-9_.]+\s*=\s*)([A-Za-z0-9_.]+)(\s*)$', line)
    if m and m.group(2) in VALUE_MAP:
        return m.group(1) + VALUE_MAP[m.group(2)] + m.group(3)
    return line


def prune(path, allowed, stats):
    lines = open(path, encoding='utf-8').read().splitlines()
    out = []
    stack = []
    i = 0
    while i < len(lines):
        raw = lines[i]
        s = raw.strip()
        m = OBJ_RE.match(s)
        if m:
            stack.append(m.group(3))
            out.append(raw)
            i += 1
            continue
        if s == 'end':
            if stack:
                stack.pop()
            out.append(raw)
            i += 1
            continue
        if '=' in s and not s.startswith('#'):
            # property
            key = s.split('=', 1)[0].strip()
            cls = stack[-1] if stack else 'TForm'
            props = allowed.get(cls)
            if props is None:
                props = allowed.get('TForm')
                stats['unknown_class'].add(cls)
            keep = (props is None) or key in props
            if not keep and '.' in key:
                keep = key.split('.')[0] in props
            block = [raw]
            depth = balance(s)
            i += 1
            while i < len(lines) and depth > 0:
                block.append(lines[i])
                depth += balance(lines[i])
                i += 1
            if keep:
                out.append(map_values(block[0]))
                out.extend(block[1:])
            else:
                stats['dropped'].add('%s.%s' % (cls, key))
            continue
        out.append(raw)
        i += 1
    return '\n'.join(out) + '\n'


def main():
    if not os.path.exists(PROP_DUMP):
        print('missing prop dump')
        return 1
    allowed = load_dump(PROP_DUMP)
    # filer-defined (non-RTTI) properties that both Delphi and LCL stream
    allowed.setdefault('TImageList', set()).add('Bitmap')
    total = collections.Counter()
    unknown = collections.Counter()
    for path in sorted(glob.glob(os.path.join(UNITS, '*.lfm'))):
        stats = dict(dropped=set(), unknown_class=set())
        new = prune(path, allowed, stats)
        open(path, 'w', encoding='utf-8', newline='\n').write(new)
        for d in stats['dropped']:
            total[d.split('.')[-1]] += 1
        for u in stats['unknown_class']:
            unknown[u] += 1
    print('dropped property names (top 25):')
    for k, v in total.most_common(25):
        print('  %-28s %d' % (k, v))
    print('root form classes seen:', len(unknown))
    return 0


if __name__ == '__main__':
    sys.exit(main())
