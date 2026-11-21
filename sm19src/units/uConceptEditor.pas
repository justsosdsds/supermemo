unit uConceptEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TConceptEditor = class(TForm)
    TopicTemplateLabel: TLabel;
    ItemTemplateLabel: TLabel;
    RootLabel: TLabel;
    HookLabel: TLabel;
    TaskTemplateLabel: TLabel;
    DefaultElement: TLabel;
    GoToConceptBtn: TSpeedButton;
    TopicTemplateBtn: TButton;
    ItemTemplateBtn: TButton;
    RootBtn: TButton;
    HookBtn: TButton;
    TopicAutoApplyCheck: TCheckBox;
    Button5: TButton;
    PriorityEdit: TEdit;
    TaskTemplateBtn: TButton;
    ItemAutoApplyCheck: TCheckBox;
    SimilarAutoApplyCheck: TCheckBox;
    procedure AutoApplyCheckMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoToConceptBtnClick(Sender: TObject);
    procedure HookBtnClick(Sender: TObject);
    procedure ItemTemplateBtnClick(Sender: TObject);
    procedure PriorityEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure RootBtnClick(Sender: TObject);
    procedure TaskTemplateBtnClick(Sender: TObject);
    procedure TopicTemplateBtnClick(Sender: TObject);
  end;

var
  ConceptEditor: TConceptEditor;

implementation

{$R *.lfm}

procedure TConceptEditor.AutoApplyCheckMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TConceptEditor.Button5Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Button5Click');
end;

procedure TConceptEditor.FormCreate(Sender: TObject);
begin
end;

procedure TConceptEditor.FormShow(Sender: TObject);
begin
end;

procedure TConceptEditor.GoToConceptBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToConceptBtnClick');
end;

procedure TConceptEditor.HookBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HookBtnClick');
end;

procedure TConceptEditor.ItemTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ItemTemplateBtnClick');
end;

procedure TConceptEditor.PriorityEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'PriorityEditKeyDown');
end;

procedure TConceptEditor.RootBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RootBtnClick');
end;

procedure TConceptEditor.TaskTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskTemplateBtnClick');
end;

procedure TConceptEditor.TopicTemplateBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TopicTemplateBtnClick');
end;

initialization
  if GetClass('TConceptEditor') = nil then
    RegisterClass(TConceptEditor);

end.
