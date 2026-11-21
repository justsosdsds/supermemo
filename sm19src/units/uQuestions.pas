unit uQuestions;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TQuestions = class(TForm)
    Panel1: TPanel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Save: TBitBtn;
    CloseBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Country: TMemo;
    Occupation: TMemo;
    Education: TMemo;
    Age: TMemo;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    HowLearn: TMemo;
    SM2_7: TCheckBox;
    SM15: TCheckBox;
    SM8_99: TCheckBox;
    SM2004: TCheckBox;
    SM2000_2002: TCheckBox;
    Use: TMemo;
    Time: TMemo;
    Memorized: TMemo;
    SM2006_2008: TCheckBox;
    GroupBox3: TGroupBox;
    MethodExcellent: TRadioButton;
    MethodUseful: TRadioButton;
    MethodNothing: TRadioButton;
    MethodArtificial: TRadioButton;
    MethodWaste: TRadioButton;
    NoMethodOpinion: TRadioButton;
    GroupBox4: TGroupBox;
    ProgramExcellent: TRadioButton;
    ProgramReliable: TRadioButton;
    ProgramGood: TRadioButton;
    ProgramPoor: TRadioButton;
    ProgramBag: TRadioButton;
    NoProgramOpinion: TRadioButton;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Like: TMemo;
    Dislike: TMemo;
    GroupBox6: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Improvements: TMemo;
    Help: TMemo;
    IR: TMemo;
    procedure CancelClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
  end;

var
  Questions: TQuestions;

implementation

{$R *.lfm}

procedure TQuestions.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TQuestions.CloseBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseBtnClick');
end;

procedure TQuestions.FormCreate(Sender: TObject);
begin
end;

procedure TQuestions.FormDestroy(Sender: TObject);
begin
end;

procedure TQuestions.FormShow(Sender: TObject);
begin
end;

procedure TQuestions.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TQuestions.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

initialization
  if GetClass('TQuestions') = nil then
    RegisterClass(TQuestions);

end.
