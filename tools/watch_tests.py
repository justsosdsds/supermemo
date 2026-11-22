"""Watch T1-T4 collections and report the moment the original program writes.

Run this in one window, operate SuperMemo in another.  It prints a line as soon
as any tracked file changes, so you know immediately whether the operation
actually reached disk.

  python watch_tests.py            # watch all four
  python watch_tests.py T1 T2      # watch a subset
"""
import os, sys, time, hashlib, datetime

S = r'C:\supermemo\systems'
TRACK = ('elements\\2.HTM', 'info\\ElementInfo.dat', 'info\\contents.dat',
         'registry\\Text.rtx', 'info\\compon.dat')


def sig(coll):
    out = {}
    for rel in TRACK:
        p = os.path.join(coll, rel)
        if os.path.exists(p):
            out[rel] = (os.path.getsize(p),
                        hashlib.sha256(open(p, 'rb').read()).hexdigest()[:12])
    return out


def main():
    names = sys.argv[1:] or ['T1', 'T1b', 'T2', 'T3', 'T4']
    names = [n if n.startswith('T') else 'T' + n for n in names]
    dirs = {n: os.path.join(S, n) for n in names
            if os.path.isdir(os.path.join(S, n))}
    if not dirs:
        print('no test collections found under', S)
        return 2

    base = {n: sig(d) for n, d in dirs.items()}
    print('监控中: %s' % ', '.join(sorted(dirs)))
    print('基线已记录，等你操作原版。Ctrl+C 结束。')
    print()

    hit = {n: False for n in dirs}
    try:
        while True:
            time.sleep(0.6)
            for n, d in dirs.items():
                cur = sig(d)
                for rel in TRACK:
                    a, b = base[n].get(rel), cur.get(rel)
                    if a != b:
                        ts = datetime.datetime.now().strftime('%H:%M:%S')
                        print('[%s] %s  %s  ->  %s' % (
                            ts, n, rel,
                            ('%d 字节' % b[0]) if b else '消失'))
                        base[n][rel] = b
                        if not hit[n]:
                            hit[n] = True
                            print('    ^^ %s 已被写入，操作生效' % n)
    except KeyboardInterrupt:
        pass

    print()
    for n in sorted(dirs):
        print('%s: %s' % (n, '有写入' if hit[n] else '没有任何写入'))
    return 0


if __name__ == '__main__':
    sys.exit(main())
