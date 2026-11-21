unit uAlignDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAlignDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    HNoChange: TRadioButton;
    LeftSides: TRadioButton;
    HCenters: TRadioButton;
    RightSides: TRadioButton;
    HSpace: TRadioButton;
    HCenter: TRadioButton;
    GroupBox2: TGroupBox;
    VNoChange: TRadioButton;
    Tops: TRadioButton;
    VCenters: TRadioButton;
    Bottoms: TRadioButton;
    VSpace: TRadioButton;
    VCenter: TRadioButton;
    OK: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox3: TGroupBox;
    HShrink: TRadioButton;
    HGrow: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox4: TGroupBox;
    VShrink: TRadioButton;
    VGrow: TRadioButton;
    RadioButton6: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure OKClick(Sender: TObject);
  end;

var
  AlignDlg: TAlignDlg;

implementation

{$R *.lfm}

procedure TAlignDlg.FormCreate(Sender: TObject);
begin
end;

procedure TAlignDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TAlignDlg') = nil then
    RegisterClass(TAlignDlg);

end.
