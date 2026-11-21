unit uTileDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTileDlg = class(TForm)
    ComponentsL: TLabel;
    Label2: TLabel;
    Columns: TLabel;
    PaintBox1: TPaintBox;
    SquaresL: TLabel;
    RowsE: TEdit;
    ColsE: TEdit;
    OK: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    MIClose: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure ColsEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure RowsEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure RowsEKeyPress(Sender: TObject; var AKey: Char);
  end;

var
  TileDlg: TTileDlg;

implementation

{$R *.lfm}

procedure TTileDlg.Button2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button2Click');
end;

procedure TTileDlg.ColsEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ColsEKeyDown');
end;

procedure TTileDlg.FormActivate(Sender: TObject);
begin
end;

procedure TTileDlg.FormCreate(Sender: TObject);
begin
end;

procedure TTileDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TTileDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TTileDlg.RowsEKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'RowsEKeyDown');
end;

procedure TTileDlg.RowsEKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'RowsEKeyPress');
end;

initialization
  if GetClass('TTileDlg') = nil then
    RegisterClass(TTileDlg);

end.
