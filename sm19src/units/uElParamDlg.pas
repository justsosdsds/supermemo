unit uElParamDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TElParamDlg = class(TForm)
    PageControl1: TPageControl;
    ElementTab: TTabSheet;
    Bevel1: TBevel;
    Title: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    IntervalBtn: TSpeedButton;
    ChooseDate: TSpeedButton;
    Label13: TLabel;
    IntervalEdit: TEdit;
    NextRepetition: TEdit;
    AFactor: TEdit;
    FI: TEdit;
    Ordinal: TEdit;
    TargetConceptCombo: TComboBox;
    Comment: TMemo;
    ETypeGroup: TRadioGroup;
    TitleEdit: TEdit;
    TemplateCombo: TComboBox;
    PriorityEdit: TEdit;
    TaskTab: TTabSheet;
    Bevel3: TBevel;
    DescriptionLabel: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ValueLabel: TLabel;
    TimeLabel: TLabel;
    Tasklist: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Description: TMemo;
    RadioGroup1: TRadioGroup;
    Value: TEdit;
    Time: TEdit;
    TaskPriority: TEdit;
    Introduced: TEdit;
    DeadlineEdit: TEdit;
    Halftime: TEdit;
    TaskCombo: TComboBox;
    DeadlineBtn: TButton;
    HalfTimeBtn: TButton;
    MaxPriority: TEdit;
    Position_Ctl: TEdit;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    HistoryButton: TToolButton;
    ToolButton7: TToolButton;
    FutureButton: TToolButton;
    ToolButton6: TToolButton;
    Difficulty: TToolButton;
    ToolButton8: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    CancelBtn: TToolButton;
    ToolButton3: TToolButton;
    HelpButton: TToolButton;
    ToolButton5: TToolButton;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    procedure CancelClick(Sender: TObject);
    procedure DeadlineBtnClick(Sender: TObject);
    procedure DescriptionKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DifficultyClick(Sender: TObject);
    procedure ETypeGroupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HalfTimeBtnClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure HistoryClick(Sender: TObject);
    procedure IntervalBtnClick(Sender: TObject);
    procedure IntervalEditEnter(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ParamsKeyPress(Sender: TObject; var AKey: Char);
    procedure RadioGroup1Click(Sender: TObject);
    procedure TargetConceptComboChange(Sender: TObject);
    procedure TargetConceptComboClick(Sender: TObject);
    procedure TargetConceptComboDropDown(Sender: TObject);
    procedure TargetConceptComboEnter(Sender: TObject);
    procedure TargetConceptComboKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure TargetConceptComboKeyPress(Sender: TObject; var AKey: Char);
    procedure TaskComboChange(Sender: TObject);
    procedure TaskComboClick(Sender: TObject);
    procedure TaskComboDropDown(Sender: TObject);
    procedure TaskComboEnter(Sender: TObject);
    procedure TaskComboKeyPress(Sender: TObject; var AKey: Char);
    procedure TemplateComboChange(Sender: TObject);
    procedure TemplateComboEnter(Sender: TObject);
    procedure TemplateComboKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure TemplateComboKeyPress(Sender: TObject; var AKey: Char);
    procedure TitleClick(Sender: TObject);
    procedure TitleEditKeyPress(Sender: TObject; var AKey: Char);
  end;

var
  ElParamDlg: TElParamDlg;

implementation

{$R *.lfm}

procedure TElParamDlg.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TElParamDlg.DeadlineBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeadlineBtnClick');
end;

procedure TElParamDlg.DescriptionKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'DescriptionKeyDown');
end;

procedure TElParamDlg.DifficultyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DifficultyClick');
end;

procedure TElParamDlg.ETypeGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ETypeGroupClick');
end;

procedure TElParamDlg.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TElParamDlg.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TElParamDlg.FormCreate(Sender: TObject);
begin
end;

procedure TElParamDlg.FormShow(Sender: TObject);
begin
end;

procedure TElParamDlg.HalfTimeBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HalfTimeBtnClick');
end;

procedure TElParamDlg.HelpButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HelpButtonClick');
end;

procedure TElParamDlg.HistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HistoryClick');
end;

procedure TElParamDlg.IntervalBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'IntervalBtnClick');
end;

procedure TElParamDlg.IntervalEditEnter(Sender: TObject);
begin
end;

procedure TElParamDlg.OKBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKBtnClick');
end;

procedure TElParamDlg.ParamsKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'ParamsKeyPress');
end;

procedure TElParamDlg.RadioGroup1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'RadioGroup1Click');
end;

procedure TElParamDlg.TargetConceptComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TargetConceptComboChange');
end;

procedure TElParamDlg.TargetConceptComboClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TargetConceptComboClick');
end;

procedure TElParamDlg.TargetConceptComboDropDown(Sender: TObject);
begin
  DispatchAction(Sender, 'TargetConceptComboDropDown');
end;

procedure TElParamDlg.TargetConceptComboEnter(Sender: TObject);
begin
end;

procedure TElParamDlg.TargetConceptComboKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'TargetConceptComboKeyDown');
end;

procedure TElParamDlg.TargetConceptComboKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TargetConceptComboKeyPress');
end;

procedure TElParamDlg.TaskComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboChange');
end;

procedure TElParamDlg.TaskComboClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboClick');
end;

procedure TElParamDlg.TaskComboDropDown(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboDropDown');
end;

procedure TElParamDlg.TaskComboEnter(Sender: TObject);
begin
end;

procedure TElParamDlg.TaskComboKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TaskComboKeyPress');
end;

procedure TElParamDlg.TemplateComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TemplateComboChange');
end;

procedure TElParamDlg.TemplateComboEnter(Sender: TObject);
begin
end;

procedure TElParamDlg.TemplateComboKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'TemplateComboKeyDown');
end;

procedure TElParamDlg.TemplateComboKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TemplateComboKeyPress');
end;

procedure TElParamDlg.TitleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TitleClick');
end;

procedure TElParamDlg.TitleEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TitleEditKeyPress');
end;

initialization
  if GetClass('TElParamDlg') = nil then
    RegisterClass(TElParamDlg);

end.
