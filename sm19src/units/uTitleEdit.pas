unit uTitleEdit;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTitleEdit = class(TForm)
    TitleMemo: TMemo;
    ButtonPanel: TPanel;
    Save: TSpeedButton;
    CloseButton: TSpeedButton;
    RestoreTitle: TSpeedButton;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RestoreTitleClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure TitleMemoChange(Sender: TObject);
    procedure TitleMemoKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
  end;

var
  TitleEdit: TTitleEdit;

implementation

{$R *.lfm}

procedure TTitleEdit.CloseButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseButtonClick');
end;

procedure TTitleEdit.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TTitleEdit.FormCreate(Sender: TObject);
begin
end;

procedure TTitleEdit.RestoreTitleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RestoreTitleClick');
end;

procedure TTitleEdit.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

procedure TTitleEdit.TitleMemoChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TitleMemoChange');
end;

procedure TTitleEdit.TitleMemoKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'TitleMemoKeyDown');
end;

initialization
  if GetClass('TTitleEdit') = nil then
    RegisterClass(TTitleEdit);

end.
