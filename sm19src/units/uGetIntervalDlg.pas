unit uGetIntervalDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TGetIntervalDlg = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    IntervalEdit: TEdit;
    OK: TBitBtn;
    CancelBtn: TBitBtn;
    DateEdit: TEdit;
    Panel1: TPanel;
    Calendar: TMonthCalendar;
    procedure CalendarClick(Sender: TObject);
    procedure DateEditKeyPress(Sender: TObject; var AKey: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IntervalEditKeyPress(Sender: TObject; var AKey: Char);
    procedure OKClick(Sender: TObject);
  end;

var
  GetIntervalDlg: TGetIntervalDlg;

implementation

{$R *.lfm}

procedure TGetIntervalDlg.CalendarClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CalendarClick');
end;

procedure TGetIntervalDlg.DateEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'DateEditKeyPress');
end;

procedure TGetIntervalDlg.FormCreate(Sender: TObject);
begin
end;

procedure TGetIntervalDlg.FormResize(Sender: TObject);
begin
end;

procedure TGetIntervalDlg.FormShow(Sender: TObject);
begin
end;

procedure TGetIntervalDlg.IntervalEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'IntervalEditKeyPress');
end;

procedure TGetIntervalDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TGetIntervalDlg') = nil then
    RegisterClass(TGetIntervalDlg);

end.
