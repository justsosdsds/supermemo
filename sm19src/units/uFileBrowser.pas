unit uFileBrowser;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TFileBrowser = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    DirBox: TDirectoryListBox;
    StatusBar: TPanel;
    TopPanel: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    FileLabel: TLabel;
    FindBtn: TSpeedButton;
    SearchLabel: TLabel;
    DriveBox: TDriveComboBox;
    SearchEdit: TEdit;
    OptionPanel: TPanel;
    StretchChk: TCheckBox;
    PreviewBox: TCheckBox;
    MediaPlayer1: TMediaPlayer;
    HiddenBox: TCheckBox;
    BottomPanel: TPanel;
    FileNameLabel: TLabel;
    FileTypeLabel: TLabel;
    FilterBox: TFilterComboBox;
    FileNameEdit: TEdit;
    OK: TButton;
    Cancel: TButton;
    FileBox: TFileListBox;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    MediaPanel: TPanel;
    PlayBtn: TSpeedButton;
    StopBtn: TSpeedButton;
    ProgressBar: TProgressBar;
    FBrowseEdit: TRichEdit;
    MediaTimer: TTimer;
    BrowserMenu: TPopupMenu;
    MIPreview: TMenuItem;
    MIView: TMenuItem;
    Edit1: TMenuItem;
    MIDelete: TMenuItem;
    MIRename: TMenuItem;
    N1: TMenuItem;
    InvRename: TMenuItem;
    procedure BrowserMenuPopup(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure CancelMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure CancelMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure DirBoxChange(Sender: TObject);
    procedure DirBoxEnter(Sender: TObject);
    procedure DirBoxExit(Sender: TObject);
    procedure DirBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure DriveBoxChange(Sender: TObject);
    procedure DriveBoxEnter(Sender: TObject);
    procedure DriveBoxExit(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FBrowseEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FileBoxChange(Sender: TObject);
    procedure FileBoxClick(Sender: TObject);
    procedure FileBoxEnter(Sender: TObject);
    procedure FileBoxExit(Sender: TObject);
    procedure FileBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure FileBoxKeyPress(Sender: TObject; var AKey: Char);
    procedure FileBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure FileBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure FileNameEditEnter(Sender: TObject);
    procedure FileNameEditExit(Sender: TObject);
    procedure FileNameEditKeyPress(Sender: TObject; var AKey: Char);
    procedure FindBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HiddenBoxClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIPreviewClick(Sender: TObject);
    procedure MIRenameClick(Sender: TObject);
    procedure MIViewClick(Sender: TObject);
    procedure MediaTimerTimer(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure OKMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure OKMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PlayBtnClick(Sender: TObject);
    procedure PlayBtnMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PlayBtnMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure PreviewBoxClick(Sender: TObject);
    procedure SearchEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure Splitter1Moved(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure StopBtnMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StopBtnMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
    procedure StretchChkClick(Sender: TObject);
    procedure TopPanelResize(Sender: TObject);
  end;

var
  FileBrowser: TFileBrowser;

implementation

{$R *.lfm}

procedure TFileBrowser.BrowserMenuPopup(Sender: TObject);
begin
  DispatchAction(Sender, 'BrowserMenuPopup');
end;

procedure TFileBrowser.CancelClick(Sender: TObject);
begin
  DispatchAction(Sender, 'CancelClick');
end;

procedure TFileBrowser.CancelMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.CancelMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.DirBoxChange(Sender: TObject);
begin
  DispatchAction(Sender, 'DirBoxChange');
end;

procedure TFileBrowser.DirBoxEnter(Sender: TObject);
begin
end;

procedure TFileBrowser.DirBoxExit(Sender: TObject);
begin
end;

procedure TFileBrowser.DirBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'DirBoxKeyDown');
end;

procedure TFileBrowser.DriveBoxChange(Sender: TObject);
begin
  DispatchAction(Sender, 'DriveBoxChange');
end;

procedure TFileBrowser.DriveBoxEnter(Sender: TObject);
begin
end;

procedure TFileBrowser.DriveBoxExit(Sender: TObject);
begin
end;

procedure TFileBrowser.Edit1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Edit1Click');
end;

procedure TFileBrowser.FBrowseEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FBrowseEditKeyDown');
end;

procedure TFileBrowser.FileBoxChange(Sender: TObject);
begin
  DispatchAction(Sender, 'FileBoxChange');
end;

procedure TFileBrowser.FileBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FileBoxClick');
end;

procedure TFileBrowser.FileBoxEnter(Sender: TObject);
begin
end;

procedure TFileBrowser.FileBoxExit(Sender: TObject);
begin
end;

procedure TFileBrowser.FileBoxKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'FileBoxKeyDown');
end;

procedure TFileBrowser.FileBoxKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'FileBoxKeyPress');
end;

procedure TFileBrowser.FileBoxMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.FileBoxMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.FileNameEditEnter(Sender: TObject);
begin
end;

procedure TFileBrowser.FileNameEditExit(Sender: TObject);
begin
end;

procedure TFileBrowser.FileNameEditKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'FileNameEditKeyPress');
end;

procedure TFileBrowser.FindBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindBtnClick');
end;

procedure TFileBrowser.FormActivate(Sender: TObject);
begin
end;

procedure TFileBrowser.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TFileBrowser.FormCloseQuery(Sender: TObject; var ACanClose: Boolean);
begin
end;

procedure TFileBrowser.FormCreate(Sender: TObject);
begin
end;

procedure TFileBrowser.FormDeactivate(Sender: TObject);
begin
end;

procedure TFileBrowser.FormDestroy(Sender: TObject);
begin
end;

procedure TFileBrowser.FormResize(Sender: TObject);
begin
end;

procedure TFileBrowser.FormShow(Sender: TObject);
begin
end;

procedure TFileBrowser.HiddenBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'HiddenBoxClick');
end;

procedure TFileBrowser.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TFileBrowser.MIPreviewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIPreviewClick');
end;

procedure TFileBrowser.MIRenameClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRenameClick');
end;

procedure TFileBrowser.MIViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewClick');
end;

procedure TFileBrowser.MediaTimerTimer(Sender: TObject);
begin
end;

procedure TFileBrowser.OKClick(Sender: TObject);
begin
  DispatchAction(Sender, 'OKClick');
end;

procedure TFileBrowser.OKMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.OKMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.PlayBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PlayBtnClick');
end;

procedure TFileBrowser.PlayBtnMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.PlayBtnMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.PreviewBoxClick(Sender: TObject);
begin
  DispatchAction(Sender, 'PreviewBoxClick');
end;

procedure TFileBrowser.SearchEditKeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'SearchEditKeyDown');
end;

procedure TFileBrowser.Splitter1Moved(Sender: TObject);
begin
end;

procedure TFileBrowser.StopBtnClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StopBtnClick');
end;

procedure TFileBrowser.StopBtnMouseDown(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.StopBtnMouseUp(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; X, AY: Integer);
begin
end;

procedure TFileBrowser.StretchChkClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StretchChkClick');
end;

procedure TFileBrowser.TopPanelResize(Sender: TObject);
begin
end;

initialization
  if GetClass('TFileBrowser') = nil then
    RegisterClass(TFileBrowser);

end.
