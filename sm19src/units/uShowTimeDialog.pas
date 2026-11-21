unit uShowTimeDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TShowTimeDialog = class(TForm)
    Bevel1: TBevel;
    AtEditing: TCheckBox;
    AtDragging: TCheckBox;
    AtBrowsing: TCheckBox;
    QuestionBox: TCheckBox;
    AnswerBox: TCheckBox;
    PostGradeBox: TCheckBox;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Clear: TBitBtn;
    procedure ClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
  end;

var
  ShowTimeDialog: TShowTimeDialog;

implementation

{$R *.lfm}

procedure TShowTimeDialog.ClearClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearClick');
end;

procedure TShowTimeDialog.FormCreate(Sender: TObject);
begin
end;

procedure TShowTimeDialog.FormShow(Sender: TObject);
begin
end;

procedure TShowTimeDialog.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TShowTimeDialog') = nil then
    RegisterClass(TShowTimeDialog);

end.
