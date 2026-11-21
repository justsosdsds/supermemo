unit uMercyOptions;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMercyOptions = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ImportanceP: TLabel;
    LatenessP: TLabel;
    InvestmentP: TLabel;
    EasinessP: TLabel;
    RecencyP: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Default: TBitBtn;
    Importance: TTrackBar;
    Lateness: TTrackBar;
    Investment: TTrackBar;
    Easiness: TTrackBar;
    Recency: TTrackBar;
    ModeCheckBox: TRadioGroup;
    procedure DefaultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImportanceChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  end;

var
  MercyOptions: TMercyOptions;

implementation

{$R *.lfm}

procedure TMercyOptions.DefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultClick');
end;

procedure TMercyOptions.FormCreate(Sender: TObject);
begin
end;

procedure TMercyOptions.FormShow(Sender: TObject);
begin
end;

procedure TMercyOptions.ImportanceChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportanceChange');
end;

procedure TMercyOptions.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

initialization
  if GetClass('TMercyOptions') = nil then
    RegisterClass(TMercyOptions);

end.
