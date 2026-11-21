unit uCommanderDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TCommanderDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    HintArea: TLabel;
    CommandLine: TEdit;
    OCommandLine: TEdit;
    CommandBox: TListBox;
    OCommandBox: TListBox;
    OK: TButton;
    Cancel: TButton;
    Rename: TButton;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    Execute1: TMenuItem;
    MIClose: TMenuItem;
    Up1: TMenuItem;
    Down1: TMenuItem;
    InvRight1: TMenuItem;
    InvLeft1: TMenuItem;
    InvTab1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure CommandBoxClick(Sender: TObject);
    procedure CommandLineChange(Sender: TObject);
    procedure Down1Click(Sender: TObject);
    procedure Execute1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InvLeft1Click(Sender: TObject);
    procedure InvRight1Click(Sender: TObject);
    procedure InvTab1Click(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure OCommandBoxClick(Sender: TObject);
    procedure OCommandLineChange(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure RenameClick(Sender: TObject);
    procedure Up1Click(Sender: TObject);
  end;

var
  CommanderDlg: TCommanderDlg;

implementation

{$R *.lfm}

procedure TCommanderDlg.Button1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button1Click');
end;

procedure TCommanderDlg.CommandBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CommandBoxClick');
end;

procedure TCommanderDlg.CommandLineChange(Sender: TObject);
begin
  DispatchAction(Sender, 'CommandLineChange');
end;

procedure TCommanderDlg.Down1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Down1Click');
end;

procedure TCommanderDlg.Execute1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Execute1Click');
end;

procedure TCommanderDlg.FormActivate(Sender: TObject);
begin
end;

procedure TCommanderDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TCommanderDlg.FormCreate(Sender: TObject);
begin
end;

procedure TCommanderDlg.FormDestroy(Sender: TObject);
begin
end;

procedure TCommanderDlg.FormShow(Sender: TObject);
begin
end;

procedure TCommanderDlg.InvLeft1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvLeft1Click');
end;

procedure TCommanderDlg.InvRight1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvRight1Click');
end;

procedure TCommanderDlg.InvTab1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvTab1Click');
end;

procedure TCommanderDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TCommanderDlg.OCommandBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OCommandBoxClick');
end;

procedure TCommanderDlg.OCommandLineChange(Sender: TObject);
begin
  DispatchAction(Sender, 'OCommandLineChange');
end;

procedure TCommanderDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TCommanderDlg.RenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RenameClick');
end;

procedure TCommanderDlg.Up1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Up1Click');
end;

initialization
  if GetClass('TCommanderDlg') = nil then
    RegisterClass(TCommanderDlg);

end.
