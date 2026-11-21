"""Binary DFM (TPF0) parser -> JSON tree + text DFM.

Format reference: Delphi Classes.TReader/TWriter binary streaming.
"""
import struct, os, json, sys, glob, traceback

VA_NULL, VA_LIST, VA_INT8, VA_INT16, VA_INT32, VA_EXTENDED, VA_STRING, VA_IDENT, \
    VA_FALSE, VA_TRUE, VA_BINARY, VA_SET, VA_LSTRING, VA_NIL, VA_COLLECTION, \
    VA_SINGLE, VA_CURRENCY, VA_DATE, VA_WSTRING, VA_INT64, VA_UTF8STRING, VA_DOUBLE = range(22)

VA_NAMES = {0: 'Null', 1: 'List', 2: 'Int8', 3: 'Int16', 4: 'Int32', 5: 'Extended', 6: 'String',
            7: 'Ident', 8: 'False', 9: 'True', 10: 'Binary', 11: 'Set', 12: 'LString', 13: 'Nil',
            14: 'Collection', 15: 'Single', 16: 'Currency', 17: 'Date', 18: 'WString', 19: 'Int64',
            20: 'UTF8String', 21: 'Double'}


class Reader:
    def __init__(self, buf):
        self.b = buf
        self.p = 0

    def eof(self):
        return self.p >= len(self.b)

    def u8(self):
        v = self.b[self.p]
        self.p += 1
        return v

    def s8(self):
        v = self.b[self.p]
        self.p += 1
        return v - 256 if v > 127 else v

    def take(self, n):
        v = self.b[self.p:self.p + n]
        if len(v) != n:
            raise EOFError('short read at %d want %d got %d' % (self.p, n, len(v)))
        self.p += n
        return v

    def i16(self):
        return struct.unpack('<h', self.take(2))[0]

    def u32(self):
        return struct.unpack('<I', self.take(4))[0]

    def i32(self):
        return struct.unpack('<i', self.take(4))[0]

    def i64(self):
        return struct.unpack('<q', self.take(8))[0]

    def str_short(self):
        n = self.u8()
        raw = self.take(n)
        return decode_text(raw)

    def str_long(self, wide=False):
        n = self.u32()
        raw = self.take(n)
        if wide:
            return raw.decode('utf-16le', 'replace')
        return decode_text(raw)


def decode_text(raw):
    for enc in ('utf-8', 'gbk', 'cp1252', 'latin1'):
        try:
            return raw.decode(enc)
        except UnicodeDecodeError:
            continue
    return raw.decode('latin1')


def read_value(r):
    tag = r.u8()
    if tag == VA_NULL:
        return ('null', None)
    if tag == VA_LIST:
        items = []
        while True:
            if r.b[r.p] == VA_NULL:
                r.p += 1
                break
            items.append(read_value(r))
        return ('list', items)
    if tag == VA_INT8:
        return ('int', r.s8())
    if tag == VA_INT16:
        return ('int', r.i16())
    if tag == VA_INT32:
        return ('int', r.i32())
    if tag == VA_EXTENDED:
        raw = r.take(10)
        return ('ext', raw.hex())
    if tag == VA_STRING:
        return ('str', r.str_short())
    if tag == VA_IDENT:
        return ('ident', r.str_short())
    if tag == VA_FALSE:
        return ('bool', False)
    if tag == VA_TRUE:
        return ('bool', True)
    if tag == VA_BINARY:
        n = r.u32()
        return ('binary', r.take(n).hex())
    if tag == VA_SET:
        items = []
        while True:
            s = r.str_short()
            if s == '':
                break
            items.append(s)
        return ('set', items)
    if tag == VA_LSTRING:
        return ('str', r.str_long())
    if tag == VA_NIL:
        return ('nil', None)
    if tag == VA_COLLECTION:
        items = []
        while True:
            if r.b[r.p] == VA_NULL:
                r.p += 1
                break
            r.take(1)  # item index byte
            props = []
            while True:
                name = r.str_short()
                if name == '':
                    break
                props.append((name, read_value(r)))
            items.append(dict(props))
        return ('collection', items)
    if tag == VA_SINGLE:
        return ('float', struct.unpack('<f', r.take(4))[0])
    if tag == VA_CURRENCY:
        return ('currency', r.i64() / 10000.0)
    if tag == VA_DATE:
        return ('date', struct.unpack('<d', r.take(8))[0])
    if tag == VA_WSTRING:
        return ('str', r.str_long(wide=True))
    if tag == VA_INT64:
        return ('int', r.i64())
    if tag == VA_UTF8STRING:
        return ('str', r.str_long())
    if tag == VA_DOUBLE:
        return ('float', struct.unpack('<d', r.take(8))[0])
    raise ValueError('bad value tag %d (0x%02x) at %d' % (tag, tag, r.p - 1))


def read_component(r, depth=0):
    if r.eof() or r.b[r.p] == 0:
        if not r.eof():
            r.p += 1
        return None
    cls = r.str_short()
    if cls == '':
        return None
    name = r.str_short()
    flags, child_pos = 0, None
    props = []
    while True:
        pname = r.str_short()
        if pname == '':
            break
        props.append((pname, read_value(r)))
    children = []
    while True:
        if r.eof():
            break
        if r.b[r.p] == 0:
            r.p += 1
            break
        c = read_component(r, depth + 1)
        if c is None:
            break
        children.append(c)
    return dict(cls=cls, name=name, flags=flags, child_pos=child_pos,
                props=props, children=children)


def parse(blob):
    assert blob[:4] == b'TPF0', blob[:8]
    r = Reader(blob[4:])
    root = read_component(r)
    trailing = len(r.b) - r.p
    return root, trailing


def to_text(node, indent=0, is_root=True):
    pad = '  ' * indent
    kw = 'object' if is_root else 'object'
    lines = ['%s%s %s: %s' % (pad, kw, node['name'], node['cls'])]
    for k, (t, v) in node['props']:
        lines.append('%s  %s = %s' % (pad, k, render(t, v, indent + 1)))
    for c in node['children']:
        lines.append(to_text(c, indent + 1, False))
    lines.append('%send' % pad)
    return '\n'.join(lines)


def render(t, v, ind):
    if t == 'null':
        return 'nil'
    if t == 'nil':
        return 'nil'
    if t == 'int':
        return str(v)
    if t == 'bool':
        return 'True' if v else 'False'
    if t == 'ident':
        return v
    if t == 'str':
        return "'" + str(v).replace("'", "''").replace('\r\n', "'+#13#10+'").replace('\n', "'+#10+'").replace('\r', "'+#13+'") + "'"
    if t == 'set':
        return '[' + ', '.join(v) + ']'
    if t == 'float':
        return repr(v)
    if t == 'date':
        return repr(v)
    if t == 'currency':
        return '%r' % v
    if t == 'ext':
        return '<extended %s>' % v
    if t == 'binary':
        return '{binary %d bytes}' % (len(v) // 2)
    if t == 'list':
        pad = '  ' * ind
        inner = ('\n' + pad + '  ').join(render(tt, vv, ind + 2) for tt, vv in v)
        return '(\n' + pad + '  ' + inner + ')'
    if t == 'collection':
        pad = '  ' * ind
        out = ['<']
        for item in v:
            out.append(pad + '  item')
            for k, (tt, vv) in item.items():
                out.append(pad + '    %s = %s' % (k, render(tt, vv, ind + 2)))
            out.append(pad + '  end')
        out.append(pad + '>')
        return '\n'.join(out)
    return repr(v)


def dump_report(nodes, path):
    pass


def count_nodes(n):
    return 1 + sum(count_nodes(c) for c in n['children'])


if __name__ == '__main__':
    src = r'F:\Projects\逆向\work\dfm_raw'
    outdir = r'F:\Projects\逆向\work\dfm_json'
    txtdir = r'F:\Projects\逆向\work\dfm_text'
    os.makedirs(outdir, exist_ok=True)
    os.makedirs(txtdir, exist_ok=True)
    ok = bad = 0
    summary = []
    for fn in sorted(glob.glob(os.path.join(src, '*.dfm.bin'))):
        blob = open(fn, 'rb').read()
        base = os.path.basename(fn).replace('.dfm.bin', '')
        try:
            root, trailing = parse(blob)
            json.dump(root, open(os.path.join(outdir, base + '.json'), 'w', encoding='utf-8'),
                      ensure_ascii=False, indent=1)
            open(os.path.join(txtdir, base + '.dfm'), 'w', encoding='utf-8').write(to_text(root))
            ncomp = count_nodes(root)
            summary.append((base, root['cls'], ncomp, len(blob), trailing))
            ok += 1
        except Exception as ex:
            bad += 1
            print('FAIL', base, type(ex).__name__, ex)
            print(traceback.format_exc(limit=3))
    print('parsed ok=%d bad=%d' % (ok, bad))


def count_nodes(n):
    return 1 + sum(count_nodes(c) for c in n['children'])
