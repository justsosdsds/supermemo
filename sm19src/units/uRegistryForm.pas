unit uRegistryForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRegistryForm = class(TForm)
    Splitter1: TSplitter;
    RightPanel: TPanel;
    Splitter2: TSplitter;
    UserListBox: TCheckListBox;
    ButtonPanel: TPanel;
    Insert: TButton;
    Accept: TButton;
    Rename: TButton;
    List: TButton;
    Browse: TButton;
    Add: TButton;
    Go: TButton;
    Button1: TButton;
    PathPanel: TPanel;
    PathLabel: TPanel;
    SlotLabel: TPanel;
    PositLabel: TPanel;
    UserLabel: TPanel;
    IndexLabel: TPanel;
    ComboPanel: TPanel;
    ComboBox1: TComboBox;
    MemberPanel: TPanel;
    MemberListBox: TCheckListBox;
    ScrollPanel: TPanel;
    ScrollBar1: TScrollBar;
    ToolBar1: TToolBar;
    MenuBtn: TToolButton;
    ListButton: TToolButton;
    GoToBtn: TToolButton;
    ViewButton: TToolButton;
    GoNeuralBtn: TToolButton;
    FindButton: TToolButton;
    ReplaceButton: TToolButton;
    SuperSet: TToolButton;
    SubSet: TToolButton;
    CheckBtn: TToolButton;
    UnCheckBtn: TToolButton;
    RandomButton: TToolButton;
    FontButton: TToolButton;
    SwitchRegistry: TToolButton;
    BrowseBtn: TToolButton;
    ImportBtn: TToolButton;
    ModeBtn: TToolButton;
    SaveBtn: TToolButton;
    MediaPlayer1: TMediaPlayer;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    MIGoNeural: TMenuItem;
    MIViewMenu: TMenuItem;
    MIListUsers: TMenuItem;
    MIView: TMenuItem;
    MIGoTo: TMenuItem;
    MIConceptMap: TMenuItem;
    MIViewReference: TMenuItem;
    N7: TMenuItem;
    MIBrowseCurrent: TMenuItem;
    MIBrowseSelected: TMenuItem;
    MIBrowseAll: TMenuItem;
    N12: TMenuItem;
    MIRandomPick: TMenuItem;
    MISelectPosition: TMenuItem;
    N3: TMenuItem;
    MIShowPath: TMenuItem;
    MIPlay: TMenuItem;
    MIUTF8codes: TMenuItem;
    N11: TMenuItem;
    MIClear: TMenuItem;
    MIEditMenu: TMenuItem;
    MIPaste: TMenuItem;
    MIPasteOver: TMenuItem;
    MIOverwrite: TMenuItem;
    N15: TMenuItem;
    MIEditText: TMenuItem;
    MIEditTranslation: TMenuItem;
    MICopyPath: TMenuItem;
    MISearch: TMenuItem;
    MIFindAll: TMenuItem;
    MIFindFirst: TMenuItem;
    MIFindNext: TMenuItem;
    N10: TMenuItem;
    MIReplace: TMenuItem;
    MIApplyFilter: TMenuItem;
    MIRename: TMenuItem;
    MIDeleteMember: TMenuItem;
    N9: TMenuItem;
    MITools: TMenuItem;
    MIImportFile: TMenuItem;
    MIImportText: TMenuItem;
    MIExportFile: TMenuItem;
    MIExportText: TMenuItem;
    N2: TMenuItem;
    MISort: TMenuItem;
    MISortSize: TMenuItem;
    MISortPriority: TMenuItem;
    N6: TMenuItem;
    MIExternalize: TMenuItem;
    MIInternalize: TMenuItem;
    MIRecover: TMenuItem;
    MINormalizeURLs: TMenuItem;
    MIDeleteUnused: TMenuItem;
    MIComputeSize: TMenuItem;
    N4: TMenuItem;
    MIAddPredefined: TMenuItem;
    MIGenerateCollection: TMenuItem;
    MIGenerateImageReferences: TMenuItem;
    MIDeleteAllMembers: TMenuItem;
    Selection1: TMenuItem;
    MISelectAllMembers: TMenuItem;
    MIUnslectAll: TMenuItem;
    MISwapSelection: TMenuItem;
    N14: TMenuItem;
    MISelectIndexRange: TMenuItem;
    MISelectPositionRange: TMenuItem;
    N16: TMenuItem;
    MISelectedSubset: TMenuItem;
    Subset1: TMenuItem;
    MIPreviousSubset: TMenuItem;
    MINextSubset: TMenuItem;
    MIDeleteSubset: TMenuItem;
    N13: TMenuItem;
    MIMatchToSubset: TMenuItem;
    Selectformat1: TMenuItem;
    MISelectHTML: TMenuItem;
    MISelectTXT: TMenuItem;
    MISelectEML: TMenuItem;
    MISelectRTF: TMenuItem;
    N8: TMenuItem;
    MISelectBMP: TMenuItem;
    MISelectJPG: TMenuItem;
    MISelectGIF: TMenuItem;
    PNG1: TMenuItem;
    MISelectBySizeRange: TMenuItem;
    MISelectUntranslated: TMenuItem;
    MIUseStatistics: TMenuItem;
    N5: TMenuItem;
    MIClose: TMenuItem;
    N1: TMenuItem;
    InvAdd1: TMenuItem;
    InvAdd2: TMenuItem;
    InvBrowse1: TMenuItem;
    InvPopup1: TMenuItem;
    InvEdit1: TMenuItem;
    InvGoneural1: TMenuItem;
    procedure AcceptClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBtnClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DeleteClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint; var AHandled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoClick(Sender: TObject);
    procedure GoNeuralBtnClick(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure InvEdit1Click(Sender: TObject);
    procedure InvPopup1Click(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure MIAddPredefinedClick(Sender: TObject);
    procedure MIApplyFilterClick(Sender: TObject);
    procedure MIBrowseAllClick(Sender: TObject);
    procedure MIBrowseCurrentClick(Sender: TObject);
    procedure MIBrowseSelectedClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MIComputeSizeClick(Sender: TObject);
    procedure MICopyPathClick(Sender: TObject);
    procedure MIDeleteAllMembersClick(Sender: TObject);
    procedure MIDeleteSubsetClick(Sender: TObject);
    procedure MIDeleteUnusedClick(Sender: TObject);
    procedure MIEditMenuClick(Sender: TObject);
    procedure MIEditTextClick(Sender: TObject);
    procedure MIEditTranslationClick(Sender: TObject);
    procedure MIExportTextClick(Sender: TObject);
    procedure MIExternalizeClick(Sender: TObject);
    procedure MIFindAllClick(Sender: TObject);
    procedure MIFindFirstClick(Sender: TObject);
    procedure MIFindNextClick(Sender: TObject);
    procedure MIGenerateCollectionClick(Sender: TObject);
    procedure MIGenerateImageReferencesClick(Sender: TObject);
    procedure MIGoNeuralClick(Sender: TObject);
    procedure MIImportFileClick(Sender: TObject);
    procedure MIImportTextClick(Sender: TObject);
    procedure MIInternalizeClick(Sender: TObject);
    procedure MIMatchToSubsetClick(Sender: TObject);
    procedure MINormalizeURLsClick(Sender: TObject);
    procedure MIOverwriteClick(Sender: TObject);
    procedure MIPasteClick(Sender: TObject);
    procedure MIPasteOverClick(Sender: TObject);
    procedure MIPlayClick(Sender: TObject);
    procedure MIRecoverClick(Sender: TObject);
    procedure MIReplaceClick(Sender: TObject);
    procedure MISelectAllMembersClick(Sender: TObject);
    procedure MISelectBMPClick(Sender: TObject);
    procedure MISelectBySizeRangeClick(Sender: TObject);
    procedure MISelectEMLClick(Sender: TObject);
    procedure MISelectGIFClick(Sender: TObject);
    procedure MISelectHTMLClick(Sender: TObject);
    procedure MISelectIndexRangeClick(Sender: TObject);
    procedure MISelectJPGClick(Sender: TObject);
    procedure MISelectPositionClick(Sender: TObject);
    procedure MISelectPositionRangeClick(Sender: TObject);
    procedure MISelectRTFClick(Sender: TObject);
    procedure MISelectTXTClick(Sender: TObject);
    procedure MISelectUntranslatedClick(Sender: TObject);
    procedure MISelectedSubsetClick(Sender: TObject);
    procedure MIShowPathClick(Sender: TObject);
    procedure MISortClick(Sender: TObject);
    procedure MISortPriorityClick(Sender: TObject);
    procedure MISortSizeClick(Sender: TObject);
    procedure MISwapSelectionClick(Sender: TObject);
    procedure MIUTF8codesClick(Sender: TObject);
    procedure MIUnslectAllClick(Sender: TObject);
    procedure MIUseStatisticsClick(Sender: TObject);
    procedure MIViewReferenceClick(Sender: TObject);
    procedure MemberListBoxClickCheck(Sender: TObject);
    procedure MemberListBoxDblClick(Sender: TObject);
    procedure MemberListBoxDrawItem(Sender: TObject);
    procedure MemberListBoxKeyPress(Sender: TObject; var AKey: Char);
    procedure MemberListBoxKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure MemberListBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure MemberListBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure MemberListBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ModeButtonClick(Sender: TObject);
    procedure PNG1Click(Sender: TObject);
    procedure PopUpButtonClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure RandomButtonClick(Sender: TObject);
    procedure RenameClick(Sender: TObject);
    procedure RightPanelClick(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject);
    procedure ScrollPanelResize(Sender: TObject);
    procedure SubSetClick(Sender: TObject);
    procedure SuperSetClick(Sender: TObject);
    procedure SwitchRegistryClick(Sender: TObject);
    procedure UnCheckBtnClick(Sender: TObject);
    procedure UserListBoxDblClick(Sender: TObject);
    procedure UserListBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure UserListBoxKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure UserListBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ViewButtonClick(Sender: TObject);
  end;

var
  RegistryForm: TRegistryForm;

implementation

{$R *.lfm}

procedure TRegistryForm.AcceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AcceptClick');
end;

procedure TRegistryForm.AddClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddClick');
end;

procedure TRegistryForm.BrowseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BrowseBtnClick');
end;

procedure TRegistryForm.Button1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button1Click');
end;

procedure TRegistryForm.CheckBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CheckBtnClick');
end;

procedure TRegistryForm.ClearClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearClick');
end;

procedure TRegistryForm.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure TRegistryForm.ComboBox1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ComboBox1KeyDown');
end;

procedure TRegistryForm.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TRegistryForm.ExportButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportButtonClick');
end;

procedure TRegistryForm.FontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontButtonClick');
end;

procedure TRegistryForm.FormActivate(Sender: TObject);
begin
end;

procedure TRegistryForm.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TRegistryForm.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TRegistryForm.FormCreate(Sender: TObject);
begin
end;

procedure TRegistryForm.FormDeactivate(Sender: TObject);
begin
end;

procedure TRegistryForm.FormDestroy(Sender: TObject);
begin
end;

procedure TRegistryForm.FormMouseWheel(Sender: TObject; AShift: TShiftState; AWheelDelta: Integer; AMousePos: TPoint; var AHandled: Boolean);
begin
end;

procedure TRegistryForm.FormPaint(Sender: TObject);
begin
end;

procedure TRegistryForm.FormResize(Sender: TObject);
begin
end;

procedure TRegistryForm.FormShow(Sender: TObject);
begin
end;

procedure TRegistryForm.GoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoClick');
end;

procedure TRegistryForm.GoNeuralBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoNeuralBtnClick');
end;

procedure TRegistryForm.InsertClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InsertClick');
end;

procedure TRegistryForm.InvEdit1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvEdit1Click');
end;

procedure TRegistryForm.InvPopup1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPopup1Click');
end;

procedure TRegistryForm.ListClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListClick');
end;

procedure TRegistryForm.MIAddPredefinedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddPredefinedClick');
end;

procedure TRegistryForm.MIApplyFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplyFilterClick');
end;

procedure TRegistryForm.MIBrowseAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseAllClick');
end;

procedure TRegistryForm.MIBrowseCurrentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseCurrentClick');
end;

procedure TRegistryForm.MIBrowseSelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseSelectedClick');
end;

procedure TRegistryForm.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TRegistryForm.MIComputeSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIComputeSizeClick');
end;

procedure TRegistryForm.MICopyPathClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyPathClick');
end;

procedure TRegistryForm.MIDeleteAllMembersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteAllMembersClick');
end;

procedure TRegistryForm.MIDeleteSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteSubsetClick');
end;

procedure TRegistryForm.MIDeleteUnusedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteUnusedClick');
end;

procedure TRegistryForm.MIEditMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditMenuClick');
end;

procedure TRegistryForm.MIEditTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditTextClick');
end;

procedure TRegistryForm.MIEditTranslationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditTranslationClick');
end;

procedure TRegistryForm.MIExportTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportTextClick');
end;

procedure TRegistryForm.MIExternalizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExternalizeClick');
end;

procedure TRegistryForm.MIFindAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindAllClick');
end;

procedure TRegistryForm.MIFindFirstClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindFirstClick');
end;

procedure TRegistryForm.MIFindNextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindNextClick');
end;

procedure TRegistryForm.MIGenerateCollectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGenerateCollectionClick');
end;

procedure TRegistryForm.MIGenerateImageReferencesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGenerateImageReferencesClick');
end;

procedure TRegistryForm.MIGoNeuralClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoNeuralClick');
end;

procedure TRegistryForm.MIImportFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportFileClick');
end;

procedure TRegistryForm.MIImportTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportTextClick');
end;

procedure TRegistryForm.MIInternalizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInternalizeClick');
end;

procedure TRegistryForm.MIMatchToSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMatchToSubsetClick');
end;

procedure TRegistryForm.MINormalizeURLsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINormalizeURLsClick');
end;

procedure TRegistryForm.MIOverwriteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOverwriteClick');
end;

procedure TRegistryForm.MIPasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteClick');
end;

procedure TRegistryForm.MIPasteOverClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteOverClick');
end;

procedure TRegistryForm.MIPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlayClick');
end;

procedure TRegistryForm.MIRecoverClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRecoverClick');
end;

procedure TRegistryForm.MIReplaceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReplaceClick');
end;

procedure TRegistryForm.MISelectAllMembersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectAllMembersClick');
end;

procedure TRegistryForm.MISelectBMPClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectBMPClick');
end;

procedure TRegistryForm.MISelectBySizeRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectBySizeRangeClick');
end;

procedure TRegistryForm.MISelectEMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectEMLClick');
end;

procedure TRegistryForm.MISelectGIFClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectGIFClick');
end;

procedure TRegistryForm.MISelectHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectHTMLClick');
end;

procedure TRegistryForm.MISelectIndexRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectIndexRangeClick');
end;

procedure TRegistryForm.MISelectJPGClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectJPGClick');
end;

procedure TRegistryForm.MISelectPositionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectPositionClick');
end;

procedure TRegistryForm.MISelectPositionRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectPositionRangeClick');
end;

procedure TRegistryForm.MISelectRTFClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectRTFClick');
end;

procedure TRegistryForm.MISelectTXTClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectTXTClick');
end;

procedure TRegistryForm.MISelectUntranslatedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectUntranslatedClick');
end;

procedure TRegistryForm.MISelectedSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectedSubsetClick');
end;

procedure TRegistryForm.MIShowPathClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShowPathClick');
end;

procedure TRegistryForm.MISortClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortClick');
end;

procedure TRegistryForm.MISortPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortPriorityClick');
end;

procedure TRegistryForm.MISortSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortSizeClick');
end;

procedure TRegistryForm.MISwapSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwapSelectionClick');
end;

procedure TRegistryForm.MIUTF8codesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUTF8codesClick');
end;

procedure TRegistryForm.MIUnslectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnslectAllClick');
end;

procedure TRegistryForm.MIUseStatisticsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUseStatisticsClick');
end;

procedure TRegistryForm.MIViewReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewReferenceClick');
end;

procedure TRegistryForm.MemberListBoxClickCheck(Sender: TObject);
begin
  DispatchAction(Sender, 'MemberListBoxClickCheck');
end;

procedure TRegistryForm.MemberListBoxDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MemberListBoxDblClick');
end;

procedure TRegistryForm.MemberListBoxDrawItem(Sender: TObject);
begin
  DispatchAction(Sender, 'MemberListBoxDrawItem');
end;

procedure TRegistryForm.MemberListBoxKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'MemberListBoxKeyPress');
end;

procedure TRegistryForm.MemberListBoxKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
end;

procedure TRegistryForm.MemberListBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRegistryForm.MemberListBoxMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRegistryForm.MemberListBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRegistryForm.ModeButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ModeButtonClick');
end;

procedure TRegistryForm.PNG1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'PNG1Click');
end;

procedure TRegistryForm.PopUpButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PopUpButtonClick');
end;

procedure TRegistryForm.PopupMenu1Popup(Sender: TObject);
begin
  DispatchAction(Sender, 'PopupMenu1Popup');
end;

procedure TRegistryForm.RandomButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RandomButtonClick');
end;

procedure TRegistryForm.RenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RenameClick');
end;

procedure TRegistryForm.RightPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RightPanelClick');
end;

procedure TRegistryForm.ScrollBar1Scroll(Sender: TObject);
begin
end;

procedure TRegistryForm.ScrollPanelResize(Sender: TObject);
begin
end;

procedure TRegistryForm.SubSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SubSetClick');
end;

procedure TRegistryForm.SuperSetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SuperSetClick');
end;

procedure TRegistryForm.SwitchRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SwitchRegistryClick');
end;

procedure TRegistryForm.UnCheckBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UnCheckBtnClick');
end;

procedure TRegistryForm.UserListBoxDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UserListBoxDblClick');
end;

procedure TRegistryForm.UserListBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'UserListBoxKeyDown');
end;

procedure TRegistryForm.UserListBoxKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
end;

procedure TRegistryForm.UserListBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TRegistryForm.ViewButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewButtonClick');
end;

initialization
  if GetClass('TRegistryForm') = nil then
    RegisterClass(TRegistryForm);

end.
