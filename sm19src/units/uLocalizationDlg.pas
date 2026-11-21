unit uLocalizationDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TLocalizationDlg = class(TForm)
    Panel1: TPanel;
    FontButton: TSpeedButton;
    FontName: TLabel;
    Cancel: TBitBtn;
    OK: TBitBtn;
    Import: TButton;
    Export: TButton;
    Delete: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    FontDialog1: TFontDialog;
    procedure CancelClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ExportClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure StringGrid1TopLeftChanged(Sender: TObject);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure StringGrid2TopLeftChanged(Sender: TObject);
  end;

var
  LocalizationDlg: TLocalizationDlg;

implementation

{$R *.lfm}

procedure TLocalizationDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TLocalizationDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TLocalizationDlg.ExportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportClick');
end;

procedure TLocalizationDlg.FontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontButtonClick');
end;

procedure TLocalizationDlg.FormActivate(Sender: TObject);
begin
end;

procedure TLocalizationDlg.FormCreate(Sender: TObject);
begin
end;

procedure TLocalizationDlg.FormResize(Sender: TObject);
begin
end;

procedure TLocalizationDlg.ImportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportClick');
end;

procedure TLocalizationDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TLocalizationDlg.StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid1SelectCell');
end;

procedure TLocalizationDlg.StringGrid1TopLeftChanged(Sender: TObject);
begin
end;

procedure TLocalizationDlg.StringGrid2SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid2SelectCell');
end;

procedure TLocalizationDlg.StringGrid2TopLeftChanged(Sender: TObject);
begin
end;

initialization
  if GetClass('TLocalizationDlg') = nil then
    RegisterClass(TLocalizationDlg);

end.
