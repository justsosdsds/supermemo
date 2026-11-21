unit uSimDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSimDlg = class(TForm)
    PaintBox1: TPaintBox;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label3: TLabel;
    FILabel: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    DateLabel: TLabel;
    Label13: TLabel;
    AvgRepetitions: TLabel;
    Label15: TLabel;
    AvgNewRepetitions: TLabel;
    Label17: TLabel;
    AvgTime: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Memory: TLabel;
    Label14: TLabel;
    DayLabel: TLabel;
    HundredPercent: TLabel;
    LastDate: TLabel;
    ChartType: TLabel;
    Label6: TLabel;
    MemorizedItems: TLabel;
    FIBar: TTrackBar;
    RepsPerDayEdit: TEdit;
    GroupBox1: TGroupBox;
    OnlyRepeat: TRadioButton;
    LearnNew: TRadioButton;
    Start: TButton;
    Stop: TButton;
    Close_Ctl: TButton;
    Resume: TButton;
    OriginalFI: TCheckBox;
    UpdateTimer: TTimer;
    procedure FIBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LearnNewClick(Sender: TObject);
    procedure OnlyRepeatClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ResumeClick(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  end;

var
  SimDlg: TSimDlg;

implementation

{$R *.lfm}

procedure TSimDlg.FIBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FIBarChange');
end;

procedure TSimDlg.FormCreate(Sender: TObject);
begin
end;

procedure TSimDlg.FormDestroy(Sender: TObject);
begin
end;

procedure TSimDlg.LearnNewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LearnNewClick');
end;

procedure TSimDlg.OnlyRepeatClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OnlyRepeatClick');
end;

procedure TSimDlg.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TSimDlg.ResumeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResumeClick');
end;

procedure TSimDlg.StartClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StartClick');
end;

procedure TSimDlg.StopClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StopClick');
end;

procedure TSimDlg.UpdateTimerTimer(Sender: TObject);
begin
end;

initialization
  if GetClass('TSimDlg') = nil then
    RegisterClass(TSimDlg);

end.
