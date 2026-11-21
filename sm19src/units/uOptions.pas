unit uOptions;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TOptions = class(TForm)
    PageControl1: TPageControl;
    LearningTab: TTabSheet;
    Bevel6: TBevel;
    Label3: TLabel;
    FILabel: TLabel;
    Bevel5: TBevel;
    Bevel4: TBevel;
    MidnightClockLabel: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    GroupBox3: TGroupBox;
    Label20: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    IntervalLengthEdit: TEdit;
    IntervalDifferenceEdit: TEdit;
    FactorLevelEdit: TEdit;
    FI: TTrackBar;
    RandomizeDrillBtn: TCheckBox;
    MidnightShiftBar: TTrackBar;
    SkipDrillBtn: TCheckBox;
    DataAccessTab: TTabSheet;
    Label8: TLabel;
    SecondaryStorageBtn: TSpeedButton;
    Label16: TLabel;
    Label12: TLabel;
    SelectDefaultElement: TSpeedButton;
    SecondaryStorageEdit: TEdit;
    GroupBox2: TGroupBox;
    BeginnerBtn: TRadioButton;
    BasicBtn: TRadioButton;
    ProfessionalBtn: TRadioButton;
    MiddleBtn: TRadioButton;
    PasswordEdit: TEdit;
    CompileLexiconBox: TCheckBox;
    DefaultElement: TEdit;
    LanguageTab: TTabSheet;
    Bevel3: TBevel;
    Bevel1: TBevel;
    Bevel7: TBevel;
    Label14: TLabel;
    Label13: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Bevel2: TBevel;
    Label9: TLabel;
    PhoneticCombo: TComboBox;
    ChoosePhoneticFont: TButton;
    LocalizationCombo: TComboBox;
    Localization: TButton;
    TranslateSoundsBox: TCheckBox;
    TranslationCombo: TComboBox;
    TransFontName: TEdit;
    DeleteTranslation: TButton;
    ChooseTransFont: TButton;
    ProgramLanguage: TEdit;
    SuperMemoTab: TTabSheet;
    Bevel8: TBevel;
    Label17: TLabel;
    Label15: TLabel;
    ChildrenLimitLabel: TLabel;
    GroupBox1: TGroupBox;
    successlabel: TLabel;
    failurelabel: TLabel;
    PlaySuccess: TSpeedButton;
    PlayFailure: TSpeedButton;
    SuccessSoundEdit: TEdit;
    FailureSoundEdit: TEdit;
    SoundModeGroup: TRadioGroup;
    BackgroundEdit: TEdit;
    ChildrenLimit: TTrackBar;
    RemoveFormattingBox: TCheckBox;
    StatusBordersBox: TCheckBox;
    smNoneButton: TRadioButton;
    smDefaultButton: TRadioButton;
    smCustomButton: TRadioButton;
    GradeIconsBox: TCheckBox;
    MouseTab: TTabSheet;
    Translation: TGroupBox;
    TranslationOnMouseMove: TCheckBox;
    TranslationOnMiddleClick: TCheckBox;
    PhoneticTranscription: TGroupBox;
    TranscriptionOnMouseMove: TCheckBox;
    TranscriptionOnMiddleClick: TCheckBox;
    CheckBox6: TCheckBox;
    DragComponents: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox7: TCheckBox;
    EditTexts: TGroupBox;
    EditTextsOnAltClick: TCheckBox;
    EditTextsOnClick: TCheckBox;
    CheckBox3: TCheckBox;
    Leeches: TTabSheet;
    LeechChoices: TRadioGroup;
    UseSemiLeechesBox: TCheckBox;
    Fonts: TTabSheet;
    Bevel9: TBevel;
    InterfaceSample: TLabel;
    ContentsSample: TLabel;
    QuestionSample: TLabel;
    HighlightSample: TLabel;
    AnswerSample: TLabel;
    InterfaceFontButton: TBitBtn;
    QuestionFontButton: TBitBtn;
    ContentsFontButton: TBitBtn;
    HighlightFontButton: TBitBtn;
    AnswerFontButton: TBitBtn;
    DefaultFontInHTML: TCheckBox;
    StylesheetBtn: TButton;
    TabSheet1: TTabSheet;
    MailOptions: TRadioGroup;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    MailUsernameEdit: TEdit;
    MailPasswordEdit: TEdit;
    MailPortEdit: TEdit;
    SMTPHostEdit: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Help: TBitBtn;
    FontDialog1: TFontDialog;
    procedure AnswerFontButtonClick(Sender: TObject);
    procedure BeginnerBtnKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure ChildrenLimitChange(Sender: TObject);
    procedure ChoosePhoneticFontClick(Sender: TObject);
    procedure ChooseTransFontClick(Sender: TObject);
    procedure ContentsFontButtonClick(Sender: TObject);
    procedure DefaultFontInHTMLClick(Sender: TObject);
    procedure DeleteTranslationClick(Sender: TObject);
    procedure FIChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GradeIconsBoxClick(Sender: TObject);
    procedure HighlightFontButtonClick(Sender: TObject);
    procedure InterfaceFontButtonClick(Sender: TObject);
    procedure LeechChoicesClick(Sender: TObject);
    procedure LocalizationClick(Sender: TObject);
    procedure LocalizationComboClick(Sender: TObject);
    procedure MidnightShiftBarChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure PlayFailureClick(Sender: TObject);
    procedure PlaySuccessClick(Sender: TObject);
    procedure QuestionFontButtonClick(Sender: TObject);
    procedure RemoveFormattingBoxClick(Sender: TObject);
    procedure SecondaryStorageBtnClick(Sender: TObject);
    procedure SelectDefaultElementClick(Sender: TObject);
    procedure SetLevelClick(Sender: TObject);
    procedure StatusBordersBoxClick(Sender: TObject);
    procedure StylesheetBtnClick(Sender: TObject);
    procedure TranscriptionOnMiddleClickClick(Sender: TObject);
    procedure TranscriptionOnMouseMoveClick(Sender: TObject);
    procedure TranslationOnMiddleClickClick(Sender: TObject);
    procedure TranslationOnMouseMoveClick(Sender: TObject);
    procedure UseSemiLeechesBoxClick(Sender: TObject);
    procedure smNoneButtonClick(Sender: TObject);
  end;

var
  Options: TOptions;

implementation

{$R *.lfm}

procedure TOptions.AnswerFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AnswerFontButtonClick');
end;

procedure TOptions.BeginnerBtnKeyUp(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
end;

procedure TOptions.ChildrenLimitChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ChildrenLimitChange');
end;

procedure TOptions.ChoosePhoneticFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChoosePhoneticFontClick');
end;

procedure TOptions.ChooseTransFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ChooseTransFontClick');
end;

procedure TOptions.ContentsFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ContentsFontButtonClick');
end;

procedure TOptions.DefaultFontInHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultFontInHTMLClick');
end;

procedure TOptions.DeleteTranslationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteTranslationClick');
end;

procedure TOptions.FIChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FIChange');
end;

procedure TOptions.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TOptions.FormCreate(Sender: TObject);
begin
end;

procedure TOptions.FormShow(Sender: TObject);
begin
end;

procedure TOptions.GradeIconsBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GradeIconsBoxClick');
end;

procedure TOptions.HighlightFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HighlightFontButtonClick');
end;

procedure TOptions.InterfaceFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'InterfaceFontButtonClick');
end;

procedure TOptions.LeechChoicesClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LeechChoicesClick');
end;

procedure TOptions.LocalizationClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LocalizationClick');
end;

procedure TOptions.LocalizationComboClick(Sender: TObject);
begin
  DispatchAction(Sender, 'LocalizationComboClick');
end;

procedure TOptions.MidnightShiftBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'MidnightShiftBarChange');
end;

procedure TOptions.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TOptions.PasswordEditChange(Sender: TObject);
begin
  DispatchAction(Sender, 'PasswordEditChange');
end;

procedure TOptions.PlayFailureClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PlayFailureClick');
end;

procedure TOptions.PlaySuccessClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PlaySuccessClick');
end;

procedure TOptions.QuestionFontButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'QuestionFontButtonClick');
end;

procedure TOptions.RemoveFormattingBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RemoveFormattingBoxClick');
end;

procedure TOptions.SecondaryStorageBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SecondaryStorageBtnClick');
end;

procedure TOptions.SelectDefaultElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SelectDefaultElementClick');
end;

procedure TOptions.SetLevelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetLevelClick');
end;

procedure TOptions.StatusBordersBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StatusBordersBoxClick');
end;

procedure TOptions.StylesheetBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StylesheetBtnClick');
end;

procedure TOptions.TranscriptionOnMiddleClickClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TranscriptionOnMiddleClickClick');
end;

procedure TOptions.TranscriptionOnMouseMoveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TranscriptionOnMouseMoveClick');
end;

procedure TOptions.TranslationOnMiddleClickClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TranslationOnMiddleClickClick');
end;

procedure TOptions.TranslationOnMouseMoveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TranslationOnMouseMoveClick');
end;

procedure TOptions.UseSemiLeechesBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UseSemiLeechesBoxClick');
end;

procedure TOptions.smNoneButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'smNoneButtonClick');
end;

initialization
  if GetClass('TOptions') = nil then
    RegisterClass(TOptions);

end.
