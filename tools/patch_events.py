"""Narrow the wired event set: only real user actions, not mouse-tracking or
paint events (those fired constantly and produced dialog spam)."""
import re

P = r'F:\Projects\逆向\tools\gen_skeleton.py'
src = open(P, encoding='utf-8').read()

new_block = """INTERACTIVE_EVENTS = {
    'OnClick', 'OnDblClick', 'OnChange', 'OnKeyDown', 'OnKeyPress',
    'OnPopup', 'OnDropDown', 'OnSelect', 'OnEditingDone',
    'OnClickCheck', 'OnSelectCell', 'OnRowMoved', 'OnExecute', 'OnUpdate',
    'OnChanging', 'OnSelectItem', 'OnDrawItem',
}"""

src2 = re.sub(r'INTERACTIVE_EVENTS = \{.*?\}', new_block, src, count=1, flags=re.S)
if src2 == src:
    print('PATTERN NOT FOUND')
else:
    open(P, 'w', encoding='utf-8', newline='\n').write(src2)
    print('patched')
    print(src2[src2.index('INTERACTIVE_EVENTS'):src2.index('INTERACTIVE_EVENTS') + 300])
