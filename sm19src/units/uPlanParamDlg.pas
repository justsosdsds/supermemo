unit uPlanParamDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPlanParamDlg = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Save: TSpeedButton;
    LengthEdit: TEdit;
    MarginEdit: TEdit;
    RadioGroup1: TRadioGroup;
    OK: TBitBtn;
    Cancel: TBitBtn;
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
  end;

var
  PlanParamDlg: TPlanParamDlg;

implementation

{$R *.lfm}

procedure TPlanParamDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TPlanParamDlg.FormActivate(Sender: TObject);
begin
end;

procedure TPlanParamDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TPlanParamDlg.FormCreate(Sender: TObject);
begin
end;

procedure TPlanParamDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TPlanParamDlg.FormResize(Sender: TObject);
begin
end;

procedure TPlanParamDlg.FormShow(Sender: TObject);
begin
end;

procedure TPlanParamDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TPlanParamDlg.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

procedure TPlanParamDlg.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

initialization
  if GetClass('TPlanParamDlg') = nil then
    RegisterClass(TPlanParamDlg);

end.
