unit uLoginDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TLoginDialog = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    Panel: TPanel;
    Label3: TLabel;
    DatabaseName: TLabel;
    Bevel: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    UserName: TEdit;
    Password: TEdit;
    procedure FormShow(Sender: TObject);
  end;

var
  LoginDialog: TLoginDialog;

implementation

{$R *.lfm}

procedure TLoginDialog.FormShow(Sender: TObject);
begin
end;

initialization
  if GetClass('TLoginDialog') = nil then
    RegisterClass(TLoginDialog);

end.
