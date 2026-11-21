unit uURLOpenDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TURLOpenDlg = class(TForm)
    ListBox1: TCheckListBox;
    Panel1: TPanel;
    OpenURLs: TButton;
    Cancel: TButton;
    SelectAll: TButton;
    CloseSelected: TButton;
    procedure CancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenURLsClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
  end;

var
  URLOpenDlg: TURLOpenDlg;

implementation

{$R *.lfm}

procedure TURLOpenDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TURLOpenDlg.FormActivate(Sender: TObject);
begin
end;

procedure TURLOpenDlg.FormCreate(Sender: TObject);
begin
end;

procedure TURLOpenDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TURLOpenDlg.FormShow(Sender: TObject);
begin
end;

procedure TURLOpenDlg.OpenURLsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OpenURLsClick');
end;

procedure TURLOpenDlg.SelectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectAllClick');
end;

initialization
  if GetClass('TURLOpenDlg') = nil then
    RegisterClass(TURLOpenDlg);

end.
