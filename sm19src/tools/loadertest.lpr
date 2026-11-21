program loadertest;
{$mode objfpc}{$H+}

uses
  Interfaces, Forms, SysUtils, Classes,
  uAboutBox,
  uAddressDlg,
  uAddTranscription,
  uAlignDlg,
  uAnalysisDlg,
  uAncestors,
  uBack,
  uBrImp,
  uBrowser,
  uChangeCompSize,
  uChecksDlg,
  uChoicesDlg,
  uCommanderDlg,
  uComponentEditor,
  uConceptEditor,
  uConceptMapForm,
  uConceptSelectBox,
  uContents,
  uContributions,
  uElDataWind,
  uElementFilter,
  uElParamDlg,
  uElWind,
  uFAQDlg,
  uFileBrowser,
  uGetIntervalDlg,
  uHitEditor,
  uHTMLForm,
  uImgDown,
  uImgScaler,
  uImportMailDlg,
  uImportTXTDlg,
  uInputDlg,
  uLayoutDlg,
  uLeechManagerDlg,
  uLocalizationDlg,
  uLoginDialog,
  uMemForm,
  uMercyForm,
  uMercyOptions,
  uMsgDialog,
  uMyFindDlg,
  uMyReplaceDlg,
  uOptions,
  uOrderEditor,
  uPasswordDialog,
  uPasswordDlg,
  uPlanDlg,
  uPlanParamDlg,
  uPlayerForm,
  uPleaseDlg,
  uPostponeDlg,
  uPriorityDlg,
  uProgressBox,
  uQODDlg,
  uQuestions,
  uRecoveryDialog,
  uRegistrationForm,
  uRegistryForm,
  uRepGraphDlg,
  uRepHistoryForm,
  uRepSimDlg,
  uRepSortDlg,
  uRotateForm,
  uScriptEditor,
  uSetPendingDlg,
  uShowTimeDialog,
  uSimDlg,
  uSleepForm,
  uSleepGraph,
  uSMMain,
  uSpellDlg,
  uSpreadPrioritiesDlg,
  uStatBar,
  uStats,
  uStylesheetEditor,
  uTargetDlg,
  uTasklistEditor,
  uTaskManager,
  uThemeTestDlg,
  uTileDlg,
  uTitleEdit,
  uTranslationDlg,
  uURLOpenDlg,
  uVBrowser,
  uWebDlg,
  uWorkload,
  uWorkloadForm,
  uXMLExportDialog;

type
  TEntry = record
    Name: string;
    Cls: TFormClass;
  end;

const
  Entries: array[0..88] of TEntry = (
  (Name: 'TAboutBox'; Cls: TAboutBox),
  (Name: 'TAddressDlg'; Cls: TAddressDlg),
  (Name: 'TAddTranscription'; Cls: TAddTranscription),
  (Name: 'TAlignDlg'; Cls: TAlignDlg),
  (Name: 'TAnalysisDlg'; Cls: TAnalysisDlg),
  (Name: 'TAncestors'; Cls: TAncestors),
  (Name: 'TBack'; Cls: TBack),
  (Name: 'TBrImp'; Cls: TBrImp),
  (Name: 'TBrowser'; Cls: TBrowser),
  (Name: 'TChangeCompSize'; Cls: TChangeCompSize),
  (Name: 'TChecksDlg'; Cls: TChecksDlg),
  (Name: 'TChoicesDlg'; Cls: TChoicesDlg),
  (Name: 'TCommanderDlg'; Cls: TCommanderDlg),
  (Name: 'TComponentEditor'; Cls: TComponentEditor),
  (Name: 'TConceptEditor'; Cls: TConceptEditor),
  (Name: 'TConceptMapForm'; Cls: TConceptMapForm),
  (Name: 'TConceptSelectBox'; Cls: TConceptSelectBox),
  (Name: 'TContents'; Cls: TContents),
  (Name: 'TContributions'; Cls: TContributions),
  (Name: 'TElDataWind'; Cls: TElDataWind),
  (Name: 'TElementFilter'; Cls: TElementFilter),
  (Name: 'TElParamDlg'; Cls: TElParamDlg),
  (Name: 'TElWind'; Cls: TElWind),
  (Name: 'TFAQDlg'; Cls: TFAQDlg),
  (Name: 'TFileBrowser'; Cls: TFileBrowser),
  (Name: 'TGetIntervalDlg'; Cls: TGetIntervalDlg),
  (Name: 'THitEditor'; Cls: THitEditor),
  (Name: 'THTMLForm'; Cls: THTMLForm),
  (Name: 'TImgDown'; Cls: TImgDown),
  (Name: 'TImgScaler'; Cls: TImgScaler),
  (Name: 'TImportMailDlg'; Cls: TImportMailDlg),
  (Name: 'TImportTXTDlg'; Cls: TImportTXTDlg),
  (Name: 'TInputDlg'; Cls: TInputDlg),
  (Name: 'TLayoutDlg'; Cls: TLayoutDlg),
  (Name: 'TLeechManagerDlg'; Cls: TLeechManagerDlg),
  (Name: 'TLocalizationDlg'; Cls: TLocalizationDlg),
  (Name: 'TLoginDialog'; Cls: TLoginDialog),
  (Name: 'TMemForm'; Cls: TMemForm),
  (Name: 'TMercyForm'; Cls: TMercyForm),
  (Name: 'TMercyOptions'; Cls: TMercyOptions),
  (Name: 'TMsgDialog'; Cls: TMsgDialog),
  (Name: 'TMyFindDlg'; Cls: TMyFindDlg),
  (Name: 'TMyReplaceDlg'; Cls: TMyReplaceDlg),
  (Name: 'TOptions'; Cls: TOptions),
  (Name: 'TOrderEditor'; Cls: TOrderEditor),
  (Name: 'TPasswordDialog'; Cls: TPasswordDialog),
  (Name: 'TPasswordDlg'; Cls: TPasswordDlg),
  (Name: 'TPlanDlg'; Cls: TPlanDlg),
  (Name: 'TPlanParamDlg'; Cls: TPlanParamDlg),
  (Name: 'TPlayerForm'; Cls: TPlayerForm),
  (Name: 'TPleaseDlg'; Cls: TPleaseDlg),
  (Name: 'TPostponeDlg'; Cls: TPostponeDlg),
  (Name: 'TPriorityDlg'; Cls: TPriorityDlg),
  (Name: 'TProgressBox'; Cls: TProgressBox),
  (Name: 'TQODDlg'; Cls: TQODDlg),
  (Name: 'TQuestions'; Cls: TQuestions),
  (Name: 'TRecoveryDialog'; Cls: TRecoveryDialog),
  (Name: 'TRegistrationForm'; Cls: TRegistrationForm),
  (Name: 'TRegistryForm'; Cls: TRegistryForm),
  (Name: 'TRepGraphDlg'; Cls: TRepGraphDlg),
  (Name: 'TRepHistoryForm'; Cls: TRepHistoryForm),
  (Name: 'TRepSimDlg'; Cls: TRepSimDlg),
  (Name: 'TRepSortDlg'; Cls: TRepSortDlg),
  (Name: 'TRotateForm'; Cls: TRotateForm),
  (Name: 'TScriptEditor'; Cls: TScriptEditor),
  (Name: 'TSetPendingDlg'; Cls: TSetPendingDlg),
  (Name: 'TShowTimeDialog'; Cls: TShowTimeDialog),
  (Name: 'TSimDlg'; Cls: TSimDlg),
  (Name: 'TSleepForm'; Cls: TSleepForm),
  (Name: 'TSleepGraph'; Cls: TSleepGraph),
  (Name: 'TSMMain'; Cls: TSMMain),
  (Name: 'TSpellDlg'; Cls: TSpellDlg),
  (Name: 'TSpreadPrioritiesDlg'; Cls: TSpreadPrioritiesDlg),
  (Name: 'TStatBar'; Cls: TStatBar),
  (Name: 'TStats'; Cls: TStats),
  (Name: 'TStylesheetEditor'; Cls: TStylesheetEditor),
  (Name: 'TTargetDlg'; Cls: TTargetDlg),
  (Name: 'TTasklistEditor'; Cls: TTasklistEditor),
  (Name: 'TTaskManager'; Cls: TTaskManager),
  (Name: 'TThemeTestDlg'; Cls: TThemeTestDlg),
  (Name: 'TTileDlg'; Cls: TTileDlg),
  (Name: 'TTitleEdit'; Cls: TTitleEdit),
  (Name: 'TTranslationDlg'; Cls: TTranslationDlg),
  (Name: 'TURLOpenDlg'; Cls: TURLOpenDlg),
  (Name: 'TVBrowser'; Cls: TVBrowser),
  (Name: 'TWebDlg'; Cls: TWebDlg),
  (Name: 'TWorkload'; Cls: TWorkload),
  (Name: 'TWorkloadForm'; Cls: TWorkloadForm),
  (Name: 'TXMLExportDialog'; Cls: TXMLExportDialog)
  );

var
  i: Integer;
  f: TForm;
  okCount, failCount: Integer;
begin
  Application.Initialize;
  okCount := 0;
  failCount := 0;
  for i := 0 to High(Entries) do
  begin
    try
      f := nil;
      Application.CreateForm(Entries[i].Cls, f);
      try
        WriteLn('OK   ', Entries[i].Name, ' comps=', f.ComponentCount);
        Inc(okCount);
      finally
        f.Free;
      end;
    except
      on E: Exception do
      begin
        WriteLn('FAIL ', Entries[i].Name, ' :: ', E.ClassName, ': ', E.Message);
        Inc(failCount);
      end;
    end;
  end;
  WriteLn('SUMMARY ok=', okCount, ' fail=', failCount);
end.
