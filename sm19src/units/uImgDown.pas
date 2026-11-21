unit uImgDown;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TImgDown = class(TForm)
    Splitter1: TSplitter;
    ListBox1: TCheckListBox;
    Panel1: TPanel;
    InsertBtn: TButton;
    LocalizeBtn: TButton;
    SelectAll: TButton;
    OKBtn: TButton;
    DeleteBtn: TButton;
    ViewBtn: TButton;
    Panel2: TPanel;
    Image1: TImage;
    DataPanel: TPanel;
    LabelX: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NameLabel: TLabel;
    Size: TLabel;
    URLLabel: TLabel;
    NewName: TEdit;
    PopupMenu1: TPopupMenu;
    MIEditName: TMenuItem;
    MIDelete: TMenuItem;
    MISelectAll: TMenuItem;
    N1: TMenuItem;
    MIClose: TMenuItem;
    MIRename: TMenuItem;
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1ClickCheck(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var AKey: Char);
    procedure LocalizeBtnClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIEditNameClick(Sender: TObject);
    procedure MIRenameClick(Sender: TObject);
    procedure NewNameExit(Sender: TObject);
    procedure NewNameKeyPress(Sender: TObject; var AKey: Char);
    procedure OKBtnClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
  end;

var
  ImgDown: TImgDown;

implementation

{$R *.lfm}

procedure TImgDown.DeleteBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteBtnClick');
end;

procedure TImgDown.FormActivate(Sender: TObject);
begin
end;

procedure TImgDown.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TImgDown.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TImgDown.FormCreate(Sender: TObject);
begin
end;

procedure TImgDown.FormDestroy(Sender: TObject);
begin
end;

procedure TImgDown.FormResize(Sender: TObject);
begin
end;

procedure TImgDown.FormShow(Sender: TObject);
begin
end;

procedure TImgDown.InsertBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InsertBtnClick');
end;

procedure TImgDown.ListBox1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1Click');
end;

procedure TImgDown.ListBox1ClickCheck(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1ClickCheck');
end;

procedure TImgDown.ListBox1KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'ListBox1KeyPress');
end;

procedure TImgDown.LocalizeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LocalizeBtnClick');
end;

procedure TImgDown.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TImgDown.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TImgDown.MIEditNameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditNameClick');
end;

procedure TImgDown.MIRenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenameClick');
end;

procedure TImgDown.NewNameExit(Sender: TObject);
begin
end;

procedure TImgDown.NewNameKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'NewNameKeyPress');
end;

procedure TImgDown.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TImgDown.SelectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectAllClick');
end;

procedure TImgDown.ViewBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewBtnClick');
end;

initialization
  if GetClass('TImgDown') = nil then
    RegisterClass(TImgDown);

end.
