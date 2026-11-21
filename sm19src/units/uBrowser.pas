unit uBrowser;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TBrowser = class(TForm)
    ThumbCanvas: TImage;
    StringGrid1: TStringGrid;
    Speedbar: TToolBar;
    MenuButton: TToolButton;
    ProcessElementsButton: TToolButton;
    StandardSize: TToolButton;
    ToolButton8: TToolButton;
    ReviewButton: TToolButton;
    ToolButton9: TToolButton;
    ReviewTopics: TToolButton;
    ToolButton3: TToolButton;
    ChildSelected: TToolButton;
    ChildUnselected: TToolButton;
    ToolButton1: TToolButton;
    TopicsBtn: TToolButton;
    MemorizedButton: TToolButton;
    ToolButton5: TToolButton;
    Sources: TToolButton;
    SortBtn: TToolButton;
    PostponeBtn: TToolButton;
    AdvanceTopicsBtn: TToolButton;
    AdvanceItemsBtn: TToolButton;
    AddToOutstanding: TToolButton;
    SpreadPriorityBtn: TToolButton;
    ToolButton11: TToolButton;
    ApplyTemplateBtn: TToolButton;
    InsertPicture: TToolButton;
    RandomBtn: TToolButton;
    SaveRepsButton: TToolButton;
    ToolButton6: TToolButton;
    FindBtn: TToolButton;
    GoToBtn: TToolButton;
    SaveSubsetButton: TToolButton;
    ToolButton7: TToolButton;
    Synch: TToolButton;
    GoToElWindElement: TToolButton;
    ScrollBar1: TScrollBar;
    PopupMenu1: TPopupMenu;
    Invisible1: TMenuItem;
    InvApplytemplate1: TMenuItem;
    InvClose: TMenuItem;
    InvCommander1: TMenuItem;
    InvCountBurden1: TMenuItem;
    InvDismiss1: TMenuItem;
    InvDone1: TMenuItem;
    InvElParam1: TMenuItem;
    InvExecuterepetition1: TMenuItem;
    InvGoto1: TMenuItem;
    InvImpose1: TMenuItem;
    Linkmember1: TMenuItem;
    Memorize1: TMenuItem;
    Nextcomponent1: TMenuItem;
    InvPlan1: TMenuItem;
    InvPostpone1: TMenuItem;
    InvPriority1: TMenuItem;
    InvRepetitionhistory1: TMenuItem;
    InvReviewall1: TMenuItem;
    InvShift1: TMenuItem;
    InvShowAncestors1: TMenuItem;
    SleepChart1: TMenuItem;
    InvTasklist1: TMenuItem;
    InvTitle1: TMenuItem;
    InvTransfer1: TMenuItem;
    MILearn: TMenuItem;
    MIGoNeural: TMenuItem;
    MIGoTo: TMenuItem;
    N1: TMenuItem;
    MIChild: TMenuItem;
    MIChildPriority: TMenuItem;
    N21: TMenuItem;
    MISelected: TMenuItem;
    MIUnselected: TMenuItem;
    N15: TMenuItem;
    MIChildSources: TMenuItem;
    MIChildArticles: TMenuItem;
    MIExtracts: TMenuItem;
    MIChildDescendants: TMenuItem;
    N18: TMenuItem;
    MIOutstanding: TMenuItem;
    MIMemorized: TMenuItem;
    MIPending: TMenuItem;
    MIDismissed: TMenuItem;
    N12: TMenuItem;
    MIChildItem: TMenuItem;
    MIChildTopic: TMenuItem;
    MIChildTask: TMenuItem;
    MIChildTasksAndTopics: TMenuItem;
    N13: TMenuItem;
    MIChildFilter: TMenuItem;
    N16: TMenuItem;
    MIChildBranch: TMenuItem;
    Select1: TMenuItem;
    MISelectElement: TMenuItem;
    MISelectAll: TMenuItem;
    MIClearSelection: TMenuItem;
    MIInvertSelection: TMenuItem;
    N4: TMenuItem;
    MISelectBrowserRange: TMenuItem;
    MISelectElementRange: TMenuItem;
    MIUnselectBrowserRange: TMenuItem;
    MIUnselectElementRange: TMenuItem;
    N17: TMenuItem;
    MIUnselectSubtract: TMenuItem;
    MIUnselectIntersect: TMenuItem;
    N14: TMenuItem;
    MISaveSelection: TMenuItem;
    MISubset: TMenuItem;
    MISaveAll: TMenuItem;
    N8: TMenuItem;
    MIAddSubset: TMenuItem;
    MISubtractSubset: TMenuItem;
    MIIntersectSubset: TMenuItem;
    N5: TMenuItem;
    MIIntersperseSubset: TMenuItem;
    N9: TMenuItem;
    MIDelete: TMenuItem;
    N19: TMenuItem;
    Search1: TMenuItem;
    MISearchBrowser: TMenuItem;
    N22: TMenuItem;
    Find1: TMenuItem;
    Findnext1: TMenuItem;
    MIFindAll: TMenuItem;
    MIFindCurrent: TMenuItem;
    N24: TMenuItem;
    MISearchAndReplace: TMenuItem;
    MISort: TMenuItem;
    MISortForReview: TMenuItem;
    N20: TMenuItem;
    MISortByInterval: TMenuItem;
    MISortByStability: TMenuItem;
    MISortByRetrievability: TMenuItem;
    MISortByDifficulty: TMenuItem;
    MISortByFirstRepetition: TMenuItem;
    MIByLastRep: TMenuItem;
    MIByNextRep: TMenuItem;
    MIByForgetting: TMenuItem;
    MISortByPostpone: TMenuItem;
    MISortByPriority: TMenuItem;
    MIByRepetitions: TMenuItem;
    Bytextsize1: TMenuItem;
    Byfilesize1: TMenuItem;
    MISortByTree: TMenuItem;
    Other1: TMenuItem;
    MIByTitle: TMenuItem;
    MISortByType: TMenuItem;
    MISortByAFactor: TMenuItem;
    MIByElementNo: TMenuItem;
    MISortByFI: TMenuItem;
    MIByOrdinal: TMenuItem;
    MISortByUFactor: TMenuItem;
    N11: TMenuItem;
    MIRandomize: TMenuItem;
    Export1: TMenuItem;
    MITransfer: TMenuItem;
    N23: TMenuItem;
    MIExportDocument: TMenuItem;
    MIExportQAText: TMenuItem;
    N6: TMenuItem;
    MIExportasXML: TMenuItem;
    MIExportAsText: TMenuItem;
    N25: TMenuItem;
    MITextSubset: TMenuItem;
    N26: TMenuItem;
    MIExportRepetitionHistoryCSV: TMenuItem;
    MIExportRepetitionHistoryText: TMenuItem;
    Random1: TMenuItem;
    Randomchange1: TMenuItem;
    MIRandomTest: TMenuItem;
    MIRandomizeBrowser: TMenuItem;
    MITools: TMenuItem;
    MISavePending: TMenuItem;
    MISavePriority: TMenuItem;
    Savedrill1: TMenuItem;
    MISaveRepetitions: TMenuItem;
    N7: TMenuItem;
    MISwapQA: TMenuItem;
    N27: TMenuItem;
    MITotalKnowledge: TMenuItem;
    N10: TMenuItem;
    MIRepetitionsGraph: TMenuItem;
    N2: TMenuItem;
    MIProcessBrowser: TMenuItem;
    N3: TMenuItem;
    MIClose: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure AddToOutstandingClick(Sender: TObject);
    procedure AdvanceItemsBtnClick(Sender: TObject);
    procedure AdvanceTopicsBtnClick(Sender: TObject);
    procedure ApplyTemplateBtnClick(Sender: TObject);
    procedure Byfilesize1Click(Sender: TObject);
    procedure Bytextsize1Click(Sender: TObject);
    procedure ChildSelectedClick(Sender: TObject);
    procedure ChildUnselectedClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure Findnext1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoToButtonClick(Sender: TObject);
    procedure GoToElWindElementClick(Sender: TObject);
    procedure InsertPictureClick(Sender: TObject);
    procedure InvApplytemplate1Click(Sender: TObject);
    procedure InvCloseClick(Sender: TObject);
    procedure InvCommander1Click(Sender: TObject);
    procedure InvCountBurden1Click(Sender: TObject);
    procedure InvDismiss1Click(Sender: TObject);
    procedure InvDone1Click(Sender: TObject);
    procedure InvElParam1Click(Sender: TObject);
    procedure InvExecuterepetition1Click(Sender: TObject);
    procedure InvGoto1Click(Sender: TObject);
    procedure InvImpose1Click(Sender: TObject);
    procedure InvPlan1Click(Sender: TObject);
    procedure InvPostpone1Click(Sender: TObject);
    procedure InvPriority1Click(Sender: TObject);
    procedure InvRepetitionhistory1Click(Sender: TObject);
    procedure InvReviewall1Click(Sender: TObject);
    procedure InvShift1Click(Sender: TObject);
    procedure InvShowAncestors1Click(Sender: TObject);
    procedure InvTasklist1Click(Sender: TObject);
    procedure InvTitle1Click(Sender: TObject);
    procedure InvTransfer1Click(Sender: TObject);
    procedure Linkmember1Click(Sender: TObject);
    procedure MIAddSubsetClick(Sender: TObject);
    procedure MIByElementNoClick(Sender: TObject);
    procedure MIByForgettingClick(Sender: TObject);
    procedure MIByLastRepClick(Sender: TObject);
    procedure MIByNextRepClick(Sender: TObject);
    procedure MIByOrdinalClick(Sender: TObject);
    procedure MIByRepetitionsClick(Sender: TObject);
    procedure MIByTitleClick(Sender: TObject);
    procedure MIChildArticlesClick(Sender: TObject);
    procedure MIChildBranchClick(Sender: TObject);
    procedure MIChildDescendantsClick(Sender: TObject);
    procedure MIChildFilterClick(Sender: TObject);
    procedure MIChildItemClick(Sender: TObject);
    procedure MIChildPriorityClick(Sender: TObject);
    procedure MIChildSourcesClick(Sender: TObject);
    procedure MIChildTaskClick(Sender: TObject);
    procedure MIChildTasksAndTopicsClick(Sender: TObject);
    procedure MIChildTopicClick(Sender: TObject);
    procedure MIClearSelectionClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIDismissedClick(Sender: TObject);
    procedure MIExportAsTextClick(Sender: TObject);
    procedure MIExportDocumentClick(Sender: TObject);
    procedure MIExportQATextClick(Sender: TObject);
    procedure MIExportRepetitionHistoryCSVClick(Sender: TObject);
    procedure MIExportRepetitionHistoryTextClick(Sender: TObject);
    procedure MIExportasXMLClick(Sender: TObject);
    procedure MIExtractsClick(Sender: TObject);
    procedure MIFindAllClick(Sender: TObject);
    procedure MIGoNeuralClick(Sender: TObject);
    procedure MIIntersectSubsetClick(Sender: TObject);
    procedure MIIntersperseSubsetClick(Sender: TObject);
    procedure MIInvertSelectionClick(Sender: TObject);
    procedure MILearnClick(Sender: TObject);
    procedure MIOutstandingClick(Sender: TObject);
    procedure MIPendingClick(Sender: TObject);
    procedure MIProcessBrowserClick(Sender: TObject);
    procedure MIRandomTestClick(Sender: TObject);
    procedure MIRandomizeClick(Sender: TObject);
    procedure MIRepetitionsGraphClick(Sender: TObject);
    procedure MISaveAllClick(Sender: TObject);
    procedure MISavePendingClick(Sender: TObject);
    procedure MISavePriorityClick(Sender: TObject);
    procedure MISaveRepetitionsClick(Sender: TObject);
    procedure MISaveSelectionClick(Sender: TObject);
    procedure MISearchAndReplaceClick(Sender: TObject);
    procedure MISearchBrowserClick(Sender: TObject);
    procedure MISelectAllClick(Sender: TObject);
    procedure MISelectBrowserRangeClick(Sender: TObject);
    procedure MISelectElementClick(Sender: TObject);
    procedure MISelectElementRangeClick(Sender: TObject);
    procedure MISelectedClick(Sender: TObject);
    procedure MISortByAFactorClick(Sender: TObject);
    procedure MISortByDifficultyClick(Sender: TObject);
    procedure MISortByFIClick(Sender: TObject);
    procedure MISortByFirstRepetitionClick(Sender: TObject);
    procedure MISortByIntervalClick(Sender: TObject);
    procedure MISortByPostponeClick(Sender: TObject);
    procedure MISortByPriorityClick(Sender: TObject);
    procedure MISortByRetrievabilityClick(Sender: TObject);
    procedure MISortByStabilityClick(Sender: TObject);
    procedure MISortByTreeClick(Sender: TObject);
    procedure MISortByTypeClick(Sender: TObject);
    procedure MISortByUFactorClick(Sender: TObject);
    procedure MISortForReviewClick(Sender: TObject);
    procedure MISubtractSubsetClick(Sender: TObject);
    procedure MISwapQAClick(Sender: TObject);
    procedure MITextSubsetClick(Sender: TObject);
    procedure MITotalKnowledgeClick(Sender: TObject);
    procedure MITransferClick(Sender: TObject);
    procedure MIUnselectBrowserRangeClick(Sender: TObject);
    procedure MIUnselectElementRangeClick(Sender: TObject);
    procedure MIUnselectIntersectClick(Sender: TObject);
    procedure MIUnselectSubtractClick(Sender: TObject);
    procedure MIUnselectedClick(Sender: TObject);
    procedure Memorize1Click(Sender: TObject);
    procedure MemorizedClick(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure Nextcomponent1Click(Sender: TObject);
    procedure PostponeBtnClick(Sender: TObject);
    procedure ProcessElementsButtonMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure RandomButtonClick(Sender: TObject);
    procedure ReviewButtonClick(Sender: TObject);
    procedure ReviewTopicsClick(Sender: TObject);
    procedure SaveSubsetButtonClick(Sender: TObject);
    procedure Savedrill1Click(Sender: TObject);
    procedure ScrollBar1KeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure ScrollBar1MouseLeave(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject);
    procedure SleepChart1Click(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
    procedure SourcesClick(Sender: TObject);
    procedure SpreadPriorityBtnClick(Sender: TObject);
    procedure StandardSizeClick(Sender: TObject);
    procedure StringGrid1ColumnMoved(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure SynchClick(Sender: TObject);
    procedure ThumbCanvasDblClick(Sender: TObject);
    procedure ThumbCanvasMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ToolButton8Click(Sender: TObject);
  end;

var
  Browser: TBrowser;

implementation

{$R *.lfm}

procedure TBrowser.AddToOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddToOutstandingClick');
end;

procedure TBrowser.AdvanceItemsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AdvanceItemsBtnClick');
end;

procedure TBrowser.AdvanceTopicsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AdvanceTopicsBtnClick');
end;

procedure TBrowser.ApplyTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ApplyTemplateBtnClick');
end;

procedure TBrowser.Byfilesize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Byfilesize1Click');
end;

procedure TBrowser.Bytextsize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Bytextsize1Click');
end;

procedure TBrowser.ChildSelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChildSelectedClick');
end;

procedure TBrowser.ChildUnselectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChildUnselectedClick');
end;

procedure TBrowser.FindButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindButtonClick');
end;

procedure TBrowser.Findnext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Findnext1Click');
end;

procedure TBrowser.FormActivate(Sender: TObject);
begin
end;

procedure TBrowser.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TBrowser.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TBrowser.FormCreate(Sender: TObject);
begin
end;

procedure TBrowser.FormDeactivate(Sender: TObject);
begin
end;

procedure TBrowser.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TBrowser.FormResize(Sender: TObject);
begin
end;

procedure TBrowser.FormShow(Sender: TObject);
begin
end;

procedure TBrowser.GoToButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToButtonClick');
end;

procedure TBrowser.GoToElWindElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToElWindElementClick');
end;

procedure TBrowser.InsertPictureClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InsertPictureClick');
end;

procedure TBrowser.InvApplytemplate1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvApplytemplate1Click');
end;

procedure TBrowser.InvCloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InvCloseClick');
end;

procedure TBrowser.InvCommander1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvCommander1Click');
end;

procedure TBrowser.InvCountBurden1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvCountBurden1Click');
end;

procedure TBrowser.InvDismiss1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvDismiss1Click');
end;

procedure TBrowser.InvDone1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvDone1Click');
end;

procedure TBrowser.InvElParam1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvElParam1Click');
end;

procedure TBrowser.InvExecuterepetition1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvExecuterepetition1Click');
end;

procedure TBrowser.InvGoto1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvGoto1Click');
end;

procedure TBrowser.InvImpose1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvImpose1Click');
end;

procedure TBrowser.InvPlan1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPlan1Click');
end;

procedure TBrowser.InvPostpone1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPostpone1Click');
end;

procedure TBrowser.InvPriority1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPriority1Click');
end;

procedure TBrowser.InvRepetitionhistory1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvRepetitionhistory1Click');
end;

procedure TBrowser.InvReviewall1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvReviewall1Click');
end;

procedure TBrowser.InvShift1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvShift1Click');
end;

procedure TBrowser.InvShowAncestors1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvShowAncestors1Click');
end;

procedure TBrowser.InvTasklist1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvTasklist1Click');
end;

procedure TBrowser.InvTitle1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvTitle1Click');
end;

procedure TBrowser.InvTransfer1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvTransfer1Click');
end;

procedure TBrowser.Linkmember1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Linkmember1Click');
end;

procedure TBrowser.MIAddSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddSubsetClick');
end;

procedure TBrowser.MIByElementNoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByElementNoClick');
end;

procedure TBrowser.MIByForgettingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByForgettingClick');
end;

procedure TBrowser.MIByLastRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByLastRepClick');
end;

procedure TBrowser.MIByNextRepClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByNextRepClick');
end;

procedure TBrowser.MIByOrdinalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByOrdinalClick');
end;

procedure TBrowser.MIByRepetitionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByRepetitionsClick');
end;

procedure TBrowser.MIByTitleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIByTitleClick');
end;

procedure TBrowser.MIChildArticlesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildArticlesClick');
end;

procedure TBrowser.MIChildBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildBranchClick');
end;

procedure TBrowser.MIChildDescendantsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildDescendantsClick');
end;

procedure TBrowser.MIChildFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildFilterClick');
end;

procedure TBrowser.MIChildItemClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildItemClick');
end;

procedure TBrowser.MIChildPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildPriorityClick');
end;

procedure TBrowser.MIChildSourcesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildSourcesClick');
end;

procedure TBrowser.MIChildTaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildTaskClick');
end;

procedure TBrowser.MIChildTasksAndTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildTasksAndTopicsClick');
end;

procedure TBrowser.MIChildTopicClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIChildTopicClick');
end;

procedure TBrowser.MIClearSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIClearSelectionClick');
end;

procedure TBrowser.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TBrowser.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TBrowser.MIDismissedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismissedClick');
end;

procedure TBrowser.MIExportAsTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportAsTextClick');
end;

procedure TBrowser.MIExportDocumentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDocumentClick');
end;

procedure TBrowser.MIExportQATextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportQATextClick');
end;

procedure TBrowser.MIExportRepetitionHistoryCSVClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportRepetitionHistoryCSVClick');
end;

procedure TBrowser.MIExportRepetitionHistoryTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportRepetitionHistoryTextClick');
end;

procedure TBrowser.MIExportasXMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportasXMLClick');
end;

procedure TBrowser.MIExtractsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExtractsClick');
end;

procedure TBrowser.MIFindAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindAllClick');
end;

procedure TBrowser.MIGoNeuralClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoNeuralClick');
end;

procedure TBrowser.MIIntersectSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIntersectSubsetClick');
end;

procedure TBrowser.MIIntersperseSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIntersperseSubsetClick');
end;

procedure TBrowser.MIInvertSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInvertSelectionClick');
end;

procedure TBrowser.MILearnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnClick');
end;

procedure TBrowser.MIOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOutstandingClick');
end;

procedure TBrowser.MIPendingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPendingClick');
end;

procedure TBrowser.MIProcessBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIProcessBrowserClick');
end;

procedure TBrowser.MIRandomTestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomTestClick');
end;

procedure TBrowser.MIRandomizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomizeClick');
end;

procedure TBrowser.MIRepetitionsGraphClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRepetitionsGraphClick');
end;

procedure TBrowser.MISaveAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveAllClick');
end;

procedure TBrowser.MISavePendingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISavePendingClick');
end;

procedure TBrowser.MISavePriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISavePriorityClick');
end;

procedure TBrowser.MISaveRepetitionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveRepetitionsClick');
end;

procedure TBrowser.MISaveSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveSelectionClick');
end;

procedure TBrowser.MISearchAndReplaceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchAndReplaceClick');
end;

procedure TBrowser.MISearchBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchBrowserClick');
end;

procedure TBrowser.MISelectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectAllClick');
end;

procedure TBrowser.MISelectBrowserRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectBrowserRangeClick');
end;

procedure TBrowser.MISelectElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectElementClick');
end;

procedure TBrowser.MISelectElementRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectElementRangeClick');
end;

procedure TBrowser.MISelectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectedClick');
end;

procedure TBrowser.MISortByAFactorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByAFactorClick');
end;

procedure TBrowser.MISortByDifficultyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByDifficultyClick');
end;

procedure TBrowser.MISortByFIClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByFIClick');
end;

procedure TBrowser.MISortByFirstRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByFirstRepetitionClick');
end;

procedure TBrowser.MISortByIntervalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByIntervalClick');
end;

procedure TBrowser.MISortByPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByPostponeClick');
end;

procedure TBrowser.MISortByPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByPriorityClick');
end;

procedure TBrowser.MISortByRetrievabilityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByRetrievabilityClick');
end;

procedure TBrowser.MISortByStabilityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByStabilityClick');
end;

procedure TBrowser.MISortByTreeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByTreeClick');
end;

procedure TBrowser.MISortByTypeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByTypeClick');
end;

procedure TBrowser.MISortByUFactorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortByUFactorClick');
end;

procedure TBrowser.MISortForReviewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortForReviewClick');
end;

procedure TBrowser.MISubtractSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISubtractSubsetClick');
end;

procedure TBrowser.MISwapQAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwapQAClick');
end;

procedure TBrowser.MITextSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextSubsetClick');
end;

procedure TBrowser.MITotalKnowledgeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITotalKnowledgeClick');
end;

procedure TBrowser.MITransferClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferClick');
end;

procedure TBrowser.MIUnselectBrowserRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnselectBrowserRangeClick');
end;

procedure TBrowser.MIUnselectElementRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnselectElementRangeClick');
end;

procedure TBrowser.MIUnselectIntersectClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnselectIntersectClick');
end;

procedure TBrowser.MIUnselectSubtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnselectSubtractClick');
end;

procedure TBrowser.MIUnselectedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnselectedClick');
end;

procedure TBrowser.Memorize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Memorize1Click');
end;

procedure TBrowser.MemorizedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MemorizedClick');
end;

procedure TBrowser.MenuButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MenuButtonClick');
end;

procedure TBrowser.Nextcomponent1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Nextcomponent1Click');
end;

procedure TBrowser.PostponeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PostponeBtnClick');
end;

procedure TBrowser.ProcessElementsButtonMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrowser.RandomButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RandomButtonClick');
end;

procedure TBrowser.ReviewButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReviewButtonClick');
end;

procedure TBrowser.ReviewTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReviewTopicsClick');
end;

procedure TBrowser.SaveSubsetButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveSubsetButtonClick');
end;

procedure TBrowser.Savedrill1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Savedrill1Click');
end;

procedure TBrowser.ScrollBar1KeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
end;

procedure TBrowser.ScrollBar1MouseLeave(Sender: TObject);
begin
end;

procedure TBrowser.ScrollBar1Scroll(Sender: TObject);
begin
end;

procedure TBrowser.SleepChart1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SleepChart1Click');
end;

procedure TBrowser.SortBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SortBtnClick');
end;

procedure TBrowser.SourcesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SourcesClick');
end;

procedure TBrowser.SpreadPriorityBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SpreadPriorityBtnClick');
end;

procedure TBrowser.StandardSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StandardSizeClick');
end;

procedure TBrowser.StringGrid1ColumnMoved(Sender: TObject);
begin
end;

procedure TBrowser.StringGrid1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StringGrid1DblClick');
end;

procedure TBrowser.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

procedure TBrowser.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TBrowser.StringGrid1MouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrowser.StringGrid1MouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrowser.StringGrid1MouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrowser.StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid1SelectCell');
end;

procedure TBrowser.SynchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SynchClick');
end;

procedure TBrowser.ThumbCanvasDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ThumbCanvasDblClick');
end;

procedure TBrowser.ThumbCanvasMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TBrowser.ToolButton8Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton8Click');
end;

initialization
  if GetClass('TBrowser') = nil then
    RegisterClass(TBrowser);

end.
