unit smsettings;

{ Makes the rebuilt dialogs behave like real dialogs:

    - LoadFormFromIni / SaveFormToIni round-trip every check box, edit,
      combo box, spin edit and track bar of a form through an INI file, so
      Options (and every other settings dialog) actually persists.
    - WireOkButtons gives OK/Cancel buttons a ModalResult so ShowModal can
      report the outcome.
    - PopulateForm fills any tree view / string grid / list box / memo found
      on the form with real collection data.
    - SuppressActions tells DispatchAction to stay quiet while we are loading
      or filling controls (population fires OnChange/OnSelect events). }

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Spin,
  Buttons, Grids, Dialogs, IniFiles, smcollection;

var
  SuppressActions: Integer = 0;

function SettingsFilePath: string;
procedure LogLine(const S: string);
procedure SetSettingsFile(const APath: string);
procedure SetDefaultCollection(const APath: string);
function CollectionRootFor(AForm: TForm): string;

procedure SaveFormToIni(AForm: TForm; const ASection: string);
procedure LoadFormFromIni(AForm: TForm; const ASection: string);
procedure PopulateForm(AForm: TForm; const ACollectionRoot: string);
function WireOkButtons(AForm: TForm): Integer;

implementation

var
  GSettingsFile: string = '';
  GDefaultCollection: string = 'F:\SMCollections\ABC';

function SettingsFilePath: string;
begin
  if GSettingsFile <> '' then
    Result := GSettingsFile
  else
    Result := ExtractFilePath(ParamStr(0)) + 'sm19settings.ini';
end;

procedure SetSettingsFile(const APath: string);
begin
  GSettingsFile := APath;
end;

procedure SetDefaultCollection(const APath: string);
begin
  GDefaultCollection := APath;
end;

function CollectionRootFor(AForm: TForm): string;
begin
  Result := GDefaultCollection;
end;

procedure CollectControls(AParent: TWinControl; AList: TList);
var
  i: Integer;
  c: TControl;
begin
  for i := 0 to AParent.ControlCount - 1 do
  begin
    c := AParent.Controls[i];
    AList.Add(c);
    if c is TWinControl then
      CollectControls(TWinControl(c), AList);
  end;
end;

procedure SaveFormToIni(AForm: TForm; const ASection: string);
var
  ini: TIniFile;
  list: TList;
  i: Integer;
  c: TControl;
  sec: string;
begin
  if AForm = nil then
    Exit;
  sec := ASection;
  if sec = '' then
    sec := AForm.ClassName;
  ini := TIniFile.Create(SettingsFilePath);
  list := TList.Create;
  Inc(SuppressActions);
  try
    CollectControls(AForm, list);
    ini.EraseSection(sec);
    for i := 0 to list.Count - 1 do
    begin
      c := TControl(list[i]);
      if c.Name = '' then
        Continue;
      if c is TCheckBox then
        ini.WriteBool(sec, c.Name + '.Checked', TCheckBox(c).Checked)
      else if c is TRadioButton then
        ini.WriteBool(sec, c.Name + '.Checked', TRadioButton(c).Checked)
      else if c is TSpinEdit then
        ini.WriteInteger(sec, c.Name + '.Value', TSpinEdit(c).Value)
      else if c is TTrackBar then
        ini.WriteInteger(sec, c.Name + '.Position', TTrackBar(c).Position)
      else if c is TComboBox then
        ini.WriteString(sec, c.Name + '.Text', TComboBox(c).Text)
      else if c is TEdit then
        ini.WriteString(sec, c.Name + '.Text', TEdit(c).Text);
    end;
    ini.WriteInteger(sec, '.controlCount', list.Count);
  finally
    Dec(SuppressActions);
    list.Free;
    ini.Free;
  end;
end;

procedure LoadFormFromIni(AForm: TForm; const ASection: string);
var
  ini: TIniFile;
  list: TList;
  i: Integer;
  c: TControl;
  sec: string;
begin
  if AForm = nil then
    Exit;
  sec := ASection;
  if sec = '' then
    sec := AForm.ClassName;
  if not FileExists(SettingsFilePath) then
    Exit;
  ini := TIniFile.Create(SettingsFilePath);
  list := TList.Create;
  Inc(SuppressActions);
  try
    if not ini.SectionExists(sec) then
      Exit;
    CollectControls(AForm, list);
    for i := 0 to list.Count - 1 do
    begin
      c := TControl(list[i]);
      if c.Name = '' then
        Continue;
      if c is TCheckBox then
        TCheckBox(c).Checked := ini.ReadBool(sec, c.Name + '.Checked', TCheckBox(c).Checked)
      else if c is TRadioButton then
        TRadioButton(c).Checked := ini.ReadBool(sec, c.Name + '.Checked', TRadioButton(c).Checked)
      else if c is TSpinEdit then
        TSpinEdit(c).Value := ini.ReadInteger(sec, c.Name + '.Value', TSpinEdit(c).Value)
      else if c is TTrackBar then
        TTrackBar(c).Position := ini.ReadInteger(sec, c.Name + '.Position', TTrackBar(c).Position)
      else if c is TComboBox then
        TComboBox(c).Text := ini.ReadString(sec, c.Name + '.Text', TComboBox(c).Text)
      else if c is TEdit then
        TEdit(c).Text := ini.ReadString(sec, c.Name + '.Text', TEdit(c).Text);
    end;
  finally
    Dec(SuppressActions);
    list.Free;
    ini.Free;
  end;
end;

function WireOkButtons(AForm: TForm): Integer;
var
  list: TList;
  i: Integer;
  c: TControl;
  cap: string;

  function Norm(const S: string): string;
  begin
    Result := UpperCase(Trim(StringReplace(S, '&', '', [rfReplaceAll])));
  end;

begin
  Result := 0;
  if AForm = nil then
    Exit;
  list := TList.Create;
  try
    CollectControls(AForm, list);
    for i := 0 to list.Count - 1 do
    begin
      c := TControl(list[i]);
      if c is TButton then
      begin
        if TButton(c).ModalResult = mrNone then
        begin
          cap := Norm(TButton(c).Caption);
          if (cap = 'OK') or (cap = 'CLOSE') then
          begin
            TButton(c).ModalResult := mrOk;
            Inc(Result);
          end
          else if (cap = 'CANCEL') or (cap = 'ABORT') then
          begin
            TButton(c).ModalResult := mrCancel;
            Inc(Result);
          end;
        end;
      end
      else if c is TBitBtn then
      begin
        if TBitBtn(c).ModalResult = mrNone then
        begin
          cap := Norm(TBitBtn(c).Caption);
          if (cap = 'OK') or (cap = 'CLOSE') then
          begin
            TBitBtn(c).ModalResult := mrOk;
            Inc(Result);
          end
          else if (cap = 'CANCEL') or (cap = 'ABORT') then
          begin
            TBitBtn(c).ModalResult := mrCancel;
            Inc(Result);
          end;
        end;
      end;
    end;
  finally
    list.Free;
  end;
end;

procedure FillTree(ATree: TTreeView; const ACollectionRoot: string);
var
  C: TSMCollection;
  els: TSMElements;
  i: Integer;
  root, node: TTreeNode;
begin
  ATree.Items.BeginUpdate;
  try
    ATree.Items.Clear;
    C := TSMCollection.Create(ACollectionRoot);
    try
      if not C.Load then
      begin
        ATree.Items.Add(nil, '(collection not found: ' + ACollectionRoot + ')');
        Exit;
      end;
      root := ATree.Items.Add(nil, C.Name);
      els := C.Elements;
      for i := 0 to High(els) do
        node := ATree.Items.AddChild(root,
          Format('#%d  %s', [els[i].Id, Copy(C.ElementText(els[i].Id), 1, 60)]));
      root.Expand(False);
    finally
      C.Free;
    end;
  finally
    ATree.Items.EndUpdate;
  end;
end;

procedure FillGrid(AGrid: TStringGrid; const ACollectionRoot: string);
var
  C: TSMCollection;
  els: TSMElements;
  i, row, statRows, tv, tot: Integer;
  statNames: array[0..7] of string;
begin
  C := TSMCollection.Create(ACollectionRoot);
  try
    if not C.Load then
      Exit;
    els := C.Elements;
    if AGrid.ColCount < 4 then
      AGrid.ColCount := 4;
    AGrid.FixedRows := 1;

    { statistics that the original program keeps in stats\*.dat: two int32
      per file — the value for today and the value for the whole collection }
    statNames[0] := 'itemtotal';
    statNames[1] := 'itemmemorized';
    statNames[2] := 'itemoutstanding';
    statNames[3] := 'itemreps';
    statNames[4] := 'retention';
    statNames[5] := 'Recall';
    statNames[6] := 'burden';
    statNames[7] := 'reptime';
    statRows := 0;
    for i := 0 to 7 do
      if C.StatsPair(statNames[i], tv, tot) then
        Inc(statRows);

    AGrid.RowCount := statRows + Length(els) + 2;
    AGrid.Cells[0, 0] := 'id';
    AGrid.Cells[1, 0] := 'slot';
    AGrid.Cells[2, 0] := 'flags';
    AGrid.Cells[3, 0] := 'text';

    row := 1;
    if statRows > 0 then
    begin
      AGrid.Cells[0, row] := 'STAT';
      AGrid.Cells[1, row] := 'today';
      AGrid.Cells[2, row] := 'total';
      AGrid.Cells[3, row] := 'metric (from stats\*.dat)';
      Inc(row);
      for i := 0 to 7 do
        if C.StatsPair(statNames[i], tv, tot) then
        begin
          AGrid.Cells[0, row] := '-';
          AGrid.Cells[1, row] := IntToStr(tv);
          AGrid.Cells[2, row] := IntToStr(tot);
          AGrid.Cells[3, row] := statNames[i];
          Inc(row);
        end;
    end;

    for i := 0 to High(els) do
    begin
      AGrid.Cells[0, row] := IntToStr(els[i].Id);
      AGrid.Cells[1, row] := IntToStr(els[i].Slot);
      AGrid.Cells[2, row] := IntToStr(els[i].Flags);
      AGrid.Cells[3, row] := Copy(C.ElementText(els[i].Id), 1, 80);
      Inc(row);
    end;
  finally
    C.Free;
  end;
end;

procedure FillListBox(AList: TListBox; const ACollectionRoot: string);
var
  C: TSMCollection;
  els: TSMElements;
  i: Integer;
begin
  AList.Items.BeginUpdate;
  try
    AList.Items.Clear;
    C := TSMCollection.Create(ACollectionRoot);
    try
      if not C.Load then
        Exit;
      els := C.Elements;
      for i := 0 to High(els) do
        AList.Items.Add(Format('#%d  %s', [els[i].Id, Copy(C.ElementText(els[i].Id), 1, 70)]));
    finally
      C.Free;
    end;
  finally
    AList.Items.EndUpdate;
  end;
end;

procedure AddTreeLines(C: TSMCollection; Ordinal, Depth: Integer; ALines: TStrings);
var
  kids: TIntArray;
  k, id: Integer;
  txt: string;
begin
  id := C.ElementIdOfOrdinal(Ordinal);
  txt := C.ElementText(id);
  if Length(txt) > 80 then
    txt := Copy(txt, 1, 80) + '...';
  ALines.Add(StringOfChar(' ', Depth * 2) + Format('#%d (ord %d)  %s', [id, Ordinal, txt]));
  kids := C.ChildrenOf(Ordinal);
  for k := 0 to High(kids) do
    if Depth < 8 then
      AddTreeLines(C, kids[k], Depth + 1, ALines);
end;

procedure FillMemo(AMemo: TMemo; const ACollectionRoot: string);
var
  C: TSMCollection;
  els: TSMElements;
  i: Integer;
begin
  AMemo.Lines.BeginUpdate;
  try
    AMemo.Lines.Clear;
    C := TSMCollection.Create(ACollectionRoot);
    try
      if not C.Load then
      begin
        AMemo.Lines.Add('collection not found: ' + ACollectionRoot);
        Exit;
      end;
      els := C.Elements;
      AMemo.Lines.Add(Format('collection: %s', [C.Name]));
      AMemo.Lines.Add(Format('elements: %d', [Length(els)]));
      AMemo.Lines.Add('');
      { tree view using contents.dat }
      AddTreeLines(C, C.RootOrdinal, 0, AMemo.Lines);
    finally
      C.Free;
    end;
  finally
    AMemo.Lines.EndUpdate;
  end;
end;

procedure PopulateForm(AForm: TForm; const ACollectionRoot: string);
var
  list: TList;
  i, filled: Integer;
  c: TControl;
  m: TMemo;
begin
  if AForm = nil then
    Exit;
  Inc(SuppressActions);
  list := TList.Create;
  try
    CollectControls(AForm, list);
    filled := 0;
    for i := 0 to list.Count - 1 do
    begin
      c := TControl(list[i]);
      if c is TTreeView then
      begin
        c.Visible := True;
        FillTree(TTreeView(c), ACollectionRoot);
        Inc(filled);
      end
      else if c is TStringGrid then
      begin
        { these grids are hidden in the original DFM and shown by code later;
          lift them to the form itself so no toolbar can hide them }
        TStringGrid(c).Parent := AForm;
        TStringGrid(c).Align := alClient;
        TStringGrid(c).Visible := True;
        TStringGrid(c).BringToFront;
        FillGrid(TStringGrid(c), ACollectionRoot);
        Inc(filled);
      end
      else if c is TListBox then
      begin
        c.Visible := True;
        FillListBox(TListBox(c), ACollectionRoot);
        Inc(filled);
      end;
    end;
    if filled = 0 then
    begin
      for i := 0 to list.Count - 1 do
        if TControl(list[i]) is TMemo then
        begin
          FillMemo(TMemo(list[i]), ACollectionRoot);
          Inc(filled);
          Break;
        end;
      { nothing on this form can show data: add a read-only viewer }
      if filled = 0 then
      begin
        m := TMemo.Create(AForm);
        m.Parent := AForm;
        m.Align := alClient;
        m.ScrollBars := ssAutoBoth;
        m.WordWrap := False;
        m.Name := 'SMSyntheticViewer';
        m.BringToFront;
        FillMemo(m, ACollectionRoot);
        Inc(filled);
      end;
    end;
  finally
    list.Free;
    Dec(SuppressActions);
  end;
end;



var
  GLogReady: Boolean = False;

procedure LogLine(const S: string);
var
  f: TextFile;
  path: string;
begin
  path := ExtractFilePath(ParamStr(0)) + 'sm19runtime.log';
  AssignFile(f, path);
  try
    if GLogReady then
      Append(f)
    else
    begin
      Rewrite(f);
      GLogReady := True;
    end;
    WriteLn(f, FormatDateTime('hh:nn:ss.zzz', Now), '  ', S);
  finally
    CloseFile(f);
  end;
end;

end.