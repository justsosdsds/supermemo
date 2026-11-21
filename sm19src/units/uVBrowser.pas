unit uVBrowser;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TVBrowser = class(TForm)
    Image1: TImage;
    Image2: TImage;
    PopupMenu1: TPopupMenu;
    MIclose: TMenuItem;
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure MIcloseClick(Sender: TObject);
  end;

var
  VBrowser: TVBrowser;

implementation

{$R *.lfm}

procedure TVBrowser.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TVBrowser.MIcloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIcloseClick');
end;

initialization
  if GetClass('TVBrowser') = nil then
    RegisterClass(TVBrowser);

end.
