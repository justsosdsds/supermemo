unit uHitEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  THitEditor = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Panel1: TPanel;
    ColorPanel: TPanel;
    Color_Ctl: TButton;
    Clone: TButton;
    Copy: TButton;
    Paste: TButton;
    Clear: TButton;
    Close_: TButton;
    ComboBox1: TComboBox;
    Help: TButton;
    Memo1: TMemo;
    ColorDialog1: TColorDialog;
    procedure ClearClick(Sender: TObject);
    procedure CloneClick(Sender: TObject);
    procedure Close_Click(Sender: TObject);
    procedure ColorClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PasteClick(Sender: TObject);
  end;

var
  HitEditor: THitEditor;

implementation

{$R *.lfm}

procedure THitEditor.ClearClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearClick');
end;

procedure THitEditor.CloneClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloneClick');
end;

procedure THitEditor.Close_Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close_Click');
end;

procedure THitEditor.ColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ColorClick');
end;

procedure THitEditor.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure THitEditor.CopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CopyClick');
end;

procedure THitEditor.FormCreate(Sender: TObject);
begin
end;

procedure THitEditor.FormShow(Sender: TObject);
begin
end;

procedure THitEditor.Image1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure THitEditor.PasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PasteClick');
end;

initialization
  if GetClass('THitEditor') = nil then
    RegisterClass(THitEditor);

end.
