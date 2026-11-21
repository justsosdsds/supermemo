unit uMemForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMemForm = class(TForm)
    PaintBox1: TPaintBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  end;

var
  MemForm: TMemForm;

implementation

{$R *.lfm}

procedure TMemForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TMemForm.FormShow(Sender: TObject);
begin
end;

procedure TMemForm.PaintBox1Paint(Sender: TObject);
begin
end;

initialization
  if GetClass('TMemForm') = nil then
    RegisterClass(TMemForm);

end.
