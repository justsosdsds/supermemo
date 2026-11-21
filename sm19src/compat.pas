unit compat;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, Grids, Calendar, ImgList, Buttons, ExtDlgs, FileCtrl, CheckLst, Spin, ColorBox, MaskEdit;

type
  TCategoryButtons = class(TPanel)
  public
  end;
  TDirectoryListBox = class(TListBox)
  public
  end;
  TDriveComboBox = class(TComboBox)
  public
  end;
  TMediaPlayer = class(TPanel)
  public
  end;
  TMonthCalendar = class(TCalendar)
  public
  end;
  TRichEdit = class(TMemo)
  public
  end;
  TTabPage = class(TPanel)
  public
  end;
  TTabSet = class(TPanel)
  public
  end;
  TTabbedNotebook = class(TPageControl)
  public
  end;

implementation

initialization
  RegisterClass(TCategoryButtons);
  RegisterClass(TDirectoryListBox);
  RegisterClass(TDriveComboBox);
  RegisterClass(TMediaPlayer);
  RegisterClass(TMonthCalendar);
  RegisterClass(TRichEdit);
  RegisterClass(TTabPage);
  RegisterClass(TTabSet);
  RegisterClass(TTabbedNotebook);
end.
