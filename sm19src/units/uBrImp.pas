unit uBrImp;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TBrImp = class(TForm)
    ConceptGroupLabel: TLabel;
    Label3: TLabel;
    PriorityGroup: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MinPriorEdit: TEdit;
    MaxPriorEdit: TEdit;
    StringGrid1: TStringGrid;
    ImportBtn: TBitBtn;
    CollectBtn: TBitBtn;
    ToolBar1: TToolBar;
    SetLinks: TToolButton;
    SetTextMode: TToolButton;
    ParseBtn: TToolButton;
    IgnoreAllBtn: TToolButton;
    KeepBrowsersBtn: TToolButton;
    CloseAllBtn: TToolButton;
    FilterDuplicatesBtn: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    GenerateTitleBtn: TToolButton;
    ToolButton3: TToolButton;
    Label4: TLabel;
    YouTubeBtn: TToolButton;
    WikiBtn: TToolButton;
    SMButton: TToolButton;
    PDFBtn: TToolButton;
    ImgBtn: TToolButton;
    ImportLocation: TRadioGroup;
    CreateConceptBox: TCheckBox;
    ImageLocation: TRadioGroup;
    ConceptEdit: TEdit;
    TitleEdit: TEdit;
    TheMemo: TMemo;
    HelpBtn: TButton;
    PopUpMenu_Ctl: TPopupMenu;
    MIText: TMenuItem;
    Link1: TMenuItem;
    HTML1: TMenuItem;
    Parse1: TMenuItem;
    Images1: TMenuItem;
    N2: TMenuItem;
    Ignore1: TMenuItem;
    MIKeep: TMenuItem;
    MICloseBrowser: TMenuItem;
    N3: TMenuItem;
    MIView: TMenuItem;
    MIViewInBrowser: TMenuItem;
    ViewinSuperMemo1: TMenuItem;
    MISelectall: TMenuItem;
    Delete1: TMenuItem;
    N4: TMenuItem;
    Filterduplicates1: TMenuItem;
    MIBrowseDuplicates: TMenuItem;
    MIPriorityRange: TMenuItem;
    N1: TMenuItem;
    Exist1: TMenuItem;
    N5: TMenuItem;
    InvHome1: TMenuItem;
    InvEnd1: TMenuItem;
    procedure CloseAllBtnClick(Sender: TObject);
    procedure CollectBtnClick(Sender: TObject);
    procedure ConceptEditClick(Sender: TObject);
    procedure ConceptEditEnter(Sender: TObject);
    procedure CreateConceptBoxClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Exist1Click(Sender: TObject);
    procedure FilterDuplicatesBtnClick(Sender: TObject);
    procedure Filterduplicates1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHelp(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GenerateTitleBtnClick(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Ignore1Click(Sender: TObject);
    procedure IgnoreAllBtnClick(Sender: TObject);
    procedure Images1Click(Sender: TObject);
    procedure ImgBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure ImportLocationClick(Sender: TObject);
    procedure InvEnd1Click(Sender: TObject);
    procedure InvHome1Click(Sender: TObject);
    procedure KeepBrowsersBtnClick(Sender: TObject);
    procedure Link1Click(Sender: TObject);
    procedure MIBrowseDuplicatesClick(Sender: TObject);
    procedure MICloseBrowserClick(Sender: TObject);
    procedure MIKeepClick(Sender: TObject);
    procedure MIPriorityRangeClick(Sender: TObject);
    procedure MISelectallClick(Sender: TObject);
    procedure MITextClick(Sender: TObject);
    procedure MIViewClick(Sender: TObject);
    procedure MIViewInBrowserClick(Sender: TObject);
    procedure PDFBtnClick(Sender: TObject);
    procedure Parse1Click(Sender: TObject);
    procedure ParseClick(Sender: TObject);
    procedure PriorityGroupEnter(Sender: TObject);
    procedure SMButtonClick(Sender: TObject);
    procedure SetLinksClick(Sender: TObject);
    procedure SetTextModeClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ToolButton4Click(Sender: TObject);
    procedure ViewinSuperMemo1Click(Sender: TObject);
    procedure WikiBtnClick(Sender: TObject);
    procedure YouTubeBtnClick(Sender: TObject);
  end;

var
  BrImp: TBrImp;

implementation

{$R *.lfm}

procedure TBrImp.CloseAllBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseAllBtnClick');
end;

procedure TBrImp.CollectBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CollectBtnClick');
end;

procedure TBrImp.ConceptEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ConceptEditClick');
end;

procedure TBrImp.ConceptEditEnter(Sender: TObject);
begin
end;

procedure TBrImp.CreateConceptBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CreateConceptBoxClick');
end;

procedure TBrImp.Delete1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Delete1Click');
end;

procedure TBrImp.Exist1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Exist1Click');
end;

procedure TBrImp.FilterDuplicatesBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FilterDuplicatesBtnClick');
end;

procedure TBrImp.Filterduplicates1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Filterduplicates1Click');
end;

procedure TBrImp.FormActivate(Sender: TObject);
begin
end;

procedure TBrImp.FormCreate(Sender: TObject);
begin
end;

procedure TBrImp.FormDeactivate(Sender: TObject);
begin
end;

procedure TBrImp.FormDestroy(Sender: TObject);
begin
end;

procedure TBrImp.FormHelp(Sender: TObject);
begin
end;

procedure TBrImp.FormResize(Sender: TObject);
begin
end;

procedure TBrImp.FormShow(Sender: TObject);
begin
end;

procedure TBrImp.GenerateTitleBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GenerateTitleBtnClick');
end;

procedure TBrImp.HTML1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'HTML1Click');
end;

procedure TBrImp.HelpBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpBtnClick');
end;

procedure TBrImp.Ignore1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Ignore1Click');
end;

procedure TBrImp.IgnoreAllBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IgnoreAllBtnClick');
end;

procedure TBrImp.Images1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Images1Click');
end;

procedure TBrImp.ImgBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImgBtnClick');
end;

procedure TBrImp.ImportBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportBtnClick');
end;

procedure TBrImp.ImportLocationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportLocationClick');
end;

procedure TBrImp.InvEnd1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvEnd1Click');
end;

procedure TBrImp.InvHome1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvHome1Click');
end;

procedure TBrImp.KeepBrowsersBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'KeepBrowsersBtnClick');
end;

procedure TBrImp.Link1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Link1Click');
end;

procedure TBrImp.MIBrowseDuplicatesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseDuplicatesClick');
end;

procedure TBrImp.MICloseBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseBrowserClick');
end;

procedure TBrImp.MIKeepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIKeepClick');
end;

procedure TBrImp.MIPriorityRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPriorityRangeClick');
end;

procedure TBrImp.MISelectallClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectallClick');
end;

procedure TBrImp.MITextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextClick');
end;

procedure TBrImp.MIViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewClick');
end;

procedure TBrImp.MIViewInBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewInBrowserClick');
end;

procedure TBrImp.PDFBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PDFBtnClick');
end;

procedure TBrImp.Parse1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Parse1Click');
end;

procedure TBrImp.ParseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ParseClick');
end;

procedure TBrImp.PriorityGroupEnter(Sender: TObject);
begin
end;

procedure TBrImp.SMButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SMButtonClick');
end;

procedure TBrImp.SetLinksClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetLinksClick');
end;

procedure TBrImp.SetTextModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetTextModeClick');
end;

procedure TBrImp.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

procedure TBrImp.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TBrImp.StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrImp.ToolButton4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton4Click');
end;

procedure TBrImp.ViewinSuperMemo1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewinSuperMemo1Click');
end;

procedure TBrImp.WikiBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WikiBtnClick');
end;

procedure TBrImp.YouTubeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'YouTubeBtnClick');
end;

initialization
  if GetClass('TBrImp') = nil then
    RegisterClass(TBrImp);

end.
