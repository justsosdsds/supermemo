"""Prepare T1-T4 test collections with pre-operation snapshots.

Each collection is built from a known-good baseline so the original program
accepts it. Every case gets:
  systems/T<n>            the collection to operate on
  systems/T<n>_base       byte-identical pre-operation snapshot
  work/T<n>_manifest.json file digests of the snapshot

Usage:
  python setup_tests.py            # build all four
  python setup_tests.py T2         # rebuild one
"""
import os, shutil, struct, json, sys, datetime

SYSTEMS = r'C:\supermemo\systems'
BASE = os.path.join(SYSTEMS, 'EXTEST_base')
WORK = r'F:\Projects\逆向\work'

DIM, CONTENT, MEMREC = 118, 37, 30


def load(p):
    return bytearray(open(p, 'rb').read())


def save(p, d):
    open(p, 'wb').write(bytes(d))


def rewrite_topic_body(coll, slot, body_bytes, text_bytes):
    """Replace the body file and the plain-text record that mirrors it."""
    bf = os.path.join(coll, 'elements', '%d.HTM' % slot)
    os.makedirs(os.path.dirname(bf), exist_ok=True)
    open(bf, 'wb').write(body_bytes)

    # text pool: the topic's plain-text record is the one matching the old body
    rtx_p = os.path.join(coll, 'registry', 'Text.rtx')
    rtx = load(rtx_p)
    recs, i = [], 0
    while i < len(rtx):
        st = i
        while i < len(rtx) and rtx[i] != 0:
            i += 1
        if i >= len(rtx):
            break
        raw = bytes(rtx[st:i])
        i += 1
        tid = struct.unpack_from('<i', rtx, i)[0] if i + 4 <= len(rtx) else -1
        tail = i + 5
        recs.append((tid, raw, st, tail))
        i = tail

    # pick the record whose text looks like the old body and belongs to this slot
    info = open(os.path.join(coll, 'info', 'ElementInfo.dat'), 'rb').read()
    r = info[(slot - 1) * DIM:slot * DIM]
    elem_id = struct.unpack_from('<H', r, 2)[0]
    for tid, raw, st, en in recs:
        if tid == elem_id:
            new = text_bytes + b'\x00' + struct.pack('<i', tid) + b'\x01'
            rtx[st:en] = new
            save(rtx_p, rtx)
            return True
    return False


def build(name, title, body_html, body_text, note):
    src = os.path.join(SYSTEMS, 'T%s' % name)
    shutil.rmtree(src, ignore_errors=True)
    shutil.copytree(BASE, src)

    # retitle the collection so the original lists it distinctly
    rewrite_topic_body(src, 2, body_html, body_text)

    # collection.ini keeps the display name
    ini = os.path.join(src, 'collection.ini')
    if os.path.exists(ini):
        s = open(ini, 'rb').read().decode('cp1252', 'replace')
        s = s.replace('EXTEST', title)
        open(ini, 'wb').write(s.encode('cp1252', 'replace'))

    # snapshot
    snap = os.path.join(SYSTEMS, 'T%s_base' % name)
    shutil.rmtree(snap, ignore_errors=True)
    shutil.copytree(src, snap)

    # manifest
    import hashlib
    man = {}
    for root, dirs, files in os.walk(snap):
        for f in files:
            p = os.path.join(root, f)
            man[os.path.relpath(p, snap)] = {
                'size': os.path.getsize(p),
                'sha256': hashlib.sha256(open(p, 'rb').read()).hexdigest()[:16]}
    os.makedirs(WORK, exist_ok=True)
    json.dump(man, open(os.path.join(WORK, 'T%s_manifest.json' % name), 'w'),
              indent=1, ensure_ascii=False)

    print('%s  %-28s %d files snapshotted' % (name, title, len(man)))
    print('     %s' % note)


CASES = [
    ('1', 'T1 two articles, same keyword',
     ('<P>AAA alpha paragraph</P>\r\n<P>The word second appears here.</P>\r\n<P>CCC tail</P>',
      'AAA alpha paragraph\r\nThe word second appears here.\r\nCCC tail'),
     'Before: 目标文章含 second。另一篇无关文章也存在（见下方 T1b）。'),

    ('2', 'T2 one article, keyword twice',
     ('<P>First: second one here.</P>\r\n<P>Second: second two here.</P>\r\n<P>Tail paragraph</P>',
      'First: second one here.\r\nSecond: second two here.\r\nTail paragraph'),
     '操作时必须选中第二个 second（Second: 后面的那个），防止脚本固定替换第一次出现。'),

    ('3', 'T3 Chinese multi paragraph',
     ('<P>第一段：这是引入。</P>\r\n<P>第二段：STM32 小车需要保存障碍物距离。</P>\r\n<P>第三段：结束。</P>',
      '第一段：这是引入。\r\n第二段：STM32 小车需要保存障碍物距离。\r\n第三段：结束。'),
     '用来验证中文编码与多段排版。'),

    ('4', 'T4 two clozes in one paragraph',
     ('<P>STM32 小车需要保存障碍物距离与左轮目标转速。</P>\r\n<P>尾段。</P>',
      'STM32 小车需要保存障碍物距离与左轮目标转速。\r\n尾段。'),
     '同一段连续挖两个词：障碍物距离、左轮目标转速。'),
]


def main():
    want = sys.argv[1] if len(sys.argv) > 1 else None
    if not os.path.isdir(BASE):
        print('baseline missing:', BASE)
        return 2
    for name, title, body, note in CASES:
        if want and want.upper() != 'T' + name:
            continue
        build(name, title, body[0].encode('utf-8'), body[1].encode('utf-8'), note)
    print()
    print('快照目录: %s\\T<n>_base' % SYSTEMS)
    print('清单文件: %s\\T<n>_manifest.json' % WORK)
    return 0


if __name__ == '__main__':
    sys.exit(main())
