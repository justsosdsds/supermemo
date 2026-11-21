# sm19 可编译骨架工程（由 SuperMemo 19 二进制还原）

本目录是从 `G:\SuperMemo19_Unlocked_Setup.exe` 逆向还原出的 **Object Pascal 工程**：
89 个窗体、3607 个组件字段、2441 个事件方法桩，全部由原程序内嵌的 89 份二进制 DFM
资源（`TPF0`）反序列化生成，并已在本机用 Lazarus 3.0 + FPC 3.2.2 编译通过、运行通过。

## 快速编译

```powershell
# 方式一：命令行（已在本机验证）
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19src\sm19.lpi
# 产物：F:\Projects\逆向\sm19src\sm19.exe

# 方式二：Lazarus IDE 打开 sm19.lpi，F9 运行
```

## 目录

```
sm19src/
  sm19.lpr            程序文件：Application.CreateForm(TSMMain, SMMain)
  sm19.lpi            Lazarus 工程（LCL 依赖、ObjFpc 模式）
  compat.pas          LCL 缺失类的桩定义 + RegisterClass
  units/u*.pas        89 个窗体单元：类声明 + published 组件字段 + 事件方法桩
  units/u*.lfm        89 个窗体资源：由 TPF0 二进制 DFM 逐属性还原
  sm19.exe            已编译产物（3.4 MB，x86_64）
  manifest.json       单元 / 类 / 实例名 / 字段数 / 事件数索引
  REPORT.md           完整还原报告（目标链、资源统计、验证结果、适配清单）
  tools/
    propdump.lpr      导出 LCL 各类 published 属性白名单（裁剪依据）
    loadertest.lpr    对 89 个窗体逐个做 LCL 流式加载验证（89/89 通过）
    props.txt         propdump 的实际输出
```

## 方法体状态

每个事件方法都是**编译通过的空桩**：

```pascal
procedure TSMMain.FormCreate(Sender: TObject);
begin
end;
```

这正是 R3 阶段要逐模块填充的位置 —— 方法名、签名、绑定关系都已按原程序还原，
填充时不需要再动界面或绑定代码。

## 从二进制重新生成

```powershell
cd F:\Projects\逆向
python tools\extract_payload.py      # Inno 包 -> extracted\SuperMemo19_payload.exe
python tools\extract_dfm.py          # .rsrc -> work\dfm_raw\*.dfm.bin
python tools\dfm_to_json.py          # TPF0 -> work\dfm_json\*.json
python tools\gen_skeleton.py         # JSON -> units\*.pas + *.lfm
C:\lazarus\lazbuild.exe --build-all sm19src\tools\propdump.lpi
sm19src\tools\bin\propdump.exe sm19src\tools\props.txt
python tools\prune_lfm.py            # 按 LCL 白名单裁剪 LFM
python tools\gen_lpi.py
C:\lazarus\lazbuild.exe --build-all sm19src\sm19.lpi
python tools\gen_loadertest.py && C:\lazarus\lazbuild.exe --build-all sm19src\tools\loadertest.lpi
```

`tools\build.ps1` 是上述 1-4 步的串行版本；`tools\fix_loop.py` 会自动迭代编译错误并按
`work\name_blacklist.json` 扩充保留字黑名单。

## 已知限制

- 方法体为空（骨架构架，非语义等价实现）
- 9 个类用桩替代（`TRichEdit`、`TMediaPlayer`、`TCategoryButtons`、`TTabPage`、
  `TTabSet`、`TTabbedNotebook`、`TMonthCalendar`、`TDirectoryListBox`、`TDriveComboBox`），
  界面外观与原版在这几处有差异
- 与基类成员同名的 3 个组件被改名（`Close_Ctl`、`PopUpMenu_Ctl`、`Position_Ctl`）
- 运行时动态创建的控件、字符串拼接、文件格式读写逻辑不在 DFM 内，需 R3 阶段从
  反汇编中重建
