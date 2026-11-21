unit uStylesheetEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TStylesheetEditor = class(TForm)
    MemberName: TLabel;
    StyleFilename: TLabel;
    ComboBox1: TComboBox;
    QuestionFontButton: TBitBtn;
    Color_Ctl: TBitBtn;
    Sample: TMemo;
    CloseBtn: TBitBtn;
    FontColor: TBitBtn;
    View: TBitBtn;
    Edit: TBitBtn;
    OK: TBitBtn;
    Default: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    procedure CloseBtnClick(Sender: TObject);
    procedure ColorClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DefaultClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure FontColorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure QuestionFontButtonClick(Sender: TObject);
    procedure ViewClick(Sender: TObject);
  end;

var
  StylesheetEditor: TStylesheetEditor;

implementation

{$R *.lfm}

procedure TStylesheetEditor.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TStylesheetEditor.ColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ColorClick');
end;

procedure TStylesheetEditor.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure TStylesheetEditor.DefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultClick');
end;

procedure TStylesheetEditor.EditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EditClick');
end;

procedure TStylesheetEditor.FontColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontColorClick');
end;

procedure TStylesheetEditor.FormCreate(Sender: TObject);
begin
end;

procedure TStylesheetEditor.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TStylesheetEditor.FormShow(Sender: TObject);
begin
end;

procedure TStylesheetEditor.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TStylesheetEditor.QuestionFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'QuestionFontButtonClick');
end;

procedure TStylesheetEditor.ViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewClick');
end;

initialization
  if GetClass('TStylesheetEditor') = nil then
    RegisterClass(TStylesheetEditor);

end.
