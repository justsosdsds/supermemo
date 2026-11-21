unit uConceptSelectBox;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TConceptSelectBox = class(TForm)
    PaintBox1: TPaintBox;
    Edit1: TEdit;
    ToolBar1: TToolBar;
    ViewBtn: TToolButton;
    ReviewConceptGroupBtn: TToolButton;
    TransferBtn: TToolButton;
    LinkConcept: TToolButton;
    AnchorBtn: TToolButton;
    HookBtn: TToolButton;
    CloseBtn: TToolButton;
    procedure AnchorBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var AKey: Char);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure HookBtnClick(Sender: TObject);
    procedure LinkConceptClick(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ReviewConceptGroupBtnClick(Sender: TObject);
    procedure TransferBtnClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
  end;

var
  ConceptSelectBox: TConceptSelectBox;

implementation

{$R *.lfm}

procedure TConceptSelectBox.AnchorBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AnchorBtnClick');
end;

procedure TConceptSelectBox.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TConceptSelectBox.Edit1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'Edit1Change');
end;

procedure TConceptSelectBox.Edit1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'Edit1KeyDown');
end;

procedure TConceptSelectBox.Edit1KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'Edit1KeyPress');
end;

procedure TConceptSelectBox.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TConceptSelectBox.FormCreate(Sender: TObject);
begin
end;

procedure TConceptSelectBox.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TConceptSelectBox.FormShow(Sender: TObject);
begin
end;

procedure TConceptSelectBox.HookBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HookBtnClick');
end;

procedure TConceptSelectBox.LinkConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LinkConceptClick');
end;

procedure TConceptSelectBox.PaintBox1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PaintBox1DblClick');
end;

procedure TConceptSelectBox.PaintBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TConceptSelectBox.ReviewConceptGroupBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReviewConceptGroupBtnClick');
end;

procedure TConceptSelectBox.TransferBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TransferBtnClick');
end;

procedure TConceptSelectBox.ViewBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewBtnClick');
end;

initialization
  if GetClass('TConceptSelectBox') = nil then
    RegisterClass(TConceptSelectBox);

end.
