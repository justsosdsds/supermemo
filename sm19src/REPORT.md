# SuperMemo 19 逆向还原报告（R1 静态还原 / R2 骨架工程）

生成时间：2026-11-21 22:12:28

## 1. 目标链

| 阶段 | 对象 | 说明 |
| --- | --- | --- |
| 原始目标 | `G:\SuperMemo19_Unlocked_Setup.exe` | 18,754,048 字节，Inno Setup 5.5.7 安装包（`SuperMemo Setup`），结构被修改导致 `innoextract` 拒收 |
| 内层主程序 | `extracted\SuperMemo19_payload.exe` | 13166592 字节，SHA-256 `29932da1f9f694663ecadf4f0143d13746fdc01c1a090ab10148622df992b350` |
| 编译器特征 | Delphi / Embarcadero（VCL） | PE32 i386 GUI，11 段 `.text/.itext/.data/.bss/.idata/.didata/.edata/.tls/.rdata/.reloc/.rsrc`，入口 `0x007fa38c`（`.itext`），无壳无虚拟化 |
| 编译时间戳 | 2023-10-07 12:51:48 UTC | PE TimeDateStamp |
| 原始文件名 | `sm19.exe` | 程序中硬编码 |

## 2. 资源与代码规模

| 项目 | 数值 |
| --- | --- |
| DFM 窗体资源（`TPF0`） | **89** |
| 资源叶子总数 | 315（含 92 RCDATA、84 BITMAP、51 STRING、39 自定义类型、21 CURSOR、4 ICON 等） |
| 组件对象总数 | 3708 |
| 组件类（distinct） | 141 |
| 事件绑定总数 | 2700（47 种事件） |
| 属性名（distinct） | 266 |
| 导入 DLL | 20（user32 228、kernel32 158、gdi32 125、ole32 45、comctl32 37、wininet 22、msvcrt 20、oleaut32 18、advapi32 18 …） |
| .NET 迹象 | 无 `mscoree` 导入；尾部存在 `BSJB` 元数据签名（内嵌资源，非主程序运行时） |

## 3. 窗体清单（89 个，全部由 DFM 100% 还原）

| # | 单元 | 类 | 实例名 | 字段数 | 事件方法数 | 源资源 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `uAboutBox` | `TAboutBox` | `AboutBox` | 13 | 8 | `001_0.json` |
| 2 | `uAddressDlg` | `TAddressDlg` | `AddressDlg` | 5 | 2 | `002_0.json` |
| 3 | `uAddTranscription` | `TAddTranscription` | `AddTranscription` | 6 | 3 | `003_0.json` |
| 4 | `uAlignDlg` | `TAlignDlg` | `AlignDlg` | 26 | 2 | `004_0.json` |
| 5 | `uAnalysisDlg` | `TAnalysisDlg` | `AnalysisDlg` | 57 | 61 | `005_0.json` |
| 6 | `uAncestors` | `TAncestors` | `Ancestors` | 9 | 8 | `006_0.json` |
| 7 | `uBack` | `TBack` | `Back` | 1 | 0 | `007_0.json` |
| 8 | `uBrImp` | `TBrImp` | `BrImp` | 60 | 51 | `008_0.json` |
| 9 | `uBrowser` | `TBrowser` | `Browser` | 187 | 149 | `009_0.json` |
| 10 | `uChangeCompSize` | `TChangeCompSize` | `ChangeCompSize` | 13 | 2 | `010_0.json` |
| 11 | `uChecksDlg` | `TChecksDlg` | `ChecksDlg` | 7 | 7 | `011_0.json` |
| 12 | `uChoicesDlg` | `TChoicesDlg` | `ChoicesDlg` | 5 | 7 | `012_0.json` |
| 13 | `uCommanderDlg` | `TCommanderDlg` | `CommanderDlg` | 19 | 19 | `013_0.json` |
| 14 | `uComponentEditor` | `TComponentEditor` | `ComponentEditor` | 0 | 7 | `014_0.json` |
| 15 | `uConceptEditor` | `TConceptEditor` | `ConceptEditor` | 17 | 11 | `015_0.json` |
| 16 | `uConceptMapForm` | `TConceptMapForm` | `ConceptMapForm` | 7 | 5 | `016_0.json` |
| 17 | `uConceptSelectBox` | `TConceptSelectBox` | `ConceptSelectBox` | 10 | 16 | `017_0.json` |
| 18 | `uContents` | `TContents` | `Contents` | 189 | 137 | `018_0.json` |
| 19 | `uContributions` | `TContributions` | `Contributions` | 4 | 2 | `019_0.json` |
| 20 | `uElDataWind` | `TElDataWind` | `ElDataWind` | 7 | 13 | `020_0.json` |
| 21 | `uElementFilter` | `TElementFilter` | `ElementFilter` | 55 | 23 | `021_0.json` |
| 22 | `uElParamDlg` | `TElParamDlg` | `ElParamDlg` | 65 | 34 | `022_0.json` |
| 23 | `uElWind` | `TElWind` | `ElWind` | 638 | 403 | `023_0.json` |
| 24 | `uFAQDlg` | `TFAQDlg` | `FAQDlg` | 25 | 16 | `024_0.json` |
| 25 | `uFileBrowser` | `TFileBrowser` | `FileBrowser` | 41 | 53 | `025_0.json` |
| 26 | `uGetIntervalDlg` | `TGetIntervalDlg` | `GetIntervalDlg` | 9 | 7 | `026_0.json` |
| 27 | `uHitEditor` | `THitEditor` | `HitEditor` | 14 | 10 | `027_0.json` |
| 28 | `uHTMLForm` | `THTMLForm` | `HTMLForm` | 23 | 6 | `028_0.json` |
| 29 | `uImgDown` | `TImgDown` | `ImgDown` | 27 | 22 | `029_0.json` |
| 30 | `uImgScaler` | `TImgScaler` | `ImgScaler` | 19 | 6 | `030_0.json` |
| 31 | `uImportMailDlg` | `TImportMailDlg` | `ImportMailDlg` | 31 | 26 | `031_0.json` |
| 32 | `uImportTXTDlg` | `TImportTXTDlg` | `ImportTXTDlg` | 8 | 6 | `032_0.json` |
| 33 | `uInputDlg` | `TInputDlg` | `InputDlg` | 7 | 9 | `033_0.json` |
| 34 | `uLayoutDlg` | `TLayoutDlg` | `LayoutDlg` | 9 | 9 | `034_0.json` |
| 35 | `uLeechManagerDlg` | `TLeechManagerDlg` | `LeechManagerDlg` | 26 | 24 | `035_0.json` |
| 36 | `uLocalizationDlg` | `TLocalizationDlg` | `LocalizationDlg` | 13 | 13 | `036_0.json` |
| 37 | `uLoginDialog` | `TLoginDialog` | `LoginDialog` | 11 | 1 | `037_0.json` |
| 38 | `uMemForm` | `TMemForm` | `MemForm` | 7 | 3 | `038_0.json` |
| 39 | `uMercyForm` | `TMercyForm` | `MercyForm` | 23 | 7 | `039_0.json` |
| 40 | `uMercyOptions` | `TMercyOptions` | `MercyOptions` | 21 | 5 | `040_0.json` |
| 41 | `uMsgDialog` | `TMsgDialog` | `MsgDialog` | 14 | 18 | `041_0.json` |
| 42 | `uMyFindDlg` | `TMyFindDlg` | `MyFindDlg` | 32 | 19 | `042_0.json` |
| 43 | `uMyReplaceDlg` | `TMyReplaceDlg` | `MyReplaceDlg` | 10 | 8 | `043_0.json` |
| 44 | `uOptions` | `TOptions` | `Options` | 127 | 36 | `044_0.json` |
| 45 | `uOrderEditor` | `TOrderEditor` | `OrderEditor` | 4 | 8 | `045_0.json` |
| 46 | `uPasswordDialog` | `TPasswordDialog` | `PasswordDialog` | 7 | 5 | `046_0.json` |
| 47 | `uPasswordDlg` | `TPasswordDlg` | `PasswordDlg` | 4 | 3 | `047_0.json` |
| 48 | `uPlanDlg` | `TPlanDlg` | `PlanDlg` | 76 | 63 | `048_0.json` |
| 49 | `uPlanParamDlg` | `TPlanParamDlg` | `PlanParamDlg` | 10 | 10 | `049_0.json` |
| 50 | `uPlayerForm` | `TPlayerForm` | `PlayerForm` | 46 | 36 | `050_0.json` |
| 51 | `uPleaseDlg` | `TPleaseDlg` | `PleaseDlg` | 8 | 5 | `051_0.json` |
| 52 | `uPostponeDlg` | `TPostponeDlg` | `PostponeDlg` | 63 | 16 | `052_0.json` |
| 53 | `uPriorityDlg` | `TPriorityDlg` | `PriorityDlg` | 32 | 18 | `053_0.json` |
| 54 | `uProgressBox` | `TProgressBox` | `ProgressBox` | 20 | 6 | `054_0.json` |
| 55 | `uQODDlg` | `TQODDlg` | `QODDlg` | 9 | 7 | `055_0.json` |
| 56 | `uQuestions` | `TQuestions` | `Questions` | 59 | 7 | `056_0.json` |
| 57 | `uRecoveryDialog` | `TRecoveryDialog` | `RecoveryDialog` | 19 | 7 | `057_0.json` |
| 58 | `uRegistrationForm` | `TRegistrationForm` | `RegistrationForm` | 21 | 8 | `058_0.json` |
| 59 | `uRegistryForm` | `TRegistryForm` | `RegistryForm` | 143 | 109 | `059_0.json` |
| 60 | `uRepGraphDlg` | `TRepGraphDlg` | `RepGraphDlg` | 5 | 4 | `060_0.json` |
| 61 | `uRepHistoryForm` | `TRepHistoryForm` | `RepHistoryForm` | 11 | 11 | `061_0.json` |
| 62 | `uRepSimDlg` | `TRepSimDlg` | `RepSimDlg` | 15 | 5 | `062_0.json` |
| 63 | `uRepSortDlg` | `TRepSortDlg` | `RepSortDlg` | 18 | 7 | `063_0.json` |
| 64 | `uRotateForm` | `TRotateForm` | `RotateForm` | 24 | 24 | `064_0.json` |
| 65 | `uScriptEditor` | `TScriptEditor` | `ScriptEditor` | 47 | 41 | `065_0.json` |
| 66 | `uSetPendingDlg` | `TSetPendingDlg` | `SetPendingDlg` | 8 | 5 | `066_0.json` |
| 67 | `uShowTimeDialog` | `TShowTimeDialog` | `ShowTimeDialog` | 10 | 4 | `067_0.json` |
| 68 | `uSimDlg` | `TSimDlg` | `SimDlg` | 36 | 10 | `068_0.json` |
| 69 | `uSleepForm` | `TSleepForm` | `SleepForm` | 133 | 96 | `069_0.json` |
| 70 | `uSleepGraph` | `TSleepGraph` | `SleepGraph` | 6 | 8 | `070_0.json` |
| 71 | `uSMMain` | `TSMMain` | `SMMain` | 577 | 406 | `071_0.json` |
| 72 | `uSpellDlg` | `TSpellDlg` | `SpellDlg` | 9 | 3 | `072_0.json` |
| 73 | `uSpreadPrioritiesDlg` | `TSpreadPrioritiesDlg` | `SpreadPrioritiesDlg` | 25 | 11 | `073_0.json` |
| 74 | `uStatBar` | `TStatBar` | `StatBar` | 5 | 3 | `074_0.json` |
| 75 | `uStats` | `TStats` | `Stats` | 16 | 18 | `075_0.json` |
| 76 | `uStylesheetEditor` | `TStylesheetEditor` | `StylesheetEditor` | 14 | 12 | `076_0.json` |
| 77 | `uTargetDlg` | `TTargetDlg` | `TargetDlg` | 15 | 17 | `077_0.json` |
| 78 | `uTasklistEditor` | `TTasklistEditor` | `TasklistEditor` | 12 | 5 | `078_0.json` |
| 79 | `uTaskManager` | `TTaskManager` | `TaskManager` | 57 | 44 | `079_0.json` |
| 80 | `uThemeTestDlg` | `TThemeTestDlg` | `ThemeTestDlg` | 9 | 7 | `080_0.json` |
| 81 | `uTileDlg` | `TTileDlg` | `TileDlg` | 11 | 8 | `081_0.json` |
| 82 | `uTitleEdit` | `TTitleEdit` | `TitleEdit` | 5 | 7 | `082_0.json` |
| 83 | `uTranslationDlg` | `TTranslationDlg` | `TranslationDlg` | 5 | 7 | `083_0.json` |
| 84 | `uURLOpenDlg` | `TURLOpenDlg` | `URLOpenDlg` | 6 | 7 | `084_0.json` |
| 85 | `uVBrowser` | `TVBrowser` | `VBrowser` | 4 | 2 | `085_0.json` |
| 86 | `uWebDlg` | `TWebDlg` | `WebDlg` | 53 | 41 | `086_0.json` |
| 87 | `uWorkload` | `TWorkload` | `Workload` | 40 | 36 | `087_0.json` |
| 88 | `uWorkloadForm` | `TWorkloadForm` | `WorkloadForm` | 2 | 10 | `088_0.json` |
| 89 | `uXMLExportDialog` | `TXMLExportDialog` | `XMLExportDialog` | 11 | 0 | `089_0.json` |

## 4. 组件类分布（前 40）

| 类 | 数量 |
| --- | --- |
| `TMenuItem` | 1731 |
| `TToolButton` | 405 |
| `TLabel` | 335 |
| `TEdit` | 159 |
| `TBitBtn` | 134 |
| `TButton` | 122 |
| `TCheckBox` | 91 |
| `TPopupMenu` | 62 |
| `TPanel` | 60 |
| `TSpeedButton` | 47 |
| `TMemo` | 41 |
| `TBevel` | 41 |
| `TPaintBox` | 40 |
| `TRadioButton` | 39 |
| `TToolBar` | 29 |
| `TTabSheet` | 29 |
| `TTrackBar` | 28 |
| `TRadioGroup` | 26 |
| `TComboBox` | 24 |
| `TGroupBox` | 23 |
| `TStringGrid` | 13 |
| `TTimer` | 13 |
| `TImage` | 11 |
| `TTabPage` | 11 |
| `TTabSet` | 10 |
| `TTabControl` | 10 |
| `TOpenDialog` | 8 |
| `TListBox` | 8 |
| `TCheckListBox` | 7 |
| `TSaveDialog` | 7 |
| `TSplitter` | 7 |
| `TFontDialog` | 6 |
| `TPageControl` | 6 |
| `TMediaPlayer` | 6 |
| `TScrollBar` | 4 |
| `TScrollBox` | 3 |
| `TColorDialog` | 3 |
| `TUpDown` | 3 |
| `TImageList` | 2 |
| `TRichEdit` | 2 |

## 5. 事件分布（全部）

| 事件 | 绑定数 |
| --- | --- |
| `OnClick` | 1996 |
| `OnChange` | 89 |
| `OnCreate` | 73 |
| `OnShow` | 60 |
| `OnKeyDown` | 59 |
| `OnMouseDown` | 46 |
| `OnKeyPress` | 39 |
| `OnPaint` | 33 |
| `OnResize` | 31 |
| `OnClose` | 29 |
| `OnActivate` | 25 |
| `OnDblClick` | 19 |
| `OnEnter` | 18 |
| `OnDestroy` | 17 |
| `OnDeactivate` | 17 |
| `OnMouseMove` | 16 |
| `OnCloseQuery` | 16 |
| `OnMouseUp` | 13 |
| `OnTimer` | 13 |
| `OnExit` | 11 |
| `OnPopup` | 10 |
| `OnDrawCell` | 7 |
| `OnSelectCell` | 7 |
| `OnKeyUp` | 6 |
| `OnHide` | 5 |
| `OnDropDown` | 5 |
| `OnDragDrop` | 4 |
| `OnDragOver` | 4 |
| `OnClickCheck` | 3 |
| `OnRowMoved` | 3 |
| `OnContextPopup` | 3 |
| `OnMouseWheelDown` | 2 |
| `OnMouseWheelUp` | 2 |
| `OnColumnMoved` | 2 |
| `OnScroll` | 2 |
| `OnTopLeftChanged` | 2 |
| `OnChangingEx` | 2 |
| `OnMouseWheel` | 2 |
| `OnHelp` | 1 |
| `OnMouseLeave` | 1 |
| `OnButtonClicked` | 1 |
| `OnCategoryCollapase` | 1 |
| `OnGetImageIndex` | 1 |
| `OnMoved` | 1 |
| `OnDrawItem` | 1 |
| `OnNotify` | 1 |
| `OnChanging` | 1 |

## 6. 还原产物

```
sm19src/
  sm19.lpr                程序文件（Application.CreateForm(TSMMain, SMMain)）
  compat.pas              LCL 缺失类的桩定义 + RegisterClass
  units/u*.pas            89 个窗体单元（类声明 + 3607 组件字段 + 2441 事件方法桩）
  units/u*.lfm            89 个窗体资源（由 TPF0 二进制 DFM 反序列化）
  tools/propdump.lpr      LCL 已发布属性导出工具（用于裁剪 LFM 到 LCL 安全属性集）
  manifest.json           单元/类/字段/事件索引
```

## 7. 保真度与限制

已 100% 还原：
- 窗体与控件树（层级、顺序、Owner 关系）
- 全部 published 属性值（坐标、尺寸、标题、字体、颜色、菜单结构、Tab 序、字符串列表、集合）
- 事件处理函数名与绑定点（2441 个）
- 类名、实例名、资源名与单元划分

不可从二进制恢复：
- 过程内部实现（方法体）—— 需 R3 阶段按模块逆向重写
- 局部变量名、注释、泛型与内联细节
- Delphi 编译器版本精确值（仅由段布局/字符串推断为 Embarcadero VCL）
- 运行时动态创建的控件与字符串拼接逻辑（不在 DFM 内）

LCL 适配差异：
- 4 个类 LCL 无对应实现，使用桩类：`TRichEdit→TMemo`、`TMediaPlayer→TPanel`、`TCategoryButtons→TPanel`、`TTabPage→TPanel`
- `OldCreateOrder`、`PixelsPerInch` 等 Delphi 专有属性由裁剪器剔除
- 与基类方法同名的事件/组件被改名（如 `TSimDlg.Close` 组件 → `Close_Ctl`）

## 8. 验证结果（编译 + 加载 + 运行）

| 验证项 | 结果 |
| --- | --- |
| 编译链 | Lazarus 3.0 + FPC 3.2.2 (x86_64-win64)，`lazbuild sm19.lpi` |
| 编译 | **通过**，17,743 行，代码 1,877,184 字节 |
| 产物 | `sm19.exe`，3588608 字节 |
| 单元/资源 | 89 个 `.pas` + 89 个 `.lfm` |
| LFM 语法校验 | 89/89 通过 `lazres` |
| 窗体流式加载（`Application.CreateForm`） | **89/89 通过**（失败 0） |
| 实际运行 | 主窗体 `TSMMain` 显示，标题 `SuperMemo`，菜单 File/Edit/Search/Learn/View/Toolkit/Window/Help 与工具栏按钮全部按原 DFM 还原 |

验证方法：

```pascal
// tools/loadertest.lpr —— 对 89 个窗体逐个触发 LCL 组件流式加载
Application.Initialize;
for i := 0 to High(Entries) do
begin
  f := nil;
  Application.CreateForm(Entries[i].Cls, f);   // 真实读取 .lfm
  ...
end;
```

## 9. 适配层（兼容性处理清单）

| 类型 | 处理 |
| --- | --- |
| LCL 缺类 | 桩类（继承就近 LCL 类 + RegisterClass）：`TRichEdit→TMemo`、`TMediaPlayer→TPanel`、`TCategoryButtons→TPanel`、`TTabPage→TPanel`、`TTabSet→TPanel`、`TTabbedNotebook→TPageControl`、`TMonthCalendar→TCalendar`、`TDirectoryListBox→TListBox`、`TDriveComboBox→TComboBox` |
| Delphi 专有属性 | 由 `tools/prune_lfm.py` 按 `tools/props.txt`（LCL 运行时导出的 published 属性白名单）剔除：`OldCreateOrder`、`TextHeight`、`PixelsPerInch`、`StyleElements`、`Explicit*`、`Margins.*`（无此属性的类）等 |
| 枚举值差异 | 值映射替换，如 `tbsTextButton → tbsButton`（Delphi 有、LCL 无） |
| 与基类成员同名 | 组件/事件改名并同步 LFM：如 `TSimDlg.Close` 组件 → `Close_Ctl`、`PopUpMenu` → `PopUpMenu_Ctl` |
| 匿名子组件 | DFM 中的无名对象补名（`AnonComp_n`），否则 LCL 文本读取器拒绝 |
| 事件方法 | 全部放入 published 区并加 `{$R *.lfm}`，保证流式加载时按名字绑定 |
| 事件签名 | 参数名统一加 `A` 前缀（`Action`/`CanClose`/`Key` 等），避免与 TForm 属性在 objfpc 模式下重名 |

## 10. 第二阶段：图标资源恢复 + 运行时窗口还原

### 10.1 二进制资源（全部恢复）

| 资源 | 数量 | 处理 |
| --- | --- | --- |
| `TBitBtn.Glyph.Data` / `TSpeedButton.Glyph.Data` | 49 | 剥离 4 字节长度前缀后为完整 BMP，以 `Data = {HEX}` 写回 LFM |
| `TImageList.Bitmap`（模板 `IL` 流） | 2 | 原样写回 LFM —— LCL 的 `TCustomImageList.ReadData` 能直接解析 Delphi 的 `IL` 流 |
| `TImage.Picture.Data`（`TJPEGImage` 封装） | 1 | 原样写回 LFM（AboutBox 的 SuperMemo 19 封面图，已实际显示） |
| `Icon.Data`（ICO） | 3 | 原样写回 LFM（窗体图标） |

关键实现细节：`Images = AboutBox.ImageList1` 这种跨窗体引用要求宿主窗体先存在，
因此 `sm19.lpr` 先执行 `AboutBox := TAboutBox.Create(Application);`（不显示，仅作
ImageList 宿主），再 `Application.CreateForm(TSMMain, SMMain)`。

验证：主窗体顶部 3 排共 116 个工具栏按钮的彩色图标全部显示，与原版一致。

### 10.2 启动时的窗口结构

原版首屏是 `TContents`（概念/内容窗口），实测运行 `SuperMemo19.exe` 首次启动即为该窗口：
菜单 `File`/`Help`、工具栏 `Contents`/`Search`/←/→/`History`/集合下拉、底部 `Learn`/`Add new` 按钮。

骨架现在同样在启动时创建并显示 `TContents`，布局与原版一致（左列垂直工具按钮、
顶部工具栏图标、底部 Learn/Add 按钮均来自原 DFM）。

### 10.3 该阶段仍缺

- 客户区内容：元素内容由运行时 HTML/图形渲染生成，不在 DFM 内
- 工具栏的显示/隐藏状态：原版由运行时代码控制哪些工具栏可见
- 菜单项的启用状态与快捷键联动（`TActionList` 逻辑）

### 10.4 构建环境备注

`lazbuild` 曾出现 `Package file not found / LazEdit` 错误，`TPCTargetConfigCache` 无法
刷新，导致所有构建失败。重装 Lazarus 3.0（同一安装器静默覆盖）后恢复。
重装后编译输出：`17,746 lines compiled, 1,899,520 bytes code`，产物 `sm19.exe` 3.93 MB。
