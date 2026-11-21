unit uRecoveryDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRecoveryDialog = class(TForm)
    Label1: TLabel;
    LastRecoveryL: TLabel;
    Bevel1: TBevel;
    VerifyRepHistButton: TCheckBox;
    RebuildTranslationButton: TCheckBox;
    RebuildLexiconButton: TCheckBox;
    CheckFilespaceButton: TCheckBox;
    VerifyTasklistsButton: TCheckBox;
    RecoverRegistriesButton: TCheckBox;
    BasicRecoveryButton: TCheckBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    CheckAll: TBitBtn;
    Backup: TCheckBox;
    Garbage: TCheckBox;
    PopupMenu1: TPopupMenu;
    MIDetailed: TMenuItem;
    InvDetailed1: TMenuItem;
    procedure BasicRecoveryButtonClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InvDetailed1Click(Sender: TObject);
    procedure MIDetailedClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure RecoverRegistriesButtonClick(Sender: TObject);
  end;

var
  RecoveryDialog: TRecoveryDialog;

implementation

{$R *.lfm}

procedure TRecoveryDialog.BasicRecoveryButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BasicRecoveryButtonClick');
end;

procedure TRecoveryDialog.CheckAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CheckAllClick');
end;

procedure TRecoveryDialog.FormShow(Sender: TObject);
begin
end;

procedure TRecoveryDialog.InvDetailed1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvDetailed1Click');
end;

procedure TRecoveryDialog.MIDetailedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDetailedClick');
end;

procedure TRecoveryDialog.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TRecoveryDialog.RecoverRegistriesButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RecoverRegistriesButtonClick');
end;

initialization
  if GetClass('TRecoveryDialog') = nil then
    RegisterClass(TRecoveryDialog);

end.
