unit uMercyForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMercyForm = class(TForm)
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GatherLabel: TLabel;
    Label5: TLabel;
    OutstandingLabel: TLabel;
    Affected: TLabel;
    TodayDate: TLabel;
    ReschedDate: TLabel;
    GatherDate: TLabel;
    Items: TEdit;
    Resched: TEdit;
    Gather: TEdit;
    FutureCheckBox: TCheckBox;
    Panel1: TPanel;
    Memo1: TMemo;
    OK: TBitBtn;
    BitBtn2: TBitBtn;
    UpdateButton: TBitBtn;
    BitBtn4: TBitBtn;
    CriteriaBtn: TButton;
    procedure CriteriaBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FutureCheckBoxClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure ItemsEnter(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
  end;

var
  MercyForm: TMercyForm;

implementation

{$R *.lfm}

procedure TMercyForm.CriteriaBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CriteriaBtnClick');
end;

procedure TMercyForm.FormCreate(Sender: TObject);
begin
end;

procedure TMercyForm.FutureCheckBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FutureCheckBoxClick');
end;

procedure TMercyForm.ItemsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ItemsChange');
end;

procedure TMercyForm.ItemsEnter(Sender: TObject);
begin
end;

procedure TMercyForm.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TMercyForm.UpdateButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UpdateButtonClick');
end;

initialization
  if GetClass('TMercyForm') = nil then
    RegisterClass(TMercyForm);

end.
