unit uMyFindDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TMyFindDlg = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Delete: TSpeedButton;
    Label4: TLabel;
    LastUsed: TSpeedButton;
    FindText: TEdit;
    FindNextBtn: TButton;
    MatchingWords: TCheckBox;
    MatchingCase: TCheckBox;
    Cancel: TButton;
    Details: TButton;
    MayFindList: TMemo;
    MustNotFindList: TMemo;
    SearchDefinitions: TComboBox;
    MustFindList: TMemo;
    Google: TBitBtn;
    Save: TBitBtn;
    PopupMenu1: TPopupMenu;
    MIRestoreLast: TMenuItem;
    MIChooseDefinition: TMenuItem;
    N1: TMenuItem;
    Edittext1: TMenuItem;
    EditANDtext1: TMenuItem;
    EditORtext1: TMenuItem;
    EditNOTtext1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    N3: TMenuItem;
    InvEitFindtext1: TMenuItem;
    InvChangeMatchcase1: TMenuItem;
    procedure CancelClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure DetailsClick(Sender: TObject);
    procedure EditANDtext1Click(Sender: TObject);
    procedure EditNOTtext1Click(Sender: TObject);
    procedure EditORtext1Click(Sender: TObject);
    procedure Edittext1Click(Sender: TObject);
    procedure FindNextBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoogleClick(Sender: TObject);
    procedure InvChangeMatchcase1Click(Sender: TObject);
    procedure InvEitFindtext1Click(Sender: TObject);
    procedure LastUsedClick(Sender: TObject);
    procedure MIChooseDefinitionClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SearchDefinitionsChange(Sender: TObject);
  end;

var
  MyFindDlg: TMyFindDlg;

implementation

{$R *.lfm}

procedure TMyFindDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TMyFindDlg.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TMyFindDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TMyFindDlg.DetailsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DetailsClick');
end;

procedure TMyFindDlg.EditANDtext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'EditANDtext1Click');
end;

procedure TMyFindDlg.EditNOTtext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'EditNOTtext1Click');
end;

procedure TMyFindDlg.EditORtext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'EditORtext1Click');
end;

procedure TMyFindDlg.Edittext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Edittext1Click');
end;

procedure TMyFindDlg.FindNextBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindNextBtnClick');
end;

procedure TMyFindDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TMyFindDlg.FormCreate(Sender: TObject);
begin
end;

procedure TMyFindDlg.FormShow(Sender: TObject);
begin
end;

procedure TMyFindDlg.GoogleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoogleClick');
end;

procedure TMyFindDlg.InvChangeMatchcase1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvChangeMatchcase1Click');
end;

procedure TMyFindDlg.InvEitFindtext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvEitFindtext1Click');
end;

procedure TMyFindDlg.LastUsedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LastUsedClick');
end;

procedure TMyFindDlg.MIChooseDefinitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChooseDefinitionClick');
end;

procedure TMyFindDlg.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

procedure TMyFindDlg.SearchDefinitionsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'SearchDefinitionsChange');
end;

initialization
  if GetClass('TMyFindDlg') = nil then
    RegisterClass(TMyFindDlg);

end.
