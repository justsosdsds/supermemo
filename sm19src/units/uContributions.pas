unit uContributions;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TContributions = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Cancel: TBitBtn;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  end;

var
  Contributions: TContributions;

implementation

{$R *.lfm}

procedure TContributions.FormCreate(Sender: TObject);
begin
end;

procedure TContributions.Label2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Label2Click');
end;

initialization
  if GetClass('TContributions') = nil then
    RegisterClass(TContributions);

end.
