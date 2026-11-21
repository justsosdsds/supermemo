unit uOrderEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TOrderEditor = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    procedure CancelKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
  end;

var
  OrderEditor: TOrderEditor;

implementation

{$R *.lfm}

procedure TOrderEditor.CancelKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'CancelKeyDown');
end;

procedure TOrderEditor.FormActivate(Sender: TObject);
begin
end;

procedure TOrderEditor.FormCreate(Sender: TObject);
begin
end;

procedure TOrderEditor.FormDeactivate(Sender: TObject);
begin
end;

procedure TOrderEditor.FormResize(Sender: TObject);
begin
end;

procedure TOrderEditor.FormShow(Sender: TObject);
begin
end;

procedure TOrderEditor.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TOrderEditor.StringGrid1RowMoved(Sender: TObject; FromIndex, AToIndex: Integer);
begin
  DispatchAction(Sender, 'StringGrid1RowMoved');
end;

initialization
  if GetClass('TOrderEditor') = nil then
    RegisterClass(TOrderEditor);

end.
