unit uWorkloadForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TWorkloadForm = class(TForm)
    PaintBox1: TPaintBox;
    ScrollBar1: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var AKey: Char);
    procedure FormMouseWheelDown(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
  end;

var
  WorkloadForm: TWorkloadForm;

implementation

{$R *.lfm}

procedure TWorkloadForm.FormCreate(Sender: TObject);
begin
end;

procedure TWorkloadForm.FormDestroy(Sender: TObject);
begin
end;

procedure TWorkloadForm.FormKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'FormKeyPress');
end;

procedure TWorkloadForm.FormMouseWheelDown(Sender: TObject);
begin
end;

procedure TWorkloadForm.FormMouseWheelUp(Sender: TObject);
begin
end;

procedure TWorkloadForm.PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWorkloadForm.PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWorkloadForm.PaintBox1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWorkloadForm.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TWorkloadForm.ScrollBar1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ScrollBar1Change');
end;

initialization
  if GetClass('TWorkloadForm') = nil then
    RegisterClass(TWorkloadForm);

end.
