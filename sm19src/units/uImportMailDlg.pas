unit uImportMailDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TImportMailDlg = class(TForm)
    From: TLabel;
    To_: TLabel;
    Sent: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Subject: TLabel;
    FromLabel: TLabel;
    Label2: TLabel;
    SortSenders: TSpeedButton;
    SortSubjects: TSpeedButton;
    Label1: TLabel;
    Preview: TMemo;
    PickInbox: TButton;
    ImportFolder: TEdit;
    ArchiveFolder: TEdit;
    PickArchive: TButton;
    Subjects: TListBox;
    BitBtn1: TBitBtn;
    Senders: TListBox;
    Panel1: TPanel;
    ImportAll: TButton;
    Delete: TButton;
    ToArchive: TButton;
    Import: TButton;
    ViewMail: TButton;
    Reply: TButton;
    Move: TButton;
    CategoryCombo: TComboBox;
    PopupMenu1: TPopupMenu;
    MIClose: TMenuItem;
    MISwitch: TMenuItem;
    procedure CategoryComboChange(Sender: TObject);
    procedure CategoryComboClick(Sender: TObject);
    procedure CategoryComboDropDown(Sender: TObject);
    procedure CategoryComboKeyPress(Sender: TObject; var AKey: Char);
    procedure DeleteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImportAllClick(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure ListBoxEnter(Sender: TObject);
    procedure ListBoxExit(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MISwitchClick(Sender: TObject);
    procedure MoveClick(Sender: TObject);
    procedure PickArchiveClick(Sender: TObject);
    procedure PickInboxClick(Sender: TObject);
    procedure ReplyClick(Sender: TObject);
    procedure SendersDblClick(Sender: TObject);
    procedure SortSendersClick(Sender: TObject);
    procedure SortSubjectsClick(Sender: TObject);
    procedure ToArchiveClick(Sender: TObject);
    procedure ViewMailClick(Sender: TObject);
  end;

var
  ImportMailDlg: TImportMailDlg;

implementation

{$R *.lfm}

procedure TImportMailDlg.CategoryComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'CategoryComboChange');
end;

procedure TImportMailDlg.CategoryComboClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CategoryComboClick');
end;

procedure TImportMailDlg.CategoryComboDropDown(Sender: TObject);
begin
  DispatchAction(Sender, 'CategoryComboDropDown');
end;

procedure TImportMailDlg.CategoryComboKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'CategoryComboKeyPress');
end;

procedure TImportMailDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TImportMailDlg.FormActivate(Sender: TObject);
begin
end;

procedure TImportMailDlg.FormCreate(Sender: TObject);
begin
end;

procedure TImportMailDlg.FormDestroy(Sender: TObject);
begin
end;

procedure TImportMailDlg.FormResize(Sender: TObject);
begin
end;

procedure TImportMailDlg.FormShow(Sender: TObject);
begin
end;

procedure TImportMailDlg.ImportAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportAllClick');
end;

procedure TImportMailDlg.ImportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportClick');
end;

procedure TImportMailDlg.ListBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBoxClick');
end;

procedure TImportMailDlg.ListBoxEnter(Sender: TObject);
begin
end;

procedure TImportMailDlg.ListBoxExit(Sender: TObject);
begin
end;

procedure TImportMailDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TImportMailDlg.MISwitchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwitchClick');
end;

procedure TImportMailDlg.MoveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MoveClick');
end;

procedure TImportMailDlg.PickArchiveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PickArchiveClick');
end;

procedure TImportMailDlg.PickInboxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PickInboxClick');
end;

procedure TImportMailDlg.ReplyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReplyClick');
end;

procedure TImportMailDlg.SendersDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SendersDblClick');
end;

procedure TImportMailDlg.SortSendersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SortSendersClick');
end;

procedure TImportMailDlg.SortSubjectsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SortSubjectsClick');
end;

procedure TImportMailDlg.ToArchiveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ToArchiveClick');
end;

procedure TImportMailDlg.ViewMailClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewMailClick');
end;

initialization
  if GetClass('TImportMailDlg') = nil then
    RegisterClass(TImportMailDlg);

end.
