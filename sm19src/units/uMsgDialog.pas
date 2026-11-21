unit uMsgDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMsgDialog = class(TForm)
    Bevel1: TBevel;
    MsgLabel: TLabel;
    ToolBar1: TToolBar;
    Ok: TToolButton;
    Yes: TToolButton;
    No: TToolButton;
    All: TToolButton;
    Copy: TToolButton;
    Search: TToolButton;
    Help: TToolButton;
    Info: TToolButton;
    Report: TToolButton;
    EMailBtn: TToolButton;
    Cancel: TToolButton;
    procedure AllClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure EMailBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure InfoClick(Sender: TObject);
    procedure MsgLabelMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure NoClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure ReportClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure YesClick(Sender: TObject);
  end;

var
  MsgDialog: TMsgDialog;

implementation

{$R *.lfm}

procedure TMsgDialog.AllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AllClick');
end;

procedure TMsgDialog.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TMsgDialog.CopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CopyClick');
end;

procedure TMsgDialog.EMailBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EMailBtnClick');
end;

procedure TMsgDialog.FormActivate(Sender: TObject);
begin
end;

procedure TMsgDialog.FormCreate(Sender: TObject);
begin
end;

procedure TMsgDialog.FormDeactivate(Sender: TObject);
begin
end;

procedure TMsgDialog.FormHide(Sender: TObject);
begin
end;

procedure TMsgDialog.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TMsgDialog.FormShow(Sender: TObject);
begin
end;

procedure TMsgDialog.HelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpClick');
end;

procedure TMsgDialog.InfoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InfoClick');
end;

procedure TMsgDialog.MsgLabelMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TMsgDialog.NoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NoClick');
end;

procedure TMsgDialog.OkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OkClick');
end;

procedure TMsgDialog.ReportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReportClick');
end;

procedure TMsgDialog.SearchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SearchClick');
end;

procedure TMsgDialog.YesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'YesClick');
end;

initialization
  if GetClass('TMsgDialog') = nil then
    RegisterClass(TMsgDialog);

end.
