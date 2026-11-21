unit uSpellDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TSpellDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ErrorEdit: TEdit;
    lbSuggestions: TListBox;
    ReplaceEdit: TEdit;
    Ignore: TBitBtn;
    Change: TBitBtn;
    Cancel: TBitBtn;
    procedure ChangeClick(Sender: TObject);
    procedure IgnoreClick(Sender: TObject);
    procedure lbSuggestionsClick(Sender: TObject);
  end;

var
  SpellDlg: TSpellDlg;

implementation

{$R *.lfm}

procedure TSpellDlg.ChangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangeClick');
end;

procedure TSpellDlg.IgnoreClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IgnoreClick');
end;

procedure TSpellDlg.lbSuggestionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'lbSuggestionsClick');
end;

initialization
  if GetClass('TSpellDlg') = nil then
    RegisterClass(TSpellDlg);

end.
