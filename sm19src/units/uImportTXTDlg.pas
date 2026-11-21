unit uImportTXTDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TImportTXTDlg = class(TForm)
    Bevel1: TBevel;
    QAChoiceGroup: TRadioGroup;
    OKBtn: TButton;
    CancelBtn: TButton;
    MCTChoiceGroup: TRadioGroup;
    ChangeFile: TBitBtn;
    Edit1: TEdit;
    DecodeUTFBox: TCheckBox;
    procedure ChangeFileClick(Sender: TObject);
    procedure DecodeUTFBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MCTChoiceGroupClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure QAChoiceGroupClick(Sender: TObject);
  end;

var
  ImportTXTDlg: TImportTXTDlg;

implementation

{$R *.lfm}

procedure TImportTXTDlg.ChangeFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangeFileClick');
end;

procedure TImportTXTDlg.DecodeUTFBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DecodeUTFBoxClick');
end;

procedure TImportTXTDlg.FormCreate(Sender: TObject);
begin
end;

procedure TImportTXTDlg.MCTChoiceGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MCTChoiceGroupClick');
end;

procedure TImportTXTDlg.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TImportTXTDlg.QAChoiceGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'QAChoiceGroupClick');
end;

initialization
  if GetClass('TImportTXTDlg') = nil then
    RegisterClass(TImportTXTDlg);

end.
