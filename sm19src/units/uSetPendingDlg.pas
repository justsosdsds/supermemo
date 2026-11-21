unit uSetPendingDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSetPendingDlg = class(TForm)
    Bevel1: TBevel;
    PendingSizeLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    OK: TBitBtn;
    PlacementEdit: TEdit;
    PositionEdit: TEdit;
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlacementEditChange(Sender: TObject);
    procedure PositionEditChange(Sender: TObject);
  end;

var
  SetPendingDlg: TSetPendingDlg;

implementation

{$R *.lfm}

procedure TSetPendingDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TSetPendingDlg.FormCreate(Sender: TObject);
begin
end;

procedure TSetPendingDlg.FormShow(Sender: TObject);
begin
end;

procedure TSetPendingDlg.PlacementEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'PlacementEditChange');
end;

procedure TSetPendingDlg.PositionEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'PositionEditChange');
end;

initialization
  if GetClass('TSetPendingDlg') = nil then
    RegisterClass(TSetPendingDlg);

end.
