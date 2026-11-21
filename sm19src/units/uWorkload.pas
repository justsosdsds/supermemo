unit uWorkload;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TWorkload = class(TForm)
    PageControl1: TPageControl;
    DailyTab: TTabSheet;
    StringGrid1: TStringGrid;
    MonthlyTab: TTabSheet;
    StringGrid2: TStringGrid;
    GraphTab: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton9: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ZoomIn: TToolButton;
    ZoomOut: TToolButton;
    ToolButton14: TToolButton;
    SmoothBtn: TToolButton;
    ToolButton13: TToolButton;
    ToolButton2: TToolButton;
    ExportWorkload: TToolButton;
    ToolButton12: TToolButton;
    TypeCombo: TComboBox;
    ChangeType: TToolButton;
    FormatCombo: TComboBox;
    WorkloadLabel: TLabel;
    PopupMenu1: TPopupMenu;
    MIDaily: TMenuItem;
    MIMonthly: TMenuItem;
    Workloadgraph1: TMenuItem;
    N1: TMenuItem;
    MIGoTo: TMenuItem;
    View1: TMenuItem;
    MISwitchPanels: TMenuItem;
    N2: TMenuItem;
    MIExportData: TMenuItem;
    N4: TMenuItem;
    Close1: TMenuItem;
    procedure Ahead4Click(Sender: TObject);
    procedure AheadClick(Sender: TObject);
    procedure Back4Click(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure ChangeTypeClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure End_Click(Sender: TObject);
    procedure EyeButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormatComboChange(Sender: TObject);
    procedure HomeClick(Sender: TObject);
    procedure MIDailyClick(Sender: TObject);
    procedure MIExportDataClick(Sender: TObject);
    procedure MIGoToClick(Sender: TObject);
    procedure MIMonthlyClick(Sender: TObject);
    procedure MISwitchPanelsClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AAllowChange: Boolean);
    procedure SmoothBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure StringGrid2KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid2MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure TypeComboChange(Sender: TObject);
    procedure Workloadgraph1Click(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
  end;

var
  Workload: TWorkload;

implementation

{$R *.lfm}

procedure TWorkload.Ahead4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Ahead4Click');
end;

procedure TWorkload.AheadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AheadClick');
end;

procedure TWorkload.Back4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Back4Click');
end;

procedure TWorkload.BackClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BackClick');
end;

procedure TWorkload.ChangeTypeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangeTypeClick');
end;

procedure TWorkload.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TWorkload.End_Click(Sender: TObject);
begin
  DispatchAction(Sender, 'End_Click');
end;

procedure TWorkload.EyeButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EyeButtonClick');
end;

procedure TWorkload.FormActivate(Sender: TObject);
begin
end;

procedure TWorkload.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TWorkload.FormCreate(Sender: TObject);
begin
end;

procedure TWorkload.FormDestroy(Sender: TObject);
begin
end;

procedure TWorkload.FormResize(Sender: TObject);
begin
end;

procedure TWorkload.FormShow(Sender: TObject);
begin
end;

procedure TWorkload.FormatComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FormatComboChange');
end;

procedure TWorkload.HomeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HomeClick');
end;

procedure TWorkload.MIDailyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDailyClick');
end;

procedure TWorkload.MIExportDataClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDataClick');
end;

procedure TWorkload.MIGoToClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToClick');
end;

procedure TWorkload.MIMonthlyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMonthlyClick');
end;

procedure TWorkload.MISwitchPanelsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwitchPanelsClick');
end;

procedure TWorkload.PageControl1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'PageControl1Change');
end;

procedure TWorkload.PageControl1Changing(Sender: TObject; var AAllowChange: Boolean);
begin
  DispatchAction(Sender, 'PageControl1Changing');
end;

procedure TWorkload.SmoothBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SmoothBtnClick');
end;

procedure TWorkload.StringGrid1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StringGrid1DblClick');
end;

procedure TWorkload.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

procedure TWorkload.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TWorkload.StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid1SelectCell');
end;

procedure TWorkload.StringGrid2DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StringGrid2DblClick');
end;

procedure TWorkload.StringGrid2KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid2KeyDown');
end;

procedure TWorkload.StringGrid2MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWorkload.StringGrid2SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid2SelectCell');
end;

procedure TWorkload.TypeComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TypeComboChange');
end;

procedure TWorkload.Workloadgraph1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Workloadgraph1Click');
end;

procedure TWorkload.ZoomInClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ZoomInClick');
end;

procedure TWorkload.ZoomOutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ZoomOutClick');
end;

initialization
  if GetClass('TWorkload') = nil then
    RegisterClass(TWorkload);

end.
