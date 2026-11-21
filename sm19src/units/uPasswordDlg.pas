unit uPasswordDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPasswordDlg = class(TForm)
    PasswordCommand: TLabel;
    PasswordEdit: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormShow(Sender: TObject);
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.lfm}

procedure TPasswordDlg.CancelBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelBtnClick');
end;

procedure TPasswordDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TPasswordDlg.FormShow(Sender: TObject);
begin
end;

initialization
  if GetClass('TPasswordDlg') = nil then
    RegisterClass(TPasswordDlg);

end.
