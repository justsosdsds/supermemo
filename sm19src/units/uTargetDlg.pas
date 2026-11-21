unit uTargetDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTargetDlg = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel1: TPanel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Add: TBitBtn;
    DelBtn: TBitBtn;
    SearchEdit: TEdit;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    MISearch: TMenuItem;
    Close1: TMenuItem;
    InvSearchO1: TMenuItem;
    procedure ChooseAnotherClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure DeleteTargetClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var AKey: Char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InvSearchO1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure MISearchClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure SearchEditEnter(Sender: TObject);
    procedure SearchEditKeyPress(Sender: TObject; var AKey: Char);
  end;

var
  TargetDlg: TTargetDlg;

implementation

{$R *.lfm}

procedure TTargetDlg.ChooseAnotherClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseAnotherClick');
end;

procedure TTargetDlg.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TTargetDlg.DeleteTargetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteTargetClick');
end;

procedure TTargetDlg.FormActivate(Sender: TObject);
begin
end;

procedure TTargetDlg.FormCreate(Sender: TObject);
begin
end;

procedure TTargetDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TTargetDlg.FormKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'FormKeyPress');
end;

procedure TTargetDlg.FormResize(Sender: TObject);
begin
end;

procedure TTargetDlg.FormShow(Sender: TObject);
begin
end;

procedure TTargetDlg.InvSearchO1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvSearchO1Click');
end;

procedure TTargetDlg.ListBox1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1Click');
end;

procedure TTargetDlg.ListBox1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1DblClick');
end;

procedure TTargetDlg.ListBox2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox2Click');
end;

procedure TTargetDlg.MISearchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchClick');
end;

procedure TTargetDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TTargetDlg.SearchEditEnter(Sender: TObject);
begin
end;

procedure TTargetDlg.SearchEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'SearchEditKeyPress');
end;

initialization
  if GetClass('TTargetDlg') = nil then
    RegisterClass(TTargetDlg);

end.
