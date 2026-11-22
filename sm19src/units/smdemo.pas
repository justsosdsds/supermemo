unit smdemo;

{ Complete study-step glue between the reconstructed UI and the scheduling
  engine, driven from TSMMain.MILearnClick:

    1. read a real element + its text from the collection
    2. show it and ask for the quality grade
    3. let the engine compute the next interval from the collection's matrix
    4. write the observation back to alg17/*.dat
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, smcollection, smengine,
  smsettings, smactions, smimport;

const
  SM_DEMO_COLLECTION = 'F:\SMCollections\ABC';

function PickElement(const C: TSMCollection; out ElemId: Integer;
  out Title, Body: string): Boolean;
procedure RunAlgoDemo(AOwner: TComponent);
procedure RunSearchDemo(AOwner: TComponent);
procedure RunExportDemo(AOwner: TComponent);

{ non-interactive study step, used by the --study command-line switch }
procedure RunStudyStep(const CollectionRoot: string; ElemId, Grade: Integer;
  ShowResult: Boolean; const LogFile: string = '');
procedure SMStartupStudy(Data: PtrInt);
procedure SMTestSettings(Data: PtrInt);
procedure RunImportDemo(AOwner: TComponent);
procedure RunLearnClick(AOwner: TComponent);

implementation

function CleanText(const S: string): string;
var
  i: Integer;
begin
  i := 1;
  while (i <= Length(S)) and (S[i] < #32) do
    Inc(i);
  Result := Trim(Copy(S, i, MaxInt));
end;

function PickElement(const C: TSMCollection; out ElemId: Integer;
  out Title, Body: string): Boolean;
var
  recs: TSMTextRecords;
  i: Integer;
begin
  Result := False;
  ElemId := 0;
  Title := '';
  Body := '';
  recs := C.TextPool('Text');
  for i := 0 to High(recs) do
  begin
    if (recs[i].A > 1) and (Length(CleanText(recs[i].Text)) > 20) then
    begin
      ElemId := recs[i].A;
      Body := CleanText(recs[i].Text);
      Title := 'Element ' + IntToStr(ElemId);
      Exit(True);
    end;
  end;
end;

procedure RunStudyStep(const CollectionRoot: string; ElemId, Grade: Integer;
  ShowResult: Boolean; const LogFile: string);
var
  C: TSMCollection;
  St: TCardState;
  R: TNextResult;
  body: string;
  sl: TStringList;
  procedure Emit(const S: string);
  begin
    if LogFile <> '' then
      sl.Add(S);
  end;
begin
  sl := nil;
  if LogFile <> '' then
  begin
    sl := TStringList.Create;
    sl.Add('=== study step ===');
    sl.Add('collection: ' + CollectionRoot);
  end;
  C := TSMCollection.Create(CollectionRoot);
  try
    if not C.Load then
    begin
      Emit('ERROR: cannot load matrices');
      if ShowResult then
        MessageDlg('Study step', 'Cannot load matrices from ' + CollectionRoot,
          mtWarning, [mbOK], 0);
      Exit;
    end;
    body := C.ElementText(ElemId);
    if body = '' then
    begin
      Emit('ERROR: element has no text');
      if ShowResult then
        MessageDlg('Study step', Format('Element %d has no text.', [ElemId]),
          mtWarning, [mbOK], 0);
      Exit;
    end;

    St := DefaultCard;
    R := ComputeNext(C, St, Grade / 5.0);
    RecordRepetition(C, R.UFactor, St);
    C.SaveStabilityIncrease;
    C.SaveStabilityCases;

    Emit('element #' + IntToStr(ElemId));
    Emit('text: ' + body);
    Emit(Format('grade %d (quality %.2f)', [Grade, Grade / 5.0]));
    Emit(Format('matrix cell [R=%d,S=%d,D=%d] U-factor=%.4f source=%s',
      [R.RIndex, R.SIndex, R.DIndex, R.UFactor, R.Source]));
    Emit(Format('next interval = %.2f days', [R.Interval]));
    Emit('observation written to alg17/StabilityIncrease.dat');

    if ShowResult then
      MessageDlg('Study step',
        Format('Element #%d  (grade %d / quality %.2f)', [ElemId, Grade, Grade / 5.0]) +
        LineEnding + LineEnding + body + LineEnding + LineEnding +
        Format('matrix cell [R=%d, S=%d, D=%d]  U-factor %.4f', [R.RIndex, R.SIndex, R.DIndex, R.UFactor]) +
        LineEnding +
        Format('next interval = %.2f days', [R.Interval]) + LineEnding +
        'observation written to alg17/StabilityIncrease.dat',
        mtInformation, [mbOK], 0);
  finally
    C.Free;
    if sl <> nil then
    begin
      sl.SaveToFile(LogFile);
      sl.Free;
    end;
  end;
end;

procedure SMStartupStudy(Data: PtrInt);
var
  root, arg: string;
  grade, p: Integer;
begin
  root := SM_DEMO_COLLECTION;
  grade := 4;
  for p := 1 to ParamCount do
  begin
    arg := ParamStr(p);
    if Copy(arg, 1, 8) = '--study=' then
      grade := StrToIntDef(Copy(arg, 9, MaxInt), 4)
    else if Copy(arg, 1, 8) = '--coll=' then
      root := Copy(arg, 8, MaxInt);
  end;
  RunStudyStep(root, 6, grade, False, ExtractFilePath(ParamStr(0)) + 'study_run.log');
  Application.Terminate;
end;

procedure RunAlgoDemo(AOwner: TComponent);
var
  C: TSMCollection;
  St: TCardState;
  R: TNextResult;
  elemId: Integer;
  title, body, s: string;
  grade: Integer;
  quality: Double;
begin
  C := TSMCollection.Create(SM_DEMO_COLLECTION);
  try
    if not C.Load then
    begin
      MessageDlg('Scheduling engine',
        'Collection matrices not found at ' + SM_DEMO_COLLECTION, mtWarning, [mbOK], 0);
      Exit;
    end;

    if not PickElement(C, elemId, title, body) then
    begin
      MessageDlg('Scheduling engine',
        'No element with text found in the collection.', mtWarning, [mbOK], 0);
      Exit;
    end;

    St := DefaultCard;
    St.Stability := 12.4;
    St.Difficulty := 0.32;
    St.Repetition := 5;
    St.Interval := 12.4;
    St.Retrievability := 0.87;

    if not InputQuery('Grade this element (0-5)',
      body + LineEnding + LineEnding +
      'How well did you recall it?  (0 = blackout, 5 = perfect)', s) then
      Exit;
    grade := StrToIntDef(Trim(s), -1);
    if (grade < 0) or (grade > 5) then
    begin
      MessageDlg('Scheduling engine', 'Grade must be 0..5.', mtWarning, [mbOK], 0);
      Exit;
    end;
    quality := grade / 5.0;

    R := ComputeNext(C, St, quality);
    RecordRepetition(C, R.UFactor, St);
    C.SaveStabilityIncrease;
    C.SaveStabilityCases;

    MessageDlg('Study step',
      'Element #' + IntToStr(elemId) + LineEnding +
      body + LineEnding + LineEnding +
      Format('grade %d  (quality %.2f)' + LineEnding, [grade, quality]) +
      Format('matrix cell [R=%d, S=%d, D=%d]' + LineEnding,
        [R.RIndex, R.SIndex, R.DIndex]) +
      Format('U-factor %.4f  ->  next interval %.2f days' + LineEnding,
        [R.UFactor, R.Interval]) +
      LineEnding + 'observation written back to alg17/StabilityIncrease.dat',
      mtInformation, [mbOK], 0);
  finally
    C.Free;
  end;
end;

procedure RunSearchDemo(AOwner: TComponent);
var
  C: TSMCollection;
  recs: TSMTextRecords;
  needle, hits, line: string;
  i, n: Integer;
begin
  if not InputQuery('Search collection', 'Text to find:', needle) then
    Exit;
  if Trim(needle) = '' then
    Exit;
  C := TSMCollection.Create(SM_DEMO_COLLECTION);
  try
    C.Load;
    recs := C.TextPool('Text');
    n := 0;
    hits := '';
    for i := 0 to High(recs) do
    begin
      line := CleanText(recs[i].Text);
      if Pos(LowerCase(Trim(needle)), LowerCase(line)) > 0 then
      begin
        Inc(n);
        if n <= 12 then
          hits := hits + Format('  [#%d] %s' + LineEnding,
            [recs[i].A, Copy(line, 1, 90)]);
      end;
    end;
    if n = 0 then
      MessageDlg('Search', 'No match for "' + needle + '".', mtInformation, [mbOK], 0)
    else
      MessageDlg('Search results',
        Format('%d element(s) match "%s":' + LineEnding + LineEnding, [n, needle]) + hits,
        mtInformation, [mbOK], 0);
  finally
    C.Free;
  end;
end;

procedure RunExportDemo(AOwner: TComponent);
var
  C: TSMCollection;
  recs: TSMTextRecords;
  out: TStringList;
  i, count: Integer;
  path, line: string;
begin
  C := TSMCollection.Create(SM_DEMO_COLLECTION);
  try
    C.Load;
    recs := C.TextPool('Text');
    out := TStringList.Create;
    try
      out.Add('# Exported from a SuperMemo collection by the reconstructed engine');
      out.Add('# format: element_id <TAB> text');
      count := 0;
      for i := 0 to High(recs) do
      begin
        line := CleanText(recs[i].Text);
        if line = '' then
          Continue;
        out.Add(IntToStr(recs[i].A) + #9 + line);
        Inc(count);
      end;
      path := ExtractFilePath(ParamStr(0)) + 'exported_elements.tsv';
      out.SaveToFile(path);
      MessageDlg('Export',
        Format('%d element texts exported to:' + LineEnding + '%s', [count, path]),
        mtInformation, [mbOK], 0);
    finally
      out.Free;
    end;
  finally
    C.Free;
  end;
end;



procedure SMTestSettings(Data: PtrInt);
var
  log: TStringList;
  ok1, ok2, ok3: Boolean;
begin
  ok1 := SaveFormSettings('TOptions');
  ok2 := SaveFormSettings('TBrowser');
  ok3 := SaveFormSettings('TStats');
  log := TStringList.Create;
  try
    log.Add('=== settings test ===');
    log.Add(Format('TOptions=%s TBrowser=%s TStats=%s', [BoolToStr(ok1, True), BoolToStr(ok2, True), BoolToStr(ok3, True)]));
    log.Add('ini: ' + SettingsFilePath);
    log.SaveToFile(ExtractFilePath(ParamStr(0)) + 'settings_test.log');
  finally
    log.Free;
  end;
end;


procedure RunImportDemo(AOwner: TComponent);

var
  path, err, logPath: string;
  added, i: Integer;
  sl: TStringList;
  arg: string;
begin
  path := 'F:\SMImport\import_qa.txt';
  for i := 1 to ParamCount do
  begin
    arg := ParamStr(i);
    if Copy(arg, 1, 9) = '--import=' then
      path := Copy(arg, 10, MaxInt);
  end;
  sl := TStringList.Create;
  try
    sl.Add('=== import (Pascal) ===');
    sl.Add('file: ' + path);
    if ImportQAInto(SM_DEMO_COLLECTION, path, added, err) then
      sl.Add(Format('OK: %d card(s)', [added]))
    else
      sl.Add('FAILED: ' + err);
    logPath := ExtractFilePath(ParamStr(0)) + 'import_test.log';
    sl.SaveToFile(logPath);
  finally
    sl.Free;
  end;
end;

procedure RunLearnClick(AOwner: TComponent);
var
  C: TSMCollection;
  els: TSMElements;
  i, pick, grade: Integer;
  txt: string;
  answer: string;
begin
  C := TSMCollection.Create(SM_DEMO_COLLECTION);
  try
    if not C.Load then
    begin
      MessageDlg('Learn', 'Cannot open collection:' + LineEnding + SM_DEMO_COLLECTION,
        mtError, [mbOK], 0);
      Exit;
    end;
    els := C.Elements;
    pick := -1;
    for i := 0 to High(els) do
      if C.ElementText(els[i].Id) <> '' then
      begin
        pick := i;
        Break;
      end;
    if pick < 0 then
    begin
      MessageDlg('Learn', 'This collection has no element with text yet.', mtInformation, [mbOK], 0);
      Exit;
    end;

    txt := C.ElementText(els[pick].Id);
    if not InputQuery('Learn — question',
      Format('Element #%d (ordinal %d)%s%s%s%sGrade 0..5 (empty = cancel):',
        [els[pick].Id, els[pick].Ordinal, LineEnding, LineEnding, txt, LineEnding + LineEnding]),
      answer) then
      Exit;
    if Trim(answer) = '' then
      Exit;
    grade := StrToIntDef(Trim(answer), -1);
    if (grade < 0) or (grade > 5) then
    begin
      MessageDlg('Learn', 'Grade must be 0..5', mtError, [mbOK], 0);
      Exit;
    end;

    RunStudyStep(SM_DEMO_COLLECTION, els[pick].Id, grade, True);
  finally
    C.Free;
  end;
end;

end.