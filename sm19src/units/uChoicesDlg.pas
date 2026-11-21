unit uChoicesDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TChoicesDlg = class(TForm)
    MessageLabel: TLabel;
    RadioGroup1: TRadioGroup;
    Cancel: TBitBtn;
    OK: TBitBtn;
    CopyBtn: TBitBtn;
    procedure CancelClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
  end;

var
  ChoicesDlg: TChoicesDlg;

implementation

{$R *.lfm}

procedure TChoicesDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TChoicesDlg.CopyBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CopyBtnClick');
end;

procedure TChoicesDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TChoicesDlg.FormCreate(Sender: TObject);
begin
end;

procedure TChoicesDlg.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TChoicesDlg.FormShow(Sender: TObject);
begin
end;

procedure TChoicesDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TChoicesDlg') = nil then
    RegisterClass(TChoicesDlg);

end.
