"""Emit a propdump project: dumps published property names of every class used
in the reconstructed forms, so the LFM files can be pruned to LCL-safe props."""
import json, glob, os, io, sys

sys.path.insert(0, os.path.dirname(__file__))
from gen_skeleton import CLASS_UNIT, STUB_BASE, BASE_UNITS, pident

SRC = r'F:\Projects\逆向\work\dfm_json'
OUT = r'F:\Projects\逆向\sm19src'
TOOLS = os.path.join(OUT, 'tools')
os.makedirs(TOOLS, exist_ok=True)

classes = set()
for fn in glob.glob(os.path.join(SRC, '*.json')):
    root = json.load(open(fn, encoding='utf-8'))

    def walk(n):
        classes.add(n['cls'])
        for c in n['children']:
            walk(c)
    walk(root)

units_needed = sorted({CLASS_UNIT[c] for c in classes if c in CLASS_UNIT} | {'Forms', 'Controls'})
missing = sorted(c for c in classes if c not in CLASS_UNIT and c not in STUB_BASE)

lines = []
w = lines.append
w('program propdump;')
w('{$mode objfpc}{$H+}')
w('')
w('uses')
w('  Interfaces, Classes, SysUtils, TypInfo, ' + ', '.join(units_needed) + ', compat;')
w('')
w('type')
w('  TClsEntry = record')
w('    Name: string;')
w('    Ref: TClass;')
w('  end;')
w('')
# classes referencing forms are not available here; only component classes
comp_classes = sorted(c for c in classes if c not in {json.load(open(fn, encoding='utf-8'))['cls'] for fn in glob.glob(os.path.join(SRC, '*.json'))})
w('const')
w('  Entries: array[0..%d] of TClsEntry = (' % (len(comp_classes)))
rows = ["    (Name: 'TForm'; Ref: TForm)"]
for c in comp_classes:
    rows.append("    (Name: '%s'; Ref: %s)" % (c, c))
w(',\n'.join(rows))
w('  );')
w('')
w('var')
w('  i, n, j: Integer;')
w('  pl: PPropList;')
w('  out: TStringList;')
w('  line: string;')
w('begin')
w('  out := TStringList.Create;')
w('  try')
w('    for i := 0 to High(Entries) do')
w('    begin')
w('      line := Entries[i].Name + \'=\';')
w('      try')
w('        n := GetPropList(Entries[i].Ref.ClassInfo, tkAny, nil);')
w('      except')
w('        n := -1;')
w('      end;')
w('      if n > 0 then')
w('      begin')
w('        GetMem(pl, n * SizeOf(Pointer));')
w('        try')
w('          GetPropList(Entries[i].Ref.ClassInfo, tkAny, pl);')
w('          for j := 0 to n - 1 do')
w('            if j = 0 then line := line + pl^[j]^.Name')
w('            else line := line + \',\' + pl^[j]^.Name;')
w('        finally')
w('          FreeMem(pl);')
w('        end;')
w('      end')
w('      else if n = 0 then')
w('        line := line + \'<none>\'')
w('      else')
w('        line := line + \'<err>\';')
w('      out.Add(line);')
w('    end;')
w('    out.SaveToFile(ParamStr(1));')
w('  finally')
w('    out.Free;')
w('  end;')
w('end.')

open(os.path.join(TOOLS, 'propdump.lpr'), 'w', encoding='utf-8', newline='\r\n').write('\n'.join(lines))
print('component classes:', len(comp_classes))
print('missing from LCL map (handled as stubs or unknown):', missing)
print('wrote', os.path.join(TOOLS, 'propdump.lpr'))
