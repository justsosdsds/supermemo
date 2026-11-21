unit uRegistrationForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRegistrationForm = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    UserIDLabel: TLabel;
    Label6: TLabel;
    SendBtn: TButton;
    Button3: TButton;
    OrderIDEdit: TEdit;
    NameEdit: TEdit;
    CountryEdit: TEdit;
    Button2: TButton;
    ContactMemo: TMemo;
    CommentMemo: TMemo;
    FileEdit: TButton;
    PasswordBtn: TButton;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FileEditClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure PasswordBtnClick(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
  end;

var
  RegistrationForm: TRegistrationForm;

implementation

{$R *.lfm}

procedure TRegistrationForm.Button2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button2Click');
end;

procedure TRegistrationForm.Button3Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button3Click');
end;

procedure TRegistrationForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TRegistrationForm.FileEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FileEditClick');
end;

procedure TRegistrationForm.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TRegistrationForm.FormShow(Sender: TObject);
begin
end;

procedure TRegistrationForm.PasswordBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PasswordBtnClick');
end;

procedure TRegistrationForm.SendBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SendBtnClick');
end;

initialization
  if GetClass('TRegistrationForm') = nil then
    RegisterClass(TRegistrationForm);

end.
