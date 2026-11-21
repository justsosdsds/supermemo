unit uSleepGraph;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSleepGraph = class(TForm)
    PaintBox1: TPaintBox;
    BottomPaintBox: TPaintBox;
    PopupMenu1: TPopupMenu;
    Nextpage1: TMenuItem;
    Previouspage1: TMenuItem;
    MIClose: TMenuItem;
    procedure BottomPaintBoxPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure Nextpage1Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Previouspage1Click(Sender: TObject);
  end;

var
  SleepGraph: TSleepGraph;

implementation

{$R *.lfm}

procedure TSleepGraph.BottomPaintBoxPaint(Sender: TObject);
begin
end;

procedure TSleepGraph.FormResize(Sender: TObject);
begin
end;

procedure TSleepGraph.FormShow(Sender: TObject);
begin
end;

procedure TSleepGraph.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TSleepGraph.Nextpage1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Nextpage1Click');
end;

procedure TSleepGraph.PaintBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TSleepGraph.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TSleepGraph.Previouspage1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Previouspage1Click');
end;

initialization
  if GetClass('TSleepGraph') = nil then
    RegisterClass(TSleepGraph);

end.
