unit uMyReplaceDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMyReplaceDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    FindEdit: TEdit;
    ReplaceEdit: TEdit;
    FindBtn: TBitBtn;
    ReplaceBtn: TBitBtn;
    ReplaceAllBtn: TBitBtn;
    Cancel: TBitBtn;
    PopupMenu1: TPopupMenu;
    MIEscape: TMenuItem;
    procedure CancelClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MIEscapeClick(Sender: TObject);
    procedure ReplaceAllBtnClick(Sender: TObject);
    procedure ReplaceBtnClick(Sender: TObject);
  end;

var
  MyReplaceDlg: TMyReplaceDlg;

implementation

{$R *.lfm}

procedure TMyReplaceDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TMyReplaceDlg.FindBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindBtnClick');
end;

procedure TMyReplaceDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TMyReplaceDlg.FormCreate(Sender: TObject);
begin
end;

procedure TMyReplaceDlg.FormShow(Sender: TObject);
begin
end;

procedure TMyReplaceDlg.MIEscapeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEscapeClick');
end;

procedure TMyReplaceDlg.ReplaceAllBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReplaceAllBtnClick');
end;

procedure TMyReplaceDlg.ReplaceBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReplaceBtnClick');
end;

initialization
  if GetClass('TMyReplaceDlg') = nil then
    RegisterClass(TMyReplaceDlg);

end.
