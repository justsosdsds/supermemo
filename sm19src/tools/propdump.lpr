program propdump;
{$mode objfpc}{$H+}

uses
  Interfaces, Classes, SysUtils, TypInfo, Buttons, CheckLst, ComCtrls, Controls, Dialogs, ExtCtrls, FileCtrl, Forms, Grids, ImgList, Menus, StdCtrls, compat;

type
  TClsEntry = record
    Name: string;
    Ref: TClass;
  end;

const
  Entries: array[0..52] of TClsEntry = (
    (Name: 'TForm'; Ref: TForm),
    (Name: 'TBevel'; Ref: TBevel),
    (Name: 'TBitBtn'; Ref: TBitBtn),
    (Name: 'TButton'; Ref: TButton),
    (Name: 'TCategoryButtons'; Ref: TCategoryButtons),
    (Name: 'TCheckBox'; Ref: TCheckBox),
    (Name: 'TCheckListBox'; Ref: TCheckListBox),
    (Name: 'TColorDialog'; Ref: TColorDialog),
    (Name: 'TComboBox'; Ref: TComboBox),
    (Name: 'TDirectoryListBox'; Ref: TDirectoryListBox),
    (Name: 'TDriveComboBox'; Ref: TDriveComboBox),
    (Name: 'TEdit'; Ref: TEdit),
    (Name: 'TFileListBox'; Ref: TFileListBox),
    (Name: 'TFilterComboBox'; Ref: TFilterComboBox),
    (Name: 'TFontDialog'; Ref: TFontDialog),
    (Name: 'TGroupBox'; Ref: TGroupBox),
    (Name: 'TImage'; Ref: TImage),
    (Name: 'TImageList'; Ref: TImageList),
    (Name: 'TLabel'; Ref: TLabel),
    (Name: 'TListBox'; Ref: TListBox),
    (Name: 'TMainMenu'; Ref: TMainMenu),
    (Name: 'TMediaPlayer'; Ref: TMediaPlayer),
    (Name: 'TMemo'; Ref: TMemo),
    (Name: 'TMenuItem'; Ref: TMenuItem),
    (Name: 'TMonthCalendar'; Ref: TMonthCalendar),
    (Name: 'TOpenDialog'; Ref: TOpenDialog),
    (Name: 'TPageControl'; Ref: TPageControl),
    (Name: 'TPaintBox'; Ref: TPaintBox),
    (Name: 'TPanel'; Ref: TPanel),
    (Name: 'TPopupMenu'; Ref: TPopupMenu),
    (Name: 'TProgressBar'; Ref: TProgressBar),
    (Name: 'TRadioButton'; Ref: TRadioButton),
    (Name: 'TRadioGroup'; Ref: TRadioGroup),
    (Name: 'TRichEdit'; Ref: TRichEdit),
    (Name: 'TSaveDialog'; Ref: TSaveDialog),
    (Name: 'TScrollBar'; Ref: TScrollBar),
    (Name: 'TScrollBox'; Ref: TScrollBox),
    (Name: 'TShape'; Ref: TShape),
    (Name: 'TSpeedButton'; Ref: TSpeedButton),
    (Name: 'TSplitter'; Ref: TSplitter),
    (Name: 'TStaticText'; Ref: TStaticText),
    (Name: 'TStringGrid'; Ref: TStringGrid),
    (Name: 'TTabControl'; Ref: TTabControl),
    (Name: 'TTabPage'; Ref: TTabPage),
    (Name: 'TTabSet'; Ref: TTabSet),
    (Name: 'TTabSheet'; Ref: TTabSheet),
    (Name: 'TTabbedNotebook'; Ref: TTabbedNotebook),
    (Name: 'TTimer'; Ref: TTimer),
    (Name: 'TToolBar'; Ref: TToolBar),
    (Name: 'TToolButton'; Ref: TToolButton),
    (Name: 'TTrackBar'; Ref: TTrackBar),
    (Name: 'TTrayIcon'; Ref: TTrayIcon),
    (Name: 'TUpDown'; Ref: TUpDown)
  );

var
  i, n, j: Integer;
  pl: PPropList;
  out: TStringList;
  line: string;
begin
  out := TStringList.Create;
  try
    for i := 0 to High(Entries) do
    begin
      line := Entries[i].Name + '=';
      try
        n := GetPropList(Entries[i].Ref.ClassInfo, tkAny, nil);
      except
        n := -1;
      end;
      if n > 0 then
      begin
        GetMem(pl, n * SizeOf(Pointer));
        try
          GetPropList(Entries[i].Ref.ClassInfo, tkAny, pl);
          for j := 0 to n - 1 do
            if j = 0 then line := line + pl^[j]^.Name
            else line := line + ',' + pl^[j]^.Name;
        finally
          FreeMem(pl);
        end;
      end
      else if n = 0 then
        line := line + '<none>'
      else
        line := line + '<err>';
      out.Add(line);
    end;
    out.SaveToFile(ParamStr(1));
  finally
    out.Free;
  end;
end.