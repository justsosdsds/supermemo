unit uPlanDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPlanDlg = class(TForm)
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    Panel2: TPanel;
    Label1: TLabel;
    LenEdit: TEdit;
    ComboBox1: TComboBox;
    ToolButton4: TToolButton;
    MenuBtn: TToolButton;
    SaveBtn: TToolButton;
    SetTimeBtn: TToolButton;
    ExportBtn: TToolButton;
    OffendersBtn: TToolButton;
    EditBtn: TToolButton;
    Totals: TToolButton;
    AdjustBtn: TToolButton;
    SplitBtn: TToolButton;
    ToolButton2: TToolButton;
    PopupMenu1: TPopupMenu;
    MIOpen: TMenuItem;
    MINew: TMenuItem;
    Save1: TMenuItem;
    MISaveAs: TMenuItem;
    N2: TMenuItem;
    MIEdit: TMenuItem;
    MIEditParameters: TMenuItem;
    N3: TMenuItem;
    MIBegin1: TMenuItem;
    MIInsert: TMenuItem;
    MIDelete: TMenuItem;
    MISplit: TMenuItem;
    MIMerge: TMenuItem;
    MIFixStartTime: TMenuItem;
    MITerminate: TMenuItem;
    N4: TMenuItem;
    Alarm1: TMenuItem;
    MIBegin2: TMenuItem;
    MIREmind: TMenuItem;
    N7: TMenuItem;
    MISetAlarm: TMenuItem;
    MIStopAlarm: TMenuItem;
    N6: TMenuItem;
    MIChooseMP3: TMenuItem;
    Tools1: TMenuItem;
    MIExport: TMenuItem;
    otals1: TMenuItem;
    MIDelays: TMenuItem;
    MIArchive: TMenuItem;
    N5: TMenuItem;
    MIAdjust: TMenuItem;
    MIAdjustFromNow: TMenuItem;
    MIAdjustFromSelected: TMenuItem;
    N10: TMenuItem;
    MIBeginAndShift: TMenuItem;
    MIReset: TMenuItem;
    N9: TMenuItem;
    MIImportDiary: TMenuItem;
    MIImportStatistics: TMenuItem;
    MIArchiveSchedules: TMenuItem;
    MIPasteFromDiary: TMenuItem;
    N11: TMenuItem;
    MIProcessSchedules: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    N8: TMenuItem;
    MISelectPlan: TMenuItem;
    InvBlockedShortcuts1: TMenuItem;
    InvNone1: TMenuItem;
    Inv1: TMenuItem;
    InvBlockF31: TMenuItem;
    InvBlockCtrlD1: TMenuItem;
    BlockCtrlR1: TMenuItem;
    Randomize1: TMenuItem;
    InvSleepChart1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    procedure AdjustBtnClick(Sender: TObject);
    procedure Alarm1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var AKey: Char);
    procedure EditBtnClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InvSleepChart1Click(Sender: TObject);
    procedure LenEditChange(Sender: TObject);
    procedure LenEditExit(Sender: TObject);
    procedure LenEditKeyPress(Sender: TObject; var AKey: Char);
    procedure MIAdjustFromNowClick(Sender: TObject);
    procedure MIAdjustFromSelectedClick(Sender: TObject);
    procedure MIArchiveClick(Sender: TObject);
    procedure MIArchiveSchedulesClick(Sender: TObject);
    procedure MIBegin2Click(Sender: TObject);
    procedure MIBeginAndShiftClick(Sender: TObject);
    procedure MIChooseMP3Click(Sender: TObject);
    procedure MIDelaysClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIEditClick(Sender: TObject);
    procedure MIEditParametersClick(Sender: TObject);
    procedure MIExportClick(Sender: TObject);
    procedure MIFixStartTimeClick(Sender: TObject);
    procedure MIImportDiaryClick(Sender: TObject);
    procedure MIImportStatisticsClick(Sender: TObject);
    procedure MIInsertClick(Sender: TObject);
    procedure MIMergeClick(Sender: TObject);
    procedure MINewClick(Sender: TObject);
    procedure MIOpenClick(Sender: TObject);
    procedure MIPasteFromDiaryClick(Sender: TObject);
    procedure MIProcessSchedulesClick(Sender: TObject);
    procedure MIREmindClick(Sender: TObject);
    procedure MIResetClick(Sender: TObject);
    procedure MISaveAsClick(Sender: TObject);
    procedure MISelectPlanClick(Sender: TObject);
    procedure MISetAlarmClick(Sender: TObject);
    procedure MISplitClick(Sender: TObject);
    procedure MIStopAlarmClick(Sender: TObject);
    procedure MITerminateClick(Sender: TObject);
    procedure MenuBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SetTimeBtnClick(Sender: TObject);
    procedure SplitBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1KeyPress(Sender: TObject; var AKey: Char);
    procedure StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure TotalsClick(Sender: TObject);
  end;

var
  PlanDlg: TPlanDlg;

implementation

{$R *.lfm}

procedure TPlanDlg.AdjustBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AdjustBtnClick');
end;

procedure TPlanDlg.Alarm1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Alarm1Click');
end;

procedure TPlanDlg.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TPlanDlg.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure TPlanDlg.ComboBox1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Click');
end;

procedure TPlanDlg.ComboBox1DropDown(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1DropDown');
end;

procedure TPlanDlg.ComboBox1KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'ComboBox1KeyPress');
end;

procedure TPlanDlg.EditBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EditBtnClick');
end;

procedure TPlanDlg.ExportBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportBtnClick');
end;

procedure TPlanDlg.FormActivate(Sender: TObject);
begin
end;

procedure TPlanDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TPlanDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TPlanDlg.FormCreate(Sender: TObject);
begin
end;

procedure TPlanDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TPlanDlg.FormResize(Sender: TObject);
begin
end;

procedure TPlanDlg.FormShow(Sender: TObject);
begin
end;

procedure TPlanDlg.InvSleepChart1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvSleepChart1Click');
end;

procedure TPlanDlg.LenEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'LenEditChange');
end;

procedure TPlanDlg.LenEditExit(Sender: TObject);
begin
end;

procedure TPlanDlg.LenEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'LenEditKeyPress');
end;

procedure TPlanDlg.MIAdjustFromNowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdjustFromNowClick');
end;

procedure TPlanDlg.MIAdjustFromSelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdjustFromSelectedClick');
end;

procedure TPlanDlg.MIArchiveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIArchiveClick');
end;

procedure TPlanDlg.MIArchiveSchedulesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIArchiveSchedulesClick');
end;

procedure TPlanDlg.MIBegin2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBegin2Click');
end;

procedure TPlanDlg.MIBeginAndShiftClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBeginAndShiftClick');
end;

procedure TPlanDlg.MIChooseMP3Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChooseMP3Click');
end;

procedure TPlanDlg.MIDelaysClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDelaysClick');
end;

procedure TPlanDlg.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TPlanDlg.MIEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditClick');
end;

procedure TPlanDlg.MIEditParametersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditParametersClick');
end;

procedure TPlanDlg.MIExportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportClick');
end;

procedure TPlanDlg.MIFixStartTimeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFixStartTimeClick');
end;

procedure TPlanDlg.MIImportDiaryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportDiaryClick');
end;

procedure TPlanDlg.MIImportStatisticsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportStatisticsClick');
end;

procedure TPlanDlg.MIInsertClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertClick');
end;

procedure TPlanDlg.MIMergeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMergeClick');
end;

procedure TPlanDlg.MINewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewClick');
end;

procedure TPlanDlg.MIOpenClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenClick');
end;

procedure TPlanDlg.MIPasteFromDiaryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteFromDiaryClick');
end;

procedure TPlanDlg.MIProcessSchedulesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIProcessSchedulesClick');
end;

procedure TPlanDlg.MIREmindClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIREmindClick');
end;

procedure TPlanDlg.MIResetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetClick');
end;

procedure TPlanDlg.MISaveAsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveAsClick');
end;

procedure TPlanDlg.MISelectPlanClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectPlanClick');
end;

procedure TPlanDlg.MISetAlarmClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetAlarmClick');
end;

procedure TPlanDlg.MISplitClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISplitClick');
end;

procedure TPlanDlg.MIStopAlarmClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStopAlarmClick');
end;

procedure TPlanDlg.MITerminateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITerminateClick');
end;

procedure TPlanDlg.MenuBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MenuBtnClick');
end;

procedure TPlanDlg.SaveBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveBtnClick');
end;

procedure TPlanDlg.SetTimeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetTimeBtnClick');
end;

procedure TPlanDlg.SplitBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SplitBtnClick');
end;

procedure TPlanDlg.StringGrid1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StringGrid1DblClick');
end;

procedure TPlanDlg.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

procedure TPlanDlg.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TPlanDlg.StringGrid1KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'StringGrid1KeyPress');
end;

procedure TPlanDlg.StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TPlanDlg.StringGrid1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TPlanDlg.StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
begin
  DispatchAction(Sender, 'StringGrid1RowMoved');
end;

procedure TPlanDlg.StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid1SelectCell');
end;

procedure TPlanDlg.Timer1Timer(Sender: TObject);
begin
end;

procedure TPlanDlg.TotalsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TotalsClick');
end;

initialization
  if GetClass('TPlanDlg') = nil then
    RegisterClass(TPlanDlg);

end.
