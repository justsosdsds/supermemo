unit uProgressBox;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TProgressBox = class(TForm)
    Passed_: TLabel;
    ToDo_: TLabel;
    Total_: TLabel;
    Passed: TLabel;
    ToDo: TLabel;
    Total: TLabel;
    PaintBox1: TPaintBox;
    MemoryLabel: TLabel;
    Memory: TLabel;
    CountLabel: TLabel;
    CountValue: TLabel;
    Panel2: TPanel;
    TimePassed_: TLabel;
    TimeLeft_: TLabel;
    TimePassed: TLabel;
    TimeLeft: TLabel;
    TimeExpected_: TLabel;
    TimeExpected: TLabel;
    Cancel: TBitBtn;
    ReportLabel: TPanel;
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  end;

var
  ProgressBox: TProgressBox;

implementation

{$R *.lfm}

procedure TProgressBox.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TProgressBox.FormActivate(Sender: TObject);
begin
end;

procedure TProgressBox.FormCreate(Sender: TObject);
begin
end;

procedure TProgressBox.FormDestroy(Sender: TObject);
begin
end;

procedure TProgressBox.FormShow(Sender: TObject);
begin
end;

procedure TProgressBox.PaintBox1Paint(Sender: TObject);
begin
end;

initialization
  if GetClass('TProgressBox') = nil then
    RegisterClass(TProgressBox);

end.
