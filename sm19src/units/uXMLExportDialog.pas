unit uXMLExportDialog;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TXMLExportDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    Button1: TButton;
    none: TEdit;
    Button2: TButton;
    RadioGroup2: TRadioGroup;
  end;

var
  XMLExportDialog: TXMLExportDialog;

implementation

{$R *.lfm}

initialization
  if GetClass('TXMLExportDialog') = nil then
    RegisterClass(TXMLExportDialog);

end.
