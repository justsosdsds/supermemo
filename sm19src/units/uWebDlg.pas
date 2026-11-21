unit uWebDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TWebDlg = class(TForm)
    Panel1: TPanel;
    ConceptGroupLabel: TLabel;
    MaxPriorityButton: TSpeedButton;
    Label2: TLabel;
    MinPriorityButton: TSpeedButton;
    Label1: TLabel;
    ImportMode: TRadioGroup;
    Filter: TRadioGroup;
    IELocation: TRadioGroup;
    ConceptEdit: TEdit;
    MaxPriorEdit: TEdit;
    MinPriorEdit: TEdit;
    PanelTop: TPanel;
    TitleLabel: TLabel;
    TitleEdit: TEdit;
    PageControl1: TPageControl;
    ArticleListTab: TTabSheet;
    ListBox1: TCheckListBox;
    PicturesTab: TTabSheet;
    MaxPicsLabel: TLabel;
    MinSizeLabel: TLabel;
    ImageLocation: TRadioGroup;
    MinSizeEdit: TEdit;
    MaxPicsEdit: TEdit;
    ToolBar1: TToolBar;
    ImportPages: TToolButton;
    CheckAll: TToolButton;
    SiftBtn: TToolButton;
    BrowseDuplicates: TToolButton;
    View: TToolButton;
    HelpBtn: TToolButton;
    CloseBox: TCheckBox;
    CreateConceptBox: TCheckBox;
    PopupMenu1: TPopupMenu;
    MIScan: TMenuItem;
    MIUncheckSelected: TMenuItem;
    MISwap: TMenuItem;
    N3: TMenuItem;
    Checkall1: TMenuItem;
    MICheckDuplicates: TMenuItem;
    MICheckSelected: TMenuItem;
    N2: TMenuItem;
    MICloseDuplicates: TMenuItem;
    MICloseChecked: TMenuItem;
    MICloseUnselected: TMenuItem;
    MICloseCurrent: TMenuItem;
    CloseAll1: TMenuItem;
    N4: TMenuItem;
    MIBrowseDuplicates: TMenuItem;
    N5: TMenuItem;
    InvChangeTab1: TMenuItem;
    N1: TMenuItem;
    MIClose: TMenuItem;
    procedure BrowseDuplicatesClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure Checkall1Click(Sender: TObject);
    procedure CloseAll1Click(Sender: TObject);
    procedure ConceptEditClick(Sender: TObject);
    procedure ConceptEditEnter(Sender: TObject);
    procedure CreateConceptBoxClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure IELocationClick(Sender: TObject);
    procedure ImageLocationClick(Sender: TObject);
    procedure ImportModeClick(Sender: TObject);
    procedure ImportPagesClick(Sender: TObject);
    procedure InvChangeTab1Click(Sender: TObject);
    procedure ListBox1ClickCheck(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure ListBox1KeyPress(Sender: TObject; var AKey: Char);
    procedure ListBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ListBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure MIBrowseDuplicatesClick(Sender: TObject);
    procedure MICheckDuplicatesClick(Sender: TObject);
    procedure MICheckSelectedClick(Sender: TObject);
    procedure MICloseCheckedClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MICloseCurrentClick(Sender: TObject);
    procedure MICloseDuplicatesClick(Sender: TObject);
    procedure MICloseUnselectedClick(Sender: TObject);
    procedure MISwapClick(Sender: TObject);
    procedure MIUncheckDuplicates(Sender: TObject);
    procedure MIUncheckSelectedClick(Sender: TObject);
    procedure MaxPriorityButtonClick(Sender: TObject);
    procedure MinPriorityButtonClick(Sender: TObject);
    procedure SiftBtnClick(Sender: TObject);
    procedure ViewClick(Sender: TObject);
  end;

var
  WebDlg: TWebDlg;

implementation

{$R *.lfm}

procedure TWebDlg.BrowseDuplicatesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BrowseDuplicatesClick');
end;

procedure TWebDlg.CheckAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CheckAllClick');
end;

procedure TWebDlg.Checkall1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Checkall1Click');
end;

procedure TWebDlg.CloseAll1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseAll1Click');
end;

procedure TWebDlg.ConceptEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ConceptEditClick');
end;

procedure TWebDlg.ConceptEditEnter(Sender: TObject);
begin
end;

procedure TWebDlg.CreateConceptBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CreateConceptBoxClick');
end;

procedure TWebDlg.FilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FilterClick');
end;

procedure TWebDlg.FormActivate(Sender: TObject);
begin
end;

procedure TWebDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TWebDlg.FormCreate(Sender: TObject);
begin
end;

procedure TWebDlg.FormDeactivate(Sender: TObject);
begin
end;

procedure TWebDlg.FormResize(Sender: TObject);
begin
end;

procedure TWebDlg.FormShow(Sender: TObject);
begin
end;

procedure TWebDlg.HelpBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpBtnClick');
end;

procedure TWebDlg.IELocationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IELocationClick');
end;

procedure TWebDlg.ImageLocationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImageLocationClick');
end;

procedure TWebDlg.ImportModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportModeClick');
end;

procedure TWebDlg.ImportPagesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportPagesClick');
end;

procedure TWebDlg.InvChangeTab1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvChangeTab1Click');
end;

procedure TWebDlg.ListBox1ClickCheck(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1ClickCheck');
end;

procedure TWebDlg.ListBox1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListBox1DblClick');
end;

procedure TWebDlg.ListBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ListBox1KeyDown');
end;

procedure TWebDlg.ListBox1KeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'ListBox1KeyPress');
end;

procedure TWebDlg.ListBox1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWebDlg.ListBox1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TWebDlg.MIBrowseDuplicatesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseDuplicatesClick');
end;

procedure TWebDlg.MICheckDuplicatesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICheckDuplicatesClick');
end;

procedure TWebDlg.MICheckSelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICheckSelectedClick');
end;

procedure TWebDlg.MICloseCheckedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseCheckedClick');
end;

procedure TWebDlg.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TWebDlg.MICloseCurrentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseCurrentClick');
end;

procedure TWebDlg.MICloseDuplicatesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseDuplicatesClick');
end;

procedure TWebDlg.MICloseUnselectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseUnselectedClick');
end;

procedure TWebDlg.MISwapClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwapClick');
end;

procedure TWebDlg.MIUncheckDuplicates(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUncheckDuplicates');
end;

procedure TWebDlg.MIUncheckSelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUncheckSelectedClick');
end;

procedure TWebDlg.MaxPriorityButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MaxPriorityButtonClick');
end;

procedure TWebDlg.MinPriorityButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MinPriorityButtonClick');
end;

procedure TWebDlg.SiftBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SiftBtnClick');
end;

procedure TWebDlg.ViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewClick');
end;

initialization
  if GetClass('TWebDlg') = nil then
    RegisterClass(TWebDlg);

end.
