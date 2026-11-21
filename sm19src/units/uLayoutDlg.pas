unit uLayoutDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TLayoutDlg = class(TForm)
    DefaultLayout: TLabel;
    CurrentLayout: TLabel;
    ListBox1: TListBox;
    Delete: TBitBtn;
    Apply: TBitBtn;
    CloseBtn: TBitBtn;
    Save: TBitBtn;
    Default: TBitBtn;
    UseEsc: TCheckBox;
    procedure ApplyClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure DefaultClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure SaveClick(Sender: TObject);
  end;

var
  LayoutDlg: TLayoutDlg;

implementation

{$R *.lfm}

procedure TLayoutDlg.ApplyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ApplyClick');
end;

procedure TLayoutDlg.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TLayoutDlg.DefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultClick');
end;

procedure TLayoutDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TLayoutDlg.FormCreate(Sender: TObject);
begin
end;

procedure TLayoutDlg.FormShow(Sender: TObject);
begin
end;

procedure TLayoutDlg.ListBox1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1DblClick');
end;

procedure TLayoutDlg.ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ListBox1KeyDown');
end;

procedure TLayoutDlg.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

initialization
  if GetClass('TLayoutDlg') = nil then
    RegisterClass(TLayoutDlg);

end.
