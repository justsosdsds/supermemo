unit uPostponeDlg;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPostponeDlg = class(TForm)
    PageControl1: TPageControl;
    Scope: TTabSheet;
    ScopeGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    BranchScope: TEdit;
    ComboBox1: TComboBox;
    Save: TButton;
    Delete: TButton;
    Default: TButton;
    ChangeBranch: TButton;
    MethodGroup: TRadioGroup;
    RangeEdit: TEdit;
    Parameters: TTabSheet;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ItemDelayPercent: TLabel;
    TopicDelayPercent: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    PriorityLabel: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ItemDelayEdit: TEdit;
    TopicDelayEdit: TEdit;
    ItemMaxIntervalEdit: TEdit;
    ItemMinIntervalEdit: TEdit;
    TopicMaxIntervalEdit: TEdit;
    TopicMinIntervalEdit: TEdit;
    SkipItemsBox: TCheckBox;
    SkipTopicsBox: TCheckBox;
    ItemSkipIntervalEdit: TEdit;
    TopicSkipIntervalEdit: TEdit;
    ItemSkipFIEdit: TEdit;
    ItemPriorityEdit: TEdit;
    TopicPriorityEdit: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    TopicSkipAFEdit: TEdit;
    RestoreDefaultsBtn: TButton;
    ItemSkipPostponeEdit: TEdit;
    TopicSkipPostponeEdit: TEdit;
    Adjust: TTabSheet;
    ItemModifyByFIBox: TCheckBox;
    TopicModifyByAFBox: TCheckBox;
    SubBranchPostpones: TRadioGroup;
    DelayAllBox: TCheckBox;
    List: TButton;
    ModifyByPriorityCheckBox: TCheckBox;
    Postpone: TButton;
    Simulate: TButton;
    CloseDlg: TButton;
    BitBtn1: TBitBtn;
    procedure CloseDlgClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DefaultClick(Sender: TObject);
    procedure DelayAllBoxClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure MethodGroupClick(Sender: TObject);
    procedure PostponeClick(Sender: TObject);
    procedure RestoreDefaultsBtnClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure ScopeGroupClick(Sender: TObject);
    procedure SimulateClick(Sender: TObject);
    procedure SkipItemsBoxClick(Sender: TObject);
    procedure SkipTopicsBoxClick(Sender: TObject);
  end;

var
  PostponeDlg: TPostponeDlg;

implementation

{$R *.lfm}

procedure TPostponeDlg.CloseDlgClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloseDlgClick');
end;

procedure TPostponeDlg.ComboBox1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'ComboBox1Change');
end;

procedure TPostponeDlg.DefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DefaultClick');
end;

procedure TPostponeDlg.DelayAllBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DelayAllBoxClick');
end;

procedure TPostponeDlg.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TPostponeDlg.FormCreate(Sender: TObject);
begin
end;

procedure TPostponeDlg.FormShow(Sender: TObject);
begin
end;

procedure TPostponeDlg.ListClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ListClick');
end;

procedure TPostponeDlg.MethodGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MethodGroupClick');
end;

procedure TPostponeDlg.PostponeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PostponeClick');
end;

procedure TPostponeDlg.RestoreDefaultsBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'RestoreDefaultsBtnClick');
end;

procedure TPostponeDlg.SaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveClick');
end;

procedure TPostponeDlg.ScopeGroupClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ScopeGroupClick');
end;

procedure TPostponeDlg.SimulateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SimulateClick');
end;

procedure TPostponeDlg.SkipItemsBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SkipItemsBoxClick');
end;

procedure TPostponeDlg.SkipTopicsBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SkipTopicsBoxClick');
end;

initialization
  if GetClass('TPostponeDlg') = nil then
    RegisterClass(TPostponeDlg);

end.
