unit uFAQDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TFAQDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    ChooseFAQFile: TSpeedButton;
    Label5: TLabel;
    Label8: TLabel;
    ChooseFAQFolder: TSpeedButton;
    WYSIWYG: TSpeedButton;
    Question: TMemo;
    Answer: TMemo;
    OK: TButton;
    Cancel: TButton;
    NameL: TEdit;
    SenderNameL: TEdit;
    SubjectL: TEdit;
    AddrCombo: TComboBox;
    FAQL: TStaticText;
    FAQFile: TEdit;
    HTMLFAQBox: TCheckBox;
    WikiFAQBox: TCheckBox;
    FAQFiles: TComboBox;
    FAQFolderE: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure ChooseFAQFileClick(Sender: TObject);
    procedure ChooseFAQFolderClick(Sender: TObject);
    procedure FAQFilesChange(Sender: TObject);
    procedure FAQFolderEChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HTMLFAQBoxClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure WYSIWYGClick(Sender: TObject);
    procedure WikiFAQBoxClick(Sender: TObject);
  end;

var
  FAQDlg: TFAQDlg;

implementation

{$R *.lfm}

procedure TFAQDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TFAQDlg.ChooseFAQFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseFAQFileClick');
end;

procedure TFAQDlg.ChooseFAQFolderClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseFAQFolderClick');
end;

procedure TFAQDlg.FAQFilesChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FAQFilesChange');
end;

procedure TFAQDlg.FAQFolderEChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FAQFolderEChange');
end;

procedure TFAQDlg.FormActivate(Sender: TObject);
begin
end;

procedure TFAQDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TFAQDlg.FormCreate(Sender: TObject);
begin
end;

procedure TFAQDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TFAQDlg.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TFAQDlg.FormResize(Sender: TObject);
begin
end;

procedure TFAQDlg.FormShow(Sender: TObject);
begin
end;

procedure TFAQDlg.HTMLFAQBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HTMLFAQBoxClick');
end;

procedure TFAQDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TFAQDlg.WYSIWYGClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WYSIWYGClick');
end;

procedure TFAQDlg.WikiFAQBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WikiFAQBoxClick');
end;

initialization
  if GetClass('TFAQDlg') = nil then
    RegisterClass(TFAQDlg);

end.
