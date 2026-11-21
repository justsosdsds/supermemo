"""Export a SuperMemo collection to a self-contained HTML report."""
import os, sys, struct, html, datetime


def read_elements(coll):
    p = os.path.join(coll, 'info', 'ElementInfo.dat')
    b = open(p, 'rb').read()
    out = []
    for i in range(len(b) // 118):
        r = b[i * 118:(i + 1) * 118]
        out.append(dict(slot=i, flags=r[0], id=struct.unpack_from('<H', r, 2)[0],
                        comp_off=struct.unpack_from('<I', r, 6)[0],
                        comp_size=struct.unpack_from('<H', r, 10)[0],
                        created=struct.unpack_from('<d', r, 20)[0],
                        ordinal=struct.unpack_from('<i', r, 40)[0]))
    return out


def read_contents(coll):
    p = os.path.join(coll, 'info', 'contents.dat')
    b = open(p, 'rb').read()
    out = []
    for i in range(len(b) // 37):
        r = b[i * 37:(i + 1) * 37]
        out.append(dict(parent=struct.unpack_from('<H', r, 1)[0],
                        first=struct.unpack_from('<H', r, 5)[0],
                        prev=struct.unpack_from('<H', r, 13)[0],
                        next=struct.unpack_from('<H', r, 17)[0],
                        kids=struct.unpack_from('<H', r, 21)[0]))
    return out


def read_texts(coll):
    p = os.path.join(coll, 'registry', 'Text.rtx')
    if not os.path.exists(p):
        return {}
    b = open(p, 'rb').read()
    out = {}
    i = 0
    while i < len(b):
        st = i
        while i < len(b) and b[i] != 0:
            i += 1
        if i >= len(b):
            break
        raw = b[st:i]
        i += 1
        tid = struct.unpack_from('<i', b, i)[0] if i + 4 <= len(b) else 0
        i += 5
        try:
            out.setdefault(tid, raw.decode('utf-8'))
        except UnicodeDecodeError:
            out.setdefault(tid, raw.decode('cp1252', 'replace'))
    return out


def clean(s):
    return s.lstrip('\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d').strip()


def main(coll, out_path):
    els = read_elements(coll)
    conts = read_contents(coll)
    texts = read_texts(coll)
    name = os.path.basename(coll.rstrip('\\/'))

    by_ord = {i + 1: c for i, c in enumerate(conts)}

    def kids_of(ordinal):
        kids = []
        cur = by_ord.get(ordinal, {}).get('first', 0)
        guard = 0
        while cur and guard < 500:
            kids.append(cur)
            cur = by_ord.get(cur, {}).get('next', 0)
            guard += 1
        return kids

    def tree_html(ordinal, depth=0):
        if ordinal < 1 or ordinal > len(els):
            return ''
        e = els[ordinal - 1]
        txt = clean(texts.get(e['id'], ''))
        parts = ['<li><span class="id">#%d</span> %s' % (e['id'], html.escape(txt[:120]))]
        kids = kids_of(ordinal)
        if kids and depth < 8:
            parts.append('<ul>')
            for k in kids:
                parts.append(tree_html(k, depth + 1))
            parts.append('</ul>')
        parts.append('</li>')
        return ''.join(parts)

    rows = []
    for e in els:
        txt = clean(texts.get(e['id'], ''))
        when = ''
        try:
            when = (datetime.datetime(1899, 12, 30) + datetime.timedelta(days=e['created'])).strftime('%Y-%m-%d')
        except Exception:
            pass
        rows.append(
            '<div class="card"><h3>#%d · ordinal %d · %s</h3><p>%s</p></div>'
            % (e['id'], e['ordinal'], when, html.escape(txt)))

    doc = """<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8">
<title>{name}</title>
<style>
body{{font-family:system-ui,'Segoe UI',Arial;margin:24px auto;max-width:960px;color:#222}}
h1{{margin-bottom:4px}}
.meta{{color:#666;margin-bottom:20px}}
ul{{list-style:none;padding-left:18px}}
li{{margin:2px 0}}
.id{{color:#0a6;font-family:monospace;margin-right:6px}}
.card{{border:1px solid #ddd;border-radius:6px;padding:10px 14px;margin:8px 0}}
.card h3{{margin:0 0 6px;font-size:13px;color:#0a6;font-family:monospace;font-weight:600}}
.card p{{margin:0;white-space:pre-wrap}}
</style></head><body>
<h1>{name}</h1>
<div class="meta">{n} elements · {c} contents records</div>
<h2>Element tree</h2>
<ul>{tree}</ul>
<h2>Cards</h2>
{cards}
</body></html>
""".format(name=html.escape(name), n=len(els), c=len(conts),
           tree=tree_html(1), cards='\n'.join(rows))

    open(out_path, 'w', encoding='utf-8').write(doc)
    print('wrote %s (%d elements, %d bytes)' % (out_path, len(els), len(doc)))
    return 0


if __name__ == '__main__':
    coll = sys.argv[1] if len(sys.argv) > 1 else r'F:\SMCollections\ABC'
    out = sys.argv[2] if len(sys.argv) > 2 else r'F:\Projects\逆向\sm19alg\export.html'
    sys.exit(main(coll, out))
