"""Wire the reconstructed features into the generated main-form unit.

Every handler is generated as `DispatchAction(Sender, 'X')`. This patch
replaces the ones that have a real implementation:
  MILearnClick  -> RunAlgoDemo      (study step)
  MISearchClick -> RunSearchDemo    (search)
  MIReportClick -> RunExportDemo    (export)
"""
import re, os

TARGET = r'F:\Projects\逆向\sm19src\units\uSMMain.pas'
src = open(TARGET, encoding='utf-8').read()
changed = []

if 'smdemo' not in src:
    src = src.replace('compat, smactions', 'compat, smactions, smdemo')
    changed.append('uses+smdemo')

WIRING = [
    ('MILearnClick', 'RunLearnClick(Self)', 'learn a card'),
    ('MISearchClick', 'RunSearchDemo(Self)', 'search'),
    ('MIReportClick', 'RunExportDemo(Self)', 'export'),
    ('MIImportTextClick', 'RunImportDemo(Self)', 'import'),
]

for name, call, label in WIRING:
    pat = re.compile(
        r'(procedure TSMMain\.%s\(Sender: TObject\);\r?\nbegin\r?\n)(.*?)(\r?\nend;)' % re.escape(name),
        re.S)
    m = pat.search(src)
    if not m:
        continue
    if call in m.group(2):
        continue
    src = src[:m.start(2)] + '  ' + call + src[m.end(2):]
    changed.append('%s -> %s' % (name, label))

open(TARGET, 'w', encoding='utf-8', newline='\r\n').write(src)
print('patched:', changed)
