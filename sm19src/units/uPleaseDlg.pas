unit uPleaseDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPleaseDlg = class(TForm)
    Bevel1: TBevel;
    PleaseLabel: TLabel;
    CreditDownTo: TLabel;
    RegisterBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure CancelBtnClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure RegisterBtnClick(Sender: TObject);
  end;

var
  PleaseDlg: TPleaseDlg;

implementation

{$R *.lfm}

procedure TPleaseDlg.CancelBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelBtnClick');
end;

procedure TPleaseDlg.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TPleaseDlg.FormShow(Sender: TObject);
begin
end;

procedure TPleaseDlg.HelpBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpBtnClick');
end;

procedure TPleaseDlg.RegisterBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RegisterBtnClick');
end;

initialization
  if GetClass('TPleaseDlg') = nil then
    RegisterClass(TPleaseDlg);

end.
