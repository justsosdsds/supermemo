unit uBack;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TBack = class(TForm)
    Image1: TImage;
  end;

var
  Back: TBack;

implementation

{$R *.lfm}

initialization
  if GetClass('TBack') = nil then
    RegisterClass(TBack);

end.
