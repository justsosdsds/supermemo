unit uContents;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TContents = class(TForm)
    BottomBar: TToolBar;
    Learn: TToolButton;
    ToolButton5: TToolButton;
    Add: TToolButton;
    ToolButton7: TToolButton;
    Insert: TToolButton;
    ToolButton11: TToolButton;
    Accept: TToolButton;
    ToolButton15: TToolButton;
    View: TToolButton;
    ToolButton13: TToolButton;
    Delete: TToolButton;
    ToolButton3: TToolButton;
    TypeCombo: TComboBox;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ProcessElementsButtons: TToolButton;
    SplitWithElement: TToolButton;
    SplitWithContents: TToolButton;
    FindButton: TToolButton;
    ViewBtn: TToolButton;
    ToolButton17: TToolButton;
    PostponeBtn: TToolButton;
    SaveBtn: TToolButton;
    RootBtn: TToolButton;
    HookButton: TToolButton;
    InfoButton: TToolButton;
    Synch: TToolButton;
    SelectTheElement: TToolButton;
    PopupMenu1: TPopupMenu;
    Invisible1: TMenuItem;
    Copy1: TMenuItem;
    InvCountBurden1: TMenuItem;
    InvDone1: TMenuItem;
    InvElParams1: TMenuItem;
    Escape: TMenuItem;
    InvExecuterepetition1: TMenuItem;
    Goto1: TMenuItem;
    Linkmember1: TMenuItem;
    Paste1: TMenuItem;
    InvPostpone1: TMenuItem;
    InvPriority1: TMenuItem;
    RepetitionHistory1: TMenuItem;
    InvReviewall1: TMenuItem;
    ShowAncestors1: TMenuItem;
    Webimport1: TMenuItem;
    New1: TMenuItem;
    MIAddItem: TMenuItem;
    MIAddTopic: TMenuItem;
    MIAddElement: TMenuItem;
    MIInsertElement: TMenuItem;
    MIDuplicate: TMenuItem;
    N2: TMenuItem;
    MIFolder: TMenuItem;
    MIViewMenu: TMenuItem;
    MIViewElement: TMenuItem;
    MIViewBranch: TMenuItem;
    MIViewDescendants: TMenuItem;
    MIBrowseSelection: TMenuItem;
    Children1: TMenuItem;
    N23: TMenuItem;
    MIViewAsMap: TMenuItem;
    N15: TMenuItem;
    MIGotoParent: TMenuItem;
    MIFirstChild: TMenuItem;
    MILastChild: TMenuItem;
    N16: TMenuItem;
    MICollapse: TMenuItem;
    MIRename: TMenuItem;
    N19: TMenuItem;
    MICopy: TMenuItem;
    MIPaste: TMenuItem;
    MIDelete: TMenuItem;
    MIMoveElement: TMenuItem;
    N6: TMenuItem;
    MILearn: TMenuItem;
    MIDismissElement: TMenuItem;
    Search1: TMenuItem;
    MIFind: TMenuItem;
    MIFindNext: TMenuItem;
    N13: TMenuItem;
    MISearchBranch: TMenuItem;
    N1: TMenuItem;
    MIConcept: TMenuItem;
    MIConvertToConcept: TMenuItem;
    N24: TMenuItem;
    MIMakeRoot: TMenuItem;
    MIMakeHook: TMenuItem;
    MIExport: TMenuItem;
    MITransfer: TMenuItem;
    N5: TMenuItem;
    MIExportDocument1: TMenuItem;
    QAtextfile1: TMenuItem;
    MIExportXML: TMenuItem;
    MIExportHTML: TMenuItem;
    N4: TMenuItem;
    ExportSourceCode: TMenuItem;
    MISaveAsSubset: TMenuItem;
    MIExportLearning: TMenuItem;
    N3: TMenuItem;
    MINameNode: TMenuItem;
    MIRegroupInFolders: TMenuItem;
    MIArrangeFolders: TMenuItem;
    RandomTest: TMenuItem;
    MIFont: TMenuItem;
    MICustomize: TMenuItem;
    MIAutoScroll: TMenuItem;
    MISorted: TMenuItem;
    N12: TMenuItem;
    MIProcessBranch: TMenuItem;
    N7: TMenuItem;
    MIClose: TMenuItem;
    FontDialog1: TFontDialog;
    ScrollTimer: TTimer;
    ProcessMenu: TPopupMenu;
    Changestatus1: TMenuItem;
    MILearn2: TMenuItem;
    MIForce: TMenuItem;
    MIReviewTopics: TMenuItem;
    N14: TMenuItem;
    MIDilute: TMenuItem;
    MIReschedule: TMenuItem;
    N17: TMenuItem;
    MIRemember: TMenuItem;
    MIReset: TMenuItem;
    MIDismiss: TMenuItem;
    MIUndismiss: TMenuItem;
    N18: TMenuItem;
    Done1: TMenuItem;
    N9: TMenuItem;
    MIAddToOutstanding: TMenuItem;
    MIAddAllToOutstanding: TMenuItem;
    MIAddToDrill: TMenuItem;
    N8: TMenuItem;
    MIResetHistory: TMenuItem;
    MIPostpone: TMenuItem;
    Advance1: TMenuItem;
    MIAdvanceTopics: TMenuItem;
    MIAdvanceItems: TMenuItem;
    MIAdvanceAll: TMenuItem;
    N20: TMenuItem;
    MIPriority: TMenuItem;
    MIIncreasePriority: TMenuItem;
    MIDecrease: TMenuItem;
    MISpreadPriority: TMenuItem;
    Modify1: TMenuItem;
    Forgettingindex1: TMenuItem;
    SetForgettingIndex1: TMenuItem;
    MIDefaultForgettingIndex: TMenuItem;
    AFactor1: TMenuItem;
    MISetAFactor: TMenuItem;
    MIModifyAFactor: TMenuItem;
    Ordinal1: TMenuItem;
    MISetOrdinal: TMenuItem;
    MISetDifficultyOrdinal: TMenuItem;
    MISpreadOrdinals: TMenuItem;
    MIBlendOrdinals: TMenuItem;
    MISetPositionOrdinal: TMenuItem;
    Setpendingordinal1: TMenuItem;
    MIModifyOrdinal: TMenuItem;
    N10: TMenuItem;
    MIExport2: TMenuItem;
    MIExportDocument: TMenuItem;
    MIExportQA: TMenuItem;
    MIExportAllTexts: TMenuItem;
    MIMove: TMenuItem;
    MIMoveToBranch: TMenuItem;
    MIMoveToCategory: TMenuItem;
    MITemplate: TMenuItem;
    MIApplyTemplate: TMenuItem;
    MIImposeTemplate: TMenuItem;
    MIDetachTemplate: TMenuItem;
    MIReplaceTemplate: TMenuItem;
    MIAddTemplate: TMenuItem;
    N11: TMenuItem;
    MIInsertPictures: TMenuItem;
    Status1: TMenuItem;
    MIMakeItems: TMenuItem;
    MIMakeTopics: TMenuItem;
    MIMakeConcepts: TMenuItem;
    N22: TMenuItem;
    MISetTitle: TMenuItem;
    MISetConceptGroup: TMenuItem;
    Reference1: TMenuItem;
    MISetReference: TMenuItem;
    MIMergeReferences: TMenuItem;
    MIDeleteReference: TMenuItem;
    N21: TMenuItem;
    MIStatistics: TMenuItem;
    procedure AcceptClick(Sender: TObject);
    procedure Children1Click(Sender: TObject);
    procedure CollapseClick(Sender: TObject);
    procedure CommitClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure DismissClick(Sender: TObject);
    procedure Done1Click(Sender: TObject);
    procedure EscapeClick(Sender: TObject);
    procedure ExportSourceCodeClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure Findnext1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure InvCountBurden1Click(Sender: TObject);
    procedure InvDone1Click(Sender: TObject);
    procedure InvElParams1Click(Sender: TObject);
    procedure InvExecuterepetition1Click(Sender: TObject);
    procedure InvPostpone1Click(Sender: TObject);
    procedure InvPriority1Click(Sender: TObject);
    procedure InvReviewall1Click(Sender: TObject);
    procedure ItemClick(Sender: TObject);
    procedure LearnClick(Sender: TObject);
    procedure Linkmember1Click(Sender: TObject);
    procedure MIAddAllToOutstandingClick(Sender: TObject);
    procedure MIAddElementClick(Sender: TObject);
    procedure MIAddItemClick(Sender: TObject);
    procedure MIAddTemplateClick(Sender: TObject);
    procedure MIAddToDrillClick(Sender: TObject);
    procedure MIAddToOutstandingClick(Sender: TObject);
    procedure MIAddTopicClick(Sender: TObject);
    procedure MIAdvanceAllClick(Sender: TObject);
    procedure MIAdvanceItemsClick(Sender: TObject);
    procedure MIAdvanceTopicsClick(Sender: TObject);
    procedure MIApplyTemplateClick(Sender: TObject);
    procedure MIArrangeFoldersClick(Sender: TObject);
    procedure MIAutoScrollClick(Sender: TObject);
    procedure MIBlendOrdinalsClick(Sender: TObject);
    procedure MIBrowseSelectionClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MICollapseClick(Sender: TObject);
    procedure MIConvertToConceptClick(Sender: TObject);
    procedure MICopyClick(Sender: TObject);
    procedure MIDecreaseClick(Sender: TObject);
    procedure MIDefaultForgettingIndexClick(Sender: TObject);
    procedure MIDeleteReferenceClick(Sender: TObject);
    procedure MIDetachTemplateClick(Sender: TObject);
    procedure MIDiluteClick(Sender: TObject);
    procedure MIDismissElementClick(Sender: TObject);
    procedure MIDuplicateClick(Sender: TObject);
    procedure MIExportAllTextsClick(Sender: TObject);
    procedure MIExportDocument1Click(Sender: TObject);
    procedure MIExportDocumentClick(Sender: TObject);
    procedure MIExportHTMLClick(Sender: TObject);
    procedure MIExportLearningClick(Sender: TObject);
    procedure MIExportQAClick(Sender: TObject);
    procedure MIExportXMLClick(Sender: TObject);
    procedure MIFirstChildClick(Sender: TObject);
    procedure MIFolderClick(Sender: TObject);
    procedure MIFontClick(Sender: TObject);
    procedure MIForceClick(Sender: TObject);
    procedure MIGotoParentClick(Sender: TObject);
    procedure MIImposeTemplateClick(Sender: TObject);
    procedure MIIncreasePriorityClick(Sender: TObject);
    procedure MIInsertElementClick(Sender: TObject);
    procedure MIInsertPicturesClick(Sender: TObject);
    procedure MILastChildClick(Sender: TObject);
    procedure MILearn2Click(Sender: TObject);
    procedure MIMakeConceptsClick(Sender: TObject);
    procedure MIMakeHookClick(Sender: TObject);
    procedure MIMakeRootClick(Sender: TObject);
    procedure MIMergeReferencesClick(Sender: TObject);
    procedure MIModifyAFactorClick(Sender: TObject);
    procedure MIModifyOrdinalClick(Sender: TObject);
    procedure MIMoveElementClick(Sender: TObject);
    procedure MIMoveToBranchClick(Sender: TObject);
    procedure MIMoveToCategoryClick(Sender: TObject);
    procedure MINameNodeClick(Sender: TObject);
    procedure MIPasteClick(Sender: TObject);
    procedure MIPostponeClick(Sender: TObject);
    procedure MIProcessBranchClick(Sender: TObject);
    procedure MIRegroupInFoldersClick(Sender: TObject);
    procedure MIRenameClick(Sender: TObject);
    procedure MIReplaceTemplateClick(Sender: TObject);
    procedure MIRescheduleClick(Sender: TObject);
    procedure MIResetHistoryClick(Sender: TObject);
    procedure MIReviewTopicsClick(Sender: TObject);
    procedure MISaveAsSubsetClick(Sender: TObject);
    procedure MISaveClick(Sender: TObject);
    procedure MISearchBranchClick(Sender: TObject);
    procedure MISetAFactorClick(Sender: TObject);
    procedure MISetConceptGroupClick(Sender: TObject);
    procedure MISetDifficultyOrdinalClick(Sender: TObject);
    procedure MISetOrdinalClick(Sender: TObject);
    procedure MISetPositionOrdinalClick(Sender: TObject);
    procedure MISetReferenceClick(Sender: TObject);
    procedure MISetTitleClick(Sender: TObject);
    procedure MISortedClick(Sender: TObject);
    procedure MISpreadOrdinalsClick(Sender: TObject);
    procedure MISpreadPriorityClick(Sender: TObject);
    procedure MIStatisticsClick(Sender: TObject);
    procedure MITransferClick(Sender: TObject);
    procedure MIViewAsMapClick(Sender: TObject);
    procedure MIViewBranchClick(Sender: TObject);
    procedure MIViewDescendantsClick(Sender: TObject);
    procedure MIViewElementClick(Sender: TObject);
    procedure Modify1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PostponeBtnClick(Sender: TObject);
    procedure ProcessElementsButtonsMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure QAtextfile1Click(Sender: TObject);
    procedure RandomTestClick(Sender: TObject);
    procedure RepetitionHistory1Click(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure RootBtnClick(Sender: TObject);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure SelectTheElementClick(Sender: TObject);
    procedure SetForgettingIndex1Click(Sender: TObject);
    procedure Setpendingordinal1Click(Sender: TObject);
    procedure ShowAncestors1Click(Sender: TObject);
    procedure SplitWithContentsClick(Sender: TObject);
    procedure SplitWithElementClick(Sender: TObject);
    procedure SynchClick(Sender: TObject);
    procedure Topic_Click(Sender: TObject);
    procedure TypeComboChange(Sender: TObject);
    procedure UndismissClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure ViewClick(Sender: TObject);
    procedure Webimport1Click(Sender: TObject);
  end;

var
  Contents: TContents;

implementation

{$R *.lfm}

procedure TContents.AcceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AcceptClick');
end;

procedure TContents.Children1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Children1Click');
end;

procedure TContents.CollapseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CollapseClick');
end;

procedure TContents.CommitClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CommitClick');
end;

procedure TContents.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TContents.DismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DismissClick');
end;

procedure TContents.Done1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Done1Click');
end;

procedure TContents.EscapeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EscapeClick');
end;

procedure TContents.ExportSourceCodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportSourceCodeClick');
end;

procedure TContents.FindClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindClick');
end;

procedure TContents.Findnext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Findnext1Click');
end;

procedure TContents.FormActivate(Sender: TObject);
begin
end;

procedure TContents.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TContents.FormCreate(Sender: TObject);
begin
end;

procedure TContents.FormDeactivate(Sender: TObject);
begin
end;

procedure TContents.FormDestroy(Sender: TObject);
begin
end;

procedure TContents.FormHide(Sender: TObject);
begin
end;

procedure TContents.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TContents.FormResize(Sender: TObject);
begin
end;

procedure TContents.FormShow(Sender: TObject);
begin
end;

procedure TContents.Goto1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Goto1Click');
end;

procedure TContents.InfoButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InfoButtonClick');
end;

procedure TContents.InvCountBurden1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvCountBurden1Click');
end;

procedure TContents.InvDone1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvDone1Click');
end;

procedure TContents.InvElParams1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvElParams1Click');
end;

procedure TContents.InvExecuterepetition1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvExecuterepetition1Click');
end;

procedure TContents.InvPostpone1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPostpone1Click');
end;

procedure TContents.InvPriority1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvPriority1Click');
end;

procedure TContents.InvReviewall1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvReviewall1Click');
end;

procedure TContents.ItemClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ItemClick');
end;

procedure TContents.LearnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LearnClick');
end;

procedure TContents.Linkmember1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Linkmember1Click');
end;

procedure TContents.MIAddAllToOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddAllToOutstandingClick');
end;

procedure TContents.MIAddElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddElementClick');
end;

procedure TContents.MIAddItemClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddItemClick');
end;

procedure TContents.MIAddTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTemplateClick');
end;

procedure TContents.MIAddToDrillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddToDrillClick');
end;

procedure TContents.MIAddToOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddToOutstandingClick');
end;

procedure TContents.MIAddTopicClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTopicClick');
end;

procedure TContents.MIAdvanceAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdvanceAllClick');
end;

procedure TContents.MIAdvanceItemsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdvanceItemsClick');
end;

procedure TContents.MIAdvanceTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAdvanceTopicsClick');
end;

procedure TContents.MIApplyTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplyTemplateClick');
end;

procedure TContents.MIArrangeFoldersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIArrangeFoldersClick');
end;

procedure TContents.MIAutoScrollClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAutoScrollClick');
end;

procedure TContents.MIBlendOrdinalsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBlendOrdinalsClick');
end;

procedure TContents.MIBrowseSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseSelectionClick');
end;

procedure TContents.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TContents.MICollapseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICollapseClick');
end;

procedure TContents.MIConvertToConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConvertToConceptClick');
end;

procedure TContents.MICopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyClick');
end;

procedure TContents.MIDecreaseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDecreaseClick');
end;

procedure TContents.MIDefaultForgettingIndexClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDefaultForgettingIndexClick');
end;

procedure TContents.MIDeleteReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteReferenceClick');
end;

procedure TContents.MIDetachTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDetachTemplateClick');
end;

procedure TContents.MIDiluteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDiluteClick');
end;

procedure TContents.MIDismissElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismissElementClick');
end;

procedure TContents.MIDuplicateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDuplicateClick');
end;

procedure TContents.MIExportAllTextsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportAllTextsClick');
end;

procedure TContents.MIExportDocument1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDocument1Click');
end;

procedure TContents.MIExportDocumentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDocumentClick');
end;

procedure TContents.MIExportHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportHTMLClick');
end;

procedure TContents.MIExportLearningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportLearningClick');
end;

procedure TContents.MIExportQAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportQAClick');
end;

procedure TContents.MIExportXMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportXMLClick');
end;

procedure TContents.MIFirstChildClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFirstChildClick');
end;

procedure TContents.MIFolderClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFolderClick');
end;

procedure TContents.MIFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFontClick');
end;

procedure TContents.MIForceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIForceClick');
end;

procedure TContents.MIGotoParentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGotoParentClick');
end;

procedure TContents.MIImposeTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImposeTemplateClick');
end;

procedure TContents.MIIncreasePriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIncreasePriorityClick');
end;

procedure TContents.MIInsertElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertElementClick');
end;

procedure TContents.MIInsertPicturesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertPicturesClick');
end;

procedure TContents.MILastChildClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILastChildClick');
end;

procedure TContents.MILearn2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearn2Click');
end;

procedure TContents.MIMakeConceptsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMakeConceptsClick');
end;

procedure TContents.MIMakeHookClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMakeHookClick');
end;

procedure TContents.MIMakeRootClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMakeRootClick');
end;

procedure TContents.MIMergeReferencesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMergeReferencesClick');
end;

procedure TContents.MIModifyAFactorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIModifyAFactorClick');
end;

procedure TContents.MIModifyOrdinalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIModifyOrdinalClick');
end;

procedure TContents.MIMoveElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveElementClick');
end;

procedure TContents.MIMoveToBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveToBranchClick');
end;

procedure TContents.MIMoveToCategoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveToCategoryClick');
end;

procedure TContents.MINameNodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINameNodeClick');
end;

procedure TContents.MIPasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteClick');
end;

procedure TContents.MIPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeClick');
end;

procedure TContents.MIProcessBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIProcessBranchClick');
end;

procedure TContents.MIRegroupInFoldersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRegroupInFoldersClick');
end;

procedure TContents.MIRenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenameClick');
end;

procedure TContents.MIReplaceTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReplaceTemplateClick');
end;

procedure TContents.MIRescheduleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRescheduleClick');
end;

procedure TContents.MIResetHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetHistoryClick');
end;

procedure TContents.MIReviewTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReviewTopicsClick');
end;

procedure TContents.MISaveAsSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveAsSubsetClick');
end;

procedure TContents.MISaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveClick');
end;

procedure TContents.MISearchBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchBranchClick');
end;

procedure TContents.MISetAFactorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetAFactorClick');
end;

procedure TContents.MISetConceptGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetConceptGroupClick');
end;

procedure TContents.MISetDifficultyOrdinalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetDifficultyOrdinalClick');
end;

procedure TContents.MISetOrdinalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetOrdinalClick');
end;

procedure TContents.MISetPositionOrdinalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetPositionOrdinalClick');
end;

procedure TContents.MISetReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetReferenceClick');
end;

procedure TContents.MISetTitleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetTitleClick');
end;

procedure TContents.MISortedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortedClick');
end;

procedure TContents.MISpreadOrdinalsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISpreadOrdinalsClick');
end;

procedure TContents.MISpreadPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISpreadPriorityClick');
end;

procedure TContents.MIStatisticsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStatisticsClick');
end;

procedure TContents.MITransferClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferClick');
end;

procedure TContents.MIViewAsMapClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewAsMapClick');
end;

procedure TContents.MIViewBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewBranchClick');
end;

procedure TContents.MIViewDescendantsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewDescendantsClick');
end;

procedure TContents.MIViewElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewElementClick');
end;

procedure TContents.Modify1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Modify1Click');
end;

procedure TContents.PopupMenu1Popup(Sender: TObject);
begin
  DispatchAction(Sender, 'PopupMenu1Popup');
end;

procedure TContents.PostponeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PostponeBtnClick');
end;

procedure TContents.ProcessElementsButtonsMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TContents.QAtextfile1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'QAtextfile1Click');
end;

procedure TContents.RandomTestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RandomTestClick');
end;

procedure TContents.RepetitionHistory1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'RepetitionHistory1Click');
end;

procedure TContents.ResetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetClick');
end;

procedure TContents.RootBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RootBtnClick');
end;

procedure TContents.ScrollTimerTimer(Sender: TObject);
begin
end;

procedure TContents.SelectTheElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectTheElementClick');
end;

procedure TContents.SetForgettingIndex1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SetForgettingIndex1Click');
end;

procedure TContents.Setpendingordinal1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Setpendingordinal1Click');
end;

procedure TContents.ShowAncestors1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ShowAncestors1Click');
end;

procedure TContents.SplitWithContentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SplitWithContentsClick');
end;

procedure TContents.SplitWithElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SplitWithElementClick');
end;

procedure TContents.SynchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SynchClick');
end;

procedure TContents.Topic_Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Topic_Click');
end;

procedure TContents.TypeComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TypeComboChange');
end;

procedure TContents.UndismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UndismissClick');
end;

procedure TContents.ViewBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewBtnClick');
end;

procedure TContents.ViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewClick');
end;

procedure TContents.Webimport1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Webimport1Click');
end;

initialization
  if GetClass('TContents') = nil then
    RegisterClass(TContents);

end.
