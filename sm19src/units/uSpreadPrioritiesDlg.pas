unit uSpreadPrioritiesDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSpreadPrioritiesDlg = class(TForm)
    Bevel4: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    ChangeLabel: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    MinLabel: TLabel;
    MaxLabel: TLabel;
    StepLabel: TLabel;
    RadioGroup1: TRadioGroup;
    ChangeBar: TTrackBar;
    OK: TBitBtn;
    BitBtn2: TBitBtn;
    ChangeEdit: TEdit;
    MinPercentEdit: TEdit;
    MaxPercentEdit: TEdit;
    MinPositEdit: TEdit;
    MaxPositEdit: TEdit;
    Limits: TCheckBox;
    Adjust: TCheckBox;
    StepEdit: TEdit;
    BitBtn1: TBitBtn;
    procedure ChangeBarChange(Sender: TObject);
    procedure ChangeEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LimitsClick(Sender: TObject);
    procedure MaxPercentEditChange(Sender: TObject);
    procedure MaxPositEditChange(Sender: TObject);
    procedure MinPercentEditChange(Sender: TObject);
    procedure MinPositEditChange(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure StepEditChange(Sender: TObject);
  end;

var
  SpreadPrioritiesDlg: TSpreadPrioritiesDlg;

implementation

{$R *.lfm}

procedure TSpreadPrioritiesDlg.ChangeBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangeBarChange');
end;

procedure TSpreadPrioritiesDlg.ChangeEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangeEditChange');
end;

procedure TSpreadPrioritiesDlg.FormShow(Sender: TObject);
begin
end;

procedure TSpreadPrioritiesDlg.LimitsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LimitsClick');
end;

procedure TSpreadPrioritiesDlg.MaxPercentEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'MaxPercentEditChange');
end;

procedure TSpreadPrioritiesDlg.MaxPositEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'MaxPositEditChange');
end;

procedure TSpreadPrioritiesDlg.MinPercentEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'MinPercentEditChange');
end;

procedure TSpreadPrioritiesDlg.MinPositEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'MinPositEditChange');
end;

procedure TSpreadPrioritiesDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TSpreadPrioritiesDlg.RadioGroup1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'RadioGroup1Click');
end;

procedure TSpreadPrioritiesDlg.StepEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'StepEditChange');
end;

initialization
  if GetClass('TSpreadPrioritiesDlg') = nil then
    RegisterClass(TSpreadPrioritiesDlg);

end.
