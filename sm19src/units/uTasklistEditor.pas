unit uTasklistEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTasklistEditor = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    DefaultTimeLabel: TLabel;
    DefaultPriorityLabel: TLabel;
    DefaultValueLabel: TLabel;
    LinkCategory: TSpeedButton;
    TimeEdit: TEdit;
    PriorityEdit: TEdit;
    ValueEdit: TEdit;
    CategoryEdit: TMemo;
    PopupMenu1: TPopupMenu;
    MIQuit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure LinkCategoryClick(Sender: TObject);
    procedure MIQuitClick(Sender: TObject);
    procedure TimeEditExit(Sender: TObject);
    procedure ValueEditExit(Sender: TObject);
  end;

var
  TasklistEditor: TTasklistEditor;

implementation

{$R *.lfm}

procedure TTasklistEditor.FormCreate(Sender: TObject);
begin
end;

procedure TTasklistEditor.LinkCategoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LinkCategoryClick');
end;

procedure TTasklistEditor.MIQuitClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIQuitClick');
end;

procedure TTasklistEditor.TimeEditExit(Sender: TObject);
begin
end;

procedure TTasklistEditor.ValueEditExit(Sender: TObject);
begin
end;

initialization
  if GetClass('TTasklistEditor') = nil then
    RegisterClass(TTasklistEditor);

end.
