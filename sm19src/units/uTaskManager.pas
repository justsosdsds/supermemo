unit uTaskManager;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TTaskManager = class(TForm)
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton8: TToolButton;
    TaskCombo: TComboBox;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    MenuBtn: TToolButton;
    ToolButton13: TToolButton;
    ToolButton4: TToolButton;
    GoToButton: TToolButton;
    ToolButton12: TToolButton;
    AddButton: TToolButton;
    Delete: TToolButton;
    ToolButton16: TToolButton;
    Find: TToolButton;
    ToolButton6: TToolButton;
    ToolButton5: TToolButton;
    SortButton: TToolButton;
    ExportButton: TToolButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    MIView: TMenuItem;
    MIGoTo: TMenuItem;
    N2: TMenuItem;
    MIDismiss: TMenuItem;
    MIMemorizedTask: TMenuItem;
    MIEditParameters: TMenuItem;
    N3: TMenuItem;
    MIAddTask: TMenuItem;
    MITransferTask: TMenuItem;
    MISort: TMenuItem;
    MIFind: TMenuItem;
    MIFindNext: TMenuItem;
    Findall1: TMenuItem;
    N8: TMenuItem;
    MISelectTasklist: TMenuItem;
    MIGotoMenu: TMenuItem;
    MIRandomJump: TMenuItem;
    MIRandomPreferred: TMenuItem;
    MISelectedRow: TMenuItem;
    Tools1: TMenuItem;
    MIOpenInBrowser: TMenuItem;
    N5: TMenuItem;
    MIExportAsHTML: TMenuItem;
    MIExportAsText: TMenuItem;
    MIImportText: TMenuItem;
    N6: TMenuItem;
    MITransferTasklist: TMenuItem;
    N4: TMenuItem;
    MIVerify: TMenuItem;
    N1: TMenuItem;
    MIClose: TMenuItem;
    N7: TMenuItem;
    InvEditparamters1: TMenuItem;
    InvTransferTaskOption: TMenuItem;
    InvAnalysis1: TMenuItem;
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure Findall1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GoToButtonClick(Sender: TObject);
    procedure InvAnalysis1Click(Sender: TObject);
    procedure InvEditparamters1Click(Sender: TObject);
    procedure MIAddTaskClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure MIDismissClick(Sender: TObject);
    procedure MIEditParametersClick(Sender: TObject);
    procedure MIExportAsHTMLClick(Sender: TObject);
    procedure MIExportAsTextClick(Sender: TObject);
    procedure MIFindClick(Sender: TObject);
    procedure MIFindNextClick(Sender: TObject);
    procedure MIGoToClick(Sender: TObject);
    procedure MIImportTextClick(Sender: TObject);
    procedure MIMemorizedTaskClick(Sender: TObject);
    procedure MIOpenInBrowserClick(Sender: TObject);
    procedure MIRandomJumpClick(Sender: TObject);
    procedure MIRandomPreferredClick(Sender: TObject);
    procedure MISelectedRowClick(Sender: TObject);
    procedure MISortClick(Sender: TObject);
    procedure MITransferTaskClick(Sender: TObject);
    procedure MITransferTasklistClick(Sender: TObject);
    procedure MIVerifyClick(Sender: TObject);
    procedure MIViewClick(Sender: TObject);
    procedure SetDefaultClick(Sender: TObject);
    procedure SortButtonClick(Sender: TObject);
    procedure StringGrid1ColumnMoved(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
    procedure TaskComboChange(Sender: TObject);
    procedure TaskComboClick(Sender: TObject);
    procedure TaskComboDropDown(Sender: TObject);
    procedure TaskComboExit(Sender: TObject);
    procedure TaskComboKeyPress(Sender: TObject; var AKey: Char);
    procedure ToolButton4Click(Sender: TObject);
  end;

var
  TaskManager: TTaskManager;

implementation

{$R *.lfm}

procedure TTaskManager.AddButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'AddButtonClick');
end;

procedure TTaskManager.DeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'DeleteClick');
end;

procedure TTaskManager.ExportButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'ExportButtonClick');
end;

procedure TTaskManager.FindClick(Sender: TObject);
begin
  DispatchAction(Sender, 'FindClick');
end;

procedure TTaskManager.Findall1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Findall1Click');
end;

procedure TTaskManager.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TTaskManager.FormCreate(Sender: TObject);
begin
end;

procedure TTaskManager.FormResize(Sender: TObject);
begin
end;

procedure TTaskManager.FormShow(Sender: TObject);
begin
end;

procedure TTaskManager.GoToButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'GoToButtonClick');
end;

procedure TTaskManager.InvAnalysis1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvAnalysis1Click');
end;

procedure TTaskManager.InvEditparamters1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'InvEditparamters1Click');
end;

procedure TTaskManager.MIAddTaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIAddTaskClick');
end;

procedure TTaskManager.MICloseClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICloseClick');
end;

procedure TTaskManager.MIDismissClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDismissClick');
end;

procedure TTaskManager.MIEditParametersClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditParametersClick');
end;

procedure TTaskManager.MIExportAsHTMLClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportAsHTMLClick');
end;

procedure TTaskManager.MIExportAsTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIExportAsTextClick');
end;

procedure TTaskManager.MIFindClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindClick');
end;

procedure TTaskManager.MIFindNextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFindNextClick');
end;

procedure TTaskManager.MIGoToClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIGoToClick');
end;

procedure TTaskManager.MIImportTextClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIImportTextClick');
end;

procedure TTaskManager.MIMemorizedTaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIMemorizedTaskClick');
end;

procedure TTaskManager.MIOpenInBrowserClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIOpenInBrowserClick');
end;

procedure TTaskManager.MIRandomJumpClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomJumpClick');
end;

procedure TTaskManager.MIRandomPreferredClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIRandomPreferredClick');
end;

procedure TTaskManager.MISelectedRowClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISelectedRowClick');
end;

procedure TTaskManager.MISortClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MISortClick');
end;

procedure TTaskManager.MITransferTaskClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferTaskClick');
end;

procedure TTaskManager.MITransferTasklistClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MITransferTasklistClick');
end;

procedure TTaskManager.MIVerifyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIVerifyClick');
end;

procedure TTaskManager.MIViewClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIViewClick');
end;

procedure TTaskManager.SetDefaultClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SetDefaultClick');
end;

procedure TTaskManager.SortButtonClick(Sender: TObject);
begin
  DispatchAction(Sender, 'SortButtonClick');
end;

procedure TTaskManager.StringGrid1ColumnMoved(Sender: TObject);
begin
end;

procedure TTaskManager.StringGrid1DblClick(Sender: TObject);
begin
  DispatchAction(Sender, 'StringGrid1DblClick');
end;

procedure TTaskManager.StringGrid1KeyDown(Sender: TObject; var AKey: Word; AShift: TShiftState);
begin
  DispatchAction(Sender, 'StringGrid1KeyDown');
end;

procedure TTaskManager.StringGrid1SelectCell(Sender: TObject; ACol, AARow: Integer; var ACanSelect: Boolean);
begin
  DispatchAction(Sender, 'StringGrid1SelectCell');
end;

procedure TTaskManager.TaskComboChange(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboChange');
end;

procedure TTaskManager.TaskComboClick(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboClick');
end;

procedure TTaskManager.TaskComboDropDown(Sender: TObject);
begin
  DispatchAction(Sender, 'TaskComboDropDown');
end;

procedure TTaskManager.TaskComboExit(Sender: TObject);
begin
end;

procedure TTaskManager.TaskComboKeyPress(Sender: TObject; var AKey: Char);
begin
  DispatchAction(Sender, 'TaskComboKeyPress');
end;

procedure TTaskManager.ToolButton4Click(Sender: TObject);
begin
  DispatchAction(Sender, 'ToolButton4Click');
end;

initialization
  if GetClass('TTaskManager') = nil then
    RegisterClass(TTaskManager);

end.
