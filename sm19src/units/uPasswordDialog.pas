unit uPasswordDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPasswordDialog = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    GroupBox1: TGroupBox;
    Edit: TEdit;
    AddButton: TButton;
    RemoveButton: TButton;
    RemoveAllButton: TButton;
    procedure AddButtonClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RemoveAllButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
  end;

var
  PasswordDialog: TPasswordDialog;

implementation

{$R *.lfm}

procedure TPasswordDialog.AddButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddButtonClick');
end;

procedure TPasswordDialog.EditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'EditChange');
end;

procedure TPasswordDialog.OKButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKButtonClick');
end;

procedure TPasswordDialog.RemoveAllButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RemoveAllButtonClick');
end;

procedure TPasswordDialog.RemoveButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RemoveButtonClick');
end;

initialization
  if GetClass('TPasswordDialog') = nil then
    RegisterClass(TPasswordDialog);

end.
