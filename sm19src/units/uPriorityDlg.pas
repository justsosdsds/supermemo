unit uPriorityDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPriorityDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Before: TLabel;
    After: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GoAfter: TSpeedButton;
    GoBefore: TSpeedButton;
    Label3: TLabel;
    IntervalBtn: TSpeedButton;
    GoThis: TSpeedButton;
    This: TLabel;
    PaintBox1: TPaintBox;
    OK: TBitBtn;
    Cancel: TBitBtn;
    TrackBar1: TTrackBar;
    PositionEdit: TEdit;
    PercentEdit: TEdit;
    FI: TEdit;
    AF: TEdit;
    Ordinal: TEdit;
    IntervalEdit: TEdit;
    PositUpDown: TUpDown;
    BitBtn1: TBitBtn;
    PopupMenu1: TPopupMenu;
    MIIncrease: TMenuItem;
    MIDecrease: TMenuItem;
    N1: TMenuItem;
    InvPercent1: TMenuItem;
    InvPosition1: TMenuItem;
    InvInterval1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoAfterClick(Sender: TObject);
    procedure GoBeforeClick(Sender: TObject);
    procedure GoThisClick(Sender: TObject);
    procedure IntervalBtnClick(Sender: TObject);
    procedure InvInterval1Click(Sender: TObject);
    procedure InvPercent1Click(Sender: TObject);
    procedure InvPosition1Click(Sender: TObject);
    procedure MIDecreaseClick(Sender: TObject);
    procedure MIIncreaseClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PercentEditChange(Sender: TObject);
    procedure PositUpDownMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PositionEditChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  end;

var
  PriorityDlg: TPriorityDlg;

implementation

{$R *.lfm}

procedure TPriorityDlg.FormCreate(Sender: TObject);
begin
end;

procedure TPriorityDlg.FormHide(Sender: TObject);
begin
end;

procedure TPriorityDlg.FormShow(Sender: TObject);
begin
end;

procedure TPriorityDlg.GoAfterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoAfterClick');
end;

procedure TPriorityDlg.GoBeforeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoBeforeClick');
end;

procedure TPriorityDlg.GoThisClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoThisClick');
end;

procedure TPriorityDlg.IntervalBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IntervalBtnClick');
end;

procedure TPriorityDlg.InvInterval1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvInterval1Click');
end;

procedure TPriorityDlg.InvPercent1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPercent1Click');
end;

procedure TPriorityDlg.InvPosition1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPosition1Click');
end;

procedure TPriorityDlg.MIDecreaseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDecreaseClick');
end;

procedure TPriorityDlg.MIIncreaseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIncreaseClick');
end;

procedure TPriorityDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TPriorityDlg.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TPriorityDlg.PercentEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'PercentEditChange');
end;

procedure TPriorityDlg.PositUpDownMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TPriorityDlg.PositionEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'PositionEditChange');
end;

procedure TPriorityDlg.TrackBar1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'TrackBar1Change');
end;

initialization
  if GetClass('TPriorityDlg') = nil then
    RegisterClass(TPriorityDlg);

end.
