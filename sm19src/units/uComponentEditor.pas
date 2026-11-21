unit uComponentEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TComponentEditor = class(TForm)
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDragDrop(Sender, ASource: TObject; X, AY: Integer);
    procedure FormDragOver(Sender, ASource: TObject; X, AY: Integer; AState: TDragState; var AAccept: Boolean);
    procedure FormMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure FormMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure FormResize(Sender: TObject);
  end;

var
  ComponentEditor: TComponentEditor;

implementation

{$R *.lfm}

procedure TComponentEditor.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TComponentEditor.FormCreate(Sender: TObject);
begin
end;

procedure TComponentEditor.FormDragDrop(Sender, ASource: TObject; X, AY: Integer);
begin
end;

procedure TComponentEditor.FormDragOver(Sender, ASource: TObject; X, AY: Integer; AState: TDragState; var AAccept: Boolean);
begin
end;

procedure TComponentEditor.FormMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TComponentEditor.FormMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TComponentEditor.FormResize(Sender: TObject);
begin
end;

initialization
  if GetClass('TComponentEditor') = nil then
    RegisterClass(TComponentEditor);

end.
