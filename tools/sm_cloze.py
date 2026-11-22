"""Cloze: turn a keyword in a topic into a deletion and produce a child item.

STATUS — PARTIALLY VERIFIED. Read before trusting this file.

WHAT IS CONFIRMED FROM THE BINARY (UTF-16 string table)
  * the markup class is spelled "clozed" (with a d): '<FONT class=clozed',
    '<SPAN class=clozed' @ 0x00b2f74c region, and the normaliser
    FUN_00b2f61c rewrites them to plain '<FONT' / '<SPAN'
  * the command hint: "Convert the selected keyword into a deletion and produce
    a new cloze item (Alt+Z)"  => cloze produces an ITEM, not a Topic
  * a companion menu item exists: "Remember cloze", "Schedule cloze",
    "Queue cloze"

WHAT IS **NOT** VERIFIED (this file's assumptions — must be checked against a
real Alt+Z diff before being called original-compatible)
  A1. that the source paragraph gets <SPAN class=clozed>..</SPAN> around the
      keyword (by analogy with extract, which does exactly that)
  A2. that the produced item body is the paragraph with the keyword replaced by
      "[...]" (SuperMemo's classic cloze rendering)
  A3. that the child element repeats the extract rule: reuse the free slot,
      kind=1, rep=1, pack=0x00010006
  A4. the exact spacing/punctuation left in place of the keyword

Everything below is marked with which assumption it implements.

Usage:
  sm_cloze.py <collection> <topic_element_id> "<keyword>" [--dry]
"""
import struct, os, sys, datetime

DIM, CONTENT, MEMREC = 118, 37, 30
FREE_ID = 65535
KIND_ITEM, KIND_FREE = 1, 3

# markup constants confirmed present in the binary
CLOZE_OPEN = b'<SPAN class=cloze>'      # parent-side marker: 'cloze' (no d) - measured in 2.HTM
CLOZE_CLOSE = b'</SPAN>'
# A2: rendering of the deletion in the produced item (NOT verified)
DELETION = '[...]'                     # measured: item text contains literal [...]


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def parse_elements(data):
    out = []
    for i in range(len(data) // DIM):
        r = bytes(data[i * DIM:(i + 1) * DIM])
        out.append(dict(slot=i, raw=r, flags=r[0], kind=r[1],
                        id=struct.unpack_from('<H', r, 2)[0],
                        comp_off=struct.unpack_from('<I', r, 6)[0],
                        comp_size=struct.unpack_from('<H', r, 10)[0],
                        ordinal=struct.unpack_from('<i', r, 40)[0]))
    return out


def parse_contents(data):
    out = []
    for i in range(len(data) // CONTENT):
        r = bytes(data[i * CONTENT:(i + 1) * CONTENT])
        out.append(dict(raw=r,
                        first=struct.unpack_from('<H', r, 5)[0],
                        last=struct.unpack_from('<H', r, 9)[0],
                        prev=struct.unpack_from('<H', r, 13)[0],
                        next=struct.unpack_from('<H', r, 17)[0],
                        kids=struct.unpack_from('<H', r, 21)[0]))
    return out


def text_ids(rtx):
    ids, i = [], 0
    while i < len(rtx):
        while i < len(rtx) and rtx[i] != 0:
            i += 1
        if i >= len(rtx):
            break
        i += 1
        if i + 4 > len(rtx):
            break
        ids.append(struct.unpack_from('<i', rtx, i)[0])
        i += 5
    return ids


def mark_keyword(body, keyword):
    """A1 (measured): wrap the keyword in <SPAN class=cloze>..</SPAN> in the
    parent body, replacing the keyword with the literal placeholder [...],
    and normalise any outer <SPAN class=extract> to a bare <SPAN> (this is what
    FUN_00b2f61c does)."""
    kw = keyword.encode('utf-8')
    pos = body.find(kw)
    if pos < 0:
        raise ValueError('keyword not found in source body')
    out = body[:pos] + CLOZE_OPEN + DELETION.encode('utf-8') + CLOZE_CLOSE + body[pos + len(kw):]
    out = out.replace(b'<SPAN class=extract>', b'<SPAN>')
    out = out.replace(b'<FONT class=extract>', b'<FONT>')
    return out


def build_cloze_text(body_text, keyword):
    """A2/A4: produce the item text = paragraph with the keyword removed.

    We keep the surrounding text untouched and drop in a visible placeholder.
    This is a guess; the real program may keep the markup and let the renderer
    hide it instead of writing a placeholder into the text pool.
    """
    return body_text.replace(keyword, DELETION, 1)


def _recount_subtrees(conts):
    """kids = number of descendants in the whole subtree (measured: root has 3
    while only one direct child, which itself has two).  Rebuild the hierarchy
    from the parent field rather than chasing first/next links."""
    n = len(conts)
    children = {}
    for i, c in enumerate(conts):
        p = struct.unpack_from('<H', c['raw'], 1)[0]
        children.setdefault(p, []).append(i + 1)

    def count(ordinal, depth=0):
        if depth > 40:
            return 0
        total = 0
        for k in children.get(ordinal, []):
            total += 1 + count(k, depth + 1)
        return total

    for i, c in enumerate(conts):
        raw = bytearray(c['raw'])
        struct.pack_into('<H', raw, 21, count(i + 1))
        c['raw'] = bytes(raw)


def cloze(coll, topic_id, keyword, dry_run=False):
    info_p = os.path.join(coll, 'info', 'ElementInfo.dat')
    cont_p = os.path.join(coll, 'info', 'contents.dat')
    comp_p = os.path.join(coll, 'info', 'compon.dat')
    rtx_p = os.path.join(coll, 'registry', 'Text.rtx')
    mem_p = os.path.join(coll, 'registry', 'Text.mem')
    ptr_p = os.path.join(coll, 'registry', 'Text.ptr')

    info = load(info_p)
    cont = load(cont_p)
    comp = load(comp_p)
    rtx = load(rtx_p)
    mem = load(mem_p)
    ptr = load(ptr_p)

    els = parse_elements(info)
    topic = next((e for e in els if e['id'] == topic_id), None)
    if topic is None:
        return None, 'topic %d not found' % topic_id

    body_file = os.path.join(coll, 'elements', '%d.HTM' % (topic['slot'] + 1))
    if not os.path.exists(body_file):
        return None, 'topic has no HTM body (cloze needs a text/HTML topic)'
    body = open(body_file, 'rb').read()

    try:
        marked = mark_keyword(body, keyword)
    except ValueError as e:
        return None, str(e)

    text = marked.decode('utf-8', 'replace')
    item_text = build_cloze_text(text, keyword)

    # the child element's own body keeps the real keyword, wrapped in
    # <SPAN class=clozed> (WITH d) - measured in 3.HTM
    # every element body that still contains the raw keyword gets the
    # <SPAN class=clozed> marker (measured: extract child 3.HTM carries it)
    kwb = keyword.encode('utf-8')
    el_dir = os.path.join(coll, 'elements')
    marked_files = []
    if os.path.isdir(el_dir):
        for fn in sorted(os.listdir(el_dir)):
            if not fn.lower().endswith('.htm'):
                continue
            fp = os.path.join(el_dir, fn)
            cb = open(fp, 'rb').read()
            if b'<SPAN class=clozed>' in cb:
                continue                     # already marked
            if kwb not in cb:
                continue
            nb = cb.replace(kwb, b'<SPAN class=clozed>' + kwb + b'</SPAN>', 1)
            if not dry_run:
                open(fp, 'wb').write(nb)
            marked_files.append(fn)

    if not dry_run:
        open(body_file, 'wb').write(marked)

    free = next((e for e in els if e['kind'] == KIND_FREE and e['id'] == FREE_ID), None)
    reused = free is not None

    used = set(e['id'] for e in els if e['id'] != FREE_ID) | set(text_ids(rtx))
    new_id = (max(used) + 1) if used else 1
    new_ord0 = max((e['ordinal'] for e in els), default=0) + 1
    new_ord = (free['slot'] + 1) if reused else (len(els) + 1)

    t_off = len(rtx)
    blob = item_text.encode('utf-8') + b'\x00' + struct.pack('<i', new_id) + b'\x01'
    rtx += blob
    mrec = bytearray(MEMREC)
    struct.pack_into('<i', mrec, 0, 1)
    struct.pack_into('<i', mrec, 4, 3)
    struct.pack_into('<i', mrec, 8, (t_off + 1) << 16)
    struct.pack_into('<i', mrec, 12, len(blob) << 16)
    struct.pack_into('<i', mrec, 16, new_id << 16)
    mem += mrec
    ptr += struct.pack('<i', new_id)

    tpl = next((e for e in reversed(els) if e['comp_off'] != 0xFFFFFFFF and e['comp_size'] > 0), None)
    if tpl is None:
        return None, 'no component block to clone'
    c_off = len(comp)
    blk = bytearray(comp[tpl['comp_off']:tpl['comp_off'] + tpl['comp_size']])
    struct.pack_into('<i', blk, 4, new_ord)
    comp += blk

    erec = bytearray(free['raw'] if reused else tpl['raw'])
    slot_index = free['slot'] if reused else len(info) // DIM
    erec[0] = 0x01                        # measured: cloze child has flags=0x1
    erec[1] = KIND_ITEM                  # A3
    struct.pack_into('<H', erec, 2, new_id)
    struct.pack_into('<I', erec, 6, c_off)
    struct.pack_into('<H', erec, 10, tpl['comp_size'])
    struct.pack_into('<i', erec, 12, 1)            # A3 / PROVISIONAL
    struct.pack_into('<I', erec, 16, 0x00010003)   # measured: cloze child pack=0x00010003
    now = (datetime.datetime.now() - datetime.datetime(1899, 12, 30)).total_seconds() / 86400.0
    struct.pack_into('<d', erec, 20, now)
    struct.pack_into('<i', erec, 40, new_ord0)
    if reused:
        info[slot_index * DIM:(slot_index + 1) * DIM] = erec
    else:
        info += bytes(erec)

    p_ord = topic['slot'] + 1
    n_cont = len(cont) // CONTENT
    if reused and new_ord <= n_cont:
        crec = bytearray(cont[(new_ord - 1) * CONTENT:new_ord * CONTENT])
        for off in (1, 5, 9, 13, 17, 21):
            struct.pack_into('<H', crec, off, 0)
        struct.pack_into('<H', crec, 1, p_ord)
        cont[(new_ord - 1) * CONTENT:new_ord * CONTENT] = crec
    else:
        crec = bytearray(CONTENT)
        struct.pack_into('<H', crec, 1, p_ord)
        cont += bytes(crec)

    conts = parse_contents(cont)
    last = conts[p_ord - 1]['last']
    if last:
        r = bytearray(conts[last - 1]['raw'])
        struct.pack_into('<H', r, 17, new_ord)
        conts[last - 1]['raw'] = bytes(r)
        r = bytearray(conts[new_ord - 1]['raw'])
        struct.pack_into('<H', r, 13, last)
        conts[new_ord - 1]['raw'] = bytes(r)
    pr = bytearray(conts[p_ord - 1]['raw'])
    if last == 0:
        struct.pack_into('<H', pr, 5, new_ord)
    struct.pack_into('<H', pr, 9, new_ord)
    conts[p_ord - 1]['raw'] = bytes(pr)
    _recount_subtrees(conts)   # after pr is stored, so subtree sizes see the new child

    out = bytearray()
    for c in conts:
        out += c['raw']

    if not dry_run:
        save(rtx_p, rtx)
        save(mem_p, mem)
        save(ptr_p, ptr)
        save(comp_p, comp)
        save(info_p, info)
        save(cont_p, out)

    return dict(new_id=new_id, new_ordinal=new_ord, slot=slot_index + 1,
                reused=reused, topic=topic_id, item_text=item_text,
                marked_files=marked_files), None


def main():
    if len(sys.argv) < 4:
        print('usage: sm_cloze.py <collection> <topic_element_id> "<keyword>" [--dry]')
        return 1
    res, err = cloze(sys.argv[1], int(sys.argv[2]), sys.argv[3], dry_run='--dry' in sys.argv)
    if err:
        print('ERROR:', err)
        return 2
    print('cloze ok  [ASSUMPTIONS A1-A4 apply — see file header]')
    print('  new item : id=%d ordinal=%d slot=%d' % (res['new_id'], res['new_ordinal'], res['slot']))
    print('  parent   : #%d' % res['topic'])
    print('  reused   : %s' % ('yes' if res['reused'] else 'no'))
    print('  marked files: %s' % res.get('marked_files'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
