unit uRepSortDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRepSortDlg = class(TForm)
    PaintBox1: TPaintBox;
    YLabel: TLabel;
    XLabel: TLabel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label4: TLabel;
    Label3: TLabel;
    ItemRandomizationL: TLabel;
    Label5: TLabel;
    TopicRandomizationL: TLabel;
    TopicsBar: TTrackBar;
    SortNow: TBitBtn;
    OK: TBitBtn;
    Cancel: TBitBtn;
    ItemRandomizationBar: TTrackBar;
    TopicRandomizationBar: TTrackBar;
    TabSet1: TTabSet;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ItemRandomizationBarChange(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SortNowClick(Sender: TObject);
    procedure TabSet1Change(Sender: TObject);
  end;

var
  RepSortDlg: TRepSortDlg;

implementation

{$R *.lfm}

procedure TRepSortDlg.FormResize(Sender: TObject);
begin
end;

procedure TRepSortDlg.FormShow(Sender: TObject);
begin
end;

procedure TRepSortDlg.ItemRandomizationBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ItemRandomizationBarChange');
end;

procedure TRepSortDlg.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TRepSortDlg.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TRepSortDlg.SortNowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SortNowClick');
end;

procedure TRepSortDlg.TabSet1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'TabSet1Change');
end;

initialization
  if GetClass('TRepSortDlg') = nil then
    RegisterClass(TRepSortDlg);

end.
