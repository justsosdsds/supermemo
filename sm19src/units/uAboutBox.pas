unit uAboutBox;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TAboutBox = class(TForm)
    BackgroundPanel: TPanel;
    Panel1: TPanel;
    AboutPic: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ContributionsButton: TSpeedButton;
    BottomPanel: TPanel;
    Date: TLabel;
    Version: TLabel;
    ChangePictureLabel: TLabel;
    Reseller: TLabel;
    SpeedButton1: TSpeedButton;
    ImageList1: TImageList;
    procedure ChangePictureLabelClick(Sender: TObject);
    procedure ContributionsButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ResellerClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.lfm}

procedure TAboutBox.ChangePictureLabelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChangePictureLabelClick');
end;

procedure TAboutBox.ContributionsButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ContributionsButtonClick');
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
end;

procedure TAboutBox.FormDestroy(Sender: TObject);
begin
end;

procedure TAboutBox.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
end;

procedure TAboutBox.ResellerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResellerClick');
end;

procedure TAboutBox.SpeedButton1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SpeedButton1Click');
end;

initialization
  if GetClass('TAboutBox') = nil then
    RegisterClass(TAboutBox);

end.
