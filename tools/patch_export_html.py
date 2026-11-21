"""Add an `export-html` subcommand to smcli (self-contained HTML report)."""
P = r'F:\Projects\逆向\sm19alg\smcli.lpr'
src = open(P, encoding='utf-8').read()

if 'CmdExportHtml' in src:
    print('already patched')
    raise SystemExit(0)

src = src.replace(
    'procedure CmdImport(const Root, QAPath: string);',
    'procedure CmdImport(const Root, QAPath: string);\n'
    'procedure CmdExportHtml(const Root, OutFile: string);')

src = src.replace(
    "  else if cmd = 'import' then",
    "  else if cmd = 'export-html' then\n"
    "    CmdExportHtml(root, ParamStr(3))\n"
    "  else if cmd = 'import' then")

src = src.replace(
    "  WriteLn('  smcli import  <collection> <qa.txt>');",
    "  WriteLn('  smcli export-html <collection> <out.html>');\n"
    "  WriteLn('  smcli import  <collection> <qa.txt>');")

body = r'''
function HtmlEscape(const S: string): string;
begin
  Result := StringReplace(S, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
end;

procedure HtmlTree(C: TSMCollection; Ordinal, Depth: Integer; SL: TStringList);
var
  kids: TIntArray;
  k, id: Integer;
  txt: string;
begin
  id := C.ElementIdOfOrdinal(Ordinal);
  txt := C.ElementText(id);
  SL.Add(Format('<li class="d%d"><span class="id">#%d</span> %s',
    [Depth, id, HtmlEscape(txt)]));
  kids := C.ChildrenOf(Ordinal);
  if (Length(kids) > 0) and (Depth < 8) then
  begin
    SL.Add('<ul>');
    for k := 0 to High(kids) do
      HtmlTree(C, kids[k], Depth + 1, SL);
    SL.Add('</ul>');
  end;
  SL.Add('</li>');
end;

procedure CmdExportHtml(const Root, OutFile: string);
var
  C: TSMCollection;
  els: TSMElements;
  recs: TSMContents;
  sl: TStringList;
  i, id: Integer;
  txt, outp: string;
begin
  outp := OutFile;
  if outp = '' then
    outp := 'export.html';
  C := TSMCollection.Create(Root);
  sl := TStringList.Create;
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load collection at ', Root);
      Halt(2);
    end;
    els := C.Elements;
    recs := C.Contents;

    sl.Add('<!DOCTYPE html>');
    sl.Add('<html lang="en"><head><meta charset="utf-8">');
    sl.Add('<title>' + HtmlEscape(C.Name) + '</title>');
    sl.Add('<style>');
    sl.Add('body{font-family:system-ui,Segoe UI,Arial;margin:24px;max-width:960px}');
    sl.Add('h1{margin-bottom:4px}');
    sl.Add('.meta{color:#666;margin-bottom:20px}');
    sl.Add('ul{list-style:none;padding-left:18px}');
    sl.Add('li{margin:2px 0}');
    sl.Add('.id{color:#0a6;font-family:monospace;margin-right:6px}');
    sl.Add('.card{border:1px solid #ddd;border-radius:6px;padding:10px 14px;margin:8px 0}');
    sl.Add('.card h3{margin:0 0 6px;font-size:14px;color:#0a6;font-family:monospace}');
    sl.Add('.card p{margin:0;white-space:pre-wrap}');
    sl.Add('</style></head><body>');
    sl.Add('<h1>' + HtmlEscape(C.Name) + '</h1>');
    sl.Add(Format('<div class="meta">%d elements &middot; %d contents records &middot; %d matrix cells</div>',
      [Length(els), Length(recs), Length(C.StabilityMatrix)]));
    sl.Add('<h2>Element tree</h2>');
    sl.Add('<ul>');
    HtmlTree(C, C.RootOrdinal, 0, sl);
    sl.Add('</ul>');
    sl.Add('<h2>Cards</h2>');
    for i := 0 to High(els) do
    begin
      id := els[i].Id;
      txt := C.ElementText(id);
      sl.Add('<div class="card">');
      sl.Add(Format('<h3>#%d &middot; ordinal %d &middot; created %s</h3>',
        [id, els[i].Ordinal, FormatDateTime('yyyy-mm-dd', els[i].Created)]));
      sl.Add('<p>' + HtmlEscape(txt) + '</p>');
      sl.Add('</div>');
    end;
    sl.Add('</body></html>');
    sl.SaveToFile(outp);
    WriteLn(Format('wrote %s (%d elements, %d bytes)', [outp, Length(els), Length(sl.Text)]));
  finally
    sl.Free;
    C.Free;
  end;
end;

end.
'''

t = src.rstrip()
if t.endswith('end.'):
    t = t[:-4].rstrip()
open(P, 'w', encoding='utf-8', newline='\n').write(t + '\n' + body)
print('patched smcli with export-html')
