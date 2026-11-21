unit uRotateForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRotateForm = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    CasesLabel: TLabel;
    DifficultyLabel: TLabel;
    ParamsPaint: TPaintBox;
    SliceLabel: TLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    DiffBar: TTrackBar;
    Smoothing: TButton;
    CasesBar: TTrackBar;
    ComputeBtn: TButton;
    Reset: TButton;
    ResetCases: TButton;
    Cancel: TButton;
    ExportBtn: TButton;
    Button1: TButton;
    AverageBox: TCheckBox;
    TheGraphs: TTabControl;
    TheMatrices: TTabControl;
    SliceBar: TTrackBar;
    PopupMenu1: TPopupMenu;
    MIParameteroptimization: TMenuItem;
    Close1: TMenuItem;
    procedure AverageBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure CasesBarChange(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ComputeBtnClick(Sender: TObject);
    procedure DiffBarChange(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MIParameteroptimizationClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ResetCasesClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure SmoothingClick(Sender: TObject);
    procedure TheGraphsChange(Sender: TObject);
    procedure TheMatricesChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar2KeyPress(Sender: TObject; var AKey: Char);
  end;

var
  RotateForm: TRotateForm;

implementation

{$R *.lfm}

procedure TRotateForm.AverageBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AverageBoxClick');
end;

procedure TRotateForm.Button1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button1Click');
end;

procedure TRotateForm.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TRotateForm.CasesBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'CasesBarChange');
end;

procedure TRotateForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TRotateForm.ComputeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ComputeBtnClick');
end;

procedure TRotateForm.DiffBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'DiffBarChange');
end;

procedure TRotateForm.ExportBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportBtnClick');
end;

procedure TRotateForm.FormCreate(Sender: TObject);
begin
end;

procedure TRotateForm.FormShow(Sender: TObject);
begin
end;

procedure TRotateForm.MIParameteroptimizationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIParameteroptimizationClick');
end;

procedure TRotateForm.PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRotateForm.PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRotateForm.PaintBox1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRotateForm.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TRotateForm.ResetCasesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetCasesClick');
end;

procedure TRotateForm.ResetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetClick');
end;

procedure TRotateForm.SmoothingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SmoothingClick');
end;

procedure TRotateForm.TheGraphsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TheGraphsChange');
end;

procedure TRotateForm.TheMatricesChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TheMatricesChange');
end;

procedure TRotateForm.TrackBar1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'TrackBar1Change');
end;

procedure TRotateForm.TrackBar1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'TrackBar1KeyDown');
end;

procedure TRotateForm.TrackBar2Change(Sender: TObject);
begin
  DispatchAction(Sender, 'TrackBar2Change');
end;

procedure TRotateForm.TrackBar2KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TrackBar2KeyPress');
end;

initialization
  if GetClass('TRotateForm') = nil then
    RegisterClass(TRotateForm);

end.
