unit uConceptMapForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TConceptMapForm = class(TForm)
    TheMap: TImage;
    ToolBar1: TToolBar;
    ViewBtn: TToolButton;
    ToolButton1: TToolButton;
    CaptionsBtn: TToolButton;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TheMapMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ViewBtnClick(Sender: TObject);
  end;

var
  ConceptMapForm: TConceptMapForm;

implementation

{$R *.lfm}

procedure TConceptMapForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TConceptMapForm.FormActivate(Sender: TObject);
begin
end;

procedure TConceptMapForm.FormShow(Sender: TObject);
begin
end;

procedure TConceptMapForm.TheMapMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TConceptMapForm.ViewBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewBtnClick');
end;

initialization
  if GetClass('TConceptMapForm') = nil then
    RegisterClass(TConceptMapForm);

end.
