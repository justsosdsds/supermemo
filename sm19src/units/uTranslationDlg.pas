unit uTranslationDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTranslationDlg = class(TForm)
    TextMemo: TMemo;
    TranslationMemo: TMemo;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    Hide1: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Hide1Click(Sender: TObject);
    procedure TextMemoKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
  end;

var
  TranslationDlg: TTranslationDlg;

implementation

{$R *.lfm}

procedure TTranslationDlg.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TTranslationDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TTranslationDlg.FormCreate(Sender: TObject);
begin
end;

procedure TTranslationDlg.FormHide(Sender: TObject);
begin
end;

procedure TTranslationDlg.FormResize(Sender: TObject);
begin
end;

procedure TTranslationDlg.Hide1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Hide1Click');
end;

procedure TTranslationDlg.TextMemoKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'TextMemoKeyDown');
end;

initialization
  if GetClass('TTranslationDlg') = nil then
    RegisterClass(TTranslationDlg);

end.
