unit uAncestors;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAncestors = class(TForm)
    ListBox1: TCheckListBox;
    PopupMenu1: TPopupMenu;
    ViewElement1: TMenuItem;
    Viewbranch1: TMenuItem;
    N1: TMenuItem;
    MILearn: TMenuItem;
    MIPostpone: TMenuItem;
    N2: TMenuItem;
    MIReturn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure MIPostponeClick(Sender: TObject);
    procedure MIReturnClick(Sender: TObject);
    procedure Viewbranch1Click(Sender: TObject);
  end;

var
  Ancestors: TAncestors;

implementation

{$R *.lfm}

procedure TAncestors.FormCreate(Sender: TObject);
begin
end;

procedure TAncestors.FormShow(Sender: TObject);
begin
end;

procedure TAncestors.ListBox1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1Click');
end;

procedure TAncestors.ListBox1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1DblClick');
end;

procedure TAncestors.ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ListBox1KeyDown');
end;

procedure TAncestors.MIPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeClick');
end;

procedure TAncestors.MIReturnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReturnClick');
end;

procedure TAncestors.Viewbranch1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Viewbranch1Click');
end;

initialization
  if GetClass('TAncestors') = nil then
    RegisterClass(TAncestors);

end.
