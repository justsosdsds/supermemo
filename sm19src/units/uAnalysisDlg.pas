unit uAnalysisDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAnalysisDlg = class(TForm)
    Notebook: TTabbedNotebook;
    UsePaintBox: TPaintBox;
    CatSet: TTabSet;
    UseSet: TTabSet;
    Curve17PaintBox: TPaintBox;
    StabTab: TTabControl;
    DiffTab: TTabControl;
    CurvePaintBox: TPaintBox;
    RepTabSet: TTabSet;
    LapsesTabSet: TTabSet;
    AFTabSet: TTabSet;
    StabilizationPaintBox: TPaintBox;
    SStabTab: TTabControl;
    SDiffTab: TTabControl;
    GraphPaintBox: TPaintBox;
    GraphTabset: TTabSet;
    DistrPaintBox: TPaintBox;
    DistrTabs: TTabControl;
    Curve3DPaintBox: TPaintBox;
    AF3DTabSet: TTabSet;
    PaintBox3D: TPaintBox;
    ThreeDTabSet: TTabSet;
    SIncDecayPaintBox: TPaintBox;
    SIncDecayTabs: TTabControl;
    OFDecayPaintBox: TPaintBox;
    OFDecayTabs: TTabSet;
    RecallPaint: TPaintBox;
    MatrixTabs: TTabControl;
    Bottom: TPanel;
    ViewMode: TSpeedButton;
    XYLabel: TLabel;
    OK: TBitBtn;
    HelpBtn: TBitBtn;
    Rotate: TBitBtn;
    Smooth: TBitBtn;
    ViewCombo: TComboBox;
    PopupMenu1: TPopupMenu;
    MINext: TMenuItem;
    MIPrevious: TMenuItem;
    N5: TMenuItem;
    MINextSecondary: TMenuItem;
    MIPreviousSecondary: TMenuItem;
    N2: TMenuItem;
    Cutoffleft1: TMenuItem;
    Cutoffright1: TMenuItem;
    Cutofftop1: TMenuItem;
    N4: TMenuItem;
    MIExport: TMenuItem;
    Import1: TMenuItem;
    N1: TMenuItem;
    MIClose: TMenuItem;
    N3: TMenuItem;
    InvDistributions1: TMenuItem;
    Inv3DCurves1: TMenuItem;
    Invapproximations1: TMenuItem;
    InvUse1: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure AF3DTabSetChange(Sender: TObject);
    procedure AFTabSetChange(Sender: TObject);
    procedure CatSetClick(Sender: TObject);
    procedure Curve17PaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure Curve17PaintBoxPaint(Sender: TObject);
    procedure Curve3DPaintBoxPaint(Sender: TObject);
    procedure CurvePaintBoxPaint(Sender: TObject);
    procedure Cutoffleft1Click(Sender: TObject);
    procedure Cutoffright1Click(Sender: TObject);
    procedure Cutofftop1Click(Sender: TObject);
    procedure DiffTabChange(Sender: TObject);
    procedure DistrPaintBoxPaint(Sender: TObject);
    procedure DistrTabsChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GraphPaintBoxPaint(Sender: TObject);
    procedure GraphTabsetClick(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure Inv3DCurves1Click(Sender: TObject);
    procedure InvDistributions1Click(Sender: TObject);
    procedure InvUse1Click(Sender: TObject);
    procedure Invapproximations1Click(Sender: TObject);
    procedure LapsesTabSetChange(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MIExportClick(Sender: TObject);
    procedure MINextClick(Sender: TObject);
    procedure MINextSecondaryClick(Sender: TObject);
    procedure MIPreviousClick(Sender: TObject);
    procedure MIPreviousSecondaryClick(Sender: TObject);
    procedure MatrixPaint(Sender: TObject);
    procedure MatrixTabSetClick(Sender: TObject);
    procedure NotebookClick(Sender: TObject);
    procedure OFDecayPaintBoxPaint(Sender: TObject);
    procedure OFDecayTabsClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure PaintBox3DPaint(Sender: TObject);
    procedure RecallPaintDblClick(Sender: TObject);
    procedure RecallPaintMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure RepTabSetChange(Sender: TObject);
    procedure RotateClick(Sender: TObject);
    procedure SDiffTabChange(Sender: TObject);
    procedure SIncDecayPaintBoxPaint(Sender: TObject);
    procedure SIncDecayTabsChange(Sender: TObject);
    procedure SmoothClick(Sender: TObject);
    procedure StabTabChange(Sender: TObject);
    procedure StabilizationPaintBoxPaint(Sender: TObject);
    procedure ThreeDTabSetClick(Sender: TObject);
    procedure UsePaintBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure UsePaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure UsePaintBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure UsePaintBoxPaint(Sender: TObject);
    procedure UseSetClick(Sender: TObject);
    procedure ViewComboChange(Sender: TObject);
    procedure ViewModeClick(Sender: TObject);
  end;

var
  AnalysisDlg: TAnalysisDlg;

implementation

{$R *.lfm}

procedure TAnalysisDlg.AF3DTabSetChange(Sender: TObject);
begin
  DispatchAction(Sender, 'AF3DTabSetChange');
end;

procedure TAnalysisDlg.AFTabSetChange(Sender: TObject);
begin
  DispatchAction(Sender, 'AFTabSetChange');
end;

procedure TAnalysisDlg.CatSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CatSetClick');
end;

procedure TAnalysisDlg.Curve17PaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TAnalysisDlg.Curve17PaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.Curve3DPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.CurvePaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.Cutoffleft1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cutoffleft1Click');
end;

procedure TAnalysisDlg.Cutoffright1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cutoffright1Click');
end;

procedure TAnalysisDlg.Cutofftop1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cutofftop1Click');
end;

procedure TAnalysisDlg.DiffTabChange(Sender: TObject);
begin
  DispatchAction(Sender, 'DiffTabChange');
end;

procedure TAnalysisDlg.DistrPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.DistrTabsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'DistrTabsChange');
end;

procedure TAnalysisDlg.FormActivate(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TAnalysisDlg.FormCreate(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormDestroy(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormMouseWheelDown(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormMouseWheelUp(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormResize(Sender: TObject);
begin
end;

procedure TAnalysisDlg.FormShow(Sender: TObject);
begin
end;

procedure TAnalysisDlg.GraphPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.GraphTabsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GraphTabsetClick');
end;

procedure TAnalysisDlg.Import1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Import1Click');
end;

procedure TAnalysisDlg.Inv3DCurves1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Inv3DCurves1Click');
end;

procedure TAnalysisDlg.InvDistributions1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvDistributions1Click');
end;

procedure TAnalysisDlg.InvUse1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvUse1Click');
end;

procedure TAnalysisDlg.Invapproximations1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Invapproximations1Click');
end;

procedure TAnalysisDlg.LapsesTabSetChange(Sender: TObject);
begin
  DispatchAction(Sender, 'LapsesTabSetChange');
end;

procedure TAnalysisDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TAnalysisDlg.MIExportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportClick');
end;

procedure TAnalysisDlg.MINextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextClick');
end;

procedure TAnalysisDlg.MINextSecondaryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextSecondaryClick');
end;

procedure TAnalysisDlg.MIPreviousClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousClick');
end;

procedure TAnalysisDlg.MIPreviousSecondaryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousSecondaryClick');
end;

procedure TAnalysisDlg.MatrixPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.MatrixTabSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MatrixTabSetClick');
end;

procedure TAnalysisDlg.NotebookClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NotebookClick');
end;

procedure TAnalysisDlg.OFDecayPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.OFDecayTabsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OFDecayTabsClick');
end;

procedure TAnalysisDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TAnalysisDlg.PaintBox3DPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.RecallPaintDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RecallPaintDblClick');
end;

procedure TAnalysisDlg.RecallPaintMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TAnalysisDlg.RepTabSetChange(Sender: TObject);
begin
  DispatchAction(Sender, 'RepTabSetChange');
end;

procedure TAnalysisDlg.RotateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RotateClick');
end;

procedure TAnalysisDlg.SDiffTabChange(Sender: TObject);
begin
  DispatchAction(Sender, 'SDiffTabChange');
end;

procedure TAnalysisDlg.SIncDecayPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.SIncDecayTabsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'SIncDecayTabsChange');
end;

procedure TAnalysisDlg.SmoothClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SmoothClick');
end;

procedure TAnalysisDlg.StabTabChange(Sender: TObject);
begin
  DispatchAction(Sender, 'StabTabChange');
end;

procedure TAnalysisDlg.StabilizationPaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.ThreeDTabSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ThreeDTabSetClick');
end;

procedure TAnalysisDlg.UsePaintBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TAnalysisDlg.UsePaintBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TAnalysisDlg.UsePaintBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TAnalysisDlg.UsePaintBoxPaint(Sender: TObject);
begin
end;

procedure TAnalysisDlg.UseSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UseSetClick');
end;

procedure TAnalysisDlg.ViewComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewComboChange');
end;

procedure TAnalysisDlg.ViewModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewModeClick');
end;

initialization
  if GetClass('TAnalysisDlg') = nil then
    RegisterClass(TAnalysisDlg);

end.
