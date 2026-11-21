program smcli;
{$mode objfpc}{$H+}

{ Command-line front end for the reconstructed SuperMemo engine.

  smcli list    <collection>              elements with ids, ordinals, texts
  smcli tree    <collection>              element hierarchy from contents.dat
  smcli show    <collection> <element_id>
  smcli search  <collection> <text>
  smcli export  <collection> <outfile.tsv>
  smcli import  <collection> <qa.txt>
  smcli study   <collection> <element_id> <grade 0..5>
  smcli matrix  <collection> <R> <S> <D>
}

uses
  Classes, SysUtils, Math, sm20alg, smcollection, smengine, smimport;

function CleanText(const S: string): string;
var
  i: Integer;
begin
  i := 1;
  while (i <= Length(S)) and (S[i] < #32) do
    Inc(i);
  Result := Trim(Copy(S, i, MaxInt));
end;

function FindElement(const C: TSMCollection; ElemId: Integer; out E: TSMElement): Boolean;
var
  els: TSMElements;
  i: Integer;
begin
  Result := False;
  els := C.Elements;
  for i := 0 to High(els) do
    if els[i].Id = ElemId then
    begin
      E := els[i];
      Result := True;
      Exit;
    end;
end;

procedure CmdList(const Root: string);
var
  C: TSMCollection;
  els: TSMElements;
  i: Integer;
  txt: string;
begin
  C := TSMCollection.Create(Root);
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load collection matrices from ', Root);
      Halt(2);
    end;
    els := C.Elements;
    WriteLn(Format('%-5s %-6s %-6s %-8s %-8s %-9s %-9s %s',
      ['slot', 'flags', 'id', 'comp_off', 'comp_sz', 'ordinal', 'created', 'text']));
    for i := 0 to High(els) do
    begin
      txt := C.ElementText(els[i].Id);
      if Length(txt) > 70 then
        txt := Copy(txt, 1, 70) + '...';
      WriteLn(Format('%-5d %-6d %-6d %-8d %-8d %-9d %-9s %s',
        [els[i].Slot, els[i].Flags, els[i].Id, els[i].CompOffset, els[i].CompSize,
         els[i].Ordinal, FormatDateTime('yyyy-mm-dd', els[i].Created), txt]));
    end;
    WriteLn;
    WriteLn(Format('matrix cells: %d', [Length(C.StabilityMatrix)]));
  finally
    C.Free;
  end;
end;

procedure PrintNode(C: TSMCollection; Ordinal, Depth: Integer);
var
  kids: TIntArray;
  i, id: Integer;
  txt: string;
begin
  id := C.ElementIdOfOrdinal(Ordinal);
  txt := C.ElementText(id);
  if Length(txt) > 50 then
    txt := Copy(txt, 1, 50) + '...';
  WriteLn(Format('%s[ord %d / id %d] %s',
    [StringOfChar(' ', Depth * 2), Ordinal, id, txt]));
  kids := C.ChildrenOf(Ordinal);
  for i := 0 to High(kids) do
    if Depth < 8 then
      PrintNode(C, kids[i], Depth + 1);
end;

procedure CmdTree(const Root: string);
var
  C: TSMCollection;
  recs: TSMContents;
begin
  C := TSMCollection.Create(Root);
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load collection');
      Halt(2);
    end;
    recs := C.Contents;
    WriteLn(Format('contents.dat: %d records, root ordinal %d',
      [Length(recs), C.RootOrdinal]));
    WriteLn('--- element tree ---');
    PrintNode(C, C.RootOrdinal, 0);
  finally
    C.Free;
  end;
end;

procedure CmdShow(const Root: string; ElemId: Integer);
var
  C: TSMCollection;
  E: TSMElement;
begin
  C := TSMCollection.Create(Root);
  try
    C.Load;
    if not FindElement(C, ElemId, E) then
    begin
      WriteLn('ERROR: element ', ElemId, ' not found');
      Halt(3);
    end;
    WriteLn(Format('element %d  slot=%d flags=%d comp_off=%d comp_sz=%d ordinal=%d',
      [E.Id, E.Slot, E.Flags, E.CompOffset, E.CompSize, E.Ordinal]));
    WriteLn('---');
    WriteLn(C.ElementText(ElemId));
    WriteLn('---');
  finally
    C.Free;
  end;
end;

procedure CmdSearch(const Root, Needle: string);
var
  C: TSMCollection;
  els: TSMElements;
  i, hits: Integer;
  txt, low: string;
begin
  low := LowerCase(Needle);
  C := TSMCollection.Create(Root);
  try
    C.Load;
    els := C.Elements;
    hits := 0;
    for i := 0 to High(els) do
    begin
      txt := C.ElementText(els[i].Id);
      if Pos(low, LowerCase(txt)) > 0 then
      begin
        Inc(hits);
        if Length(txt) > 90 then
          txt := Copy(txt, 1, 90) + '...';
        WriteLn(Format('  [#%d] %s', [els[i].Id, txt]));
      end;
    end;
    WriteLn(Format('%d hit(s) for "%s"', [hits, Needle]));
    if hits = 0 then
      Halt(4);
  finally
    C.Free;
  end;
end;

procedure CmdExport(const Root, OutFile: string);
var
  C: TSMCollection;
  els: TSMElements;
  i: Integer;
  sl: TStringList;
  txt: string;
begin
  C := TSMCollection.Create(Root);
  try
    C.Load;
    els := C.Elements;
    sl := TStringList.Create;
    try
      sl.Add('# element_id' + #9 + 'flags' + #9 + 'comp_offset' + #9 + 'text');
      for i := 0 to High(els) do
      begin
        txt := StringReplace(C.ElementText(els[i].Id), #9, ' ', [rfReplaceAll]);
        txt := StringReplace(txt, #13, ' ', [rfReplaceAll]);
        txt := StringReplace(txt, #10, ' ', [rfReplaceAll]);
        sl.Add(Format('%d'#9'%d'#9'%d'#9'%s',
          [els[i].Id, els[i].Flags, els[i].CompOffset, txt]));
      end;
      sl.SaveToFile(OutFile);
      WriteLn(Format('exported %d elements -> %s', [Length(els), OutFile]));
    finally
      sl.Free;
    end;
  finally
    C.Free;
  end;
end;

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

procedure CmdStudy(const Root: string; ElemId, Grade: Integer);
var
  C: TSMCollection;
  St: TCardState;
  R: TNextResult;
  txt: string;
begin
  if (Grade < 0) or (Grade > 5) then
  begin
    WriteLn('ERROR: grade must be 0..5');
    Halt(5);
  end;
  C := TSMCollection.Create(Root);
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load matrices');
      Halt(2);
    end;
    txt := C.ElementText(ElemId);
    if txt = '' then
    begin
      WriteLn('ERROR: element ', ElemId, ' has no text');
      Halt(3);
    end;

    St := DefaultCard;
    St.Retrievability := Grade / 5.0;

    R := ComputeNext(C, St, Grade / 5.0);
    WriteLn('=== study step ===');
    WriteLn('element #', ElemId);
    WriteLn('---');
    WriteLn(txt);
    WriteLn('---');
    WriteLn(Format('grade %d  (quality %.2f)', [Grade, Grade / 5.0]));
    WriteLn(Format('matrix cell [R=%d, S=%d, D=%d]  U-factor=%.4f  source=%s',
      [R.RIndex, R.SIndex, R.DIndex, R.UFactor, R.Source]));
    WriteLn(Format('next interval = %.2f days', [R.Interval]));

    RecordRepetition(C, R.UFactor, St);
    C.SaveStabilityIncrease;
    C.SaveStabilityCases;
    WriteLn('observation written back to alg17/StabilityIncrease.dat');
  finally
    C.Free;
  end;
end;

procedure CmdMatrix(const Root: string; R, S, D: Integer);
var
  C: TSMCollection;
begin
  C := TSMCollection.Create(Root);
  try
    if not C.Load then
    begin
      WriteLn('ERROR: cannot load matrices');
      Halt(2);
    end;
    WriteLn(Format('cell [R=%d,S=%d,D=%d] = %.6f   cases=%d',
      [R, S, D, C.StabilityIncrease(R, S, D), C.Cases(R, S, D)]));
  finally
    C.Free;
  end;
end;

procedure Usage;
begin
  WriteLn('smcli - reconstructed SuperMemo engine front end');
  WriteLn;
  WriteLn('  smcli list    <collection>');
  WriteLn('  smcli tree    <collection>');
  WriteLn('  smcli show    <collection> <element_id>');
  WriteLn('  smcli search  <collection> <text>');
  WriteLn('  smcli export  <collection> <outfile.tsv>');
  WriteLn('  smcli import  <collection> <qa.txt>');
  WriteLn('  smcli study   <collection> <element_id> <grade 0..5>');
  WriteLn('  smcli matrix  <collection> <R> <S> <D>');
  WriteLn;
  WriteLn('example collection: F:\SMCollections\ABC');
end;

var
  cmd, root: string;
begin
  if ParamCount < 2 then
  begin
    Usage;
    Halt(1);
  end;
  cmd := LowerCase(ParamStr(1));
  root := ParamStr(2);

  if cmd = 'list' then
    CmdList(root)
  else if cmd = 'tree' then
    CmdTree(root)
  else if cmd = 'show' then
    CmdShow(root, StrToIntDef(ParamStr(3), 0))
  else if cmd = 'search' then
    CmdSearch(root, ParamStr(3))
  else if cmd = 'export' then
    CmdExport(root, ParamStr(3))
  else if cmd = 'import' then
    CmdImport(root, ParamStr(3))
  else if cmd = 'study' then
    CmdStudy(root, StrToIntDef(ParamStr(3), 0), StrToIntDef(ParamStr(4), -1))
  else if cmd = 'matrix' then
    CmdMatrix(root, StrToIntDef(ParamStr(3), 0), StrToIntDef(ParamStr(4), 0),
      StrToIntDef(ParamStr(5), 0))
  else
  begin
    WriteLn('unknown command: ', cmd);
    Usage;
    Halt(1);
  end;
end.
