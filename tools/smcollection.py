"""SuperMemo 19 collection (.Kno) reader — reverse-engineered format.

Layout discovered by inspecting a collection created by the original binary:

  <name>.Kno                    index/metadata blob (950 bytes, int32 fields)
  <name>/collection.ini         INI, [Learning] section
  <name>/info/*.dat             element + component records
  <name>/info/sm8opt.dat        SM-8 optimisation data (18876 bytes)
  <name>/alg17/*.dat            SM-17/18/19 algorithm matrices  <-- key find
  <name>/registry/<Res>.*       text pools: .rtx .lst .ptr .mem
  <name>/stats/*.dat            counters
  <name>/reports/*.txt          generated reports

Algorithm matrices (all little-endian):
  StabilityIncrease.dat          21*21*21 doubles  = 74088 bytes
  Recall.dat / RecallCases.dat   21*21*21 int32    = 37044 bytes
  StabilityIncreaseCases.dat     21*21*21 int32    = 37044 bytes
  FirstInterval.dat              21*21*36 doubles  = 127008 bytes
  ForgettingCurve.dat            36 doubles       = 288 bytes
  DifficultyDistribution.dat     20 int32         = 80 bytes

Registry pools:
  .rtx  text pool: NUL-terminated strings
  .lst  int32 index table
  .ptr  int32 pointer table
  .mem  slot table (allocated records)
"""
import os, struct, json, sys

DIM = 21
CELLS = DIM * DIM * DIM          # 9261
STRIDE_R = DIM * DIM             # 441
STRIDE_S = DIM                   # 21


class Collection:
    def __init__(self, root):
        self.root = root
        self.name = os.path.basename(root)
        self.alg = os.path.join(root, 'alg17')
        self.info = os.path.join(root, 'info')
        self.registry = os.path.join(root, 'registry')
        self.stats = os.path.join(root, 'stats')

    # ---------- algorithm matrices ----------
    def _doubles(self, path):
        b = open(path, 'rb').read()
        n = len(b) // 8
        return list(struct.unpack('<%dd' % n, b[:n * 8]))

    def _ints(self, path):
        b = open(path, 'rb').read()
        n = len(b) // 4
        return list(struct.unpack('<%di' % n, b[:n * 4]))

    def stability_increase(self):
        """21^3 stability-increase (U-factor) matrix, flat[R*441+S*21+D]."""
        return self._doubles(os.path.join(self.alg, 'StabilityIncrease.dat'))

    def recall(self):
        return self._ints(os.path.join(self.alg, 'Recall.dat'))

    def recall_cases(self):
        return self._ints(os.path.join(self.alg, 'RecallCases.dat'))

    def stability_increase_cases(self):
        return self._ints(os.path.join(self.alg, 'StabilityIncreaseCases.dat'))

    def first_interval(self):
        return self._doubles(os.path.join(self.alg, 'FirstInterval.dat'))

    def forgetting_curve(self):
        return self._doubles(os.path.join(self.alg, 'ForgettingCurve.dat'))

    def difficulty_distribution(self):
        return self._ints(os.path.join(self.alg, 'DifficultyDistribution.dat'))

    # ---------- registry text pools ----------
    def text_pool(self, res):
        """Read registry/<Res>.rtx as a list of records.

        Empirically: <string> NUL <int32 a> <byte b>, records back to back.
        """
        p = os.path.join(self.registry, res + '.rtx')
        if not os.path.exists(p):
            return []
        b = open(p, 'rb').read()
        out = []
        i = 0
        while i < len(b):
            end = b.find(b'\x00', i)
            if end < 0:
                break
            raw = b[i:end]
            i = end + 1
            tail = b[i:i + 5]
            a = struct.unpack('<i', tail[:4])[0] if len(tail) >= 4 else None
            bb = tail[4] if len(tail) >= 5 else None
            i += 5
            for enc in ('utf-8', 'cp1252', 'latin1'):
                try:
                    s = raw.decode(enc)
                    break
                except UnicodeDecodeError:
                    continue
            out.append(dict(text=s, a=a, b=bb))
        return out

    def index_table(self, res, ext):
        p = os.path.join(self.registry, res + '.' + ext)
        if not os.path.exists(p):
            return []
        return self._ints(p)

    # ---------- summary ----------
    def summary(self):
        si = self.stability_increase()
        nz = [x for x in si if x != 0.0]
        return dict(
            name=self.name,
            root=self.root,
            matrix_cells=len(si),
            matrix_non_zero=len(nz),
            matrix_min=min(nz) if nz else 0.0,
            matrix_max=max(nz) if nz else 0.0,
            recall_non_zero=len([x for x in self.recall() if x]),
            texts={r: len(self.text_pool(r)) for r in ('Text', 'Concept', 'Tasklist', 'Template')},
            files=sorted(os.listdir(self.alg)) if os.path.isdir(self.alg) else [],
        )


if __name__ == '__main__':
    root = sys.argv[1] if len(sys.argv) > 1 else r'F:\Projects\逆向\run\systems\ABC of SuperMemo 19'
    c = Collection(root)
    print(json.dumps(c.summary(), ensure_ascii=False, indent=2))
    print('\ntext pool "Text":', c.text_pool('Text'))
    print('text pool "Concept":', c.text_pool('Concept'))
    si = c.stability_increase()
    print('\nmatrix cell(r=0,s=1,d=0..4):',
          ['%.6f' % si[0 * STRIDE_R + 1 * STRIDE_S + d] for d in range(5)])
