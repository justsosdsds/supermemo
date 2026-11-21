unit uScriptEditor;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TScriptEditor = class(TForm)
    Panel1: TPanel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    SaveBtn: TBitBtn;
    Clone: TBitBtn;
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    Links1: TMenuItem;
    MIElement: TMenuItem;
    MIGoto: TMenuItem;
    MILabel: TMenuItem;
    MIMessage: TMenuItem;
    Internet1: TMenuItem;
    MIMailto: TMenuItem;
    MIURL: TMenuItem;
    Learning1: TMenuItem;
    MIDismiss: TMenuItem;
    MILearn: TMenuItem;
    Playing1: TMenuItem;
    MIFrame: TMenuItem;
    MIPlay: TMenuItem;
    MIStart: TMenuItem;
    MIStop: TMenuItem;
    MIUPlay: TMenuItem;
    MIWait: TMenuItem;
    MIWaitFrame: TMenuItem;
    Showing1: TMenuItem;
    MIDisplay: TMenuItem;
    MIFont: TMenuItem;
    MIHide: TMenuItem;
    MIMove: TMenuItem;
    MIShow: TMenuItem;
    MITextOut: TMenuItem;
    MIToggle: TMenuItem;
    MITranslate: TMenuItem;
    SuperMemo1: TMenuItem;
    MILevel: TMenuItem;
    MIMode: TMenuItem;
    MIStatus: TMenuItem;
    MITips: TMenuItem;
    Tests1: TMenuItem;
    MIDragMatchM: TMenuItem;
    MIDragMatchS: TMenuItem;
    MIDragTextMode: TMenuItem;
    MIHitTest: TMenuItem;
    WaitGrade1: TMenuItem;
    Comment1: TMenuItem;
    procedure CancelKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure CloneClick(Sender: TObject);
    procedure Comment1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MIDismissClick(Sender: TObject);
    procedure MIDisplayClick(Sender: TObject);
    procedure MIDragMatchMClick(Sender: TObject);
    procedure MIDragMatchSClick(Sender: TObject);
    procedure MIDragTextModeClick(Sender: TObject);
    procedure MIElementClick(Sender: TObject);
    procedure MIFontClick(Sender: TObject);
    procedure MIFrameClick(Sender: TObject);
    procedure MIGotoClick(Sender: TObject);
    procedure MIHideClick(Sender: TObject);
    procedure MIHitTestClick(Sender: TObject);
    procedure MILabelClick(Sender: TObject);
    procedure MILearnClick(Sender: TObject);
    procedure MILevelClick(Sender: TObject);
    procedure MIMailtoClick(Sender: TObject);
    procedure MIMessageClick(Sender: TObject);
    procedure MIModeClick(Sender: TObject);
    procedure MIMoveClick(Sender: TObject);
    procedure MIPlayClick(Sender: TObject);
    procedure MIShowClick(Sender: TObject);
    procedure MIStartClick(Sender: TObject);
    procedure MIStatusClick(Sender: TObject);
    procedure MIStopClick(Sender: TObject);
    procedure MITextOutClick(Sender: TObject);
    procedure MITipsClick(Sender: TObject);
    procedure MIToggleClick(Sender: TObject);
    procedure MITranslateClick(Sender: TObject);
    procedure MIUPlayClick(Sender: TObject);
    procedure MIURLClick(Sender: TObject);
    procedure MIWaitClick(Sender: TObject);
    procedure MIWaitFrameClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure OKClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure WaitGrade1Click(Sender: TObject);
  end;

var
  ScriptEditor: TScriptEditor;

implementation

{$R *.lfm}

procedure TScriptEditor.CancelKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'CancelKeyDown');
end;

procedure TScriptEditor.CloneClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CloneClick');
end;

procedure TScriptEditor.Comment1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Comment1Click');
end;

procedure TScriptEditor.FormCreate(Sender: TObject);
begin
end;

procedure TScriptEditor.FormShow(Sender: TObject);
begin
end;

procedure TScriptEditor.MIDismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismissClick');
end;

procedure TScriptEditor.MIDisplayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDisplayClick');
end;

procedure TScriptEditor.MIDragMatchMClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDragMatchMClick');
end;

procedure TScriptEditor.MIDragMatchSClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDragMatchSClick');
end;

procedure TScriptEditor.MIDragTextModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDragTextModeClick');
end;

procedure TScriptEditor.MIElementClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIElementClick');
end;

procedure TScriptEditor.MIFontClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFontClick');
end;

procedure TScriptEditor.MIFrameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFrameClick');
end;

procedure TScriptEditor.MIGotoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGotoClick');
end;

procedure TScriptEditor.MIHideClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHideClick');
end;

procedure TScriptEditor.MIHitTestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIHitTestClick');
end;

procedure TScriptEditor.MILabelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILabelClick');
end;

procedure TScriptEditor.MILearnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILearnClick');
end;

procedure TScriptEditor.MILevelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MILevelClick');
end;

procedure TScriptEditor.MIMailtoClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMailtoClick');
end;

procedure TScriptEditor.MIMessageClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMessageClick');
end;

procedure TScriptEditor.MIModeClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIModeClick');
end;

procedure TScriptEditor.MIMoveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMoveClick');
end;

procedure TScriptEditor.MIPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPlayClick');
end;

procedure TScriptEditor.MIShowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIShowClick');
end;

procedure TScriptEditor.MIStartClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStartClick');
end;

procedure TScriptEditor.MIStatusClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStatusClick');
end;

procedure TScriptEditor.MIStopClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIStopClick');
end;

procedure TScriptEditor.MITextOutClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITextOutClick');
end;

procedure TScriptEditor.MITipsClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITipsClick');
end;

procedure TScriptEditor.MIToggleClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIToggleClick');
end;

procedure TScriptEditor.MITranslateClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITranslateClick');
end;

procedure TScriptEditor.MIUPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIUPlayClick');
end;

procedure TScriptEditor.MIURLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIURLClick');
end;

procedure TScriptEditor.MIWaitClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWaitClick');
end;

procedure TScriptEditor.MIWaitFrameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIWaitFrameClick');
end;

procedure TScriptEditor.Memo1Change(Sender: TObject);
begin
  DispatchAction(Sender, 'Memo1Change');
end;

procedure TScriptEditor.Memo1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'Memo1KeyDown');
end;

procedure TScriptEditor.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TScriptEditor.SaveBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SaveBtnClick');
end;

procedure TScriptEditor.WaitGrade1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'WaitGrade1Click');
end;

initialization
  if GetClass('TScriptEditor') = nil then
    RegisterClass(TScriptEditor);

end.
