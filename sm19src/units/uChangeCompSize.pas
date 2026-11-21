unit uChangeCompSize;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TChangeCompSize = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ComboBox1: TComboBox;
    XEdit: TEdit;
    YEdit: TEdit;
    WEdit: TEdit;
    HEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  end;

var
  ChangeCompSize: TChangeCompSize;

implementation

{$R *.lfm}

procedure TChangeCompSize.FormCreate(Sender: TObject);
begin
end;

procedure TChangeCompSize.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

initialization
  if GetClass('TChangeCompSize') = nil then
    RegisterClass(TChangeCompSize);

end.
