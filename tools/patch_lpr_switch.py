"""Add the --test-settings startup switch to the generated project file."""
P = r'F:\Projects\逆向\tools\gen_skeleton.py'
src = open(P, encoding='utf-8').read()

if 'test-settings' in src:
    print('already patched')
else:
    anchor = """    lb.write("  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 7) = '--study') then\\n")"""
    if anchor not in src:
        # fall back to the single-quoted variant
        anchor = "    lb.write('  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 7) = \\'--study\\') then\\n')"
    add = (
        '    lb.write("  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 15) = '
        "'--test-settings') then\\n\")\n"
        '    lb.write("  begin\\n    SMTestSettings(0);\\n    Halt(0);\\n  end;\\n")\n'
    )
    if anchor in src:
        src = src.replace(anchor, add + anchor)
        open(P, 'w', encoding='utf-8', newline='\n').write(src)
        print('patched with anchor')
    else:
        # last resort: insert right before Application.Run line
        marker = "    lb.write('  Application.Run;\\nend.\\n')"
        if marker in src:
            src = src.replace(marker, add + marker)
            open(P, 'w', encoding='utf-8', newline='\n').write(src)
            print('patched at Application.Run')
        else:
            print('ANCHOR NOT FOUND')
print('test-settings present:', 'test-settings' in open(P, encoding='utf-8').read())
