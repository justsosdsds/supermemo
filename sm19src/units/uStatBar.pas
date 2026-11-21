unit uStatBar;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TStatBar = class(TForm)
    StatusPanel: TPanel;
    OutstandingBar: TPaintBox;
    MemorizedLabel: TPanel;
    OutstandingLabel: TPanel;
    Hinter: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure HinterDblClick(Sender: TObject);
    procedure OutstandingBarPaint(Sender: TObject);
  end;

var
  StatBar: TStatBar;

implementation

{$R *.lfm}

procedure TStatBar.FormCreate(Sender: TObject);
begin
end;

procedure TStatBar.HinterDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HinterDblClick');
end;

procedure TStatBar.OutstandingBarPaint(Sender: TObject);
begin
end;

initialization
  if GetClass('TStatBar') = nil then
    RegisterClass(TStatBar);

end.
