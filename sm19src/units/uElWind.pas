unit uElWind;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TElWind = class(TForm)
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    Shadow: TShape;
    SpellResult: TMemo;
    CreditPanel: TPanel;
    NavBar: TToolBar;
    PickCollection: TToolButton;
    ToolButton1: TToolButton;
    ContentsBtn: TToolButton;
    ToolButton4: TToolButton;
    SearchBtn: TToolButton;
    ToolButton5: TToolButton;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    ToolButton11: TToolButton;
    HistoryBtn: TToolButton;
    ToolButton2: TToolButton;
    HomeB: TToolButton;
    PElementB: TToolButton;
    ParentB: TToolButton;
    NElementB: TToolButton;
    EndB: TToolButton;
    ToolButton16: TToolButton;
    FindBtn: TToolButton;
    ReplaceBtn: TToolButton;
    ReferenceBtn: TToolButton;
    ToolsBtn: TToolButton;
    MailBtn: TToolButton;
    CommanderBtn: TToolButton;
    DownloadBtn: TToolButton;
    LayoutsBtn: TToolButton;
    HelpBtn: TToolButton;
    LinkConceptBtn: TToolButton;
    DefaultConceptBtn: TToolButton;
    ConceptEdit: TEdit;
    ComputePasswordBtn: TToolButton;
    Test: TToolButton;
    ToolButton25: TToolButton;
    CaptionPanel: TPanel;
    LearnPanel: TPanel;
    LearnBar: TToolBar;
    Stop: TToolButton;
    ButtonsSeparator: TToolButton;
    AddNoteBtn: TToolButton;
    PasteArticleBtn: TToolButton;
    ExtractButton: TToolButton;
    ClozeButton: TToolButton;
    ToolButton7: TToolButton;
    PriorityPercent: TLabel;
    PriorityPosition: TLabel;
    PriorityBtn: TToolButton;
    IntervalLabel: TLabel;
    RepsLabel: TLabel;
    ForceRepetitionBtn: TToolButton;
    NextRepLabel: TLabel;
    NextRepDate: TToolButton;
    RLabel: TLabel;
    SLabel: TLabel;
    Done: TToolButton;
    ApplyTemplateBtn: TToolButton;
    FontBtn: TToolButton;
    PlainTextBtn: TToolButton;
    EditBtn: TToolButton;
    ToolButton3: TToolButton;
    DuplicateBtn: TToolButton;
    CopyBtn: TToolButton;
    PasteBtn: TToolButton;
    ToolButton6: TToolButton;
    ImportBtn: TToolButton;
    EditFileBtn: TToolButton;
    LearnBarHelp: TToolButton;
    LearnbarTabs: TTabControl;
    GradePanel: TPanel;
    Great: TBitBtn;
    Good: TBitBtn;
    Pass: TBitBtn;
    Fail: TBitBtn;
    Bad: TBitBtn;
    CancelGrade: TBitBtn;
    Learn: TBitBtn;
    AddNew: TBitBtn;
    CancelShowAnswer: TBitBtn;
    ElementMenu: TPopupMenu;
    MILearningMenu: TMenuItem;
    MIForceRepetition: TMenuItem;
    MIJumpInterval: TMenuItem;
    MILaterToday: TMenuItem;
    MIDrill: TMenuItem;
    MIAddToSubset: TMenuItem;
    N7: TMenuItem;
    MIRemember: TMenuItem;
    MIReset: TMenuItem;
    MIDismiss: TMenuItem;
    MIDone: TMenuItem;
    MIUndoRepetition: TMenuItem;
    N48: TMenuItem;
    MILearnBranch: TMenuItem;
    MIPostpone: TMenuItem;
    MILocateExtracts: TMenuItem;
    N27: TMenuItem;
    Statistics1: TMenuItem;
    MIShowRepetitionHistory: TMenuItem;
    MIMemoryStatus: TMenuItem;
    MIResetRepHist: TMenuItem;
    MIBestForgettingIndex: TMenuItem;
    MIOptimumRepetitionSchedule: TMenuItem;
    MINextRepetitionSInc: TMenuItem;
    MIRepetitionsSimulation: TMenuItem;
    MIDifficultyAnalysis: TMenuItem;
    Concept1: TMenuItem;
    MICreateConcept: TMenuItem;
    MILinkConcept: TMenuItem;
    MIUnlinkConcept: TMenuItem;
    N82: TMenuItem;
    MICreateLink: TMenuItem;
    MILinkElement: TMenuItem;
    MILinkBranch: TMenuItem;
    MIUnlinkElement: TMenuItem;
    N83: TMenuItem;
    MIListLinks: TMenuItem;
    MIConceptMap: TMenuItem;
    Priority1: TMenuItem;
    MIModifyPriority: TMenuItem;
    MIIncreasePriority: TMenuItem;
    MIDecreasePriority: TMenuItem;
    MIReferenceMenu: TMenuItem;
    MILinkReference: TMenuItem;
    MIEditReference: TMenuItem;
    MIAddReference: TMenuItem;
    MIDeleteReference: TMenuItem;
    MIDeprecate: TMenuItem;
    N15: TMenuItem;
    MICopyReferences: TMenuItem;
    MIShowReferences: TMenuItem;
    MICitation: TMenuItem;
    MIShowCitation: TMenuItem;
    MIInsertCitation: TMenuItem;
    MIEMailElement: TMenuItem;
    MISendElement: TMenuItem;
    MISendAsAttachment: TMenuItem;
    N4: TMenuItem;
    MIMailQA: TMenuItem;
    MIMailTexts: TMenuItem;
    MISendHTML: TMenuItem;
    N30: TMenuItem;
    MITemplateMenu: TMenuItem;
    MISaveAsTemplate: TMenuItem;
    MISaveAsDefault: TMenuItem;
    Savewithobjects1: TMenuItem;
    N28: TMenuItem;
    MIApplyTemplate: TMenuItem;
    MIDetachTemplate: TMenuItem;
    MIImposeTemplate: TMenuItem;
    MIAddTemplate: TMenuItem;
    N29: TMenuItem;
    MISwapSourceView: TMenuItem;
    N6: TMenuItem;
    MISaveToFile: TMenuItem;
    MILoadTemplateFromFile: TMenuItem;
    N9: TMenuItem;
    Copytemplate1: TMenuItem;
    MIPasteTemplate1: TMenuItem;
    N36: TMenuItem;
    MIFlags: TMenuItem;
    MIDeleteTemplateExtras: TMenuItem;
    MISkipSourceExtras: TMenuItem;
    MICheckSourceExtras: TMenuItem;
    MICheckTemplateExtras: TMenuItem;
    MICopyTexts: TMenuItem;
    MICopyElementSource: TMenuItem;
    MICopyQA: TMenuItem;
    MICopyText: TMenuItem;
    MICopyComponent: TMenuItem;
    MIElementPaste: TMenuItem;
    MIEditPopup: TMenuItem;
    MIEditParamters: TMenuItem;
    N16: TMenuItem;
    MITitle: TMenuItem;
    MIDuplicate: TMenuItem;
    MIMoveElement: TMenuItem;
    MITransferElement: TMenuItem;
    MISwap: TMenuItem;
    MIDismember: TMenuItem;
    N18: TMenuItem;
    MICopyToClipboard: TMenuItem;
    MIPasteElement: TMenuItem;
    MIPasteTemplate: TMenuItem;
    N37: TMenuItem;
    MIBrowseBranch: TMenuItem;
    N59: TMenuItem;
    MIBackground: TMenuItem;
    MIImportBackground: TMenuItem;
    MILinkBackground: TMenuItem;
    MIBckgArrangement: TMenuItem;
    MIBckgTopLeft: TMenuItem;
    MIBckgCenter: TMenuItem;
    MIBckgTile: TMenuItem;
    MIBckgStretch: TMenuItem;
    N5: TMenuItem;
    MIBckgDelete: TMenuItem;
    MIElColor: TMenuItem;
    MIScaleable: TMenuItem;
    MIAutoPlay: TMenuItem;
    MIElementType: TMenuItem;
    MIItem: TMenuItem;
    MITopic: TMenuItem;
    MIConcept: TMenuItem;
    MITask: TMenuItem;
    N10: TMenuItem;
    MIComponent: TMenuItem;
    MIMode: TMenuItem;
    MIPresentationmode: TMenuItem;
    MIEditingmode: TMenuItem;
    MIDraggingmode: TMenuItem;
    N70: TMenuItem;
    MISwitchComponentMode: TMenuItem;
    N42: TMenuItem;
    ComponentOrder1: TMenuItem;
    MITileComponents: TMenuItem;
    MIFitComponentSize: TMenuItem;
    MIFitAllPictures: TMenuItem;
    MICompressImages: TMenuItem;
    MIAlignment: TMenuItem;
    N52: TMenuItem;
    MITestRepetition: TMenuItem;
    MIRepleatAutoPlay: TMenuItem;
    N20: TMenuItem;
    Tab1: TMenuItem;
    ShiftTab1: TMenuItem;
    N1: TMenuItem;
    MITranslate: TMenuItem;
    MITransliterate: TMenuItem;
    MIDeleteComponents: TMenuItem;
    MIDeleteElement: TMenuItem;
    N3: TMenuItem;
    MIGoTo: TMenuItem;
    MIGoToElement: TMenuItem;
    Nexthierarchyelement1: TMenuItem;
    Previoushierarchyelement1: TMenuItem;
    FirstElement1: TMenuItem;
    LastElement1: TMenuItem;
    MIParentElement: TMenuItem;
    MINextSibling: TMenuItem;
    MIPreviousSibling: TMenuItem;
    MIFirstChild: TMenuItem;
    MILastChild: TMenuItem;
    N45: TMenuItem;
    Back1: TMenuItem;
    Forward1: TMenuItem;
    N12: TMenuItem;
    MIPath: TMenuItem;
    N40: TMenuItem;
    MINextElement: TMenuItem;
    MIPreviousElement: TMenuItem;
    N38: TMenuItem;
    InvSelectAll1: TMenuItem;
    InvCancelGrade1: TMenuItem;
    OpenDialog1: TOpenDialog;
    FontDialog1: TFontDialog;
    AutoplayTimer: TTimer;
    UntranslateTimer: TTimer;
    ComponentMenu: TPopupMenu;
    MIReading: TMenuItem;
    MIRememberExtract: TMenuItem;
    MIScheduleExtract: TMenuItem;
    MIQueueExtraction: TMenuItem;
    MIExtractTask: TMenuItem;
    N19: TMenuItem;
    MIRememberCloze: TMenuItem;
    MIScheduleCloze: TMenuItem;
    MIQueueCloze: TMenuItem;
    N50: TMenuItem;
    MIDeletePriorText: TMenuItem;
    MIDeleteAfterText: TMenuItem;
    MIDeleteProcessedTexts: TMenuItem;
    Split1: TMenuItem;
    MIInsertHorizontalLine: TMenuItem;
    MISplitArticle: TMenuItem;
    MIDecompose: TMenuItem;
    N26: TMenuItem;
    Readpoints1: TMenuItem;
    MISetReadPoint: TMenuItem;
    MIGoToReadPoint: TMenuItem;
    MIClearReadPoint: TMenuItem;
    N23: TMenuItem;
    MIEMail: TMenuItem;
    MIEMailFAQ: TMenuItem;
    N58: TMenuItem;
    MIHighlight: TMenuItem;
    MIIgnoreText: TMenuItem;
    MITextsMenu: TMenuItem;
    MIStyle: TMenuItem;
    MINewStyle: TMenuItem;
    Linkstyle1: TMenuItem;
    MIEditStyle: TMenuItem;
    MIDefaultStyle: TMenuItem;
    N02: TMenuItem;
    MIEditStylesheet: TMenuItem;
    Font1: TMenuItem;
    MINewFont: TMenuItem;
    MILinkFont: TMenuItem;
    MIEditFont: TMenuItem;
    MIDefaultFont: TMenuItem;
    MIFontColor: TMenuItem;
    N24: TMenuItem;
    MITextAlignment: TMenuItem;
    MIAlignLeft: TMenuItem;
    MIAlignCenter: TMenuItem;
    MIAlignRight: TMenuItem;
    N14: TMenuItem;
    MIRTL: TMenuItem;
    MIDefaultRTL: TMenuItem;
    MITransparent: TMenuItem;
    MICaseSensitive: TMenuItem;
    N25: TMenuItem;
    MIFullHTML: TMenuItem;
    MIPasteHTML: TMenuItem;
    MIReadOnly: TMenuItem;
    N8: TMenuItem;
    MIConvert: TMenuItem;
    MIFilter: TMenuItem;
    MIPlainText: TMenuItem;
    MIParseHTML: TMenuItem;
    MICleanleadHTML: TMenuItem;
    N60: TMenuItem;
    MIUnitConversion: TMenuItem;
    N47: TMenuItem;
    MIDecodeUTF8: TMenuItem;
    MIEncodeUTF8: TMenuItem;
    MIUnicode: TMenuItem;
    MICase: TMenuItem;
    MICaseLower: TMenuItem;
    MICaseUpper: TMenuItem;
    MICaseCapitalized: TMenuItem;
    N46: TMenuItem;
    MISpellCheck: TMenuItem;
    MIImageMenu: TMenuItem;
    MIExtractImage: TMenuItem;
    N54: TMenuItem;
    MIZoom: TMenuItem;
    MIUnzoom: TMenuItem;
    MICrop: TMenuItem;
    MIClone: TMenuItem;
    MICompressImage: TMenuItem;
    MIScaleImage: TMenuItem;
    MIZoomOptions: TMenuItem;
    N56: TMenuItem;
    MIImageSize: TMenuItem;
    MIImageNormal: TMenuItem;
    MIImageStretch: TMenuItem;
    MIImageFill: TMenuItem;
    N39: TMenuItem;
    MISwitchImageSize: TMenuItem;
    MIFitPictureSize: TMenuItem;
    MIImageTransparent: TMenuItem;
    Use1: TMenuItem;
    MIUseAsAboutBox: TMenuItem;
    MIUseOnDesktop: TMenuItem;
    WindowsDesktop1: TMenuItem;
    MISendPicture: TMenuItem;
    Convert2: TMenuItem;
    MIConvertToJPG: TMenuItem;
    MIConvertToGIF: TMenuItem;
    MIConvertToPng: TMenuItem;
    MIConverttoBMP: TMenuItem;
    N57: TMenuItem;
    MIEditHitArea: TMenuItem;
    MISoundMenu: TMenuItem;
    MIPanel: TMenuItem;
    MINoPanel: TMenuItem;
    MISliderPanel: TMenuItem;
    MIRecorderPanel: TMenuItem;
    MIButtonsPanel: TMenuItem;
    MIResetExtract: TMenuItem;
    MIContinuousPlay: TMenuItem;
    MIFullScreen: TMenuItem;
    MIFrames: TMenuItem;
    MIScript: TMenuItem;
    MIShapeMenu: TMenuItem;
    Solid2: TMenuItem;
    Cross1: TMenuItem;
    Horizontal1: TMenuItem;
    Vertical1: TMenuItem;
    Clear1: TMenuItem;
    MICopyCutPaste: TMenuItem;
    MIUndo: TMenuItem;
    N33: TMenuItem;
    MICut: TMenuItem;
    MICopy: TMenuItem;
    MIComponentPaste: TMenuItem;
    MIDeleteContent: TMenuItem;
    N34: TMenuItem;
    MISelectAll: TMenuItem;
    N53: TMenuItem;
    MICopyTranscription: TMenuItem;
    MILinksMenu: TMenuItem;
    MILinkMember: TMenuItem;
    MIRenameMember: TMenuItem;
    MIHyperlink: TMenuItem;
    MIHyperlinkNumber: TMenuItem;
    N2: TMenuItem;
    MILinkStyle: TMenuItem;
    MIFontLink: TMenuItem;
    MIClickPlay: TMenuItem;
    MILinkExternal: TMenuItem;
    N22: TMenuItem;
    MIOpenHyperlinks: TMenuItem;
    N17: TMenuItem;
    MIDeleteLink: TMenuItem;
    MIDeleteHyperlink: TMenuItem;
    MIDownloadFile: TMenuItem;
    MIWebSearch: TMenuItem;
    MIOpenInNewWindow: TMenuItem;
    N55: TMenuItem;
    MIAnswer: TMenuItem;
    MITest: TMenuItem;
    MITestNone: TMenuItem;
    MITestWrong: TMenuItem;
    MITestCorrect: TMenuItem;
    MICompColor: TMenuItem;
    MIDefaultColor: TMenuItem;
    MIDisplayAt: TMenuItem;
    MIPlayAt: TMenuItem;
    N32: TMenuItem;
    MIReference: TMenuItem;
    MISelectReference: TMenuItem;
    MITitleRef: TMenuItem;
    MIAuthor: TMenuItem;
    MIDateRef: TMenuItem;
    MISource: TMenuItem;
    Email1: TMenuItem;
    Link1: TMenuItem;
    MIComment: TMenuItem;
    N11: TMenuItem;
    MIEditReferences: TMenuItem;
    N62: TMenuItem;
    MIDownload: TMenuItem;
    MISearchText: TMenuItem;
    MIHTML: TMenuItem;
    MILinkToURL: TMenuItem;
    MIInsertElementLink: TMenuItem;
    MILinkToElementNo: TMenuItem;
    MILinkToTextRegistry: TMenuItem;
    LinkToHTMLFile: TMenuItem;
    MILinkImage: TMenuItem;
    MIInsertRegistryScriptLink: TMenuItem;
    MIDownloadImages: TMenuItem;
    MIInsertOLE: TMenuItem;
    MIOLEProperties: TMenuItem;
    MIButtonText: TMenuItem;
    MIPlayButtonText: TMenuItem;
    MIStopButtonText: TMenuItem;
    MenuItem4: TMenuItem;
    MIDeleteComponent: TMenuItem;
    MIEditMenu: TMenuItem;
    MIViewFile: TMenuItem;
    MIEditFile: TMenuItem;
    MIImport: TMenuItem;
    MISaveFile: TMenuItem;
    MIDeleteFile: TMenuItem;
    MICopyPath: TMenuItem;
    N44: TMenuItem;
    MIViewSource: TMenuItem;
    MIPasteSpecial: TMenuItem;
    N35: TMenuItem;
    MISelectPreviousComponents: TMenuItem;
    SelectNextComponent1: TMenuItem;
    MICompMode: TMenuItem;
    MIDisplay: TMenuItem;
    MIEdit: TMenuItem;
    MIDrag: TMenuItem;
    N13: TMenuItem;
    MISendToBack: TMenuItem;
    MIBrowserMenu: TMenuItem;
    ScriptTimer: TTimer;
    Searches: TPopupMenu;
    MISearchSubstring: TMenuItem;
    MISearchLexicon: TMenuItem;
    MISearchTextRegistry: TMenuItem;
    MITextRegistry: TMenuItem;
    MIFindInText: TMenuItem;
    N65: TMenuItem;
    MISearchAndReplace: TMenuItem;
    N64: TMenuItem;
    MIAncestors: TMenuItem;
    Imports: TPopupMenu;
    MIPasteArticle: TMenuItem;
    MIImportArticle: TMenuItem;
    InternetExplorer1: TMenuItem;
    Alldocuments1: TMenuItem;
    Wikipediaarticles1: TMenuItem;
    YouTubevideos1: TMenuItem;
    MIImportPictures: TMenuItem;
    Importmail1: TMenuItem;
    MIImportfile2: TMenuItem;
    Schedule: TPopupMenu;
    MIOutstanding: TMenuItem;
    MIWorkload: TMenuItem;
    N31: TMenuItem;
    MIExecuteRepetition: TMenuItem;
    MIReschedule: TMenuItem;
    MILaterToday2: TMenuItem;
    N79: TMenuItem;
    MIDismiss2: TMenuItem;
    MIRemember2: TMenuItem;
    MIForget: TMenuItem;
    N73: TMenuItem;
    MIMercy: TMenuItem;
    Del: TPopupMenu;
    MIDone2: TMenuItem;
    Dismiss1: TMenuItem;
    N80: TMenuItem;
    Deleteselection1: TMenuItem;
    MIDeleteComponent2: TMenuItem;
    MIDeleteComponents2: TMenuItem;
    MIDeleteElement2: TMenuItem;
    Files: TPopupMenu;
    MIViewFile2: TMenuItem;
    MIViewSource2: TMenuItem;
    Editfile1: TMenuItem;
    MIImportFile: TMenuItem;
    MISaveFile2: TMenuItem;
    PlayerSeparator: TMenuItem;
    MIYTPlayerVersion: TMenuItem;
    Mail: TPopupMenu;
    MISendElement2: TMenuItem;
    Sendpicture1: TMenuItem;
    MIMailTexts2: TMenuItem;
    MISendHTML2: TMenuItem;
    MIReplyToSelection: TMenuItem;
    MIEMailFAQ2: TMenuItem;
    Text_Ctl: TPopupMenu;
    MIParseHTML2: TMenuItem;
    MICleanleadHTML2: TMenuItem;
    MIPlainText2: TMenuItem;
    MIFilterHTML2: TMenuItem;
    N78: TMenuItem;
    MIEditStylesheet2: TMenuItem;
    N66: TMenuItem;
    MICaseUpper2: TMenuItem;
    MICaseLower2: TMenuItem;
    MICaseCapitalized2: TMenuItem;
    N72: TMenuItem;
    MIUnitConversion2: TMenuItem;
    N67: TMenuItem;
    MITranscription: TMenuItem;
    MITranslateTexts: TMenuItem;
    Dup: TPopupMenu;
    MIDuplicateElement: TMenuItem;
    MITransferElement2: TMenuItem;
    MIMoveElement2: TMenuItem;
    Copyandmove1: TMenuItem;
    MISwapQA: TMenuItem;
    N75: TMenuItem;
    MICopyElementSourceToClipboard: TMenuItem;
    MIPasteElement2: TMenuItem;
    Switch: TPopupMenu;
    MISwitchMode2: TMenuItem;
    N76: TMenuItem;
    MIPresentationmode3: TMenuItem;
    MIEditingmode3: TMenuItem;
    MIDraggingmode3: TMenuItem;
    N77: TMenuItem;
    MITile: TMenuItem;
    MITitle2: TMenuItem;
    N74: TMenuItem;
    MIEditReference2: TMenuItem;
    MISelectReference2: TMenuItem;
    Tools: TPopupMenu;
    MICommander: TMenuItem;
    MIOptions: TMenuItem;
    MIElementMenu: TMenuItem;
    MIComponentMenu: TMenuItem;
    Templates: TPopupMenu;
    MIApplyTemplate2: TMenuItem;
    MISaveTemplate: TMenuItem;
    MISaveTemplateAsDefault: TMenuItem;
    MIImposeTemplate2: TMenuItem;
    MIDetachTemplate2: TMenuItem;
    Read: TPopupMenu;
    Extract1: TMenuItem;
    Cloze1: TMenuItem;
    N49: TMenuItem;
    Split2: TMenuItem;
    N63: TMenuItem;
    MIHighlight2: TMenuItem;
    MIIgnore: TMenuItem;
    N43: TMenuItem;
    MIDeleteBeforeCursor2: TMenuItem;
    MIDeleteAfterCursor2: TMenuItem;
    Layouts: TPopupMenu;
    MILayoutManager: TMenuItem;
    MIApplydefaultlayout: TMenuItem;
    MISaveLayout: TMenuItem;
    MISaveDefaultLayout: TMenuItem;
    CopyMenu: TPopupMenu;
    MICut2: TMenuItem;
    MICopy2: TMenuItem;
    MIPaste: TMenuItem;
    MIDelete: TMenuItem;
    N68: TMenuItem;
    MISelectAll2: TMenuItem;
    AddComponents: TPopupMenu;
    MIAddHTMLComponent: TMenuItem;
    MIAddTextComponent: TMenuItem;
    MIAddImage: TMenuItem;
    MIAddSound: TMenuItem;
    MIAddVideo: TMenuItem;
    N69: TMenuItem;
    MIPresentationMode2: TMenuItem;
    MIEditingMode2: TMenuItem;
    MIDraggingMode2: TMenuItem;
    MISwitchMode: TMenuItem;
    AlarmMenu: TPopupMenu;
    MISetAlarm: TMenuItem;
    Cancelalarm1: TMenuItem;
    Choosemusic1: TMenuItem;
    PriorityMenu: TPopupMenu;
    MISetPriority: TMenuItem;
    MISetFI: TMenuItem;
    MIElementParameters: TMenuItem;
    Concepts: TPopupMenu;
    MILinkConcept1: TMenuItem;
    MIListLinks1: TMenuItem;
    Unlinkconcept1: TMenuItem;
    MIUnlinkElement1: TMenuItem;
    N84: TMenuItem;
    MICreateConcept1: TMenuItem;
    N21: TMenuItem;
    MIConceptMap1: TMenuItem;
    ImageList1: TImageList;
    Hyperlinks: TPopupMenu;
    Openhyperlink1: TMenuItem;
    Openparsed1: TMenuItem;
    N41: TMenuItem;
    Gotoroot1: TMenuItem;
    Changeroot1: TMenuItem;
    Resetroot1: TMenuItem;
    procedure AddNewClick(Sender: TObject);
    procedure AddNoteBtnClick(Sender: TObject);
    procedure Alldocuments1Click(Sender: TObject);
    procedure AutoplayTimerTimer(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure BadClick(Sender: TObject);
    procedure CancelLearningClick(Sender: TObject);
    procedure Cancelalarm1Click(Sender: TObject);
    procedure Changeroot1Click(Sender: TObject);
    procedure Choosemusic1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ClozeButtonClick(Sender: TObject);
    procedure CommanderBtnClick(Sender: TObject);
    procedure ComponentMenuPopup(Sender: TObject);
    procedure ComponentOrder1Click(Sender: TObject);
    procedure ComputePasswordBtnClick(Sender: TObject);
    procedure ConceptEditClick(Sender: TObject);
    procedure ContentsClick(Sender: TObject);
    procedure CreditPanelClick(Sender: TObject);
    procedure Cross1Click(Sender: TObject);
    procedure DefaultConceptBtnClick(Sender: TObject);
    procedure DoneClick(Sender: TObject);
    procedure DownloadBtnClick(Sender: TObject);
    procedure EditFileBtnClick(Sender: TObject);
    procedure ElementMenuPopup(Sender: TObject);
    procedure Email1Click(Sender: TObject);
    procedure ExtractButtonClick(Sender: TObject);
    procedure FailClick(Sender: TObject);
    procedure FilesPopup(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FirstElement1Click(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure ForceRepetitionBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDragDrop(Sender, ASource: TObject; X, AY: Integer);
    procedure FormDragOver(Sender, ASource: TObject; X, AY: Integer; AState: TDragState; var AAccept: Boolean);
    procedure FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FormMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure FormMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure FormMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure FormResize(Sender: TObject);
    procedure ForwardButtonClick(Sender: TObject);
    procedure GoodClick(Sender: TObject);
    procedure Gotoroot1Click(Sender: TObject);
    procedure GreatClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure HistoryButtonClick(Sender: TObject);
    procedure Horizontal1Click(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure Importmail1Click(Sender: TObject);
    procedure InvCancelgrade1Click(Sender: TObject);
    procedure InvSelectAll1Click(Sender: TObject);
    procedure LastElement1Click(Sender: TObject);
    procedure LayoutsBtnClick(Sender: TObject);
    procedure LearnBarHelpClick(Sender: TObject);
    procedure LearnClick(Sender: TObject);
    procedure LearnbarTabsChange(Sender: TObject);
    procedure LearnbarTabsGetImageIndex(Sender: TObject);
    procedure Link1Click(Sender: TObject);
    procedure LinkConceptBtnClick(Sender: TObject);
    procedure LinkToHTMLFileClick(Sender: TObject);
    procedure MIAddHTMLComponentClick(Sender: TObject);
    procedure MIAddImageClick(Sender: TObject);
    procedure MIAddReferenceClick(Sender: TObject);
    procedure MIAddSoundClick(Sender: TObject);
    procedure MIAddTemplateClick(Sender: TObject);
    procedure MIAddTextComponentClick(Sender: TObject);
    procedure MIAddToSubsetClick(Sender: TObject);
    procedure MIAddVideoClick(Sender: TObject);
    procedure MIAlignCenterClick(Sender: TObject);
    procedure MIAlignLeftClick(Sender: TObject);
    procedure MIAlignRightClick(Sender: TObject);
    procedure MIAlignmentClick(Sender: TObject);
    procedure MIAnswerClick(Sender: TObject);
    procedure MIApplyTemplateClick(Sender: TObject);
    procedure MIApplydefaultlayoutClick(Sender: TObject);
    procedure MIAuthorClick(Sender: TObject);
    procedure MIAutoPlayClick(Sender: TObject);
    procedure MIBackgroundClick(Sender: TObject);
    procedure MIBckgArrangementClick(Sender: TObject);
    procedure MIBckgCenterClick(Sender: TObject);
    procedure MIBckgDeleteClick(Sender: TObject);
    procedure MIBckgStretchClick(Sender: TObject);
    procedure MIBckgTileClick(Sender: TObject);
    procedure MIBckgTopLeftClick(Sender: TObject);
    procedure MIBestForgettingIndexClick(Sender: TObject);
    procedure MIBrowseBranchClick(Sender: TObject);
    procedure MIBrowserMenuClick(Sender: TObject);
    procedure MIButtonsPanelClick(Sender: TObject);
    procedure MICaseCapitalizedClick(Sender: TObject);
    procedure MICaseLowerClick(Sender: TObject);
    procedure MICaseSensitiveClick(Sender: TObject);
    procedure MICaseUpperClick(Sender: TObject);
    procedure MICheckSourceExtrasClick(Sender: TObject);
    procedure MICheckTemplateExtrasClick(Sender: TObject);
    procedure MICleanleadHTMLClick(Sender: TObject);
    procedure MIClearReadPointClick(Sender: TObject);
    procedure MIClickPlayClick(Sender: TObject);
    procedure MICloneClick(Sender: TObject);
    procedure MICommanderClick(Sender: TObject);
    procedure MICommentClick(Sender: TObject);
    procedure MICompColorClick(Sender: TObject);
    procedure MICompModeClick(Sender: TObject);
    procedure MIComponentMenuClick(Sender: TObject);
    procedure MIComponentPasteClick(Sender: TObject);
    procedure MICompressImageClick(Sender: TObject);
    procedure MICompressImagesClick(Sender: TObject);
    procedure MIConceptClick(Sender: TObject);
    procedure MIConceptMapClick(Sender: TObject);
    procedure MIContinuousPlayClick(Sender: TObject);
    procedure MIConvertToGIFClick(Sender: TObject);
    procedure MIConvertToJPGClick(Sender: TObject);
    procedure MIConvertToPngClick(Sender: TObject);
    procedure MIConverttoBMPClick(Sender: TObject);
    procedure MICopyClick(Sender: TObject);
    procedure MICopyComponentClick(Sender: TObject);
    procedure MICopyCutPasteClick(Sender: TObject);
    procedure MICopyElementSourceClick(Sender: TObject);
    procedure MICopyPathClick(Sender: TObject);
    procedure MICopyQAClick(Sender: TObject);
    procedure MICopyReferencesClick(Sender: TObject);
    procedure MICopyTextClick(Sender: TObject);
    procedure MICopyTextsClick(Sender: TObject);
    procedure MICopyToClipboardClick(Sender: TObject);
    procedure MICopyTranscriptionClick(Sender: TObject);
    procedure MICreateConceptClick(Sender: TObject);
    procedure MICreateLinkClick(Sender: TObject);
    procedure MICropClick(Sender: TObject);
    procedure MICutClick(Sender: TObject);
    procedure MIDateRefClick(Sender: TObject);
    procedure MIDecodeUTF8Click(Sender: TObject);
    procedure MIDecomposeClick(Sender: TObject);
    procedure MIDecreasePriorityClick(Sender: TObject);
    procedure MIDefaultColorClick(Sender: TObject);
    procedure MIDefaultFontClick(Sender: TObject);
    procedure MIDefaultRTLClick(Sender: TObject);
    procedure MIDefaultStyleClick(Sender: TObject);
    procedure MIDeleteAfterTextClick(Sender: TObject);
    procedure MIDeleteBeforeCursorClick(Sender: TObject);
    procedure MIDeleteComponentClick(Sender: TObject);
    procedure MIDeleteComponentsClick(Sender: TObject);
    procedure MIDeleteContentClick(Sender: TObject);
    procedure MIDeleteElementClick(Sender: TObject);
    procedure MIDeleteFileClick(Sender: TObject);
    procedure MIDeleteHyperlinkClick(Sender: TObject);
    procedure MIDeleteLinkClick(Sender: TObject);
    procedure MIDeleteProcessedTextsClick(Sender: TObject);
    procedure MIDeleteReferenceClick(Sender: TObject);
    procedure MIDeleteTemplateExtrasClick(Sender: TObject);
    procedure MIDeprecateClick(Sender: TObject);
    procedure MIDetachTemplateClick(Sender: TObject);
    procedure MIDifficultyAnalysisClick(Sender: TObject);
    procedure MIDismemberClick(Sender: TObject);
    procedure MIDismissClick(Sender: TObject);
    procedure MIDisplayAtClick(Sender: TObject);
    procedure MIDisplayClick(Sender: TObject);
    procedure MIDownloadClick(Sender: TObject);
    procedure MIDownloadFileClick(Sender: TObject);
    procedure MIDownloadImagesClick(Sender: TObject);
    procedure MIDragClick(Sender: TObject);
    procedure MIDraggingmodeClick(Sender: TObject);
    procedure MIDrillClick(Sender: TObject);
    procedure MIDuplicateClick(Sender: TObject);
    procedure MIEMailClick(Sender: TObject);
    procedure MIEMailElementClick(Sender: TObject);
    procedure MIEMailFAQClick(Sender: TObject);
    procedure MIEditClick(Sender: TObject);
    procedure MIEditFileClick(Sender: TObject);
    procedure MIEditFontClick(Sender: TObject);
    procedure MIEditHitAreaClick(Sender: TObject);
    procedure MIEditMenuClick(Sender: TObject);
    procedure MIEditParamtersClick(Sender: TObject);
    procedure MIEditReferenceClick(Sender: TObject);
    procedure MIEditStyleClick(Sender: TObject);
    procedure MIEditStylesheetClick(Sender: TObject);
    procedure MIEditingmodeClick(Sender: TObject);
    procedure MIElColorClick(Sender: TObject);
    procedure MIElementMenuClick(Sender: TObject);
    procedure MIElementPasteClick(Sender: TObject);
    procedure MIElementTypeClick(Sender: TObject);
    procedure MIEncodeUTF8Click(Sender: TObject);
    procedure MIExtractImageClick(Sender: TObject);
    procedure MIExtractTaskClick(Sender: TObject);
    procedure MIFilterClick(Sender: TObject);
    procedure MIFirstChildClick(Sender: TObject);
    procedure MIFitAllPicturesClick(Sender: TObject);
    procedure MIFitComponentSizeClick(Sender: TObject);
    procedure MIFitPictureSizeClick(Sender: TObject);
    procedure MIFlagsClick(Sender: TObject);
    procedure MIFontColorClick(Sender: TObject);
    procedure MIForceRepetitionClick(Sender: TObject);
    procedure MIForgetClick(Sender: TObject);
    procedure MIFramesClick(Sender: TObject);
    procedure MIFullHTMLClick(Sender: TObject);
    procedure MIFullScreenClick(Sender: TObject);
    procedure MIGoToElementClick(Sender: TObject);
    procedure MIGoToReadPointClick(Sender: TObject);
    procedure MIHighlightClick(Sender: TObject);
    procedure MIHyperlinkClick(Sender: TObject);
    procedure MIIgnoreTextClick(Sender: TObject);
    procedure MIImageFillClick(Sender: TObject);
    procedure MIImageMenuClick(Sender: TObject);
    procedure MIImageNormalClick(Sender: TObject);
    procedure MIImageSizeClick(Sender: TObject);
    procedure MIImageStretchClick(Sender: TObject);
    procedure MIImportArticleClick(Sender: TObject);
    procedure MIImportBackgroundClick(Sender: TObject);
    procedure MIImportClick(Sender: TObject);
    procedure MIImportPicturesClick(Sender: TObject);
    procedure MIImposeTemplateClick(Sender: TObject);
    procedure MIIncreasePriorityClick(Sender: TObject);
    procedure MIInsertCitationClick(Sender: TObject);
    procedure MIInsertElementLinkClick(Sender: TObject);
    procedure MIInsertHorizontalLineClick(Sender: TObject);
    procedure MIInsertOLEClick(Sender: TObject);
    procedure MIInsertRegistryScriptLinkClick(Sender: TObject);
    procedure MIItemClick(Sender: TObject);
    procedure MIJumpIntervalClick(Sender: TObject);
    procedure MILastChildClick(Sender: TObject);
    procedure MILaterTodayClick(Sender: TObject);
    procedure MILayoutManagerClick(Sender: TObject);
    procedure MILearnBranchClick(Sender: TObject);
    procedure MILinkBackgroundClick(Sender: TObject);
    procedure MILinkBranchClick(Sender: TObject);
    procedure MILinkComponentToElementClick(Sender: TObject);
    procedure MILinkConceptClick(Sender: TObject);
    procedure MILinkElementClick(Sender: TObject);
    procedure MILinkExternalClick(Sender: TObject);
    procedure MILinkFontClick(Sender: TObject);
    procedure MILinkImageClick(Sender: TObject);
    procedure MILinkMemberClick(Sender: TObject);
    procedure MILinkReferenceClick(Sender: TObject);
    procedure MILinkStyleClick(Sender: TObject);
    procedure MILinkTextToElementNoClick(Sender: TObject);
    procedure MILinkToTextRegistryClick(Sender: TObject);
    procedure MILinkToURLClick(Sender: TObject);
    procedure MIListLinksClick(Sender: TObject);
    procedure MILoadTemplateFromFileClick(Sender: TObject);
    procedure MILocateExtractsClick(Sender: TObject);
    procedure MIMailQAClick(Sender: TObject);
    procedure MIMailTextsClick(Sender: TObject);
    procedure MIMemoryStatusClick(Sender: TObject);
    procedure MIMercyClick(Sender: TObject);
    procedure MIModeClick(Sender: TObject);
    procedure MIModifyPriorityClick(Sender: TObject);
    procedure MIMoveElementClick(Sender: TObject);
    procedure MINewFontClick(Sender: TObject);
    procedure MINewStyleClick(Sender: TObject);
    procedure MINextElementClick(Sender: TObject);
    procedure MINextRepetitionSIncClick(Sender: TObject);
    procedure MINextSiblingClick(Sender: TObject);
    procedure MINoPanelClick(Sender: TObject);
    procedure MIOLEPropertiesClick(Sender: TObject);
    procedure MIOpenHyperlinksClick(Sender: TObject);
    procedure MIOpenInNewWindowClick(Sender: TObject);
    procedure MIOptimumRepetitionScheduleClick(Sender: TObject);
    procedure MIOptionsClick(Sender: TObject);
    procedure MIOutstandingClick(Sender: TObject);
    procedure MIParentElementClick(Sender: TObject);
    procedure MIParseHTMLClick(Sender: TObject);
    procedure MIPasteArticleClick(Sender: TObject);
    procedure MIPasteElementClick(Sender: TObject);
    procedure MIPasteHTMLClick(Sender: TObject);
    procedure MIPasteTemplateClick(Sender: TObject);
    procedure MIPathClick(Sender: TObject);
    procedure MIPlainTextClick(Sender: TObject);
    procedure MIPlayAtClick(Sender: TObject);
    procedure MIPlayButtonTextClick(Sender: TObject);
    procedure MIPostponeClick(Sender: TObject);
    procedure MIPresentationmodeClick(Sender: TObject);
    procedure MIPreviousElementClick(Sender: TObject);
    procedure MIPreviousSiblingClick(Sender: TObject);
    procedure MIQueueClozeClick(Sender: TObject);
    procedure MIQueueExtractionClick(Sender: TObject);
    procedure MIRTLClick(Sender: TObject);
    procedure MIReadOnlyClick(Sender: TObject);
    procedure MIRecorderPanelClick(Sender: TObject);
    procedure MIRemember2Click(Sender: TObject);
    procedure MIRememberClick(Sender: TObject);
    procedure MIRememberClozeClick(Sender: TObject);
    procedure MIRememberExtractClick(Sender: TObject);
    procedure MIRenameMemberClick(Sender: TObject);
    procedure MIRepetitionsSimulationClick(Sender: TObject);
    procedure MIRepleatAutoPlayClick(Sender: TObject);
    procedure MIReplyToSelectionClick(Sender: TObject);
    procedure MIResetExtractClick(Sender: TObject);
    procedure MIResetRepHistClick(Sender: TObject);
    procedure MISaveAsDefaultClick(Sender: TObject);
    procedure MISaveAsTemplateClick(Sender: TObject);
    procedure MISaveDefaultLayoutClick(Sender: TObject);
    procedure MISaveFileClick(Sender: TObject);
    procedure MISaveLayoutClick(Sender: TObject);
    procedure MISaveToFileClick(Sender: TObject);
    procedure MIScaleImageClick(Sender: TObject);
    procedure MIScaleableClick(Sender: TObject);
    procedure MIScheduleClozeClick(Sender: TObject);
    procedure MIScheduleExtractClick(Sender: TObject);
    procedure MIScriptClick(Sender: TObject);
    procedure MISearchAndReplaceClick(Sender: TObject);
    procedure MISearchLexiconClick(Sender: TObject);
    procedure MISearchSubstringClick(Sender: TObject);
    procedure MISearchTextClick(Sender: TObject);
    procedure MISearchTextRegistryClick(Sender: TObject);
    procedure MISelectAllClick(Sender: TObject);
    procedure MISelectPreviousComponentsClick(Sender: TObject);
    procedure MISelectReferenceClick(Sender: TObject);
    procedure MISendAsAttachmentClick(Sender: TObject);
    procedure MISendElementClick(Sender: TObject);
    procedure MISendHTMLClick(Sender: TObject);
    procedure MISendPictureClick(Sender: TObject);
    procedure MISendToBackClick(Sender: TObject);
    procedure MISetAlarmClick(Sender: TObject);
    procedure MISetFIClick(Sender: TObject);
    procedure MISetReadPointClick(Sender: TObject);
    procedure MIShowCitationClick(Sender: TObject);
    procedure MIShowReferencesClick(Sender: TObject);
    procedure MIShowRepetitionHistoryClick(Sender: TObject);
    procedure MISkipSourceExtrasClick(Sender: TObject);
    procedure MISliderPanelClick(Sender: TObject);
    procedure MISoundMenuClick(Sender: TObject);
    procedure MISourceClick(Sender: TObject);
    procedure MISpellCheckClick(Sender: TObject);
    procedure MISplitArticleClick(Sender: TObject);
    procedure MIStopButtonTextClick(Sender: TObject);
    procedure MISwapClick(Sender: TObject);
    procedure MISwapSourceViewClick(Sender: TObject);
    procedure MISwitchImageSizeClick(Sender: TObject);
    procedure MISwitchModeClick(Sender: TObject);
    procedure MITaskClick(Sender: TObject);
    procedure MITemplateMenuClick(Sender: TObject);
    procedure MITestClick(Sender: TObject);
    procedure MITestCorrectClick(Sender: TObject);
    procedure MITestNoneClick(Sender: TObject);
    procedure MITestRepetitionClick(Sender: TObject);
    procedure MITestWrongClick(Sender: TObject);
    procedure MITextAlignmentClick(Sender: TObject);
    procedure MITextRegistryClick(Sender: TObject);
    procedure MITextsMenuClick(Sender: TObject);
    procedure MITileComponentsClick(Sender: TObject);
    procedure MITitleClick(Sender: TObject);
    procedure MITitleRefClick(Sender: TObject);
    procedure MITopicClick(Sender: TObject);
    procedure MITransferElementClick(Sender: TObject);
    procedure MITranslateClick(Sender: TObject);
    procedure MITransliterateClick(Sender: TObject);
    procedure MITransparentClick(Sender: TObject);
    procedure MIUndoClick(Sender: TObject);
    procedure MIUndoRepetitionClick(Sender: TObject);
    procedure MIUnicodeClick(Sender: TObject);
    procedure MIUnitConversionClick(Sender: TObject);
    procedure MIUnlinkConceptClick(Sender: TObject);
    procedure MIUnlinkElement1Click(Sender: TObject);
    procedure MIUnlinkElementClick(Sender: TObject);
    procedure MIUnzoomClick(Sender: TObject);
    procedure MIUseAsAboutBoxClick(Sender: TObject);
    procedure MIUseOnDesktopClick(Sender: TObject);
    procedure MIViewFileClick(Sender: TObject);
    procedure MIViewSourceClick(Sender: TObject);
    procedure MIWebSearchClick(Sender: TObject);
    procedure MIWorkloadClick(Sender: TObject);
    procedure MIYTPlayerVersionClick(Sender: TObject);
    procedure MIZoomClick(Sender: TObject);
    procedure MIZoomOptionsClick(Sender: TObject);
    procedure MailBtnClick(Sender: TObject);
    procedure NavBarResize(Sender: TObject);
    procedure NavigationButtonClick(Sender: TObject);
    procedure NextRepDateClick(Sender: TObject);
    procedure Nexthierarchyelement1Click(Sender: TObject);
    procedure Openhyperlink1Click(Sender: TObject);
    procedure Openparsed1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PassClick(Sender: TObject);
    procedure PickCollectionClick(Sender: TObject);
    procedure PlainTextBtnClick(Sender: TObject);
    procedure Previoushierarchyelement1Click(Sender: TObject);
    procedure PriorityBtnClick(Sender: TObject);
    procedure ProfilerClick(Sender: TObject);
    procedure ReferenceBtnClick(Sender: TObject);
    procedure Resetroot1Click(Sender: TObject);
    procedure Savewithobjects1Click(Sender: TObject);
    procedure ScriptTimerTimer(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure SearchesPopup(Sender: TObject);
    procedure SelectNextComponent1Click(Sender: TObject);
    procedure ShadowMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure ShadowMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
    procedure ShiftTab1Click(Sender: TObject);
    procedure Solid2Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Tab1Click(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure TextPopup(Sender: TObject);
    procedure ToolsBtnClick(Sender: TObject);
    procedure Unlinkconcept1Click(Sender: TObject);
    procedure UntranslateTimerTimer(Sender: TObject);
    procedure Vertical1Click(Sender: TObject);
    procedure Wikipediaarticles1Click(Sender: TObject);
    procedure WindowsDesktop1Click(Sender: TObject);
    procedure YouTubevideos1Click(Sender: TObject);
  end;

var
  ElWind: TElWind;

implementation

{$R *.lfm}

procedure TElWind.AddNewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddNewClick');
end;

procedure TElWind.AddNoteBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddNoteBtnClick');
end;

procedure TElWind.Alldocuments1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Alldocuments1Click');
end;

procedure TElWind.AutoplayTimerTimer(Sender: TObject);
begin
end;

procedure TElWind.BackButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BackButtonClick');
end;

procedure TElWind.BadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BadClick');
end;

procedure TElWind.CancelLearningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelLearningClick');
end;

procedure TElWind.Cancelalarm1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cancelalarm1Click');
end;

procedure TElWind.Changeroot1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Changeroot1Click');
end;

procedure TElWind.Choosemusic1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Choosemusic1Click');
end;

procedure TElWind.Clear1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Clear1Click');
end;

procedure TElWind.ClozeButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClozeButtonClick');
end;

procedure TElWind.CommanderBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CommanderBtnClick');
end;

procedure TElWind.ComponentMenuPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'ComponentMenuPopup');
end;

procedure TElWind.ComponentOrder1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ComponentOrder1Click');
end;

procedure TElWind.ComputePasswordBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ComputePasswordBtnClick');
end;

procedure TElWind.ConceptEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ConceptEditClick');
end;

procedure TElWind.ContentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ContentsClick');
end;

procedure TElWind.CreditPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CreditPanelClick');
end;

procedure TElWind.Cross1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cross1Click');
end;

procedure TElWind.DefaultConceptBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultConceptBtnClick');
end;

procedure TElWind.DoneClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DoneClick');
end;

procedure TElWind.DownloadBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DownloadBtnClick');
end;

procedure TElWind.EditFileBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EditFileBtnClick');
end;

procedure TElWind.ElementMenuPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'ElementMenuPopup');
end;

procedure TElWind.Email1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Email1Click');
end;

procedure TElWind.ExtractButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExtractButtonClick');
end;

procedure TElWind.FailClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FailClick');
end;

procedure TElWind.FilesPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'FilesPopup');
end;

procedure TElWind.FindBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindBtnClick');
end;

procedure TElWind.FirstElement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'FirstElement1Click');
end;

procedure TElWind.FontBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontBtnClick');
end;

procedure TElWind.ForceRepetitionBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ForceRepetitionBtnClick');
end;

procedure TElWind.FormActivate(Sender: TObject);
begin
end;

procedure TElWind.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TElWind.FormCreate(Sender: TObject);
begin
end;

procedure TElWind.FormDeactivate(Sender: TObject);
begin
end;

procedure TElWind.FormDestroy(Sender: TObject);
begin
end;

procedure TElWind.FormDragDrop(Sender, ASource: TObject; X, AY: Integer);
begin
end;

procedure TElWind.FormDragOver(Sender, ASource: TObject; X, AY: Integer; AState: TDragState; var AAccept: Boolean);
begin
end;

procedure TElWind.FormKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FormKeyDown');
end;

procedure TElWind.FormMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TElWind.FormMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TElWind.FormMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TElWind.FormResize(Sender: TObject);
begin
end;

procedure TElWind.ForwardButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ForwardButtonClick');
end;

procedure TElWind.GoodClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoodClick');
end;

procedure TElWind.Gotoroot1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Gotoroot1Click');
end;

procedure TElWind.GreatClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GreatClick');
end;

procedure TElWind.HelpBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpBtnClick');
end;

procedure TElWind.HistoryButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HistoryButtonClick');
end;

procedure TElWind.Horizontal1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Horizontal1Click');
end;

procedure TElWind.ImportBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportBtnClick');
end;

procedure TElWind.Importmail1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Importmail1Click');
end;

procedure TElWind.InvCancelgrade1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvCancelgrade1Click');
end;

procedure TElWind.InvSelectAll1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvSelectAll1Click');
end;

procedure TElWind.LastElement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'LastElement1Click');
end;

procedure TElWind.LayoutsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LayoutsBtnClick');
end;

procedure TElWind.LearnBarHelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LearnBarHelpClick');
end;

procedure TElWind.LearnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LearnClick');
end;

procedure TElWind.LearnbarTabsChange(Sender: TObject);
begin
  DispatchAction(Sender, 'LearnbarTabsChange');
end;

procedure TElWind.LearnbarTabsGetImageIndex(Sender: TObject);
begin
end;

procedure TElWind.Link1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Link1Click');
end;

procedure TElWind.LinkConceptBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LinkConceptBtnClick');
end;

procedure TElWind.LinkToHTMLFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LinkToHTMLFileClick');
end;

procedure TElWind.MIAddHTMLComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddHTMLComponentClick');
end;

procedure TElWind.MIAddImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddImageClick');
end;

procedure TElWind.MIAddReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddReferenceClick');
end;

procedure TElWind.MIAddSoundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddSoundClick');
end;

procedure TElWind.MIAddTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTemplateClick');
end;

procedure TElWind.MIAddTextComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTextComponentClick');
end;

procedure TElWind.MIAddToSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddToSubsetClick');
end;

procedure TElWind.MIAddVideoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddVideoClick');
end;

procedure TElWind.MIAlignCenterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAlignCenterClick');
end;

procedure TElWind.MIAlignLeftClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAlignLeftClick');
end;

procedure TElWind.MIAlignRightClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAlignRightClick');
end;

procedure TElWind.MIAlignmentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAlignmentClick');
end;

procedure TElWind.MIAnswerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAnswerClick');
end;

procedure TElWind.MIApplyTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplyTemplateClick');
end;

procedure TElWind.MIApplydefaultlayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplydefaultlayoutClick');
end;

procedure TElWind.MIAuthorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAuthorClick');
end;

procedure TElWind.MIAutoPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAutoPlayClick');
end;

procedure TElWind.MIBackgroundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBackgroundClick');
end;

procedure TElWind.MIBckgArrangementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgArrangementClick');
end;

procedure TElWind.MIBckgCenterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgCenterClick');
end;

procedure TElWind.MIBckgDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgDeleteClick');
end;

procedure TElWind.MIBckgStretchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgStretchClick');
end;

procedure TElWind.MIBckgTileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgTileClick');
end;

procedure TElWind.MIBckgTopLeftClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBckgTopLeftClick');
end;

procedure TElWind.MIBestForgettingIndexClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBestForgettingIndexClick');
end;

procedure TElWind.MIBrowseBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseBranchClick');
end;

procedure TElWind.MIBrowserMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowserMenuClick');
end;

procedure TElWind.MIButtonsPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIButtonsPanelClick');
end;

procedure TElWind.MICaseCapitalizedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICaseCapitalizedClick');
end;

procedure TElWind.MICaseLowerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICaseLowerClick');
end;

procedure TElWind.MICaseSensitiveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICaseSensitiveClick');
end;

procedure TElWind.MICaseUpperClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICaseUpperClick');
end;

procedure TElWind.MICheckSourceExtrasClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICheckSourceExtrasClick');
end;

procedure TElWind.MICheckTemplateExtrasClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICheckTemplateExtrasClick');
end;

procedure TElWind.MICleanleadHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICleanleadHTMLClick');
end;

procedure TElWind.MIClearReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIClearReadPointClick');
end;

procedure TElWind.MIClickPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIClickPlayClick');
end;

procedure TElWind.MICloneClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloneClick');
end;

procedure TElWind.MICommanderClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICommanderClick');
end;

procedure TElWind.MICommentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICommentClick');
end;

procedure TElWind.MICompColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICompColorClick');
end;

procedure TElWind.MICompModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICompModeClick');
end;

procedure TElWind.MIComponentMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIComponentMenuClick');
end;

procedure TElWind.MIComponentPasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIComponentPasteClick');
end;

procedure TElWind.MICompressImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICompressImageClick');
end;

procedure TElWind.MICompressImagesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICompressImagesClick');
end;

procedure TElWind.MIConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConceptClick');
end;

procedure TElWind.MIConceptMapClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConceptMapClick');
end;

procedure TElWind.MIContinuousPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIContinuousPlayClick');
end;

procedure TElWind.MIConvertToGIFClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConvertToGIFClick');
end;

procedure TElWind.MIConvertToJPGClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConvertToJPGClick');
end;

procedure TElWind.MIConvertToPngClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConvertToPngClick');
end;

procedure TElWind.MIConverttoBMPClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConverttoBMPClick');
end;

procedure TElWind.MICopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyClick');
end;

procedure TElWind.MICopyComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyComponentClick');
end;

procedure TElWind.MICopyCutPasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyCutPasteClick');
end;

procedure TElWind.MICopyElementSourceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyElementSourceClick');
end;

procedure TElWind.MICopyPathClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyPathClick');
end;

procedure TElWind.MICopyQAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyQAClick');
end;

procedure TElWind.MICopyReferencesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyReferencesClick');
end;

procedure TElWind.MICopyTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyTextClick');
end;

procedure TElWind.MICopyTextsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyTextsClick');
end;

procedure TElWind.MICopyToClipboardClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyToClipboardClick');
end;

procedure TElWind.MICopyTranscriptionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyTranscriptionClick');
end;

procedure TElWind.MICreateConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICreateConceptClick');
end;

procedure TElWind.MICreateLinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICreateLinkClick');
end;

procedure TElWind.MICropClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICropClick');
end;

procedure TElWind.MICutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICutClick');
end;

procedure TElWind.MIDateRefClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDateRefClick');
end;

procedure TElWind.MIDecodeUTF8Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDecodeUTF8Click');
end;

procedure TElWind.MIDecomposeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDecomposeClick');
end;

procedure TElWind.MIDecreasePriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDecreasePriorityClick');
end;

procedure TElWind.MIDefaultColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDefaultColorClick');
end;

procedure TElWind.MIDefaultFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDefaultFontClick');
end;

procedure TElWind.MIDefaultRTLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDefaultRTLClick');
end;

procedure TElWind.MIDefaultStyleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDefaultStyleClick');
end;

procedure TElWind.MIDeleteAfterTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteAfterTextClick');
end;

procedure TElWind.MIDeleteBeforeCursorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteBeforeCursorClick');
end;

procedure TElWind.MIDeleteComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteComponentClick');
end;

procedure TElWind.MIDeleteComponentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteComponentsClick');
end;

procedure TElWind.MIDeleteContentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteContentClick');
end;

procedure TElWind.MIDeleteElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteElementClick');
end;

procedure TElWind.MIDeleteFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteFileClick');
end;

procedure TElWind.MIDeleteHyperlinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteHyperlinkClick');
end;

procedure TElWind.MIDeleteLinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteLinkClick');
end;

procedure TElWind.MIDeleteProcessedTextsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteProcessedTextsClick');
end;

procedure TElWind.MIDeleteReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteReferenceClick');
end;

procedure TElWind.MIDeleteTemplateExtrasClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteTemplateExtrasClick');
end;

procedure TElWind.MIDeprecateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeprecateClick');
end;

procedure TElWind.MIDetachTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDetachTemplateClick');
end;

procedure TElWind.MIDifficultyAnalysisClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDifficultyAnalysisClick');
end;

procedure TElWind.MIDismemberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismemberClick');
end;

procedure TElWind.MIDismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismissClick');
end;

procedure TElWind.MIDisplayAtClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDisplayAtClick');
end;

procedure TElWind.MIDisplayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDisplayClick');
end;

procedure TElWind.MIDownloadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDownloadClick');
end;

procedure TElWind.MIDownloadFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDownloadFileClick');
end;

procedure TElWind.MIDownloadImagesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDownloadImagesClick');
end;

procedure TElWind.MIDragClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDragClick');
end;

procedure TElWind.MIDraggingmodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDraggingmodeClick');
end;

procedure TElWind.MIDrillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDrillClick');
end;

procedure TElWind.MIDuplicateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDuplicateClick');
end;

procedure TElWind.MIEMailClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEMailClick');
end;

procedure TElWind.MIEMailElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEMailElementClick');
end;

procedure TElWind.MIEMailFAQClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEMailFAQClick');
end;

procedure TElWind.MIEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditClick');
end;

procedure TElWind.MIEditFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditFileClick');
end;

procedure TElWind.MIEditFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditFontClick');
end;

procedure TElWind.MIEditHitAreaClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditHitAreaClick');
end;

procedure TElWind.MIEditMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditMenuClick');
end;

procedure TElWind.MIEditParamtersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditParamtersClick');
end;

procedure TElWind.MIEditReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditReferenceClick');
end;

procedure TElWind.MIEditStyleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditStyleClick');
end;

procedure TElWind.MIEditStylesheetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditStylesheetClick');
end;

procedure TElWind.MIEditingmodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditingmodeClick');
end;

procedure TElWind.MIElColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElColorClick');
end;

procedure TElWind.MIElementMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementMenuClick');
end;

procedure TElWind.MIElementPasteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementPasteClick');
end;

procedure TElWind.MIElementTypeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementTypeClick');
end;

procedure TElWind.MIEncodeUTF8Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEncodeUTF8Click');
end;

procedure TElWind.MIExtractImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExtractImageClick');
end;

procedure TElWind.MIExtractTaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExtractTaskClick');
end;

procedure TElWind.MIFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFilterClick');
end;

procedure TElWind.MIFirstChildClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFirstChildClick');
end;

procedure TElWind.MIFitAllPicturesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFitAllPicturesClick');
end;

procedure TElWind.MIFitComponentSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFitComponentSizeClick');
end;

procedure TElWind.MIFitPictureSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFitPictureSizeClick');
end;

procedure TElWind.MIFlagsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFlagsClick');
end;

procedure TElWind.MIFontColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFontColorClick');
end;

procedure TElWind.MIForceRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIForceRepetitionClick');
end;

procedure TElWind.MIForgetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIForgetClick');
end;

procedure TElWind.MIFramesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFramesClick');
end;

procedure TElWind.MIFullHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFullHTMLClick');
end;

procedure TElWind.MIFullScreenClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFullScreenClick');
end;

procedure TElWind.MIGoToElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToElementClick');
end;

procedure TElWind.MIGoToReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToReadPointClick');
end;

procedure TElWind.MIHighlightClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHighlightClick');
end;

procedure TElWind.MIHyperlinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHyperlinkClick');
end;

procedure TElWind.MIIgnoreTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIgnoreTextClick');
end;

procedure TElWind.MIImageFillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageFillClick');
end;

procedure TElWind.MIImageMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageMenuClick');
end;

procedure TElWind.MIImageNormalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageNormalClick');
end;

procedure TElWind.MIImageSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageSizeClick');
end;

procedure TElWind.MIImageStretchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageStretchClick');
end;

procedure TElWind.MIImportArticleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportArticleClick');
end;

procedure TElWind.MIImportBackgroundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportBackgroundClick');
end;

procedure TElWind.MIImportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportClick');
end;

procedure TElWind.MIImportPicturesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportPicturesClick');
end;

procedure TElWind.MIImposeTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImposeTemplateClick');
end;

procedure TElWind.MIIncreasePriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIIncreasePriorityClick');
end;

procedure TElWind.MIInsertCitationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertCitationClick');
end;

procedure TElWind.MIInsertElementLinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertElementLinkClick');
end;

procedure TElWind.MIInsertHorizontalLineClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertHorizontalLineClick');
end;

procedure TElWind.MIInsertOLEClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertOLEClick');
end;

procedure TElWind.MIInsertRegistryScriptLinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertRegistryScriptLinkClick');
end;

procedure TElWind.MIItemClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIItemClick');
end;

procedure TElWind.MIJumpIntervalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIJumpIntervalClick');
end;

procedure TElWind.MILastChildClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILastChildClick');
end;

procedure TElWind.MILaterTodayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILaterTodayClick');
end;

procedure TElWind.MILayoutManagerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILayoutManagerClick');
end;

procedure TElWind.MILearnBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnBranchClick');
end;

procedure TElWind.MILinkBackgroundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkBackgroundClick');
end;

procedure TElWind.MILinkBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkBranchClick');
end;

procedure TElWind.MILinkComponentToElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkComponentToElementClick');
end;

procedure TElWind.MILinkConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkConceptClick');
end;

procedure TElWind.MILinkElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkElementClick');
end;

procedure TElWind.MILinkExternalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkExternalClick');
end;

procedure TElWind.MILinkFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkFontClick');
end;

procedure TElWind.MILinkImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkImageClick');
end;

procedure TElWind.MILinkMemberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkMemberClick');
end;

procedure TElWind.MILinkReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkReferenceClick');
end;

procedure TElWind.MILinkStyleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkStyleClick');
end;

procedure TElWind.MILinkTextToElementNoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkTextToElementNoClick');
end;

procedure TElWind.MILinkToTextRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkToTextRegistryClick');
end;

procedure TElWind.MILinkToURLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkToURLClick');
end;

procedure TElWind.MIListLinksClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIListLinksClick');
end;

procedure TElWind.MILoadTemplateFromFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILoadTemplateFromFileClick');
end;

procedure TElWind.MILocateExtractsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILocateExtractsClick');
end;

procedure TElWind.MIMailQAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMailQAClick');
end;

procedure TElWind.MIMailTextsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMailTextsClick');
end;

procedure TElWind.MIMemoryStatusClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMemoryStatusClick');
end;

procedure TElWind.MIMercyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMercyClick');
end;

procedure TElWind.MIModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIModeClick');
end;

procedure TElWind.MIModifyPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIModifyPriorityClick');
end;

procedure TElWind.MIMoveElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveElementClick');
end;

procedure TElWind.MINewFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewFontClick');
end;

procedure TElWind.MINewStyleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewStyleClick');
end;

procedure TElWind.MINextElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextElementClick');
end;

procedure TElWind.MINextRepetitionSIncClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextRepetitionSIncClick');
end;

procedure TElWind.MINextSiblingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextSiblingClick');
end;

procedure TElWind.MINoPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINoPanelClick');
end;

procedure TElWind.MIOLEPropertiesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOLEPropertiesClick');
end;

procedure TElWind.MIOpenHyperlinksClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenHyperlinksClick');
end;

procedure TElWind.MIOpenInNewWindowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenInNewWindowClick');
end;

procedure TElWind.MIOptimumRepetitionScheduleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOptimumRepetitionScheduleClick');
end;

procedure TElWind.MIOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOptionsClick');
end;

procedure TElWind.MIOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOutstandingClick');
end;

procedure TElWind.MIParentElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIParentElementClick');
end;

procedure TElWind.MIParseHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIParseHTMLClick');
end;

procedure TElWind.MIPasteArticleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteArticleClick');
end;

procedure TElWind.MIPasteElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteElementClick');
end;

procedure TElWind.MIPasteHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteHTMLClick');
end;

procedure TElWind.MIPasteTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPasteTemplateClick');
end;

procedure TElWind.MIPathClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPathClick');
end;

procedure TElWind.MIPlainTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlainTextClick');
end;

procedure TElWind.MIPlayAtClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlayAtClick');
end;

procedure TElWind.MIPlayButtonTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlayButtonTextClick');
end;

procedure TElWind.MIPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeClick');
end;

procedure TElWind.MIPresentationmodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPresentationmodeClick');
end;

procedure TElWind.MIPreviousElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousElementClick');
end;

procedure TElWind.MIPreviousSiblingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousSiblingClick');
end;

procedure TElWind.MIQueueClozeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIQueueClozeClick');
end;

procedure TElWind.MIQueueExtractionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIQueueExtractionClick');
end;

procedure TElWind.MIRTLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRTLClick');
end;

procedure TElWind.MIReadOnlyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReadOnlyClick');
end;

procedure TElWind.MIRecorderPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRecorderPanelClick');
end;

procedure TElWind.MIRemember2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRemember2Click');
end;

procedure TElWind.MIRememberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRememberClick');
end;

procedure TElWind.MIRememberClozeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRememberClozeClick');
end;

procedure TElWind.MIRememberExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRememberExtractClick');
end;

procedure TElWind.MIRenameMemberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenameMemberClick');
end;

procedure TElWind.MIRepetitionsSimulationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRepetitionsSimulationClick');
end;

procedure TElWind.MIRepleatAutoPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRepleatAutoPlayClick');
end;

procedure TElWind.MIReplyToSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReplyToSelectionClick');
end;

procedure TElWind.MIResetExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetExtractClick');
end;

procedure TElWind.MIResetRepHistClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetRepHistClick');
end;

procedure TElWind.MISaveAsDefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveAsDefaultClick');
end;

procedure TElWind.MISaveAsTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveAsTemplateClick');
end;

procedure TElWind.MISaveDefaultLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveDefaultLayoutClick');
end;

procedure TElWind.MISaveFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveFileClick');
end;

procedure TElWind.MISaveLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveLayoutClick');
end;

procedure TElWind.MISaveToFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveToFileClick');
end;

procedure TElWind.MIScaleImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScaleImageClick');
end;

procedure TElWind.MIScaleableClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScaleableClick');
end;

procedure TElWind.MIScheduleClozeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScheduleClozeClick');
end;

procedure TElWind.MIScheduleExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScheduleExtractClick');
end;

procedure TElWind.MIScriptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScriptClick');
end;

procedure TElWind.MISearchAndReplaceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchAndReplaceClick');
end;

procedure TElWind.MISearchLexiconClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchLexiconClick');
end;

procedure TElWind.MISearchSubstringClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchSubstringClick');
end;

procedure TElWind.MISearchTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchTextClick');
end;

procedure TElWind.MISearchTextRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchTextRegistryClick');
end;

procedure TElWind.MISelectAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectAllClick');
end;

procedure TElWind.MISelectPreviousComponentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectPreviousComponentsClick');
end;

procedure TElWind.MISelectReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectReferenceClick');
end;

procedure TElWind.MISendAsAttachmentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISendAsAttachmentClick');
end;

procedure TElWind.MISendElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISendElementClick');
end;

procedure TElWind.MISendHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISendHTMLClick');
end;

procedure TElWind.MISendPictureClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISendPictureClick');
end;

procedure TElWind.MISendToBackClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISendToBackClick');
end;

procedure TElWind.MISetAlarmClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetAlarmClick');
end;

procedure TElWind.MISetFIClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetFIClick');
end;

procedure TElWind.MISetReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISetReadPointClick');
end;

procedure TElWind.MIShowCitationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShowCitationClick');
end;

procedure TElWind.MIShowReferencesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShowReferencesClick');
end;

procedure TElWind.MIShowRepetitionHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShowRepetitionHistoryClick');
end;

procedure TElWind.MISkipSourceExtrasClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISkipSourceExtrasClick');
end;

procedure TElWind.MISliderPanelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISliderPanelClick');
end;

procedure TElWind.MISoundMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISoundMenuClick');
end;

procedure TElWind.MISourceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISourceClick');
end;

procedure TElWind.MISpellCheckClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISpellCheckClick');
end;

procedure TElWind.MISplitArticleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISplitArticleClick');
end;

procedure TElWind.MIStopButtonTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStopButtonTextClick');
end;

procedure TElWind.MISwapClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwapClick');
end;

procedure TElWind.MISwapSourceViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwapSourceViewClick');
end;

procedure TElWind.MISwitchImageSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwitchImageSizeClick');
end;

procedure TElWind.MISwitchModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISwitchModeClick');
end;

procedure TElWind.MITaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITaskClick');
end;

procedure TElWind.MITemplateMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITemplateMenuClick');
end;

procedure TElWind.MITestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestClick');
end;

procedure TElWind.MITestCorrectClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestCorrectClick');
end;

procedure TElWind.MITestNoneClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestNoneClick');
end;

procedure TElWind.MITestRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestRepetitionClick');
end;

procedure TElWind.MITestWrongClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestWrongClick');
end;

procedure TElWind.MITextAlignmentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextAlignmentClick');
end;

procedure TElWind.MITextRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextRegistryClick');
end;

procedure TElWind.MITextsMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextsMenuClick');
end;

procedure TElWind.MITileComponentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITileComponentsClick');
end;

procedure TElWind.MITitleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITitleClick');
end;

procedure TElWind.MITitleRefClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITitleRefClick');
end;

procedure TElWind.MITopicClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITopicClick');
end;

procedure TElWind.MITransferElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferElementClick');
end;

procedure TElWind.MITranslateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITranslateClick');
end;

procedure TElWind.MITransliterateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransliterateClick');
end;

procedure TElWind.MITransparentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransparentClick');
end;

procedure TElWind.MIUndoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUndoClick');
end;

procedure TElWind.MIUndoRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUndoRepetitionClick');
end;

procedure TElWind.MIUnicodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnicodeClick');
end;

procedure TElWind.MIUnitConversionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnitConversionClick');
end;

procedure TElWind.MIUnlinkConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnlinkConceptClick');
end;

procedure TElWind.MIUnlinkElement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnlinkElement1Click');
end;

procedure TElWind.MIUnlinkElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnlinkElementClick');
end;

procedure TElWind.MIUnzoomClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnzoomClick');
end;

procedure TElWind.MIUseAsAboutBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUseAsAboutBoxClick');
end;

procedure TElWind.MIUseOnDesktopClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUseOnDesktopClick');
end;

procedure TElWind.MIViewFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewFileClick');
end;

procedure TElWind.MIViewSourceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewSourceClick');
end;

procedure TElWind.MIWebSearchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWebSearchClick');
end;

procedure TElWind.MIWorkloadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWorkloadClick');
end;

procedure TElWind.MIYTPlayerVersionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIYTPlayerVersionClick');
end;

procedure TElWind.MIZoomClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIZoomClick');
end;

procedure TElWind.MIZoomOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIZoomOptionsClick');
end;

procedure TElWind.MailBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MailBtnClick');
end;

procedure TElWind.NavBarResize(Sender: TObject);
begin
end;

procedure TElWind.NavigationButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NavigationButtonClick');
end;

procedure TElWind.NextRepDateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NextRepDateClick');
end;

procedure TElWind.Nexthierarchyelement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Nexthierarchyelement1Click');
end;

procedure TElWind.Openhyperlink1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Openhyperlink1Click');
end;

procedure TElWind.Openparsed1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Openparsed1Click');
end;

procedure TElWind.PaintBox1Paint(Sender: TObject);
begin
end;

procedure TElWind.PassClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PassClick');
end;

procedure TElWind.PickCollectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PickCollectionClick');
end;

procedure TElWind.PlainTextBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PlainTextBtnClick');
end;

procedure TElWind.Previoushierarchyelement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Previoushierarchyelement1Click');
end;

procedure TElWind.PriorityBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PriorityBtnClick');
end;

procedure TElWind.ProfilerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ProfilerClick');
end;

procedure TElWind.ReferenceBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ReferenceBtnClick');
end;

procedure TElWind.Resetroot1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Resetroot1Click');
end;

procedure TElWind.Savewithobjects1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Savewithobjects1Click');
end;

procedure TElWind.ScriptTimerTimer(Sender: TObject);
begin
end;

procedure TElWind.SearchBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SearchBtnClick');
end;

procedure TElWind.SearchesPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'SearchesPopup');
end;

procedure TElWind.SelectNextComponent1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectNextComponent1Click');
end;

procedure TElWind.ShadowMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TElWind.ShadowMouseMove(Sender: TObject; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TElWind.ShiftTab1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ShiftTab1Click');
end;

procedure TElWind.Solid2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Solid2Click');
end;

procedure TElWind.StopClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StopClick');
end;

procedure TElWind.Tab1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Tab1Click');
end;

procedure TElWind.TestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TestClick');
end;

procedure TElWind.TextPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'TextPopup');
end;

procedure TElWind.ToolsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolsBtnClick');
end;

procedure TElWind.Unlinkconcept1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Unlinkconcept1Click');
end;

procedure TElWind.UntranslateTimerTimer(Sender: TObject);
begin
end;

procedure TElWind.Vertical1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Vertical1Click');
end;

procedure TElWind.Wikipediaarticles1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Wikipediaarticles1Click');
end;

procedure TElWind.WindowsDesktop1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'WindowsDesktop1Click');
end;

procedure TElWind.YouTubevideos1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'YouTubevideos1Click');
end;

initialization
  if GetClass('TElWind') = nil then
    RegisterClass(TElWind);

end.
