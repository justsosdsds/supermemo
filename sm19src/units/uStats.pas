unit uStats;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TStats = class(TForm)
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    WorkloadBtn: TToolButton;
    AnalysisBtn: TToolButton;
    Graphs4DBtn: TToolButton;
    ToolButton6: TToolButton;
    WarriorLayoutBtn: TToolButton;
    ToolButton8: TToolButton;
    ToolButton5: TToolButton;
    PopupMenu1: TPopupMenu;
    MICalendar: TMenuItem;
    MIReport: TMenuItem;
    MIRestoreLayout: TMenuItem;
    MIElementWindow: TMenuItem;
    procedure AnalysisBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure Graphs4DBtnClick(Sender: TObject);
    procedure MICalendarClick(Sender: TObject);
    procedure MIElementWindowClick(Sender: TObject);
    procedure MIReportClick(Sender: TObject);
    procedure MIRestoreLayoutClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
    procedure ToolButton5Click(Sender: TObject);
    procedure WarriorLayoutBtnClick(Sender: TObject);
    procedure WorkloadBtnClick(Sender: TObject);
  end;

var
  Stats: TStats;

implementation

{$R *.lfm}

procedure TStats.AnalysisBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AnalysisBtnClick');
end;

procedure TStats.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TStats.FormCreate(Sender: TObject);
begin
end;

procedure TStats.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TStats.FormResize(Sender: TObject);
begin
end;

procedure TStats.Graphs4DBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'Graphs4DBtnClick');
end;

procedure TStats.MICalendarClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICalendarClick');
end;

procedure TStats.MIElementWindowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementWindowClick');
end;

procedure TStats.MIReportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReportClick');
end;

procedure TStats.MIRestoreLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRestoreLayoutClick');
end;

procedure TStats.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

procedure TStats.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TStats.StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TStats.StringGrid1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TStats.StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
begin
  DispatchAction(Sender, 'StringGrid1RowMoved');
end;

procedure TStats.ToolButton5Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton5Click');
end;

procedure TStats.WarriorLayoutBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WarriorLayoutBtnClick');
end;

procedure TStats.WorkloadBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WorkloadBtnClick');
end;

initialization
  if GetClass('TStats') = nil then
    RegisterClass(TStats);

end.
