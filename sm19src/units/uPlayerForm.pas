unit uPlayerForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TPlayerForm = class(TForm)
    PaintBar: TPaintBox;
    RecorderPanel: TPanel;
    OPlay: TSpeedButton;
    UPlay: TSpeedButton;
    URecord: TSpeedButton;
    UCancel: TSpeedButton;
    Memo1: TMemo;
    SliderPanel: TPanel;
    ThreeButtonPanel: TPanel;
    SliderPause: TSpeedButton;
    SliderStop: TSpeedButton;
    SliderPlay: TSpeedButton;
    SliderBar: TTrackBar;
    ExtractPanel: TToolBar;
    PlayPause: TToolButton;
    ToolButton14: TToolButton;
    StartBtn: TToolButton;
    GoToStart: TToolButton;
    StartUpDown: TUpDown;
    ToolButton10: TToolButton;
    EndBtn: TToolButton;
    GoToEnd: TToolButton;
    EndUpDown: TUpDown;
    ToolButton13: TToolButton;
    MenuBtn: TToolButton;
    Extract: TToolButton;
    ToolButton12: TToolButton;
    Test: TToolButton;
    ToolButton15: TToolButton;
    Reset: TToolButton;
    FullScreenBtn: TToolButton;
    ToolButton16: TToolButton;
    MediaPlayer1: TMediaPlayer;
    ExtractBar: TTrackBar;
    VideoPanel: TPanel;
    ExtractorMenu: TPopupMenu;
    ResetStart1: TMenuItem;
    ResetEnd1: TMenuItem;
    ChooseStart1: TMenuItem;
    ChooseEnd1: TMenuItem;
    Frameback1: TMenuItem;
    Frameforward1: TMenuItem;
    Stepback1: TMenuItem;
    Stepforward1: TMenuItem;
    Framesperstep1: TMenuItem;
    PlayerTimer: TTimer;
    procedure EndBtnClick(Sender: TObject);
    procedure EndUpDownChangingEx(Sender: TObject);
    procedure ExtractBarChange(Sender: TObject);
    procedure ExtractBarKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure ExtractClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Frameback1Click(Sender: TObject);
    procedure Frameforward1Click(Sender: TObject);
    procedure FullScreenBtnClick(Sender: TObject);
    procedure GoToEndClick(Sender: TObject);
    procedure GoToStartClick(Sender: TObject);
    procedure MediaPlayer1Click(Sender: TObject);
    procedure MenuBtnClick(Sender: TObject);
    procedure OPlayClick(Sender: TObject);
    procedure PaintBarDblClick(Sender: TObject);
    procedure PaintBarMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PaintBarPaint(Sender: TObject);
    procedure PlayPauseClick(Sender: TObject);
    procedure PlayerButtonPopUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PlayerContextPopup(Sender: TObject; AMousePos: TPoint; var AHandled: Boolean);
    procedure PlayerTimerTimer(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure ResetEnd1Click(Sender: TObject);
    procedure ResetStart1Click(Sender: TObject);
    procedure SliderBarChange(Sender: TObject);
    procedure SliderPauseClick(Sender: TObject);
    procedure SliderPlayClick(Sender: TObject);
    procedure SliderStopClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure StartUpDownChangingEx(Sender: TObject);
    procedure TestClick(Sender: TObject);
    procedure UCancelClick(Sender: TObject);
    procedure UPlayClick(Sender: TObject);
    procedure URecordClick(Sender: TObject);
  end;

var
  PlayerForm: TPlayerForm;

implementation

{$R *.lfm}

procedure TPlayerForm.EndBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'EndBtnClick');
end;

procedure TPlayerForm.EndUpDownChangingEx(Sender: TObject);
begin
end;

procedure TPlayerForm.ExtractBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'ExtractBarChange');
end;

procedure TPlayerForm.ExtractBarKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'ExtractBarKeyDown');
end;

procedure TPlayerForm.ExtractClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExtractClick');
end;

procedure TPlayerForm.FormCreate(Sender: TObject);
begin
end;

procedure TPlayerForm.FormResize(Sender: TObject);
begin
end;

procedure TPlayerForm.FormShow(Sender: TObject);
begin
end;

procedure TPlayerForm.Frameback1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Frameback1Click');
end;

procedure TPlayerForm.Frameforward1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Frameforward1Click');
end;

procedure TPlayerForm.FullScreenBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FullScreenBtnClick');
end;

procedure TPlayerForm.GoToEndClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToEndClick');
end;

procedure TPlayerForm.GoToStartClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToStartClick');
end;

procedure TPlayerForm.MediaPlayer1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'MediaPlayer1Click');
end;

procedure TPlayerForm.MenuBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MenuBtnClick');
end;

procedure TPlayerForm.OPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OPlayClick');
end;

procedure TPlayerForm.PaintBarDblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PaintBarDblClick');
end;

procedure TPlayerForm.PaintBarMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TPlayerForm.PaintBarPaint(Sender: TObject);
begin
end;

procedure TPlayerForm.PlayPauseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PlayPauseClick');
end;

procedure TPlayerForm.PlayerButtonPopUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TPlayerForm.PlayerContextPopup(Sender: TObject; AMousePos: TPoint; var AHandled: Boolean);
begin
end;

procedure TPlayerForm.PlayerTimerTimer(Sender: TObject);
begin
end;

procedure TPlayerForm.ResetClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetClick');
end;

procedure TPlayerForm.ResetEnd1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetEnd1Click');
end;

procedure TPlayerForm.ResetStart1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ResetStart1Click');
end;

procedure TPlayerForm.SliderBarChange(Sender: TObject);
begin
  DispatchAction(Sender, 'SliderBarChange');
end;

procedure TPlayerForm.SliderPauseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SliderPauseClick');
end;

procedure TPlayerForm.SliderPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SliderPlayClick');
end;

procedure TPlayerForm.SliderStopClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SliderStopClick');
end;

procedure TPlayerForm.StartBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StartBtnClick');
end;

procedure TPlayerForm.StartUpDownChangingEx(Sender: TObject);
begin
end;

procedure TPlayerForm.TestClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TestClick');
end;

procedure TPlayerForm.UCancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UCancelClick');
end;

procedure TPlayerForm.UPlayClick(Sender: TObject);
begin
  DispatchAction(Sender, 'UPlayClick');
end;

procedure TPlayerForm.URecordClick(Sender: TObject);
begin
  DispatchAction(Sender, 'URecordClick');
end;

initialization
  if GetClass('TPlayerForm') = nil then
    RegisterClass(TPlayerForm);

end.
