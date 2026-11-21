"""Add an `import` subcommand to smcli."""
P = r'F:\Projects\逆向\sm19alg\smcli.lpr'
src = open(P, encoding='utf-8').read()

if 'CmdImport' in src:
    print('already patched')
else:
    src = src.replace(
        '  Classes, SysUtils, Math, sm20alg, smcollection, smengine;',
        '  Classes, SysUtils, Math, sm20alg, smcollection, smengine, smimport;')

    src = src.replace(
        'procedure CmdMatrix(const Root: string; R, S, D: Integer);',
        'procedure CmdImport(const Root, QAPath: string);\n'
        'procedure CmdMatrix(const Root: string; R, S, D: Integer);')

    src = src.replace(
        "  else if cmd = 'matrix' then",
        "  else if cmd = 'import' then\n"
        "    CmdImport(root, ParamStr(3))\n"
        "  else if cmd = 'matrix' then")

    src = src.replace(
        "  WriteLn('  smcli matrix  <collection> <R> <S> <D>');",
        "  WriteLn('  smcli import  <collection> <qa.txt>');\n"
        "  WriteLn('  smcli matrix  <collection> <R> <S> <D>');")

    body = '''
procedure CmdImport(const Root, QAPath: string);
var
  added: Integer;
  err: string;
begin
  if QAPath = '' then
  begin
    WriteLn('ERROR: usage: smcli import <collection> <qa.txt>');
    Halt(1);
  end;
  if not FileExists(QAPath) then
  begin
    WriteLn('ERROR: file not found: ', QAPath);
    Halt(1);
  end;
  if ImportQAInto(Root, QAPath, added, err) then
  begin
    WriteLn(Format('imported %d card(s) into %s', [added, Root]));
    WriteLn('run "smcli list" to verify');
  end
  else
  begin
    WriteLn('ERROR: ', err);
    Halt(2);
  end;
end;

end.
'''
    t = src.rstrip()
    if t.endswith('end.'):
        t = t[:-4].rstrip()
    open(P, 'w', encoding='utf-8', newline='\n').write(t + '\n' + body)
    print('patched smcli')
