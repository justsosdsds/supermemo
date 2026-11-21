unit smactions;

{ Every reconstructed event handler routes through DispatchAction.

  Two behaviour levels:
    1. If the clicked menu item / button caption maps to one of the 89 rebuilt
       forms, that form is opened as a dialog. Lookup goes through the Delphi
       class registry (RegisterClass / GetClass), so this unit does not need to
       reference the form units and no circular dependency is created.
    2. Otherwise a message box reports the exact handler that fired, so all
       2441 entry points give visible feedback instead of dying silently. }

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Menus, StdCtrls, Buttons, Dialogs;

procedure DispatchAction(Sender: TObject; const Handler: string);
function OpenRebuiltForm(const AClassName: string): Boolean;

implementation

type
  TFormMap = record
    Key: string;
    ClassName: string;
  end;
  TFormMapArray = array of TFormMap;

function FormMap: TFormMapArray;

  procedure Add(var A: TFormMapArray; const K, C: string);
  begin
    SetLength(A, Length(A) + 1);
    A[High(A)].Key := K;
    A[High(A)].ClassName := C;
  end;

begin
  SetLength(Result, 0);
  Add(Result, 'options', 'TOptions');
  Add(Result, 'contents', 'TContents');
  Add(Result, 'browser', 'TBrowser');
  Add(Result, 'find', 'TMyFindDlg');
  Add(Result, 'replace', 'TMyReplaceDlg');
  Add(Result, 'statistic', 'TStats');
  Add(Result, 'import', 'TImportTXTDlg');
  Add(Result, 'export', 'TXMLExportDialog');
  Add(Result, 'about', 'TAboutBox');
  Add(Result, 'password', 'TPasswordDialog');
  Add(Result, 'plan', 'TPlanDlg');
  Add(Result, 'workload', 'TWorkloadForm');
  Add(Result, 'priorit', 'TPriorityDlg');
  Add(Result, 'postpone', 'TPostponeDlg');
  Add(Result, 'commander', 'TCommanderDlg');
  Add(Result, 'concept', 'TConceptEditor');
  Add(Result, 'script', 'TScriptEditor');
  Add(Result, 'html', 'THTMLForm');
  Add(Result, 'sleep', 'TSleepForm');
  Add(Result, 'task', 'TTaskManager');
  Add(Result, 'localiz', 'TLocalizationDlg');
  Add(Result, 'faq', 'TFAQDlg');
  Add(Result, 'align', 'TAlignDlg');
  Add(Result, 'layout', 'TLayoutDlg');
  Add(Result, 'rotate', 'TRotateForm');
  Add(Result, 'scale', 'TImgScaler');
  Add(Result, 'tile', 'TTileDlg');
  Add(Result, 'style', 'TStylesheetEditor');
  Add(Result, 'translat', 'TTranslationDlg');
  Add(Result, 'recover', 'TRecoveryDialog');
  Add(Result, 'regist', 'TRegistryForm');
  Add(Result, 'login', 'TLoginDialog');
  Add(Result, 'answer', 'TAddTranscription');
  Add(Result, 'spell', 'TSpellDlg');
  Add(Result, 'title', 'TTitleEdit');
  Add(Result, 'order', 'TOrderEditor');
  Add(Result, 'mercy', 'TMercyOptions');
  Add(Result, 'leech', 'TLeechManagerDlg');
  Add(Result, 'subset', 'TRepSortDlg');
  Add(Result, 'spread', 'TSpreadPrioritiesDlg');
  Add(Result, 'interval', 'TGetIntervalDlg');
  Add(Result, 'analysis', 'TAnalysisDlg');
  Add(Result, 'graph', 'TRepGraphDlg');
  Add(Result, 'player', 'TPlayerForm');
  Add(Result, 'url', 'TURLOpenDlg');
  Add(Result, 'element', 'TElDataWind');
  Add(Result, 'statbar', 'TStatBar');
  Add(Result, 'ancestor', 'TAncestors');
  Add(Result, 'repetition history', 'TRepHistoryForm');
  Add(Result, 'simulation', 'TSimDlg');
  Add(Result, 'mercy', 'TMercyForm');
  Add(Result, 'choose', 'TChoicesDlg');
  Add(Result, 'target', 'TTargetDlg');
  Add(Result, 'input', 'TInputDlg');
  Add(Result, 'message', 'TMsgDialog');
end;

function CaptionOf(Sender: TObject): string;
begin
  Result := '';
  if Sender = nil then
    Exit;
  if Sender is TMenuItem then
    Result := TMenuItem(Sender).Caption
  else if Sender is TBitBtn then
    Result := TBitBtn(Sender).Caption
  else if Sender is TSpeedButton then
    Result := TSpeedButton(Sender).Caption
  else if Sender is TButton then
    Result := TButton(Sender).Caption
  else if Sender is TControl then
    Result := TControl(Sender).Name
  else if Sender is TComponent then
    Result := TComponent(Sender).Name;
  Result := StringReplace(Result, '&', '', [rfReplaceAll]);
  Result := Trim(Result);
end;

function FormClassByName(const AName: string): TFormClass;
var
  c: TPersistentClass;
begin
  Result := nil;
  if AName = '' then
    Exit;
  c := GetClass(AName);
  if (c <> nil) and c.InheritsFrom(TForm) then
    Result := TFormClass(c);
end;

function LookupFormName(const Caption: string): string;
var
  map: TFormMapArray;
  i: Integer;
  low: string;
begin
  Result := '';
  if Caption = '' then
    Exit;
  low := LowerCase(Caption);
  map := FormMap;
  for i := 0 to High(map) do
    if Pos(map[i].Key, low) > 0 then
      Exit(map[i].ClassName);
end;

function OpenRebuiltForm(const AClassName: string): Boolean;
var
  f: TForm;
  cls: TFormClass;
begin
  Result := False;
  cls := FormClassByName(AClassName);
  if cls = nil then
    Exit;
  f := nil;
  try
    f := cls.Create(Application);
    try
      f.ShowModal;
      Result := True;
    finally
      f.Free;
    end;
  except
    on E: Exception do
      MessageDlg('Dialog error', AClassName + LineEnding + E.ClassName + ': ' + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure DispatchAction(Sender: TObject; const Handler: string);
var
  cap, owner_, clsName: string;
begin
  cap := CaptionOf(Sender);
  owner_ := '';
  if (Sender is TComponent) and (TComponent(Sender).Owner is TComponent) then
    owner_ := TComponent(Sender).Owner.Name;

  clsName := LookupFormName(cap);
  if (clsName <> '') and OpenRebuiltForm(clsName) then
    Exit;

  MessageDlg('Not implemented yet',
    'Handler: ' + Handler + LineEnding +
    'Control: ' + cap + LineEnding +
    'Owner: ' + owner_ + LineEnding +
    LineEnding +
    'This entry point is wired up. The original behaviour lives in' + LineEnding +
    'code that has not been reconstructed yet.',
    mtInformation, [mbOK], 0);
end;

end.
