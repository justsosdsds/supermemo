unit uElDataWind;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TElDataWind = class(TForm)
    SM17Stats: TCategoryButtons;
    PopupMenu1: TPopupMenu;
    MIDifficulty: TMenuItem;
    MIRestoreLayout: TMenuItem;
    MIBringUpTheElementWindow: TMenuItem;
    N1: TMenuItem;
    MIFormatIntervals: TMenuItem;
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure MIBringUpTheElementWindowClick(Sender: TObject);
    procedure MIDifficultyClick(Sender: TObject);
    procedure MIFormatIntervalsClick(Sender: TObject);
    procedure MIRestoreLayoutClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SM17StatsButtonClicked(Sender: TObject);
    procedure SM17StatsCategoryCollapase(Sender: TObject);
    procedure SM17StatsKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure SM17StatsMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
  end;

var
  ElDataWind: TElDataWind;

implementation

{$R *.lfm}

procedure TElDataWind.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TElDataWind.FormCreate(Sender: TObject);
begin
end;

procedure TElDataWind.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TElDataWind.FormResize(Sender: TObject);
begin
end;

procedure TElDataWind.MIBringUpTheElementWindowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBringUpTheElementWindowClick');
end;

procedure TElDataWind.MIDifficultyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDifficultyClick');
end;

procedure TElDataWind.MIFormatIntervalsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFormatIntervalsClick');
end;

procedure TElDataWind.MIRestoreLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRestoreLayoutClick');
end;

procedure TElDataWind.PopupMenu1Popup(Sender: TObject);
begin
  DispatchAction(Sender, 'PopupMenu1Popup');
end;

procedure TElDataWind.SM17StatsButtonClicked(Sender: TObject);
begin
end;

procedure TElDataWind.SM17StatsCategoryCollapase(Sender: TObject);
begin
end;

procedure TElDataWind.SM17StatsKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'SM17StatsKeyDown');
end;

procedure TElDataWind.SM17StatsMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

initialization
  if GetClass('TElDataWind') = nil then
    RegisterClass(TElDataWind);

end.
