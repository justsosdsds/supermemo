unit uHTMLForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  THTMLForm = class(TForm)
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    FindTemplate: TSpeedButton;
    OK: TBitBtn;
    Cancel: TBitBtn;
    TheTitleEdit: TEdit;
    AuthorDataGroup: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AuthorEdit: TEdit;
    EMailEdit: TEdit;
    WebsiteEdit: TEdit;
    AddressEdit: TEdit;
    StatusRadioGroup: TRadioGroup;
    DownloadURLEdit: TEdit;
    InfoURLEdit: TEdit;
    PriceEdit: TEdit;
    UseTemplateBox: TCheckBox;
    TemplateFileEdit: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure FindTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure PriceEditClick(Sender: TObject);
  end;

var
  HTMLForm: THTMLForm;

implementation

{$R *.lfm}

procedure THTMLForm.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure THTMLForm.FindTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindTemplateClick');
end;

procedure THTMLForm.FormCreate(Sender: TObject);
begin
end;

procedure THTMLForm.FormShow(Sender: TObject);
begin
end;

procedure THTMLForm.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure THTMLForm.PriceEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PriceEditClick');
end;

initialization
  if GetClass('THTMLForm') = nil then
    RegisterClass(THTMLForm);

end.
