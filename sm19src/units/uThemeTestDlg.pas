unit uThemeTestDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TThemeTestDlg = class(TForm)
    Label1: TLabel;
    OKBtn: TButton;
    StringGrid1: TStringGrid;
    RadioGroup1: TRadioGroup;
    Memo1: TMemo;
    ThemeBox: TComboBox;
    CancelBtn: TButton;
    PopupMenu1: TPopupMenu;
    MIClose: TMenuItem;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ThemeBoxChange(Sender: TObject);
    procedure ThemeBoxKeyPress(Sender: TObject; var AKey: Char);
  end;

var
  ThemeTestDlg: TThemeTestDlg;

implementation

{$R *.lfm}

procedure TThemeTestDlg.CancelBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelBtnClick');
end;

procedure TThemeTestDlg.FormCreate(Sender: TObject);
begin
end;

procedure TThemeTestDlg.FormShow(Sender: TObject);
begin
end;

procedure TThemeTestDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TThemeTestDlg.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TThemeTestDlg.ThemeBoxChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ThemeBoxChange');
end;

procedure TThemeTestDlg.ThemeBoxKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'ThemeBoxKeyPress');
end;

initialization
  if GetClass('TThemeTestDlg') = nil then
    RegisterClass(TThemeTestDlg);

end.
