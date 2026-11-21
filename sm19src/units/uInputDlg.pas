unit uInputDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TInputDlg = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    OK: TToolButton;
    Cancel: TToolButton;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure OKClick(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
  end;

var
  InputDlg: TInputDlg;

implementation

{$R *.lfm}

procedure TInputDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TInputDlg.FormActivate(Sender: TObject);
begin
end;

procedure TInputDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TInputDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TInputDlg.FormResize(Sender: TObject);
begin
end;

procedure TInputDlg.FormShow(Sender: TObject);
begin
end;

procedure TInputDlg.Memo1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'Memo1KeyDown');
end;

procedure TInputDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TInputDlg.SelectAll1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectAll1Click');
end;

initialization
  if GetClass('TInputDlg') = nil then
    RegisterClass(TInputDlg);

end.
