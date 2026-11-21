unit uElementFilter;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TElementFilter = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    SaveFilterBtn: TSpeedButton;
    DeleteFilterBtn: TSpeedButton;
    SetMinLastRep: TSpeedButton;
    SetMinNextRep: TSpeedButton;
    SetMaxLastRep: TSpeedButton;
    SetMaxNextRep: TSpeedButton;
    RepBox: TCheckBox;
    LapBox: TCheckBox;
    IntBox: TCheckBox;
    LastRepBox: TCheckBox;
    NextRepBox: TCheckBox;
    AFBox: TCheckBox;
    FIBox: TCheckBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RepMinE: TEdit;
    RepMaxE: TEdit;
    LapMinE: TEdit;
    LapMaxE: TEdit;
    IntMinE: TEdit;
    IntMaxE: TEdit;
    LastRepMinE: TEdit;
    NextRepMinE: TEdit;
    AFMinE: TEdit;
    FIMinE: TEdit;
    LastRepMaxE: TEdit;
    NextRepMaxE: TEdit;
    AFMaxE: TEdit;
    FIMaxE: TEdit;
    OrdBox: TCheckBox;
    OrdMinE: TEdit;
    OrdMaxE: TEdit;
    ItemBox: TCheckBox;
    TopicBox: TCheckBox;
    MemorizedBox: TCheckBox;
    PendingBox: TCheckBox;
    DismissedBox: TCheckBox;
    OK: TButton;
    Cancel: TButton;
    TaskBox: TCheckBox;
    Help: TBitBtn;
    UFBox: TCheckBox;
    PostBox: TCheckBox;
    FilterCombo: TComboBox;
    UFMinE: TEdit;
    UFMaxE: TEdit;
    PostMinE: TEdit;
    PostMaxE: TEdit;
    PriorityBox: TCheckBox;
    PriorityMinE: TEdit;
    PriorityMaxE: TEdit;
    procedure AFBoxClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure DeleteFilterBtnClick(Sender: TObject);
    procedure FIBoxClick(Sender: TObject);
    procedure FilterComboChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IntBoxClick(Sender: TObject);
    procedure LapBoxClick(Sender: TObject);
    procedure LastRepBoxClick(Sender: TObject);
    procedure NextRepBoxClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure OrdBoxClick(Sender: TObject);
    procedure PostBoxClick(Sender: TObject);
    procedure PriorityBoxClick(Sender: TObject);
    procedure RepBoxClick(Sender: TObject);
    procedure SaveFilterBtnClick(Sender: TObject);
    procedure SetMaxLastRepClick(Sender: TObject);
    procedure SetMaxNextRepClick(Sender: TObject);
    procedure SetMinLastRepClick(Sender: TObject);
    procedure SetMinNextRepClick(Sender: TObject);
    procedure UFBoxClick(Sender: TObject);
  end;

var
  ElementFilter: TElementFilter;

implementation

{$R *.lfm}

procedure TElementFilter.AFBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AFBoxClick');
end;

procedure TElementFilter.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TElementFilter.DeleteFilterBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteFilterBtnClick');
end;

procedure TElementFilter.FIBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FIBoxClick');
end;

procedure TElementFilter.FilterComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FilterComboChange');
end;

procedure TElementFilter.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TElementFilter.FormCreate(Sender: TObject);
begin
end;

procedure TElementFilter.FormShow(Sender: TObject);
begin
end;

procedure TElementFilter.IntBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IntBoxClick');
end;

procedure TElementFilter.LapBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LapBoxClick');
end;

procedure TElementFilter.LastRepBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LastRepBoxClick');
end;

procedure TElementFilter.NextRepBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NextRepBoxClick');
end;

procedure TElementFilter.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TElementFilter.OrdBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OrdBoxClick');
end;

procedure TElementFilter.PostBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PostBoxClick');
end;

procedure TElementFilter.PriorityBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PriorityBoxClick');
end;

procedure TElementFilter.RepBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RepBoxClick');
end;

procedure TElementFilter.SaveFilterBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveFilterBtnClick');
end;

procedure TElementFilter.SetMaxLastRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetMaxLastRepClick');
end;

procedure TElementFilter.SetMaxNextRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetMaxNextRepClick');
end;

procedure TElementFilter.SetMinLastRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetMinLastRepClick');
end;

procedure TElementFilter.SetMinNextRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetMinNextRepClick');
end;

procedure TElementFilter.UFBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UFBoxClick');
end;

initialization
  if GetClass('TElementFilter') = nil then
    RegisterClass(TElementFilter);

end.
