unit uRepHistoryForm;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, Math, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, ExtDlgs, ImgList, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit, ActnList, Calendar, LCLType, LCLIntf, LResources, compat, smactions;

type
  TRepHistoryForm = class(TForm)
    StringGrid1: TStringGrid;
    PopupMenu1: TPopupMenu;
    MIEditHistory: TMenuItem;
    MICopy: TMenuItem;
    MIDelete: TMenuItem;
    MIResave: TMenuItem;
    Close1: TMenuItem;
    N1: TMenuItem;
    Memorystatus1: TMenuItem;
    N2: TMenuItem;
    MIFixAndEdit: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var AAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MICopyClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure MIEditHistoryClick(Sender: TObject);
    procedure MIFixAndEditClick(Sender: TObject);
    procedure MIResaveClick(Sender: TObject);
    procedure Memorystatus1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
  end;

var
  RepHistoryForm: TRepHistoryForm;

implementation

{$R *.lfm}

procedure TRepHistoryForm.Close1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Close1Click');
end;

procedure TRepHistoryForm.FormClose(Sender: TObject; var AAction: TCloseAction);
begin
end;

procedure TRepHistoryForm.FormCreate(Sender: TObject);
begin
end;

procedure TRepHistoryForm.FormShow(Sender: TObject);
begin
end;

procedure TRepHistoryForm.MICopyClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MICopyClick');
end;

procedure TRepHistoryForm.MIDeleteClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIDeleteClick');
end;

procedure TRepHistoryForm.MIEditHistoryClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIEditHistoryClick');
end;

procedure TRepHistoryForm.MIFixAndEditClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIFixAndEditClick');
end;

procedure TRepHistoryForm.MIResaveClick(Sender: TObject);
begin
  DispatchAction(Sender, 'MIResaveClick');
end;

procedure TRepHistoryForm.Memorystatus1Click(Sender: TObject);
begin
  DispatchAction(Sender, 'Memorystatus1Click');
end;

procedure TRepHistoryForm.StringGrid1DrawCell(Sender: TObject; ACol, AARow: Integer; ARect: TRect; AState: TGridDrawState);
begin
end;

initialization
  if GetClass('TRepHistoryForm') = nil then
    RegisterClass(TRepHistoryForm);

end.
