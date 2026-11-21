unit uAddTranscription;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAddTranscription = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Word: TEdit;
    Transcription: TEdit;
    OK: TBitBtn;
    Cancel: TBitBtn;
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKClick(Sender: TObject);
  end;

var
  AddTranscription: TAddTranscription;

implementation

{$R *.lfm}

procedure TAddTranscription.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TAddTranscription.FormCreate(Sender: TObject);
begin
end;

procedure TAddTranscription.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

initialization
  if GetClass('TAddTranscription') = nil then
    RegisterClass(TAddTranscription);

end.
