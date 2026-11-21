unit uQODDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TQODDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Question: TMemo;
    Answer: TMemo;
    Remember: TButton;
    NextQuestion: TButton;
    DeleteBtn: TButton;
    CloseBtn: TButton;
    ShowTipsBox: TCheckBox;
    procedure CloseBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure NextQuestionClick(Sender: TObject);
    procedure RememberClick(Sender: TObject);
    procedure ShowTipsBoxClick(Sender: TObject);
  end;

var
  QODDlg: TQODDlg;

implementation

{$R *.lfm}

procedure TQODDlg.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TQODDlg.DeleteBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteBtnClick');
end;

procedure TQODDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TQODDlg.FormCreate(Sender: TObject);
begin
end;

procedure TQODDlg.NextQuestionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NextQuestionClick');
end;

procedure TQODDlg.RememberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RememberClick');
end;

procedure TQODDlg.ShowTipsBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ShowTipsBoxClick');
end;

initialization
  if GetClass('TQODDlg') = nil then
    RegisterClass(TQODDlg);

end.
