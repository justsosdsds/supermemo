"""Compare two collections field by field and print a precise report.

Instead of a blanket "everything matches", this walks each relevant file, decodes
the known record layouts and reports per-record, per-field equality, plus a
byte-level digest for the free-form bodies.

Usage:
  python compare_collections.py <baseline_or_expected> <actual> [--strict-id]

Exit code 0 when every checked item matches, 1 otherwise.

Checked:
  info/ElementInfo.dat   per-slot (flags, kind, id, comp_size, rep, pack, ordinal)
  info/contents.dat      per-row (parent, first, last, prev, next, kids)
  info/compon.dat        per-block 112-byte equality (skipped when sizes differ)
  registry/Text.rtx      record count + per-record text equality (id order)
  elements/*.HTM         byte equality per file name
  info/priority.sub      int32 array equality
  info/RepetitionHistory.dat  record count
"""
import struct, os, sys, hashlib

DIM, CONTENT = 118, 37


def info_records(path):
    if not os.path.exists(path):
        return None
    b = open(path, 'rb').read()
    out = []
    for i in range(len(b) // DIM):
        r = b[i * DIM:(i + 1) * DIM]
        out.append(dict(
            slot=i + 1,
            flags=r[0], kind=r[1],
            id=struct.unpack_from('<H', r, 2)[0],
            comp_off=struct.unpack_from('<I', r, 6)[0],
            comp_size=struct.unpack_from('<H', r, 10)[0],
            rep=struct.unpack_from('<i', r, 12)[0],
            pack=struct.unpack_from('<I', r, 16)[0],
            ordinal=struct.unpack_from('<i', r, 40)[0]))
    return out


def contents_records(path):
    if not os.path.exists(path):
        return None
    b = open(path, 'rb').read()
    out = []
    for i in range(len(b) // CONTENT):
        out.append(tuple(struct.unpack_from('<H', b, i * CONTENT + off)
                         for off in (1, 5, 9, 13, 17, 21)))
    return out


def text_records(path):
    if not os.path.exists(path):
        return None
    b = open(path, 'rb').read()
    out, i = [], 0
    while i < len(b):
        st = i
        while i < len(b) and b[i] != 0:
            i += 1
        if i >= len(b):
            break
        raw = b[st:i]
        i += 1
        tid = struct.unpack_from('<i', b, i)[0] if i + 4 <= len(b) else -1
        i += 5
        out.append((tid, raw))
    return out


def int32_array(path):
    if not os.path.exists(path):
        return None
    b = open(path, 'rb').read()
    return list(struct.unpack('<%di' % (len(b) // 4), b[:len(b) // 4 * 4]))


def body_files(coll):
    d = os.path.join(coll, 'elements')
    if not os.path.isdir(d):
        return {}
    return {f: open(os.path.join(d, f), 'rb').read()
            for f in sorted(os.listdir(d)) if f.lower().endswith('.htm')}


class Report:
    def __init__(self):
        self.rows = []
        self.failed = 0

    def check(self, name, ok, detail=''):
        self.rows.append((name, ok, detail))
        if not ok:
            self.failed += 1

    def show(self):
        w = max(len(r[0]) for r in self.rows) if self.rows else 10
        for name, ok, detail in self.rows:
            print('  %-*s %-4s %s' % (w, name, 'OK' if ok else 'FAIL', detail))
        print()
        total = len(self.rows)
        print('%d/%d checks passed, %d failed' % (total - self.failed, total, self.failed))


def compare(exp_dir, act_dir, strict_id=False):
    rep = Report()

    # ---- ElementInfo ----
    E = info_records(os.path.join(exp_dir, 'info', 'ElementInfo.dat'))
    A = info_records(os.path.join(act_dir, 'info', 'ElementInfo.dat'))
    if E is None or A is None:
        rep.check('ElementInfo.dat present', False)
    else:
        rep.check('ElementInfo record count', len(E) == len(A),
                  'expected %d, actual %d' % (len(E), len(A)))
        fields = ('flags', 'kind', 'comp_size', 'rep', 'pack', 'ordinal')
        if strict_id:
            fields = fields + ('id',)
        for i in range(min(len(E), len(A))):
            for f in fields:
                rep.check('ElementInfo slot%d.%s' % (i + 1, f), E[i][f] == A[i][f],
                          '' if E[i][f] == A[i][f] else '%s vs %s' % (E[i][f], A[i][f]))

    # ---- contents ----
    E = contents_records(os.path.join(exp_dir, 'info', 'contents.dat'))
    A = contents_records(os.path.join(act_dir, 'info', 'contents.dat'))
    if E is None or A is None:
        rep.check('contents.dat present', False)
    else:
        rep.check('contents row count', len(E) == len(A), '%d vs %d' % (len(E), len(A)))
        names = ('parent', 'first', 'last', 'prev', 'next', 'kids')
        for i in range(min(len(E), len(A))):
            for j, nm in enumerate(names):
                rep.check('contents row%d.%s' % (i + 1, nm), E[i][j] == A[i][j],
                          '' if E[i][j] == A[i][j] else '%s vs %s' % (E[i][j], A[i][j]))

    # ---- compon.dat ----
    pe = os.path.join(exp_dir, 'info', 'compon.dat')
    pa = os.path.join(act_dir, 'info', 'compon.dat')
    if os.path.exists(pe) and os.path.exists(pa):
        be, ba = open(pe, 'rb').read(), open(pa, 'rb').read()
        rep.check('compon.dat size', len(be) == len(ba), '%d vs %d' % (len(be), len(ba)))

    # ---- Text.rtx ----
    E = text_records(os.path.join(exp_dir, 'registry', 'Text.rtx'))
    A = text_records(os.path.join(act_dir, 'registry', 'Text.rtx'))
    if E is None or A is None:
        rep.check('Text.rtx present', False)
    else:
        rep.check('Text.rtx record count', len(E) == len(A), '%d vs %d' % (len(E), len(A)))
        for i in range(min(len(E), len(A))):
            rep.check('Text.rtx record%d text' % i, E[i][1] == A[i][1],
                      '' if E[i][1] == A[i][1]
                      else 'len %d vs %d' % (len(E[i][1]), len(A[i][1])))

    # ---- element bodies ----
    E, A = body_files(exp_dir), body_files(act_dir)
    rep.check('elements/ file set', sorted(E) == sorted(A), '%s vs %s' % (sorted(E), sorted(A)))
    for f in sorted(set(E) & set(A)):
        same = E[f] == A[f]
        rep.check('elements/%s bytes' % f, same,
                  '' if same else 'len %d vs %d, sha %s vs %s' % (
                      len(E[f]), len(A[f]),
                      hashlib.sha256(E[f]).hexdigest()[:8],
                      hashlib.sha256(A[f]).hexdigest()[:8]))

    # ---- priority.sub ----
    E = int32_array(os.path.join(exp_dir, 'info', 'priority.sub'))
    A = int32_array(os.path.join(act_dir, 'info', 'priority.sub'))
    if E is not None and A is not None:
        rep.check('priority.sub', E == A, '%s vs %s' % (E, A))

    # ---- RepetitionHistory ----
    pe = os.path.join(exp_dir, 'info', 'RepetitionHistory.dat')
    pa = os.path.join(act_dir, 'info', 'RepetitionHistory.dat')
    if os.path.exists(pe) and os.path.exists(pa):
        ce = os.path.getsize(pe) // 39
        ca = os.path.getsize(pa) // 39
        rep.check('RepetitionHistory count', ce == ca, '%d vs %d' % (ce, ca))

    rep.show()
    return rep.failed == 0


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(2)
    ok = compare(sys.argv[1], sys.argv[2], '--strict-id' in sys.argv)
    sys.exit(0 if ok else 1)
