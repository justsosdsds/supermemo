unit uChecksDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TChecksDlg = class(TForm)
    MessageLabel: TLabel;
    Cancel: TBitBtn;
    OK: TBitBtn;
    CheckListBox1: TCheckListBox;
    PopupMenu1: TPopupMenu;
    MISelectAll: TMenuItem;
    InvSelectAll1: TMenuItem;
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure InvSelectAll1Click(Sender: TObject);
    procedure MISelectAllClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  end;

var
  ChecksDlg: TChecksDlg;

implementation

{$R *.lfm}

procedure TChecksDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TChecksDlg.FormCreate(Sender: TObject);
begin
end;

procedure TChecksDlg.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TChecksDlg.FormShow(Sender: TObject);
begin
end;

procedure TChecksDlg.InvSelectAll1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvSelectAll1Click');
end;

procedure TChecksDlg.MISelectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectAllClick');
end;

procedure TChecksDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TChecksDlg') = nil then
    RegisterClass(TChecksDlg);

end.
