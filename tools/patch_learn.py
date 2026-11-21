"""Inject the scheduling-engine call into the generated main-form unit.

The form units are regenerated from DFM by gen_skeleton.py, so this patch is
applied after generation and before compiling:
  - add smdemo to the uses clause of uSMMain
  - make MILearnClick actually do something
"""
import re, os, sys

UNITS = r'F:\Projects\逆向\sm19src\units'
TARGET = os.path.join(UNITS, 'uSMMain.pas')

src = open(TARGET, encoding='utf-8').read()
changed = []

# 1) uses clause
if 'smdemo' not in src:
    src = src.replace('LCLIntf, LResources, compat;', 'LCLIntf, LResources, compat, smdemo;')
    changed.append('uses+smdemo')

# 2) MILearnClick body
body_re = re.compile(
    r'(procedure TSMMain\.MILearnClick\(Sender: TObject\);\r?\nbegin\r?\n)(end;)',
    re.M)
if body_re.search(src):
    src = body_re.sub(r'\1  RunAlgoDemo(Self);\n\2', src)
    changed.append('MILearnClick body')
else:
    print('WARNING: MILearnClick body pattern not found')

# 3) also wire the toolbar Learn button if it has its own handler
for name in ('LearnBtnClick', 'BtnLearnClick', 'MILearnOutstandingClick'):
    pat = re.compile(r'(procedure TSMMain\.%s\(Sender: TObject\);\r?\nbegin\r?\n)(end;)' % name, re.M)
    if pat.search(src) and 'RunAlgoDemo' not in src[pat.search(src).start():pat.search(src).start() + 400]:
        src = pat.sub(r'\1  RunAlgoDemo(Self);\n\2', src)
        changed.append(name + ' body')

open(TARGET, 'w', encoding='utf-8', newline='\r\n').write(src)
print('patched:', changed)
