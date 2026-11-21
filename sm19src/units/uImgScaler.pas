unit uImgScaler;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TImgScaler = class(TForm)
    CompressorImage: TImage;
    Scale: TLabel;
    Size: TLabel;
    ScaledImage: TImage;
    Quality: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ScaleBar: TTrackBar;
    QualityBar: TTrackBar;
    SizeBar: TTrackBar;
    Original: TButton;
    OK: TBitBtn;
    Cancel: TBitBtn;
    LeftBar: TTrackBar;
    RightBar: TTrackBar;
    TopBar: TTrackBar;
    BottomBar: TTrackBar;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure OriginalClick(Sender: TObject);
    procedure ScaleBarChange(Sender: TObject);
  end;

var
  ImgScaler: TImgScaler;

implementation

{$R *.lfm}

procedure TImgScaler.FormActivate(Sender: TObject);
begin
end;

procedure TImgScaler.FormCreate(Sender: TObject);
begin
end;

procedure TImgScaler.FormDeactivate(Sender: TObject);
begin
end;

procedure TImgScaler.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TImgScaler.OriginalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OriginalClick');
end;

procedure TImgScaler.ScaleBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ScaleBarChange');
end;

initialization
  if GetClass('TImgScaler') = nil then
    RegisterClass(TImgScaler);

end.
