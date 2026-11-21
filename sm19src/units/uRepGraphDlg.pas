unit uRepGraphDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRepGraphDlg = class(TForm)
    PaintBox1: TPaintBox;
    CloseBtn: TButton;
    Resume: TButton;
    Stop: TButton;
    Start: TButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  end;

var
  RepGraphDlg: TRepGraphDlg;

implementation

{$R *.lfm}

procedure TRepGraphDlg.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TRepGraphDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TRepGraphDlg.FormCreate(Sender: TObject);
begin
end;

procedure TRepGraphDlg.PaintBox1Paint(Sender: TObject);
begin
end;

initialization
  if GetClass('TRepGraphDlg') = nil then
    RegisterClass(TRepGraphDlg);

end.
