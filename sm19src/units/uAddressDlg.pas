unit uAddressDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAddressDlg = class(TForm)
    Panel1: TPanel;
    ResellerLabel: TLabel;
    Label2: TLabel;
    Reseller: TMemo;
    Company: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
  end;

var
  AddressDlg: TAddressDlg;

implementation

{$R *.lfm}

procedure TAddressDlg.FormCreate(Sender: TObject);
begin
end;

procedure TAddressDlg.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

initialization
  if GetClass('TAddressDlg') = nil then
    RegisterClass(TAddressDlg);

end.
