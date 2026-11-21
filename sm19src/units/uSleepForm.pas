unit uSleepForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSleepForm = class(TForm)
    PageControl1: TPageControl;
    SleepTab: TTabSheet;
    PaintBox1: TPaintBox;
    ToolBar1: TToolBar;
    ConsolidateBlocksBtn: TToolButton;
    Approximations: TToolButton;
    EMailButton: TToolButton;
    GoToBtn: TToolButton;
    InfoButton: TToolButton;
    TraceButton: TToolButton;
    SaveDataBtn: TToolButton;
    OpenDataBtn: TToolButton;
    ComboBox1: TComboBox;
    ScrollBar1: TScrollBar;
    CircadianTab: TTabSheet;
    CircadianPaintBox: TPaintBox;
    ToolBar3: TToolBar;
    PhaseShiftBtn: TToolButton;
    Consolidate1: TToolButton;
    SleepDataBtn: TToolButton;
    FromBtn: TToolButton;
    ToolButton3: TToolButton;
    ToBtn: TToolButton;
    ToolButton4: TToolButton;
    BlockNoLabel: TLabel;
    PhaseShiftTab: TTabSheet;
    PhaseShiftPaintBox: TPaintBox;
    ToolBar2: TToolBar;
    Consolidate2: TToolButton;
    ClearStartButton: TToolButton;
    ClearFinishButton: TToolButton;
    RelativeButton: TToolButton;
    AlertnessH: TTabSheet;
    AlertnessPaintBox: TPaintBox;
    ToolBar4: TToolBar;
    AlertnessExcel: TToolButton;
    MinLengthE: TEdit;
    HalflifeEdit: TEdit;
    RepCasesAlert: TLabel;
    FormulaAlert: TLabel;
    AlertnessC: TTabSheet;
    PerformancePaintBox: TPaintBox;
    ApproxToolbar: TToolBar;
    HomeoButton: TToolButton;
    CButton: TToolButton;
    SButton: TToolButton;
    SDButton: TToolButton;
    ModelButton: TToolButton;
    UseRButton: TToolButton;
    PerformanceExcel: TToolButton;
    RepCases: TLabel;
    approximation: TButton;
    NapLength: TTabSheet;
    NapPaintBox: TPaintBox;
    REMTab: TTabSheet;
    REMPaintBox: TPaintBox;
    BlockDistribution: TTabSheet;
    DistributionPaintBox: TPaintBox;
    LogScale: TCheckBox;
    PeriodogramTab: TTabSheet;
    PeriodogramPaintBox: TPaintBox;
    XYLabel: TLabel;
    LearningVsSleep: TTabSheet;
    LearningPaintBox: TPaintBox;
    MemoryTab: TTabSheet;
    MemoryPaintBox: TPaintBox;
    Approximate: TButton;
    Button3: TButton;
    Button4: TButton;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MINew: TMenuItem;
    MIOpenSleepChart: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N5: TMenuItem;
    I1: TMenuItem;
    MIImportfromExcel: TMenuItem;
    N10: TMenuItem;
    MINewDefaultFile: TMenuItem;
    Makedefault1: TMenuItem;
    N11: TMenuItem;
    MIImportSleepChartFile: TMenuItem;
    N12: TMenuItem;
    MISuperimpose: TMenuItem;
    Export1: TMenuItem;
    MIExportToExcel: TMenuItem;
    N9: TMenuItem;
    MIExportSleepLengthData: TMenuItem;
    MIPeriodogram: TMenuItem;
    MIExport_rPRC: TMenuItem;
    ools1: TMenuItem;
    MIRepetitionHistory: TMenuItem;
    MITestForOverlaps: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MIGoToDay: TMenuItem;
    MISetFirstSleepDay: TMenuItem;
    Options1: TMenuItem;
    Age1: TMenuItem;
    MIBaby: TMenuItem;
    MIChild: TMenuItem;
    MIAdult: TMenuItem;
    Display1: TMenuItem;
    MILearningTime: TMenuItem;
    MISleepTime: TMenuItem;
    MINightSleep: TMenuItem;
    MINapTime: TMenuItem;
    MIPhaseShift: TMenuItem;
    MIREMCoefficient: TMenuItem;
    N7: TMenuItem;
    MIViewNext: TMenuItem;
    ViewPrevious1: TMenuItem;
    Consolidation1: TMenuItem;
    MIRecallvsConsolidation: TMenuItem;
    MIConsolidationvsRecall: TMenuItem;
    OpenDialog1: TOpenDialog;
    AddingTimer: TTimer;
    PopupMenu1: TPopupMenu;
    MIDenseView: TMenuItem;
    N8: TMenuItem;
    MIDeleteBlock: TMenuItem;
    MINext: TMenuItem;
    MIPrevious: TMenuItem;
    Goto1: TMenuItem;
    N4: TMenuItem;
    MIForcedAwakening: TMenuItem;
    MIDelayedRetirement: TMenuItem;
    N6: TMenuItem;
    MISleepPropensity: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    procedure AddingTimerTimer(Sender: TObject);
    procedure Age1Click(Sender: TObject);
    procedure AlertnessExcelClick(Sender: TObject);
    procedure AlertnessPaintBoxClick(Sender: TObject);
    procedure ApproximateClick(Sender: TObject);
    procedure ApproximationsClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CButtonClick(Sender: TObject);
    procedure CircadianPaintBoxPaint(Sender: TObject);
    procedure ClearFinishButtonClick(Sender: TObject);
    procedure ClearStartButtonClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ConsolidateBlocksBtnClick(Sender: TObject);
    procedure ConsolidateClick(Sender: TObject);
    procedure Consolidation1Click(Sender: TObject);
    procedure Display1Click(Sender: TObject);
    procedure DistributionPaintBoxPaint(Sender: TObject);
    procedure EMailButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint; var AHandled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FromBtnClick(Sender: TObject);
    procedure GoToBtnClick(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure HalflifeEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure HomeoButtonClick(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure LearningPaintBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure LearningPaintBoxPaint(Sender: TObject);
    procedure LogScaleClick(Sender: TObject);
    procedure MIAdultClick(Sender: TObject);
    procedure MIBabyClick(Sender: TObject);
    procedure MIChildClick(Sender: TObject);
    procedure MIConsolidationvsRecallClick(Sender: TObject);
    procedure MIDelayedRetirementClick(Sender: TObject);
    procedure MIDeleteBlockClick(Sender: TObject);
    procedure MIDenseViewClick(Sender: TObject);
    procedure MIExportSleepLengthDataClick(Sender: TObject);
    procedure MIExportToExcelClick(Sender: TObject);
    procedure MIExport_rPRCClick(Sender: TObject);
    procedure MIForcedAwakeningClick(Sender: TObject);
    procedure MIGoToDayClick(Sender: TObject);
    procedure MIImportSleepChartFileClick(Sender: TObject);
    procedure MIImportfromExcelClick(Sender: TObject);
    procedure MILearningTimeClick(Sender: TObject);
    procedure MINapTimeClick(Sender: TObject);
    procedure MINewClick(Sender: TObject);
    procedure MINewDefaultFileClick(Sender: TObject);
    procedure MINextClick(Sender: TObject);
    procedure MINightSleepClick(Sender: TObject);
    procedure MIOpenSleepChartClick(Sender: TObject);
    procedure MIPeriodogramClick(Sender: TObject);
    procedure MIPhaseShiftClick(Sender: TObject);
    procedure MIPreviousClick(Sender: TObject);
    procedure MIREMCoefficientClick(Sender: TObject);
    procedure MIRecallvsConsolidationClick(Sender: TObject);
    procedure MIRepetitionHistoryClick(Sender: TObject);
    procedure MISetFirstSleepDayClick(Sender: TObject);
    procedure MISleepPropensityClick(Sender: TObject);
    procedure MISleepTimeClick(Sender: TObject);
    procedure MISuperimposeClick(Sender: TObject);
    procedure MITestForOverlapsClick(Sender: TObject);
    procedure MIViewNextClick(Sender: TObject);
    procedure MinLengthEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure ModelButtonClick(Sender: TObject);
    procedure NapPaintBoxPaint(Sender: TObject);
    procedure OpenDataBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PerformanceExcelClick(Sender: TObject);
    procedure PeriodogramPaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure PeriodogramPaintBoxPaint(Sender: TObject);
    procedure PhaseShiftBtnClick(Sender: TObject);
    procedure PhaseShiftPaintBoxPaint(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure RelativeButtonClick(Sender: TObject);
    procedure SButtonClick(Sender: TObject);
    procedure SDButtonClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure SaveDataBtnClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure SleepDataBtnClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure TraceButtonClick(Sender: TObject);
    procedure UseRButtonClick(Sender: TObject);
    procedure ViewPrevious1Click(Sender: TObject);
    procedure approximationClick(Sender: TObject);
  end;

var
  SleepForm: TSleepForm;

implementation

{$R *.lfm}

procedure TSleepForm.AddingTimerTimer(Sender: TObject);
begin
end;

procedure TSleepForm.Age1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Age1Click');
end;

procedure TSleepForm.AlertnessExcelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlertnessExcelClick');
end;

procedure TSleepForm.AlertnessPaintBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlertnessPaintBoxClick');
end;

procedure TSleepForm.ApproximateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ApproximateClick');
end;

procedure TSleepForm.ApproximationsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ApproximationsClick');
end;

procedure TSleepForm.Button4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button4Click');
end;

procedure TSleepForm.CButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CButtonClick');
end;

procedure TSleepForm.CircadianPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.ClearFinishButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearFinishButtonClick');
end;

procedure TSleepForm.ClearStartButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearStartButtonClick');
end;

procedure TSleepForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TSleepForm.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure TSleepForm.ConsolidateBlocksBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ConsolidateBlocksBtnClick');
end;

procedure TSleepForm.ConsolidateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ConsolidateClick');
end;

procedure TSleepForm.Consolidation1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Consolidation1Click');
end;

procedure TSleepForm.Display1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Display1Click');
end;

procedure TSleepForm.DistributionPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.EMailButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EMailButtonClick');
end;

procedure TSleepForm.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TSleepForm.FormCreate(Sender: TObject);
begin
end;

procedure TSleepForm.FormDestroy(Sender: TObject);
begin
end;

procedure TSleepForm.FormHide(Sender: TObject);
begin
end;

procedure TSleepForm.FormMouseWheel(Sender: TObject; AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint; var AHandled: Boolean);
begin
end;

procedure TSleepForm.FormResize(Sender: TObject);
begin
end;

procedure TSleepForm.FormShow(Sender: TObject);
begin
end;

procedure TSleepForm.FromBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FromBtnClick');
end;

procedure TSleepForm.GoToBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToBtnClick');
end;

procedure TSleepForm.Goto1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Goto1Click');
end;

procedure TSleepForm.HalflifeEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'HalflifeEditKeyDown');
end;

procedure TSleepForm.HomeoButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HomeoButtonClick');
end;

procedure TSleepForm.InfoButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InfoButtonClick');
end;

procedure TSleepForm.LearningPaintBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TSleepForm.LearningPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.LogScaleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LogScaleClick');
end;

procedure TSleepForm.MIAdultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdultClick');
end;

procedure TSleepForm.MIBabyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBabyClick');
end;

procedure TSleepForm.MIChildClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildClick');
end;

procedure TSleepForm.MIConsolidationvsRecallClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConsolidationvsRecallClick');
end;

procedure TSleepForm.MIDelayedRetirementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDelayedRetirementClick');
end;

procedure TSleepForm.MIDeleteBlockClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteBlockClick');
end;

procedure TSleepForm.MIDenseViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDenseViewClick');
end;

procedure TSleepForm.MIExportSleepLengthDataClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportSleepLengthDataClick');
end;

procedure TSleepForm.MIExportToExcelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportToExcelClick');
end;

procedure TSleepForm.MIExport_rPRCClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExport_rPRCClick');
end;

procedure TSleepForm.MIForcedAwakeningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIForcedAwakeningClick');
end;

procedure TSleepForm.MIGoToDayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToDayClick');
end;

procedure TSleepForm.MIImportSleepChartFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportSleepChartFileClick');
end;

procedure TSleepForm.MIImportfromExcelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportfromExcelClick');
end;

procedure TSleepForm.MILearningTimeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearningTimeClick');
end;

procedure TSleepForm.MINapTimeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINapTimeClick');
end;

procedure TSleepForm.MINewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewClick');
end;

procedure TSleepForm.MINewDefaultFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewDefaultFileClick');
end;

procedure TSleepForm.MINextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextClick');
end;

procedure TSleepForm.MINightSleepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINightSleepClick');
end;

procedure TSleepForm.MIOpenSleepChartClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenSleepChartClick');
end;

procedure TSleepForm.MIPeriodogramClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPeriodogramClick');
end;

procedure TSleepForm.MIPhaseShiftClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPhaseShiftClick');
end;

procedure TSleepForm.MIPreviousClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousClick');
end;

procedure TSleepForm.MIREMCoefficientClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIREMCoefficientClick');
end;

procedure TSleepForm.MIRecallvsConsolidationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRecallvsConsolidationClick');
end;

procedure TSleepForm.MIRepetitionHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRepetitionHistoryClick');
end;

procedure TSleepForm.MISetFirstSleepDayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetFirstSleepDayClick');
end;

procedure TSleepForm.MISleepPropensityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISleepPropensityClick');
end;

procedure TSleepForm.MISleepTimeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISleepTimeClick');
end;

procedure TSleepForm.MISuperimposeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISuperimposeClick');
end;

procedure TSleepForm.MITestForOverlapsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestForOverlapsClick');
end;

procedure TSleepForm.MIViewNextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewNextClick');
end;

procedure TSleepForm.MinLengthEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'MinLengthEKeyDown');
end;

procedure TSleepForm.ModelButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ModelButtonClick');
end;

procedure TSleepForm.NapPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.OpenDataBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OpenDataBtnClick');
end;

procedure TSleepForm.PageControl1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'PageControl1Change');
end;

procedure TSleepForm.PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TSleepForm.PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TSleepForm.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TSleepForm.PerformanceExcelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PerformanceExcelClick');
end;

procedure TSleepForm.PeriodogramPaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TSleepForm.PeriodogramPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.PhaseShiftBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PhaseShiftBtnClick');
end;

procedure TSleepForm.PhaseShiftPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepForm.PopupMenu1Popup(Sender: TObject);
begin
  DispatchAction(Sender, 'PopupMenu1Popup');
end;

procedure TSleepForm.RelativeButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RelativeButtonClick');
end;

procedure TSleepForm.SButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SButtonClick');
end;

procedure TSleepForm.SDButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SDButtonClick');
end;

procedure TSleepForm.Save1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Save1Click');
end;

procedure TSleepForm.SaveAs1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveAs1Click');
end;

procedure TSleepForm.SaveDataBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveDataBtnClick');
end;

procedure TSleepForm.ScrollBar1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ScrollBar1Change');
end;

procedure TSleepForm.SleepDataBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SleepDataBtnClick');
end;

procedure TSleepForm.ToolButton3Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton3Click');
end;

procedure TSleepForm.ToolButton4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton4Click');
end;

procedure TSleepForm.TraceButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TraceButtonClick');
end;

procedure TSleepForm.UseRButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UseRButtonClick');
end;

procedure TSleepForm.ViewPrevious1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewPrevious1Click');
end;

procedure TSleepForm.approximationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'approximationClick');
end;

initialization
  if GetClass('TSleepForm') = nil then
    RegisterClass(TSleepForm);

end.
