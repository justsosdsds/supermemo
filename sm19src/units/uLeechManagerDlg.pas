unit uLeechManagerDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TLeechManagerDlg = class(TForm)
    Label2: TLabel;
    ChooseInterval: TSpeedButton;
    LapsesPaintBox: TPaintBox;
    LapsesLabel: TLabel;
    IntervalPaintBox: TPaintBox;
    IntervalLabel: TLabel;
    EditBtn: TBitBtn;
    Forget: TBitBtn;
    Dismiss: TBitBtn;
    Delete: TBitBtn;
    Postpone: TBitBtn;
    Reschedule: TBitBtn;
    Continue: TBitBtn;
    ParamsBtn: TBitBtn;
    ShowAnswer: TBitBtn;
    Great: TBitBtn;
    Good: TBitBtn;
    Pass: TBitBtn;
    Fail: TBitBtn;
    Bad: TBitBtn;
    PostponeIntervalEdit: TEdit;
    HelpBtn: TBitBtn;
    SaveLayout: TBitBtn;
    AutoPostponeBox: TCheckBox;
    AutoForgetBox: TCheckBox;
    UseSemiLeechesBox: TCheckBox;
    procedure AutoForgetBoxClick(Sender: TObject);
    procedure AutoPostponeBoxClick(Sender: TObject);
    procedure BadClick(Sender: TObject);
    procedure ChooseIntervalClick(Sender: TObject);
    procedure ContinueClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure DismissClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure FailClick(Sender: TObject);
    procedure ForgetClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure GoodClick(Sender: TObject);
    procedure GreatClick(Sender: TObject);
    procedure LapsesPaintBoxPaint(Sender: TObject);
    procedure ParamsBtnClick(Sender: TObject);
    procedure PassClick(Sender: TObject);
    procedure PostponeClick(Sender: TObject);
    procedure RescheduleClick(Sender: TObject);
    procedure SaveLayoutClick(Sender: TObject);
    procedure ShowAnswerClick(Sender: TObject);
    procedure UseSemiLeechesBoxClick(Sender: TObject);
  end;

var
  LeechManagerDlg: TLeechManagerDlg;

implementation

{$R *.lfm}

procedure TLeechManagerDlg.AutoForgetBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AutoForgetBoxClick');
end;

procedure TLeechManagerDlg.AutoPostponeBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AutoPostponeBoxClick');
end;

procedure TLeechManagerDlg.BadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BadClick');
end;

procedure TLeechManagerDlg.ChooseIntervalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseIntervalClick');
end;

procedure TLeechManagerDlg.ContinueClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ContinueClick');
end;

procedure TLeechManagerDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TLeechManagerDlg.DismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DismissClick');
end;

procedure TLeechManagerDlg.EditBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EditBtnClick');
end;

procedure TLeechManagerDlg.FailClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FailClick');
end;

procedure TLeechManagerDlg.ForgetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ForgetClick');
end;

procedure TLeechManagerDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TLeechManagerDlg.FormCreate(Sender: TObject);
begin
end;

procedure TLeechManagerDlg.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TLeechManagerDlg.FormShow(Sender: TObject);
begin
end;

procedure TLeechManagerDlg.GoodClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoodClick');
end;

procedure TLeechManagerDlg.GreatClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GreatClick');
end;

procedure TLeechManagerDlg.LapsesPaintBoxPaint(Sender: TObject);
begin
end;

procedure TLeechManagerDlg.ParamsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ParamsBtnClick');
end;

procedure TLeechManagerDlg.PassClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PassClick');
end;

procedure TLeechManagerDlg.PostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PostponeClick');
end;

procedure TLeechManagerDlg.RescheduleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RescheduleClick');
end;

procedure TLeechManagerDlg.SaveLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveLayoutClick');
end;

procedure TLeechManagerDlg.ShowAnswerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ShowAnswerClick');
end;

procedure TLeechManagerDlg.UseSemiLeechesBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UseSemiLeechesBoxClick');
end;

initialization
  if GetClass('TLeechManagerDlg') = nil then
    RegisterClass(TLeechManagerDlg);

end.
