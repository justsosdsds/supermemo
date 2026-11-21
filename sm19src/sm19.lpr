program sm19;
{$mode objfpc}{$H+}

uses
  Interfaces, Forms, LResources, compat,
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
  uXMLExportDialog,
  smdemo;

begin
  Application.Initialize;
  Application.Title := 'SuperMemo 19';
  AboutBox := TAboutBox.Create(Application);   // image-list host, never shown
  AboutBox.Hide;
  Application.CreateForm(TSMMain, SMMain);
  Ancestors := TAncestors.Create(Application);
  Back := TBack.Create(Application);
  CommanderDlg := TCommanderDlg.Create(Application);
  Contents := TContents.Create(Application);
  ElDataWind := TElDataWind.Create(Application);
  StatBar := TStatBar.Create(Application);
  Stats := TStats.Create(Application);
  Application.CreateForm(TElWind, ElWind);   // element window: original startup screen
  ElWind.Show;
  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 9) = '--import=') then
  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 15) = '--test-settings') then
  begin
    SMTestSettings(0);
    Halt(0);
  end;
  if (ParamCount >= 1) and (Copy(ParamStr(1), 1, 7) = '--study') then
  begin
    SMStartupStudy(0);
    Halt(0);
  end;
  Application.Run;
end.
