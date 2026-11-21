unit uSMMain;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions, smdemo;

type
  TSMMain = class(TForm)
    MediaPlayer1: TMediaPlayer;
    UserSound: TMediaPlayer;
    FormatBar: TToolBar;
    ElMenu1: TToolButton;
    CompMenu1: TToolButton;
    ToolButton30: TToolButton;
    CopyElementButton: TToolButton;
    PasteButton: TToolButton;
    DeleteButton: TToolButton;
    ToolButton35: TToolButton;
    BoldButton: TToolButton;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    ToolButton40: TToolButton;
    FontButton: TToolButton;
    FontColorButton: TToolButton;
    ToolButton41: TToolButton;
    FontUpButton: TToolButton;
    FontDownButton: TToolButton;
    ToolButton42: TToolButton;
    Subscript: TToolButton;
    SuperScript: TToolButton;
    ToolButton38: TToolButton;
    AlignLeft: TToolButton;
    AlignCenter: TToolButton;
    AlignRight: TToolButton;
    ToolButton32: TToolButton;
    Bullets: TToolButton;
    Numbers: TToolButton;
    ToolButton36: TToolButton;
    Outdent: TToolButton;
    Indent: TToolButton;
    ToolButton31: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton45: TToolButton;
    SaveDefaultTemplateBtn: TToolButton;
    TemplatesBtn: TToolButton;
    ToolButton43: TToolButton;
    DisplayModeBtn: TToolButton;
    EditModeBtn: TToolButton;
    DragModeBtn: TToolButton;
    SwitchModeBtn2: TToolButton;
    AlarmBar: TToolBar;
    AlarmDisplay: TPanel;
    SetAlarmButton: TToolButton;
    StopAlarmBtn: TToolButton;
    TimerDisplay: TPanel;
    TimerButton: TToolButton;
    ToolButton25: TToolButton;
    Reading: TToolBar;
    PasteArticle: TToolButton;
    ToolButton39: TToolButton;
    RememberExtract: TToolButton;
    ScheduleExtract: TToolButton;
    ToolButton49: TToolButton;
    RememberCloze: TToolButton;
    ScheduleCloze: TToolButton;
    ToolButton53: TToolButton;
    TaskExtract: TToolButton;
    ToolButton28: TToolButton;
    SplitBtn: TToolButton;
    ToolButton10: TToolButton;
    SendText: TToolButton;
    SendFAQ: TToolButton;
    ToolButton29: TToolButton;
    ApplyHighlighter: TToolButton;
    ChooseHighlighter: TToolButton;
    IgnoreText: TToolButton;
    ToolButton34: TToolButton;
    DelBeforeCursorBtn: TToolButton;
    DelAfterCursorBtn: TToolButton;
    SetReadPoint: TToolButton;
    ToolButton12: TToolButton;
    GoToReadPoint: TToolButton;
    ClearReadPoint: TToolButton;
    Compose: TToolBar;
    ElMenu2: TToolButton;
    CompMenu2: TToolButton;
    ViewSourceBtn: TToolButton;
    ToolButton69: TToolButton;
    HTMLBtn: TToolButton;
    TextButton: TToolButton;
    ToolButton19: TToolButton;
    ToolButton37: TToolButton;
    ToolButton70: TToolButton;
    ToolButton46: TToolButton;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    BinaryBtn: TToolButton;
    CreateScript: TToolButton;
    ToolButton54: TToolButton;
    ToolButton71: TToolButton;
    ToolButton56: TToolButton;
    ToolButton57: TToolButton;
    ToolButton58: TToolButton;
    ToolButton72: TToolButton;
    PresentationModeBtn: TToolButton;
    ToolButton60: TToolButton;
    ToolButton61: TToolButton;
    SwitchModeBtn: TToolButton;
    ToolButton73: TToolButton;
    NumberButton: TToolButton;
    ToolButton64: TToolButton;
    ToolButton65: TToolButton;
    PlanAlarm: TMediaPlayer;
    ToolsBar: TToolBar;
    OpenCollectionBtn: TToolButton;
    BackupBtn: TToolButton;
    ToolButton8: TToolButton;
    WebSearchBtn: TToolButton;
    ToolButton9: TToolButton;
    ToolButton3: TToolButton;
    SaveLayoutBtn: TToolButton;
    RestoreLayoutBtn: TToolButton;
    ToolButton14: TToolButton;
    WorkloadBtn: TToolButton;
    OutstandingBtn: TToolButton;
    PathListButton: TToolButton;
    ToolButton2: TToolButton;
    ImageRegistryBtn: TToolButton;
    SoundRegistryBtn: TToolButton;
    ToolButton1: TToolButton;
    TasklistButton: TToolButton;
    ToolButton24: TToolButton;
    HintsButton: TToolButton;
    TheMainMenu: TMainMenu;
    MIFile: TMenuItem;
    MIOpen: TMenuItem;
    MIFavorites: TMenuItem;
    MINew: TMenuItem;
    Break1: TMenuItem;
    MIBackup: TMenuItem;
    MICopy: TMenuItem;
    MIDelete: TMenuItem;
    MIRecover: TMenuItem;
    MIMerge: TMenuItem;
    N39: TMenuItem;
    MIImport: TMenuItem;
    MIFolders: TMenuItem;
    N52: TMenuItem;
    MIMCTText: TMenuItem;
    N55: TMenuItem;
    ImportQA_XML: TMenuItem;
    MIXMLSynchronization: TMenuItem;
    N32: TMenuItem;
    MIImportRepHistory: TMenuItem;
    MIImportLearning: TMenuItem;
    MIImportText: TMenuItem;
    MITranslationImport: TMenuItem;
    MIExport: TMenuItem;
    MIExportDocument: TMenuItem;
    MIExportQA: TMenuItem;
    MIExportAsXML: TMenuItem;
    N53: TMenuItem;
    MIHTMLExport: TMenuItem;
    MIExportLearning: TMenuItem;
    MIExportRepHistory: TMenuItem;
    MIExportText: TMenuItem;
    MITransferSubset: TMenuItem;
    N41: TMenuItem;
    Lexicon1: TMenuItem;
    Break3: TMenuItem;
    MIFileTools: TMenuItem;
    MICollectionSize: TMenuItem;
    N57: TMenuItem;
    MIViewHTML: TMenuItem;
    MIReport: TMenuItem;
    MIViewFAQ: TMenuItem;
    N34: TMenuItem;
    MIReset: TMenuItem;
    Break8: TMenuItem;
    MIMove: TMenuItem;
    MIRename: TMenuItem;
    Break9: TMenuItem;
    MIGarbage: TMenuItem;
    MIProperties: TMenuItem;
    Break2: TMenuItem;
    MIInstallation: TMenuItem;
    MIInputPassword: TMenuItem;
    MIRequestPassword: TMenuItem;
    BreakRegistration1: TMenuItem;
    MIInstallIcons: TMenuItem;
    BreakRegistration2: TMenuItem;
    MIUnregister: TMenuItem;
    MIPublish: TMenuItem;
    N56: TMenuItem;
    MIOwner: TMenuItem;
    MIAuthor: TMenuItem;
    Break4: TMenuItem;
    MILevel: TMenuItem;
    MIBeginner: TMenuItem;
    MIBasic: TMenuItem;
    MIMiddle: TMenuItem;
    MIProfessional: TMenuItem;
    LevelBreak: TMenuItem;
    MIWarrior: TMenuItem;
    N51: TMenuItem;
    MINextLevel: TMenuItem;
    MIPreviousLevel: TMenuItem;
    N50: TMenuItem;
    MIInvisibleWorkload: TMenuItem;
    N25: TMenuItem;
    MIProcessCollection: TMenuItem;
    BreakLevel: TMenuItem;
    MIExit: TMenuItem;
    BreakExit: TMenuItem;
    MI1: TMenuItem;
    MI2: TMenuItem;
    MI3: TMenuItem;
    MI4: TMenuItem;
    MI5: TMenuItem;
    MI6: TMenuItem;
    MI7: TMenuItem;
    MI8: TMenuItem;
    MI9: TMenuItem;
    MI10: TMenuItem;
    MI11: TMenuItem;
    MIEdit: TMenuItem;
    MIAddItem: TMenuItem;
    MIPasteArticle: TMenuItem;
    MIAddNewTask: TMenuItem;
    MIAddNote: TMenuItem;
    N21: TMenuItem;
    MIWebImport: TMenuItem;
    MIIEImport: TMenuItem;
    ImportWebPages: TMenuItem;
    MIWikipedia: TMenuItem;
    MIYouTube: TMenuItem;
    MIImportPictures: TMenuItem;
    MIImportMail: TMenuItem;
    MIOpenWebLinks: TMenuItem;
    N36: TMenuItem;
    MIAddComponents: TMenuItem;
    MIAddImage: TMenuItem;
    MIAddSound: TMenuItem;
    MIAddVideoComponent: TMenuItem;
    MIAddHTML: TMenuItem;
    MIAddText: TMenuItem;
    MIAddSpell: TMenuItem;
    MIEditText: TMenuItem;
    Title1: TMenuItem;
    N11: TMenuItem;
    MIEditFirstQ: TMenuItem;
    MIEditFirstA: TMenuItem;
    MIEditTexts: TMenuItem;
    N5: TMenuItem;
    MIAddPronunciation: TMenuItem;
    N4: TMenuItem;
    MIApplyFilter: TMenuItem;
    N01: TMenuItem;
    MICreateConcept: TMenuItem;
    MICreateTasklist: TMenuItem;
    N19: TMenuItem;
    MIDeleteElement: TMenuItem;
    MIDeleteComponents: TMenuItem;
    MIMenus: TMenuItem;
    MIElementMenu: TMenuItem;
    MIComponentMenu: TMenuItem;
    MIContentsMenu: TMenuItem;
    MIBrowserMenu: TMenuItem;
    MIRegistryMenu: TMenuItem;
    MIAddPage: TMenuItem;
    MIAddNewItem: TMenuItem;
    MIAddHTMLNote: TMenuItem;
    MIAddArticle: TMenuItem;
    MIHTMLFile: TMenuItem;
    MIEMailCat: TMenuItem;
    MISearch: TMenuItem;
    MIFindElements: TMenuItem;
    MIFindSubstring: TMenuItem;
    MIFindInText: TMenuItem;
    MIFindSelection: TMenuItem;
    N23: TMenuItem;
    MIFindAndReplace: TMenuItem;
    N6: TMenuItem;
    MIWebSearch: TMenuItem;
    N1: TMenuItem;
    MiConceptRegistry: TMenuItem;
    MILinkRegistry: TMenuItem;
    MIText: TMenuItem;
    MILexicon: TMenuItem;
    MIImage: TMenuItem;
    MISound: TMenuItem;
    N37: TMenuItem;
    MITemplate: TMenuItem;
    MITasklists: TMenuItem;
    MIReference: TMenuItem;
    MIOtherRegistries: TMenuItem;
    MIFont: TMenuItem;
    N13: TMenuItem;
    MITranslation: TMenuItem;
    MIPronunciation: TMenuItem;
    MIPronunciationBySound: TMenuItem;
    MIComment: TMenuItem;
    N8: TMenuItem;
    MIVideo: TMenuItem;
    MIBinary: TMenuItem;
    MIStyle: TMenuItem;
    MIScript: TMenuItem;
    MIOLE: TMenuItem;
    N33: TMenuItem;
    MIGoTo: TMenuItem;
    MILearn: TMenuItem;
    MILearnAll: TMenuItem;
    MIGoNeural: TMenuItem;
    MILearnStages: TMenuItem;
    MILearnOutstanding: TMenuItem;
    MILearnNew: TMenuItem;
    MILearnDrill: TMenuItem;
    MISortOptions: TMenuItem;
    MIAutoSort: TMenuItem;
    MISortingCriteria: TMenuItem;
    MISortReps: TMenuItem;
    MIPostponeOptions: TMenuItem;
    MIAutoPostpone: TMenuItem;
    N18: TMenuItem;
    MIPostponeTopics: TMenuItem;
    MIPostponeItems: TMenuItem;
    MIPostponeAll: TMenuItem;
    N3: TMenuItem;
    Random1: TMenuItem;
    MIRandomizeRepetitions: TMenuItem;
    MIRandomLearning: TMenuItem;
    MICutDrills: TMenuItem;
    MIView: TMenuItem;
    MIBrowseOutstanding: TMenuItem;
    MILinkList: TMenuItem;
    MINeuralQueue: TMenuItem;
    MIPriorityBrowser: TMenuItem;
    N14: TMenuItem;
    MIBrowseAll: TMenuItem;
    MIBrowseMemorized: TMenuItem;
    MIBrowseDismissed: TMenuItem;
    N38: TMenuItem;
    MIConcepts: TMenuItem;
    MIBrowseTopics: TMenuItem;
    MIBrowseItems: TMenuItem;
    MIAllTasks: TMenuItem;
    N12: TMenuItem;
    MILast: TMenuItem;
    MIBrowseSearched: TMenuItem;
    MIBrowseSubset: TMenuItem;
    MIBrowseFilter: TMenuItem;
    N40: TMenuItem;
    MIRecentBrowser: TMenuItem;
    MILearned: TMenuItem;
    MIReview: TMenuItem;
    N44: TMenuItem;
    MIElementsToPostpone: TMenuItem;
    MIPostponedElements: TMenuItem;
    MIUnpostponed: TMenuItem;
    Advanced1: TMenuItem;
    N43: TMenuItem;
    MIPreviousBrowser: TMenuItem;
    MIOtherBrowsers: TMenuItem;
    MIBrowseLeeches: TMenuItem;
    MISemiLeeches: TMenuItem;
    MIBrowsePending: TMenuItem;
    MIBrowseDrill: TMenuItem;
    MIBrowseRange: TMenuItem;
    MIHistory: TMenuItem;
    MIBrowseNode: TMenuItem;
    MITools: TMenuItem;
    MICommander: TMenuItem;
    MIWorkload: TMenuItem;
    MISleepChart: TMenuItem;
    MIPlan: TMenuItem;
    MIMercy: TMenuItem;
    MITasklist: TMenuItem;
    MIStatisticsMenu: TMenuItem;
    MIStatistics: TMenuItem;
    MIElementStatistics: TMenuItem;
    MIAnalysis: TMenuItem;
    MISimulation: TMenuItem;
    MIGenerateReport: TMenuItem;
    MIResetOptimization: TMenuItem;
    MIResetFI: TMenuItem;
    MIResetFIPriority: TMenuItem;
    MIResetFirstGradeVsAF: TMenuItem;
    Gradevsforgettingindex1: TMenuItem;
    MIResetAvgRepetitionTime: TMenuItem;
    MIResetRepetitionHistory: TMenuItem;
    MIResetMatrices: TMenuItem;
    N54: TMenuItem;
    MIMemoryMenu: TMenuItem;
    Graphs4D: TMenuItem;
    MIMemoryStatus: TMenuItem;
    MITotalKnowledge: TMenuItem;
    MIExportData: TMenuItem;
    MIMemoryStability: TMenuItem;
    MIRecomputeDifficulties: TMenuItem;
    MICollectDifficultyData: TMenuItem;
    MISaveRecallMatrix: TMenuItem;
    MINeuralAnalysis: TMenuItem;
    N22: TMenuItem;
    MIRandomize: TMenuItem;
    MIRandomizeDrill: TMenuItem;
    MIRandomizePending: TMenuItem;
    MIRandomTests: TMenuItem;
    MIResumeTest: TMenuItem;
    N26: TMenuItem;
    MIRandomAll: TMenuItem;
    MIRandomPending: TMenuItem;
    MIRandomMemorized: TMenuItem;
    MIRandomDismissed: TMenuItem;
    N27: TMenuItem;
    MIRandomTopics: TMenuItem;
    MIRandomItems: TMenuItem;
    N28: TMenuItem;
    MIRandomFilter: TMenuItem;
    MIRandomLeeches: TMenuItem;
    N30: TMenuItem;
    MIRandomSubset: TMenuItem;
    N29: TMenuItem;
    MIRandomNode: TMenuItem;
    MIRandomReview: TMenuItem;
    BreakModifyInSubset: TMenuItem;
    MIOptions: TMenuItem;
    MIWindow: TMenuItem;
    MIThemes: TMenuItem;
    MILayout: TMenuItem;
    MILayouts: TMenuItem;
    N2: TMenuItem;
    MIDefaultLayout: TMenuItem;
    MIWarriorLayout: TMenuItem;
    MIClassicLayout: TMenuItem;
    N16: TMenuItem;
    MISaveLayout: TMenuItem;
    MISaveDefaultLayout: TMenuItem;
    N17: TMenuItem;
    MIBackColor: TMenuItem;
    MIBackgroundPicture: TMenuItem;
    MIAboutPicture: TMenuItem;
    MIHints: TMenuItem;
    N7: TMenuItem;
    MIOpenContents: TMenuItem;
    MIStatusBar: TMenuItem;
    MIBackground: TMenuItem;
    MIStatistics1: TMenuItem;
    MIElementData1: TMenuItem;
    MIAncestors: TMenuItem;
    N15: TMenuItem;
    MIHideSuperMemo: TMenuItem;
    ApplyLayoutBreak1: TMenuItem;
    AL1: TMenuItem;
    AL2: TMenuItem;
    AL3: TMenuItem;
    AL4: TMenuItem;
    AL5: TMenuItem;
    AL6: TMenuItem;
    AL7: TMenuItem;
    AL8: TMenuItem;
    AL9: TMenuItem;
    MIHelp: TMenuItem;
    MIFrontPage: TMenuItem;
    MIHelpGuide: TMenuItem;
    MIHelpContents: TMenuItem;
    MIFAQHelp: TMenuItem;
    MIHintsAndTips: TMenuItem;
    MIHelpContext: TMenuItem;
    N9: TMenuItem;
    MIUserSurvey: TMenuItem;
    MIHelpWeb: TMenuItem;
    MIInternetHelp: TMenuItem;
    MIVideos: TMenuItem;
    N47: TMenuItem;
    MISearchWiki: TMenuItem;
    MISearchHelp: TMenuItem;
    MISearchSuperMemopedia: TMenuItem;
    MIGoogleSearch: TMenuItem;
    MIHelpEMail: TMenuItem;
    MIEmailSupport: TMenuItem;
    MIBugReport: TMenuItem;
    MIFeedback: TMenuItem;
    BreakInternetUpdate: TMenuItem;
    MITipOfTheDay: TMenuItem;
    N31: TMenuItem;
    MIAbout: TMenuItem;
    MIElementShortcuts: TMenuItem;
    Link1: TMenuItem;
    Registrymember1: TMenuItem;
    MIRenameMember: TMenuItem;
    MILinkExternal: TMenuItem;
    MIImportFile: TMenuItem;
    MIHyperlink: TMenuItem;
    Component1: TMenuItem;
    Deletecurrentcomponent1: TMenuItem;
    Componentorder1: TMenuItem;
    Hyperlink1: TMenuItem;
    Setreadingpoint1: TMenuItem;
    Clearreadpoint1: TMenuItem;
    Gotoreadpoint1: TMenuItem;
    Viewsource1: TMenuItem;
    MISaveLocally: TMenuItem;
    Undo1: TMenuItem;
    Nextcomponent1: TMenuItem;
    Dragging1: TMenuItem;
    Dragup1: TMenuItem;
    Dragdown1: TMenuItem;
    Dragleft1: TMenuItem;
    Dragright1: TMenuItem;
    Newelement1: TMenuItem;
    MIShortcutAhead: TMenuItem;
    Back1: TMenuItem;
    N46: TMenuItem;
    FirstElement1: TMenuItem;
    LastElement1: TMenuItem;
    Nextelement1: TMenuItem;
    Previouselement1: TMenuItem;
    Parentelement1: TMenuItem;
    MIPostpone1: TMenuItem;
    MILearnBranch: TMenuItem;
    Extract1: TMenuItem;
    ScheduleExtract1: TMenuItem;
    Cloze1: TMenuItem;
    Reference1: TMenuItem;
    MICapitalize: TMenuItem;
    EMail1: TMenuItem;
    Deletebeforecursor1: TMenuItem;
    Deleteaftercursor1: TMenuItem;
    MIGlobalShortcuts: TMenuItem;
    Edit2: TMenuItem;
    MINextComponent: TMenuItem;
    MIElementParameters: TMenuItem;
    Prioritydialog1: TMenuItem;
    MIDuplicate: TMenuItem;
    Swap1: TMenuItem;
    Transliterateall1: TMenuItem;
    MIEditingMode: TMenuItem;
    Viewfile1: TMenuItem;
    MIEditFile: TMenuItem;
    Viewsource2: TMenuItem;
    Switchimagestretch1: TMenuItem;
    FilterRTF1: TMenuItem;
    Plaintext1: TMenuItem;
    MIInsertHR: TMenuItem;
    Classify1: TMenuItem;
    Memorize1: TMenuItem;
    Dismiss1: TMenuItem;
    Drill1: TMenuItem;
    Jumpinterval1: TMenuItem;
    Shifttolater1: TMenuItem;
    Forcerepetition1: TMenuItem;
    Done1: TMenuItem;
    Repetitionhistory2: TMenuItem;
    Font1: TMenuItem;
    MINewFont: TMenuItem;
    MIBoldFont: TMenuItem;
    Italicfont1: TMenuItem;
    Underlinefont1: TMenuItem;
    Increasefontsize1: TMenuItem;
    Decreasefontsize1: TMenuItem;
    Template1: TMenuItem;
    ElWindApplyTemplate: TMenuItem;
    MISaveDefaultTemplate: TMenuItem;
    ImposeTemplate1: TMenuItem;
    MIEscape: TMenuItem;
    Repeatautoplay1: TMenuItem;
    MITestRepetition: TMenuItem;
    Popupmenu1: TMenuItem;
    MIShowReference: TMenuItem;
    MIRemoveFormattingGlobal: TMenuItem;
    N49: TMenuItem;
    Downloadimages1: TMenuItem;
    Spellcheck1: TMenuItem;
    MIProcessImageOptions: TMenuItem;
    WebSearch1: TMenuItem;
    ColorDialog1: TColorDialog;
    OpenDialog1: TOpenDialog;
    RepetitionTimer: TTimer;
    TimeUpdate: TTimer;
    FontDialog1: TFontDialog;
    SaveDialog: TSaveDialog;
    PlanTimer: TTimer;
    TrayIcon1: TTrayIcon;
    AlarmFlicker: TTimer;
    procedure ActAddTaskExecute(Sender: TObject);
    procedure ActBackgroundExecute(Sender: TObject);
    procedure ActBasicExecute(Sender: TObject);
    procedure ActBeginnerExecute(Sender: TObject);
    procedure ActMiddleExecute(Sender: TObject);
    procedure ActNextLevelExecute(Sender: TObject);
    procedure ActPrevLevelExecute(Sender: TObject);
    procedure ActProfessionalExecute(Sender: TObject);
    procedure ActTextRegistryExecute(Sender: TObject);
    procedure Advanced1Click(Sender: TObject);
    procedure AlarmDisplayClick(Sender: TObject);
    procedure AlarmFlickerTimer(Sender: TObject);
    procedure AlignCenterClick(Sender: TObject);
    procedure AlignLeftClick(Sender: TObject);
    procedure AlignRightClick(Sender: TObject);
    procedure AlignmentButton1Click(Sender: TObject);
    procedure ApplyCustomLayout(Sender: TObject);
    procedure ApplyHighlighterClick(Sender: TObject);
    procedure Back1Click(Sender: TObject);
    procedure BackupBtnClick(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure BulletsClick(Sender: TObject);
    procedure ChooseFromPickList(Sender: TObject);
    procedure ChooseHighlighterClick(Sender: TObject);
    procedure ClassicLayout(Sender: TObject);
    procedure ClearReadPointClick(Sender: TObject);
    procedure Clearreadpoint1Click(Sender: TObject);
    procedure Cloze1Click(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure CompMenu2Click(Sender: TObject);
    procedure Componentorder1Click(Sender: TObject);
    procedure CopyElementButtonClick(Sender: TObject);
    procedure CreateScriptClick(Sender: TObject);
    procedure Decreasefontsize1Click(Sender: TObject);
    procedure DelAfterCursorBtnClick(Sender: TObject);
    procedure DelBeforeCursorBtnClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure Deleteaftercursor1Click(Sender: TObject);
    procedure Deletebeforecursor1Click(Sender: TObject);
    procedure Deletecurrentcomponent1Click(Sender: TObject);
    procedure Dismiss1Click(Sender: TObject);
    procedure DisplayButtonClick(Sender: TObject);
    procedure Done1Click(Sender: TObject);
    procedure Downloadimages1Click(Sender: TObject);
    procedure Dragdown1Click(Sender: TObject);
    procedure DraggingButtonClick(Sender: TObject);
    procedure Dragleft1Click(Sender: TObject);
    procedure Dragright1Click(Sender: TObject);
    procedure Dragup1Click(Sender: TObject);
    procedure Drill1Click(Sender: TObject);
    procedure EMail1Click(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ElWindApplyTemplateClick(Sender: TObject);
    procedure EllipseButtonClick(Sender: TObject);
    procedure Extract1Click(Sender: TObject);
    procedure FilterRTF1Click(Sender: TObject);
    procedure FirstElement1Click(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure FontColorButtonClick(Sender: TObject);
    procedure FontDownButtonClick(Sender: TObject);
    procedure FontUpButtonClick(Sender: TObject);
    procedure Forcerepetition1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GoToReadPointClick(Sender: TObject);
    procedure Gotoreadpoint1Click(Sender: TObject);
    procedure Gradevsforgettingindex1Click(Sender: TObject);
    procedure Graphs4DClick(Sender: TObject);
    procedure HTMButtonClick(Sender: TObject);
    procedure Hyperlink1Click(Sender: TObject);
    procedure IgnoreTextClick(Sender: TObject);
    procedure ImageButtonClick(Sender: TObject);
    procedure ImportQA_XMLClick(Sender: TObject);
    procedure ImportWebPagesClick(Sender: TObject);
    procedure ImposeTemplate1Click(Sender: TObject);
    procedure Increasefontsize1Click(Sender: TObject);
    procedure IndentClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure Italicfont1Click(Sender: TObject);
    procedure Jumpinterval1Click(Sender: TObject);
    procedure LastElement1Click(Sender: TObject);
    procedure Lexicon1Click(Sender: TObject);
    procedure LoadTemplateBtnClick(Sender: TObject);
    procedure MIAboutClick(Sender: TObject);
    procedure MIAboutPictureClick(Sender: TObject);
    procedure MIAddArticleClick(Sender: TObject);
    procedure MIAddHTMLClick(Sender: TObject);
    procedure MIAddHTMLNoteClick(Sender: TObject);
    procedure MIAddImageClick(Sender: TObject);
    procedure MIAddItemClick(Sender: TObject);
    procedure MIAddNoteClick(Sender: TObject);
    procedure MIAddPageClick(Sender: TObject);
    procedure MIAddPronunciationClick(Sender: TObject);
    procedure MIAddSoundClick(Sender: TObject);
    procedure MIAddSpellClick(Sender: TObject);
    procedure MIAddTextClick(Sender: TObject);
    procedure MIAddVideoComponentClick(Sender: TObject);
    procedure MIAllTasksClick(Sender: TObject);
    procedure MIAnalysisClick(Sender: TObject);
    procedure MIAncestorsClick(Sender: TObject);
    procedure MIApplyDefaultlayoutClick(Sender: TObject);
    procedure MIApplyFilterClick(Sender: TObject);
    procedure MIAuthorClick(Sender: TObject);
    procedure MIAutoPostponeClick(Sender: TObject);
    procedure MIAutoSortClick(Sender: TObject);
    procedure MIBackColorClick(Sender: TObject);
    procedure MIBackgroundPictureClick(Sender: TObject);
    procedure MIBackupClick(Sender: TObject);
    procedure MIBinaryClick(Sender: TObject);
    procedure MIBoldFontClick(Sender: TObject);
    procedure MIBrowseAllClick(Sender: TObject);
    procedure MIBrowseDismissedClick(Sender: TObject);
    procedure MIBrowseDrillClick(Sender: TObject);
    procedure MIBrowseFilterClick(Sender: TObject);
    procedure MIBrowseItemsClick(Sender: TObject);
    procedure MIBrowseLeechesClick(Sender: TObject);
    procedure MIBrowseMemorizedClick(Sender: TObject);
    procedure MIBrowseNodeClick(Sender: TObject);
    procedure MIBrowseOutstandingClick(Sender: TObject);
    procedure MIBrowsePendingClick(Sender: TObject);
    procedure MIBrowseRangeClick(Sender: TObject);
    procedure MIBrowseSearchedClick(Sender: TObject);
    procedure MIBrowseSubsetClick(Sender: TObject);
    procedure MIBrowseTopicsClick(Sender: TObject);
    procedure MIBrowserMenuClick(Sender: TObject);
    procedure MIBugReportClick(Sender: TObject);
    procedure MICapitalizeClick(Sender: TObject);
    procedure MICollectDifficultyDataClick(Sender: TObject);
    procedure MICollectionSizeClick(Sender: TObject);
    procedure MICommanderClick(Sender: TObject);
    procedure MICommentClick(Sender: TObject);
    procedure MIComponentMenuClick(Sender: TObject);
    procedure MIConceptsClick(Sender: TObject);
    procedure MIContentsMenuClick(Sender: TObject);
    procedure MICopyClick(Sender: TObject);
    procedure MICreateConceptClick(Sender: TObject);
    procedure MICreateTasklistClick(Sender: TObject);
    procedure MICutDrillsClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIDeleteComponentsClick(Sender: TObject);
    procedure MIDeleteElementClick(Sender: TObject);
    procedure MIDuplicateClick(Sender: TObject);
    procedure MIEMailCatClick(Sender: TObject);
    procedure MIEditClick(Sender: TObject);
    procedure MIEditFileClick(Sender: TObject);
    procedure MIEditFirstAClick(Sender: TObject);
    procedure MIEditFirstQClick(Sender: TObject);
    procedure MIEditTextClick(Sender: TObject);
    procedure MIEditTextsClick(Sender: TObject);
    procedure MIEditingModeClick(Sender: TObject);
    procedure MIElementMenuClick(Sender: TObject);
    procedure MIElementParametersClick(Sender: TObject);
    procedure MIElementStatisticsClick(Sender: TObject);
    procedure MIElementsToPostponeClick(Sender: TObject);
    procedure MIEmailSupportClick(Sender: TObject);
    procedure MIEscapeClick(Sender: TObject);
    procedure MIExitClick(Sender: TObject);
    procedure MIExportAsXMLClick(Sender: TObject);
    procedure MIExportDataClick(Sender: TObject);
    procedure MIExportDocumentClick(Sender: TObject);
    procedure MIExportLearningClick(Sender: TObject);
    procedure MIExportQAClick(Sender: TObject);
    procedure MIExportRepHistoryClick(Sender: TObject);
    procedure MIExportTextClick(Sender: TObject);
    procedure MIFAQHelpClick(Sender: TObject);
    procedure MIFavoritesClick(Sender: TObject);
    procedure MIFeedbackClick(Sender: TObject);
    procedure MIFileClick(Sender: TObject);
    procedure MIFindAndReplaceClick(Sender: TObject);
    procedure MIFindElementsClick(Sender: TObject);
    procedure MIFindInTextClick(Sender: TObject);
    procedure MIFindSelectionClick(Sender: TObject);
    procedure MIFindSubstringClick(Sender: TObject);
    procedure MIFindWordClick(Sender: TObject);
    procedure MIFoldersClick(Sender: TObject);
    procedure MIFontClick(Sender: TObject);
    procedure MIFrontPageClick(Sender: TObject);
    procedure MIGarbageClick(Sender: TObject);
    procedure MIGenerateReportClick(Sender: TObject);
    procedure MIGoNeuralClick(Sender: TObject);
    procedure MIGoToClick(Sender: TObject);
    procedure MIGoogleSearchClick(Sender: TObject);
    procedure MIHTMLExportClick(Sender: TObject);
    procedure MIHTMLFileClick(Sender: TObject);
    procedure MIHelpClick(Sender: TObject);
    procedure MIHelpContentsClick(Sender: TObject);
    procedure MIHelpContextClick(Sender: TObject);
    procedure MIHelpGuideClick(Sender: TObject);
    procedure MIHideSuperMemoClick(Sender: TObject);
    procedure MIHintsAndTipsClick(Sender: TObject);
    procedure MIHintsClick(Sender: TObject);
    procedure MIHistoryClick(Sender: TObject);
    procedure MIHyperlinkClick(Sender: TObject);
    procedure MIImageClick(Sender: TObject);
    procedure MIImportFileClick(Sender: TObject);
    procedure MIImportLearningClick(Sender: TObject);
    procedure MIImportMailClick(Sender: TObject);
    procedure MIImportPicturesClick(Sender: TObject);
    procedure MIImportRepHistoryClick(Sender: TObject);
    procedure MIImportTextClick(Sender: TObject);
    procedure MIInputPasswordClick(Sender: TObject);
    procedure MIInsertHRClick(Sender: TObject);
    procedure MIInstallIconsClick(Sender: TObject);
    procedure MIInstallationClick(Sender: TObject);
    procedure MIInternetHelpClick(Sender: TObject);
    procedure MIInvisibleWorkloadClick(Sender: TObject);
    procedure MILastClick(Sender: TObject);
    procedure MILayoutsClick(Sender: TObject);
    procedure MILearnBranchClick(Sender: TObject);
    procedure MILearnClick(Sender: TObject);
    procedure MILearnDrillClick(Sender: TObject);
    procedure MILearnNewClick(Sender: TObject);
    procedure MILearnOutstandingClick(Sender: TObject);
    procedure MILearnedClick(Sender: TObject);
    procedure MILevelClick(Sender: TObject);
    procedure MILinkExternalClick(Sender: TObject);
    procedure MILinkListClick(Sender: TObject);
    procedure MILinkRegistryClick(Sender: TObject);
    procedure MIMCTTextClick(Sender: TObject);
    procedure MIMemoryStatusClick(Sender: TObject);
    procedure MIMercyClick(Sender: TObject);
    procedure MIMergeClick(Sender: TObject);
    procedure MIMoveClick(Sender: TObject);
    procedure MINeuralAnalysisClick(Sender: TObject);
    procedure MINeuralQueueClick(Sender: TObject);
    procedure MINewClick(Sender: TObject);
    procedure MINewFontClick(Sender: TObject);
    procedure MINextComponentClick(Sender: TObject);
    procedure MIOLEClick(Sender: TObject);
    procedure MIOpenClick(Sender: TObject);
    procedure MIOpenContentsClick(Sender: TObject);
    procedure MIOpenWebLinksClick(Sender: TObject);
    procedure MIOptionsClick(Sender: TObject);
    procedure MIOwnerClick(Sender: TObject);
    procedure MIPlanClick(Sender: TObject);
    procedure MIPostpone1Click(Sender: TObject);
    procedure MIPostponeAllClick(Sender: TObject);
    procedure MIPostponeItemsClick(Sender: TObject);
    procedure MIPostponeOptionsClick(Sender: TObject);
    procedure MIPostponeTopicsClick(Sender: TObject);
    procedure MIPostponedElementsClick(Sender: TObject);
    procedure MIPreviousBrowserClick(Sender: TObject);
    procedure MIPriorityBrowserClick(Sender: TObject);
    procedure MIProcessCollectionClick(Sender: TObject);
    procedure MIProcessImageOptionsClick(Sender: TObject);
    procedure MIPronunciationBySoundClick(Sender: TObject);
    procedure MIPronunciationClick(Sender: TObject);
    procedure MIPropertiesClick(Sender: TObject);
    procedure MIPublishClick(Sender: TObject);
    procedure MIRandomAllClick(Sender: TObject);
    procedure MIRandomDismissedClick(Sender: TObject);
    procedure MIRandomFilterClick(Sender: TObject);
    procedure MIRandomItemsClick(Sender: TObject);
    procedure MIRandomLearningClick(Sender: TObject);
    procedure MIRandomLeechesClick(Sender: TObject);
    procedure MIRandomMemorizedClick(Sender: TObject);
    procedure MIRandomNodeClick(Sender: TObject);
    procedure MIRandomPendingClick(Sender: TObject);
    procedure MIRandomReviewClick(Sender: TObject);
    procedure MIRandomSubsetClick(Sender: TObject);
    procedure MIRandomTestsClick(Sender: TObject);
    procedure MIRandomTopicsClick(Sender: TObject);
    procedure MIRandomizeClick(Sender: TObject);
    procedure MIRandomizeDrillClick(Sender: TObject);
    procedure MIRandomizePendingClick(Sender: TObject);
    procedure MIRandomizeRepetitionsClick(Sender: TObject);
    procedure MIRecomputeDifficultiesClick(Sender: TObject);
    procedure MIRecoverClick(Sender: TObject);
    procedure MIReferenceClick(Sender: TObject);
    procedure MIRegistryMenuClick(Sender: TObject);
    procedure MIRemoveFormattingGlobalClick(Sender: TObject);
    procedure MIRenameClick(Sender: TObject);
    procedure MIRenamememberClick(Sender: TObject);
    procedure MIReportClick(Sender: TObject);
    procedure MIRequestPasswordClick(Sender: TObject);
    procedure MIResetAvgRepetitionTimeClick(Sender: TObject);
    procedure MIResetClick(Sender: TObject);
    procedure MIResetFIClick(Sender: TObject);
    procedure MIResetFIPriorityClick(Sender: TObject);
    procedure MIResetFirstGradeVsAFClick(Sender: TObject);
    procedure MIResetMatricesClick(Sender: TObject);
    procedure MIResetRepetitionHistoryClick(Sender: TObject);
    procedure MIResumeTestClick(Sender: TObject);
    procedure MIReviewClick(Sender: TObject);
    procedure MISaveDefaultLayoutClick(Sender: TObject);
    procedure MISaveDefaultTemplateClick(Sender: TObject);
    procedure MISaveLayoutClick(Sender: TObject);
    procedure MISaveLocallyClick(Sender: TObject);
    procedure MISaveRecallMatrixClick(Sender: TObject);
    procedure MIScriptClick(Sender: TObject);
    procedure MISearchClick(Sender: TObject);
    procedure MISearchHelpClick(Sender: TObject);
    procedure MISearchSuperMemopediaClick(Sender: TObject);
    procedure MISearchWikiClick(Sender: TObject);
    procedure MISemiLeechesClick(Sender: TObject);
    procedure MIShortcutAheadClick(Sender: TObject);
    procedure MISimulationClick(Sender: TObject);
    procedure MISleepChartClick(Sender: TObject);
    procedure MISortOptionsClick(Sender: TObject);
    procedure MISortRepsClick(Sender: TObject);
    procedure MISortingCriteriaClick(Sender: TObject);
    procedure MISoundClick(Sender: TObject);
    procedure MIStatisticsClick(Sender: TObject);
    procedure MIStatusBarClick(Sender: TObject);
    procedure MIStyleClick(Sender: TObject);
    procedure MITasklistClick(Sender: TObject);
    procedure MITasklistsClick(Sender: TObject);
    procedure MITemplateClick(Sender: TObject);
    procedure MITestRepetitionClick(Sender: TObject);
    procedure MIThemesClick(Sender: TObject);
    procedure MITipOfTheDayClick(Sender: TObject);
    procedure MIToolsClick(Sender: TObject);
    procedure MITotalKnowledgeClick(Sender: TObject);
    procedure MITransferSubsetClick(Sender: TObject);
    procedure MITranslationClick(Sender: TObject);
    procedure MITranslationImportClick(Sender: TObject);
    procedure MIUnpostponedClick(Sender: TObject);
    procedure MIUnregisterClick(Sender: TObject);
    procedure MIUserSurveyClick(Sender: TObject);
    procedure MIVideoClick(Sender: TObject);
    procedure MIVideosClick(Sender: TObject);
    procedure MIViewClick(Sender: TObject);
    procedure MIViewFAQClick(Sender: TObject);
    procedure MIViewHTMLClick(Sender: TObject);
    procedure MIWarriorClick(Sender: TObject);
    procedure MIWarriorLayoutClick(Sender: TObject);
    procedure MIWebImportClick(Sender: TObject);
    procedure MIWebSearchClick(Sender: TObject);
    procedure MIWikipediaClick(Sender: TObject);
    procedure MIWindowClick(Sender: TObject);
    procedure MIWorkloadClick(Sender: TObject);
    procedure MIXMLSynchronizationClick(Sender: TObject);
    procedure MIYouTubeClick(Sender: TObject);
    procedure Memorize1Click(Sender: TObject);
    procedure MiConceptRegistryClick(Sender: TObject);
    procedure Nextcomponent1Click(Sender: TObject);
    procedure Nextelement1Click(Sender: TObject);
    procedure NumberButtonClick(Sender: TObject);
    procedure NumbersClick(Sender: TObject);
    procedure OLEButtonClick(Sender: TObject);
    procedure OpenCollectionBtnClick(Sender: TObject);
    procedure OutdentClick(Sender: TObject);
    procedure Parentelement1Click(Sender: TObject);
    procedure PasteArticleClick(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure PathListButtonClick(Sender: TObject);
    procedure Plaintext1Click(Sender: TObject);
    procedure PlanAlarmNotify(Sender: TObject);
    procedure PlanTimerTimer(Sender: TObject);
    procedure Popupmenu1Click(Sender: TObject);
    procedure Previouselement1Click(Sender: TObject);
    procedure Prioritydialog1Click(Sender: TObject);
    procedure ProgramButtonClick(Sender: TObject);
    procedure RRectangleButtonClick(Sender: TObject);
    procedure RTFButtonClick(Sender: TObject);
    procedure RectangleButtonClick(Sender: TObject);
    procedure Reference1Click(Sender: TObject);
    procedure Registrymember1Click(Sender: TObject);
    procedure RememberClozeClick(Sender: TObject);
    procedure RememberExtractClick(Sender: TObject);
    procedure Repeatautoplay1Click(Sender: TObject);
    procedure RepetitionTimerTimer(Sender: TObject);
    procedure Repetitionhistory2Click(Sender: TObject);
    procedure ResetTimerClick(Sender: TObject);
    procedure SaveTemplateBtnClick(Sender: TObject);
    procedure ScheduleClozeClick(Sender: TObject);
    procedure ScheduleExtract1Click(Sender: TObject);
    procedure ScheduleExtractClick(Sender: TObject);
    procedure SendFAQClick(Sender: TObject);
    procedure SendTextClick(Sender: TObject);
    procedure SetAlarmButtonClick(Sender: TObject);
    procedure SetReadPointClick(Sender: TObject);
    procedure Setreadingpoint1Click(Sender: TObject);
    procedure Shifttolater1Click(Sender: TObject);
    procedure SoundButtonClick(Sender: TObject);
    procedure SpellButtonClick(Sender: TObject);
    procedure Spellcheck1Click(Sender: TObject);
    procedure SplitBtnClick(Sender: TObject);
    procedure StartTimerButtonClick(Sender: TObject);
    procedure StopAlarmBtnClick(Sender: TObject);
    procedure SubscriptClick(Sender: TObject);
    procedure SuperScriptClick(Sender: TObject);
    procedure Swap1Click(Sender: TObject);
    procedure SwitchModeBtnClick(Sender: TObject);
    procedure Switchimagestretch1Click(Sender: TObject);
    procedure TaskExtractClick(Sender: TObject);
    procedure TasklistButtonClick(Sender: TObject);
    procedure TestRepetitionClick(Sender: TObject);
    procedure TextButtonClick(Sender: TObject);
    procedure TimeUpdateTimer(Sender: TObject);
    procedure Title1Click(Sender: TObject);
    procedure Transliterateall1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure Underlinefont1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure VideoButtonClick(Sender: TObject);
    procedure ViewSourceBtn1Click(Sender: TObject);
    procedure Viewfile1Click(Sender: TObject);
    procedure Viewsource1Click(Sender: TObject);
    procedure Viewsource2Click(Sender: TObject);
    procedure WebSearch1Click(Sender: TObject);
    procedure WebSearchBtnClick(Sender: TObject);
    procedure WorkloadBtnClick(Sender: TObject);
  end;

var
  SMMain: TSMMain;

implementation

{$R *.lfm}

procedure TSMMain.ActAddTaskExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActAddTaskExecute');
end;

procedure TSMMain.ActBackgroundExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActBackgroundExecute');
end;

procedure TSMMain.ActBasicExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActBasicExecute');
end;

procedure TSMMain.ActBeginnerExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActBeginnerExecute');
end;

procedure TSMMain.ActMiddleExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActMiddleExecute');
end;

procedure TSMMain.ActNextLevelExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActNextLevelExecute');
end;

procedure TSMMain.ActPrevLevelExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActPrevLevelExecute');
end;

procedure TSMMain.ActProfessionalExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActProfessionalExecute');
end;

procedure TSMMain.ActTextRegistryExecute(Sender: TObject);
begin
  DispatchAction(Sender, 'ActTextRegistryExecute');
end;

procedure TSMMain.Advanced1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Advanced1Click');
end;

procedure TSMMain.AlarmDisplayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlarmDisplayClick');
end;

procedure TSMMain.AlarmFlickerTimer(Sender: TObject);
begin
end;

procedure TSMMain.AlignCenterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlignCenterClick');
end;

procedure TSMMain.AlignLeftClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlignLeftClick');
end;

procedure TSMMain.AlignRightClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AlignRightClick');
end;

procedure TSMMain.AlignmentButton1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'AlignmentButton1Click');
end;

procedure TSMMain.ApplyCustomLayout(Sender: TObject);
begin
  DispatchAction(Sender, 'ApplyCustomLayout');
end;

procedure TSMMain.ApplyHighlighterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ApplyHighlighterClick');
end;

procedure TSMMain.Back1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Back1Click');
end;

procedure TSMMain.BackupBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BackupBtnClick');
end;

procedure TSMMain.BoldButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BoldButtonClick');
end;

procedure TSMMain.BulletsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'BulletsClick');
end;

procedure TSMMain.ChooseFromPickList(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseFromPickList');
end;

procedure TSMMain.ChooseHighlighterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseHighlighterClick');
end;

procedure TSMMain.ClassicLayout(Sender: TObject);
begin
  DispatchAction(Sender, 'ClassicLayout');
end;

procedure TSMMain.ClearReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ClearReadPointClick');
end;

procedure TSMMain.Clearreadpoint1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Clearreadpoint1Click');
end;

procedure TSMMain.Cloze1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Cloze1Click');
end;

procedure TSMMain.ColorButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ColorButtonClick');
end;

procedure TSMMain.CompMenu2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'CompMenu2Click');
end;

procedure TSMMain.Componentorder1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Componentorder1Click');
end;

procedure TSMMain.CopyElementButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CopyElementButtonClick');
end;

procedure TSMMain.CreateScriptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CreateScriptClick');
end;

procedure TSMMain.Decreasefontsize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Decreasefontsize1Click');
end;

procedure TSMMain.DelAfterCursorBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DelAfterCursorBtnClick');
end;

procedure TSMMain.DelBeforeCursorBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DelBeforeCursorBtnClick');
end;

procedure TSMMain.DeleteButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteButtonClick');
end;

procedure TSMMain.Deleteaftercursor1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Deleteaftercursor1Click');
end;

procedure TSMMain.Deletebeforecursor1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Deletebeforecursor1Click');
end;

procedure TSMMain.Deletecurrentcomponent1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Deletecurrentcomponent1Click');
end;

procedure TSMMain.Dismiss1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Dismiss1Click');
end;

procedure TSMMain.DisplayButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DisplayButtonClick');
end;

procedure TSMMain.Done1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Done1Click');
end;

procedure TSMMain.Downloadimages1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Downloadimages1Click');
end;

procedure TSMMain.Dragdown1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Dragdown1Click');
end;

procedure TSMMain.DraggingButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DraggingButtonClick');
end;

procedure TSMMain.Dragleft1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Dragleft1Click');
end;

procedure TSMMain.Dragright1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Dragright1Click');
end;

procedure TSMMain.Dragup1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Dragup1Click');
end;

procedure TSMMain.Drill1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Drill1Click');
end;

procedure TSMMain.EMail1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'EMail1Click');
end;

procedure TSMMain.EditButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EditButtonClick');
end;

procedure TSMMain.ElWindApplyTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ElWindApplyTemplateClick');
end;

procedure TSMMain.EllipseButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EllipseButtonClick');
end;

procedure TSMMain.Extract1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Extract1Click');
end;

procedure TSMMain.FilterRTF1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'FilterRTF1Click');
end;

procedure TSMMain.FirstElement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'FirstElement1Click');
end;

procedure TSMMain.FontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontButtonClick');
end;

procedure TSMMain.FontColorButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontColorButtonClick');
end;

procedure TSMMain.FontDownButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontDownButtonClick');
end;

procedure TSMMain.FontUpButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FontUpButtonClick');
end;

procedure TSMMain.Forcerepetition1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Forcerepetition1Click');
end;

procedure TSMMain.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TSMMain.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TSMMain.FormCreate(Sender: TObject);
begin
end;

procedure TSMMain.FormDestroy(Sender: TObject);
begin
end;

procedure TSMMain.GoToReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToReadPointClick');
end;

procedure TSMMain.Gotoreadpoint1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Gotoreadpoint1Click');
end;

procedure TSMMain.Gradevsforgettingindex1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Gradevsforgettingindex1Click');
end;

procedure TSMMain.Graphs4DClick(Sender: TObject);
begin
  DispatchAction(Sender, 'Graphs4DClick');
end;

procedure TSMMain.HTMButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HTMButtonClick');
end;

procedure TSMMain.Hyperlink1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Hyperlink1Click');
end;

procedure TSMMain.IgnoreTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IgnoreTextClick');
end;

procedure TSMMain.ImageButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImageButtonClick');
end;

procedure TSMMain.ImportQA_XMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportQA_XMLClick');
end;

procedure TSMMain.ImportWebPagesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ImportWebPagesClick');
end;

procedure TSMMain.ImposeTemplate1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ImposeTemplate1Click');
end;

procedure TSMMain.Increasefontsize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Increasefontsize1Click');
end;

procedure TSMMain.IndentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IndentClick');
end;

procedure TSMMain.ItalicButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ItalicButtonClick');
end;

procedure TSMMain.Italicfont1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Italicfont1Click');
end;

procedure TSMMain.Jumpinterval1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Jumpinterval1Click');
end;

procedure TSMMain.LastElement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'LastElement1Click');
end;

procedure TSMMain.Lexicon1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Lexicon1Click');
end;

procedure TSMMain.LoadTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LoadTemplateBtnClick');
end;

procedure TSMMain.MIAboutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAboutClick');
end;

procedure TSMMain.MIAboutPictureClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAboutPictureClick');
end;

procedure TSMMain.MIAddArticleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddArticleClick');
end;

procedure TSMMain.MIAddHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddHTMLClick');
end;

procedure TSMMain.MIAddHTMLNoteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddHTMLNoteClick');
end;

procedure TSMMain.MIAddImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddImageClick');
end;

procedure TSMMain.MIAddItemClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddItemClick');
end;

procedure TSMMain.MIAddNoteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddNoteClick');
end;

procedure TSMMain.MIAddPageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddPageClick');
end;

procedure TSMMain.MIAddPronunciationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddPronunciationClick');
end;

procedure TSMMain.MIAddSoundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddSoundClick');
end;

procedure TSMMain.MIAddSpellClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddSpellClick');
end;

procedure TSMMain.MIAddTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTextClick');
end;

procedure TSMMain.MIAddVideoComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddVideoComponentClick');
end;

procedure TSMMain.MIAllTasksClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAllTasksClick');
end;

procedure TSMMain.MIAnalysisClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAnalysisClick');
end;

procedure TSMMain.MIAncestorsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAncestorsClick');
end;

procedure TSMMain.MIApplyDefaultlayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplyDefaultlayoutClick');
end;

procedure TSMMain.MIApplyFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIApplyFilterClick');
end;

procedure TSMMain.MIAuthorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAuthorClick');
end;

procedure TSMMain.MIAutoPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAutoPostponeClick');
end;

procedure TSMMain.MIAutoSortClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAutoSortClick');
end;

procedure TSMMain.MIBackColorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBackColorClick');
end;

procedure TSMMain.MIBackgroundPictureClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBackgroundPictureClick');
end;

procedure TSMMain.MIBackupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBackupClick');
end;

procedure TSMMain.MIBinaryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBinaryClick');
end;

procedure TSMMain.MIBoldFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBoldFontClick');
end;

procedure TSMMain.MIBrowseAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseAllClick');
end;

procedure TSMMain.MIBrowseDismissedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseDismissedClick');
end;

procedure TSMMain.MIBrowseDrillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseDrillClick');
end;

procedure TSMMain.MIBrowseFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseFilterClick');
end;

procedure TSMMain.MIBrowseItemsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseItemsClick');
end;

procedure TSMMain.MIBrowseLeechesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseLeechesClick');
end;

procedure TSMMain.MIBrowseMemorizedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseMemorizedClick');
end;

procedure TSMMain.MIBrowseNodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseNodeClick');
end;

procedure TSMMain.MIBrowseOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseOutstandingClick');
end;

procedure TSMMain.MIBrowsePendingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowsePendingClick');
end;

procedure TSMMain.MIBrowseRangeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseRangeClick');
end;

procedure TSMMain.MIBrowseSearchedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseSearchedClick');
end;

procedure TSMMain.MIBrowseSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseSubsetClick');
end;

procedure TSMMain.MIBrowseTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowseTopicsClick');
end;

procedure TSMMain.MIBrowserMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBrowserMenuClick');
end;

procedure TSMMain.MIBugReportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIBugReportClick');
end;

procedure TSMMain.MICapitalizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICapitalizeClick');
end;

procedure TSMMain.MICollectDifficultyDataClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICollectDifficultyDataClick');
end;

procedure TSMMain.MICollectionSizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICollectionSizeClick');
end;

procedure TSMMain.MICommanderClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICommanderClick');
end;

procedure TSMMain.MICommentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICommentClick');
end;

procedure TSMMain.MIComponentMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIComponentMenuClick');
end;

procedure TSMMain.MIConceptsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIConceptsClick');
end;

procedure TSMMain.MIContentsMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIContentsMenuClick');
end;

procedure TSMMain.MICopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyClick');
end;

procedure TSMMain.MICreateConceptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICreateConceptClick');
end;

procedure TSMMain.MICreateTasklistClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICreateTasklistClick');
end;

procedure TSMMain.MICutDrillsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICutDrillsClick');
end;

procedure TSMMain.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TSMMain.MIDeleteComponentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteComponentsClick');
end;

procedure TSMMain.MIDeleteElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteElementClick');
end;

procedure TSMMain.MIDuplicateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDuplicateClick');
end;

procedure TSMMain.MIEMailCatClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEMailCatClick');
end;

procedure TSMMain.MIEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditClick');
end;

procedure TSMMain.MIEditFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditFileClick');
end;

procedure TSMMain.MIEditFirstAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditFirstAClick');
end;

procedure TSMMain.MIEditFirstQClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditFirstQClick');
end;

procedure TSMMain.MIEditTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditTextClick');
end;

procedure TSMMain.MIEditTextsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditTextsClick');
end;

procedure TSMMain.MIEditingModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditingModeClick');
end;

procedure TSMMain.MIElementMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementMenuClick');
end;

procedure TSMMain.MIElementParametersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementParametersClick');
end;

procedure TSMMain.MIElementStatisticsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementStatisticsClick');
end;

procedure TSMMain.MIElementsToPostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementsToPostponeClick');
end;

procedure TSMMain.MIEmailSupportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEmailSupportClick');
end;

procedure TSMMain.MIEscapeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEscapeClick');
end;

procedure TSMMain.MIExitClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExitClick');
end;

procedure TSMMain.MIExportAsXMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportAsXMLClick');
end;

procedure TSMMain.MIExportDataClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDataClick');
end;

procedure TSMMain.MIExportDocumentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportDocumentClick');
end;

procedure TSMMain.MIExportLearningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportLearningClick');
end;

procedure TSMMain.MIExportQAClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportQAClick');
end;

procedure TSMMain.MIExportRepHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportRepHistoryClick');
end;

procedure TSMMain.MIExportTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportTextClick');
end;

procedure TSMMain.MIFAQHelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFAQHelpClick');
end;

procedure TSMMain.MIFavoritesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFavoritesClick');
end;

procedure TSMMain.MIFeedbackClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFeedbackClick');
end;

procedure TSMMain.MIFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFileClick');
end;

procedure TSMMain.MIFindAndReplaceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindAndReplaceClick');
end;

procedure TSMMain.MIFindElementsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindElementsClick');
end;

procedure TSMMain.MIFindInTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindInTextClick');
end;

procedure TSMMain.MIFindSelectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindSelectionClick');
end;

procedure TSMMain.MIFindSubstringClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindSubstringClick');
end;

procedure TSMMain.MIFindWordClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindWordClick');
end;

procedure TSMMain.MIFoldersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFoldersClick');
end;

procedure TSMMain.MIFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFontClick');
end;

procedure TSMMain.MIFrontPageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFrontPageClick');
end;

procedure TSMMain.MIGarbageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGarbageClick');
end;

procedure TSMMain.MIGenerateReportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGenerateReportClick');
end;

procedure TSMMain.MIGoNeuralClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoNeuralClick');
end;

procedure TSMMain.MIGoToClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToClick');
end;

procedure TSMMain.MIGoogleSearchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoogleSearchClick');
end;

procedure TSMMain.MIHTMLExportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHTMLExportClick');
end;

procedure TSMMain.MIHTMLFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHTMLFileClick');
end;

procedure TSMMain.MIHelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHelpClick');
end;

procedure TSMMain.MIHelpContentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHelpContentsClick');
end;

procedure TSMMain.MIHelpContextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHelpContextClick');
end;

procedure TSMMain.MIHelpGuideClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHelpGuideClick');
end;

procedure TSMMain.MIHideSuperMemoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHideSuperMemoClick');
end;

procedure TSMMain.MIHintsAndTipsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHintsAndTipsClick');
end;

procedure TSMMain.MIHintsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHintsClick');
end;

procedure TSMMain.MIHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHistoryClick');
end;

procedure TSMMain.MIHyperlinkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHyperlinkClick');
end;

procedure TSMMain.MIImageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImageClick');
end;

procedure TSMMain.MIImportFileClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportFileClick');
end;

procedure TSMMain.MIImportLearningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportLearningClick');
end;

procedure TSMMain.MIImportMailClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportMailClick');
end;

procedure TSMMain.MIImportPicturesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportPicturesClick');
end;

procedure TSMMain.MIImportRepHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportRepHistoryClick');
end;

procedure TSMMain.MIImportTextClick(Sender: TObject);
begin
  RunImportDemo(Self)
end;

procedure TSMMain.MIInputPasswordClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInputPasswordClick');
end;

procedure TSMMain.MIInsertHRClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInsertHRClick');
end;

procedure TSMMain.MIInstallIconsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInstallIconsClick');
end;

procedure TSMMain.MIInstallationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInstallationClick');
end;

procedure TSMMain.MIInternetHelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInternetHelpClick');
end;

procedure TSMMain.MIInvisibleWorkloadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIInvisibleWorkloadClick');
end;

procedure TSMMain.MILastClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILastClick');
end;

procedure TSMMain.MILayoutsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILayoutsClick');
end;

procedure TSMMain.MILearnBranchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnBranchClick');
end;

procedure TSMMain.MILearnClick(Sender: TObject);
begin
  RunLearnClick(Self)
end;

procedure TSMMain.MILearnDrillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnDrillClick');
end;

procedure TSMMain.MILearnNewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnNewClick');
end;

procedure TSMMain.MILearnOutstandingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnOutstandingClick');
end;

procedure TSMMain.MILearnedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnedClick');
end;

procedure TSMMain.MILevelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILevelClick');
end;

procedure TSMMain.MILinkExternalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkExternalClick');
end;

procedure TSMMain.MILinkListClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkListClick');
end;

procedure TSMMain.MILinkRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILinkRegistryClick');
end;

procedure TSMMain.MIMCTTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMCTTextClick');
end;

procedure TSMMain.MIMemoryStatusClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMemoryStatusClick');
end;

procedure TSMMain.MIMercyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMercyClick');
end;

procedure TSMMain.MIMergeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMergeClick');
end;

procedure TSMMain.MIMoveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveClick');
end;

procedure TSMMain.MINeuralAnalysisClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINeuralAnalysisClick');
end;

procedure TSMMain.MINeuralQueueClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINeuralQueueClick');
end;

procedure TSMMain.MINewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewClick');
end;

procedure TSMMain.MINewFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINewFontClick');
end;

procedure TSMMain.MINextComponentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MINextComponentClick');
end;

procedure TSMMain.MIOLEClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOLEClick');
end;

procedure TSMMain.MIOpenClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenClick');
end;

procedure TSMMain.MIOpenContentsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenContentsClick');
end;

procedure TSMMain.MIOpenWebLinksClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenWebLinksClick');
end;

procedure TSMMain.MIOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOptionsClick');
end;

procedure TSMMain.MIOwnerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOwnerClick');
end;

procedure TSMMain.MIPlanClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlanClick');
end;

procedure TSMMain.MIPostpone1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostpone1Click');
end;

procedure TSMMain.MIPostponeAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeAllClick');
end;

procedure TSMMain.MIPostponeItemsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeItemsClick');
end;

procedure TSMMain.MIPostponeOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeOptionsClick');
end;

procedure TSMMain.MIPostponeTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponeTopicsClick');
end;

procedure TSMMain.MIPostponedElementsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPostponedElementsClick');
end;

procedure TSMMain.MIPreviousBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviousBrowserClick');
end;

procedure TSMMain.MIPriorityBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPriorityBrowserClick');
end;

procedure TSMMain.MIProcessCollectionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIProcessCollectionClick');
end;

procedure TSMMain.MIProcessImageOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIProcessImageOptionsClick');
end;

procedure TSMMain.MIPronunciationBySoundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPronunciationBySoundClick');
end;

procedure TSMMain.MIPronunciationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPronunciationClick');
end;

procedure TSMMain.MIPropertiesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPropertiesClick');
end;

procedure TSMMain.MIPublishClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPublishClick');
end;

procedure TSMMain.MIRandomAllClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomAllClick');
end;

procedure TSMMain.MIRandomDismissedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomDismissedClick');
end;

procedure TSMMain.MIRandomFilterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomFilterClick');
end;

procedure TSMMain.MIRandomItemsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomItemsClick');
end;

procedure TSMMain.MIRandomLearningClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomLearningClick');
end;

procedure TSMMain.MIRandomLeechesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomLeechesClick');
end;

procedure TSMMain.MIRandomMemorizedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomMemorizedClick');
end;

procedure TSMMain.MIRandomNodeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomNodeClick');
end;

procedure TSMMain.MIRandomPendingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomPendingClick');
end;

procedure TSMMain.MIRandomReviewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomReviewClick');
end;

procedure TSMMain.MIRandomSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomSubsetClick');
end;

procedure TSMMain.MIRandomTestsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomTestsClick');
end;

procedure TSMMain.MIRandomTopicsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomTopicsClick');
end;

procedure TSMMain.MIRandomizeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomizeClick');
end;

procedure TSMMain.MIRandomizeDrillClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomizeDrillClick');
end;

procedure TSMMain.MIRandomizePendingClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomizePendingClick');
end;

procedure TSMMain.MIRandomizeRepetitionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomizeRepetitionsClick');
end;

procedure TSMMain.MIRecomputeDifficultiesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRecomputeDifficultiesClick');
end;

procedure TSMMain.MIRecoverClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRecoverClick');
end;

procedure TSMMain.MIReferenceClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReferenceClick');
end;

procedure TSMMain.MIRegistryMenuClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRegistryMenuClick');
end;

procedure TSMMain.MIRemoveFormattingGlobalClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRemoveFormattingGlobalClick');
end;

procedure TSMMain.MIRenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenameClick');
end;

procedure TSMMain.MIRenamememberClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenamememberClick');
end;

procedure TSMMain.MIReportClick(Sender: TObject);
begin
  RunExportDemo(Self)
end;

procedure TSMMain.MIRequestPasswordClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRequestPasswordClick');
end;

procedure TSMMain.MIResetAvgRepetitionTimeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetAvgRepetitionTimeClick');
end;

procedure TSMMain.MIResetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetClick');
end;

procedure TSMMain.MIResetFIClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetFIClick');
end;

procedure TSMMain.MIResetFIPriorityClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetFIPriorityClick');
end;

procedure TSMMain.MIResetFirstGradeVsAFClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetFirstGradeVsAFClick');
end;

procedure TSMMain.MIResetMatricesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetMatricesClick');
end;

procedure TSMMain.MIResetRepetitionHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResetRepetitionHistoryClick');
end;

procedure TSMMain.MIResumeTestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResumeTestClick');
end;

procedure TSMMain.MIReviewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIReviewClick');
end;

procedure TSMMain.MISaveDefaultLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveDefaultLayoutClick');
end;

procedure TSMMain.MISaveDefaultTemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveDefaultTemplateClick');
end;

procedure TSMMain.MISaveLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveLayoutClick');
end;

procedure TSMMain.MISaveLocallyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveLocallyClick');
end;

procedure TSMMain.MISaveRecallMatrixClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISaveRecallMatrixClick');
end;

procedure TSMMain.MIScriptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIScriptClick');
end;

procedure TSMMain.MISearchClick(Sender: TObject);
begin
  RunSearchDemo(Self)
end;

procedure TSMMain.MISearchHelpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchHelpClick');
end;

procedure TSMMain.MISearchSuperMemopediaClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchSuperMemopediaClick');
end;

procedure TSMMain.MISearchWikiClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISearchWikiClick');
end;

procedure TSMMain.MISemiLeechesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISemiLeechesClick');
end;

procedure TSMMain.MIShortcutAheadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShortcutAheadClick');
end;

procedure TSMMain.MISimulationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISimulationClick');
end;

procedure TSMMain.MISleepChartClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISleepChartClick');
end;

procedure TSMMain.MISortOptionsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortOptionsClick');
end;

procedure TSMMain.MISortRepsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortRepsClick');
end;

procedure TSMMain.MISortingCriteriaClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortingCriteriaClick');
end;

procedure TSMMain.MISoundClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISoundClick');
end;

procedure TSMMain.MIStatisticsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStatisticsClick');
end;

procedure TSMMain.MIStatusBarClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStatusBarClick');
end;

procedure TSMMain.MIStyleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStyleClick');
end;

procedure TSMMain.MITasklistClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITasklistClick');
end;

procedure TSMMain.MITasklistsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITasklistsClick');
end;

procedure TSMMain.MITemplateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITemplateClick');
end;

procedure TSMMain.MITestRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITestRepetitionClick');
end;

procedure TSMMain.MIThemesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIThemesClick');
end;

procedure TSMMain.MITipOfTheDayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITipOfTheDayClick');
end;

procedure TSMMain.MIToolsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIToolsClick');
end;

procedure TSMMain.MITotalKnowledgeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITotalKnowledgeClick');
end;

procedure TSMMain.MITransferSubsetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferSubsetClick');
end;

procedure TSMMain.MITranslationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITranslationClick');
end;

procedure TSMMain.MITranslationImportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITranslationImportClick');
end;

procedure TSMMain.MIUnpostponedClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnpostponedClick');
end;

procedure TSMMain.MIUnregisterClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUnregisterClick');
end;

procedure TSMMain.MIUserSurveyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUserSurveyClick');
end;

procedure TSMMain.MIVideoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIVideoClick');
end;

procedure TSMMain.MIVideosClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIVideosClick');
end;

procedure TSMMain.MIViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewClick');
end;

procedure TSMMain.MIViewFAQClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewFAQClick');
end;

procedure TSMMain.MIViewHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewHTMLClick');
end;

procedure TSMMain.MIWarriorClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWarriorClick');
end;

procedure TSMMain.MIWarriorLayoutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWarriorLayoutClick');
end;

procedure TSMMain.MIWebImportClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWebImportClick');
end;

procedure TSMMain.MIWebSearchClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWebSearchClick');
end;

procedure TSMMain.MIWikipediaClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWikipediaClick');
end;

procedure TSMMain.MIWindowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWindowClick');
end;

procedure TSMMain.MIWorkloadClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWorkloadClick');
end;

procedure TSMMain.MIXMLSynchronizationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIXMLSynchronizationClick');
end;

procedure TSMMain.MIYouTubeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIYouTubeClick');
end;

procedure TSMMain.Memorize1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Memorize1Click');
end;

procedure TSMMain.MiConceptRegistryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MiConceptRegistryClick');
end;

procedure TSMMain.Nextcomponent1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Nextcomponent1Click');
end;

procedure TSMMain.Nextelement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Nextelement1Click');
end;

procedure TSMMain.NumberButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NumberButtonClick');
end;

procedure TSMMain.NumbersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'NumbersClick');
end;

procedure TSMMain.OLEButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OLEButtonClick');
end;

procedure TSMMain.OpenCollectionBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OpenCollectionBtnClick');
end;

procedure TSMMain.OutdentClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OutdentClick');
end;

procedure TSMMain.Parentelement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Parentelement1Click');
end;

procedure TSMMain.PasteArticleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PasteArticleClick');
end;

procedure TSMMain.PasteButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PasteButtonClick');
end;

procedure TSMMain.PathListButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PathListButtonClick');
end;

procedure TSMMain.Plaintext1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Plaintext1Click');
end;

procedure TSMMain.PlanAlarmNotify(Sender: TObject);
begin
end;

procedure TSMMain.PlanTimerTimer(Sender: TObject);
begin
end;

procedure TSMMain.Popupmenu1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Popupmenu1Click');
end;

procedure TSMMain.Previouselement1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Previouselement1Click');
end;

procedure TSMMain.Prioritydialog1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Prioritydialog1Click');
end;

procedure TSMMain.ProgramButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ProgramButtonClick');
end;

procedure TSMMain.RRectangleButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RRectangleButtonClick');
end;

procedure TSMMain.RTFButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RTFButtonClick');
end;

procedure TSMMain.RectangleButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RectangleButtonClick');
end;

procedure TSMMain.Reference1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Reference1Click');
end;

procedure TSMMain.Registrymember1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Registrymember1Click');
end;

procedure TSMMain.RememberClozeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RememberClozeClick');
end;

procedure TSMMain.RememberExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RememberExtractClick');
end;

procedure TSMMain.Repeatautoplay1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Repeatautoplay1Click');
end;

procedure TSMMain.RepetitionTimerTimer(Sender: TObject);
begin
end;

procedure TSMMain.Repetitionhistory2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Repetitionhistory2Click');
end;

procedure TSMMain.ResetTimerClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetTimerClick');
end;

procedure TSMMain.SaveTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveTemplateBtnClick');
end;

procedure TSMMain.ScheduleClozeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ScheduleClozeClick');
end;

procedure TSMMain.ScheduleExtract1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ScheduleExtract1Click');
end;

procedure TSMMain.ScheduleExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ScheduleExtractClick');
end;

procedure TSMMain.SendFAQClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SendFAQClick');
end;

procedure TSMMain.SendTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SendTextClick');
end;

procedure TSMMain.SetAlarmButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetAlarmButtonClick');
end;

procedure TSMMain.SetReadPointClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetReadPointClick');
end;

procedure TSMMain.Setreadingpoint1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Setreadingpoint1Click');
end;

procedure TSMMain.Shifttolater1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Shifttolater1Click');
end;

procedure TSMMain.SoundButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SoundButtonClick');
end;

procedure TSMMain.SpellButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SpellButtonClick');
end;

procedure TSMMain.Spellcheck1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Spellcheck1Click');
end;

procedure TSMMain.SplitBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SplitBtnClick');
end;

procedure TSMMain.StartTimerButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StartTimerButtonClick');
end;

procedure TSMMain.StopAlarmBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StopAlarmBtnClick');
end;

procedure TSMMain.SubscriptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SubscriptClick');
end;

procedure TSMMain.SuperScriptClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SuperScriptClick');
end;

procedure TSMMain.Swap1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Swap1Click');
end;

procedure TSMMain.SwitchModeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SwitchModeBtnClick');
end;

procedure TSMMain.Switchimagestretch1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Switchimagestretch1Click');
end;

procedure TSMMain.TaskExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskExtractClick');
end;

procedure TSMMain.TasklistButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TasklistButtonClick');
end;

procedure TSMMain.TestRepetitionClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TestRepetitionClick');
end;

procedure TSMMain.TextButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TextButtonClick');
end;

procedure TSMMain.TimeUpdateTimer(Sender: TObject);
begin
end;

procedure TSMMain.Title1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Title1Click');
end;

procedure TSMMain.Transliterateall1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Transliterateall1Click');
end;

procedure TSMMain.TrayIcon1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'TrayIcon1Click');
end;

procedure TSMMain.UnderlineButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UnderlineButtonClick');
end;

procedure TSMMain.Underlinefont1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Underlinefont1Click');
end;

procedure TSMMain.Undo1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Undo1Click');
end;

procedure TSMMain.VideoButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'VideoButtonClick');
end;

procedure TSMMain.ViewSourceBtn1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ViewSourceBtn1Click');
end;

procedure TSMMain.Viewfile1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Viewfile1Click');
end;

procedure TSMMain.Viewsource1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Viewsource1Click');
end;

procedure TSMMain.Viewsource2Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Viewsource2Click');
end;

procedure TSMMain.WebSearch1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'WebSearch1Click');
end;

procedure TSMMain.WebSearchBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WebSearchBtnClick');
end;

procedure TSMMain.WorkloadBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'WorkloadBtnClick');
end;

initialization
  if GetClass('TSMMain') = nil then
    RegisterClass(TSMMain);

end.
