unit uRepSimDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRepSimDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BestStabilityL: TLabel;
    Label4: TLabel;
    MinimumRepsL: TLabel;
    Label6: TLabel;
    SamplesL: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    MIClose: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
  end;

var
  RepSimDlg: TRepSimDlg;

implementation

{$R *.lfm}

procedure TRepSimDlg.Button1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button1Click');
end;

procedure TRepSimDlg.Button2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button2Click');
end;

procedure TRepSimDlg.Button3Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button3Click');
end;

procedure TRepSimDlg.FormCreate(Sender: TObject);
begin
end;

procedure TRepSimDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

initialization
  if GetClass('TRepSimDlg') = nil then
    RegisterClass(TRepSimDlg);

end.
