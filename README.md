# SuperMemo 19 逆向重建工程

把 SuperMemo 19（Delphi VCL 原生 PE32）逆向重构为**可编译、可编辑的 Lazarus/FPC 工程**，并逐步补齐数据格式、算法与业务流程。

> 原始目标程序：`SuperMemo19_Unlocked_Setup.exe`（18,754,048 字节）
> 其中内嵌的 `sm19.exe`：13,166,592 字节，PE32 i386，Delphi 编译，无加壳

---

## 目录结构

```
sm19src/          重建版主工程（Lazarus 3.0 + FPC 3.2.2）
  sm19.lpr          程序入口
  sm19.lpi          Lazarus 工程文件
  units/
    u*.pas          89 个窗体单元（从二进制 DFM 还原）
    u*.lfm          对应的窗体定义
    sm20alg.pas     SM-20 算法移植（V2/V4/V6 公式、21³ 矩阵）
    smcollection.pas 集合读写（ElementInfo / contents / compon / Text / stats / 历史）
    smengine.pas    调度引擎（ComputeNext / RecordRepetition）
    smactions.pas   事件分发与窗体打开
    smsettings.pas  设置往返（INI）+ 通用数据填充
    smimport.pas    导入卡片（Q&A 文本 → 集合）

sm19alg/          独立命令行工具（纯控制台，无 LCL 依赖）
  smcli.lpr         集合命令行：list / tree / show / search / export / import / study / matrix
  smplan.lpr        工作量预测
  smhist.lpr        学习历史查看
  smstats.lpr       原版统计指标
  sm20alg.pas       算法核心
  smcollection.pas  集合读写
  smengine.pas      调度引擎

tools/            Python 辅助工具
  extract_payload.py  从安装包中手工 PE 雕刻
  extract_dfm.py      提取二进制 DFM
  dfm_to_json.py      DFM → JSON
  gen_skeleton.py     生成 Pascal 骨架
  prune_lfm.py        LFM 属性裁剪（只保留 LCL 支持的）
  patch_features.py   把已实现的功能挂到菜单事件
  sm_import.py        Q&A 导入（参考实现）
  sm_extract.py       提取（渐进阅读 Extract）
  sm_export_html.py   HTML 导出
  fast_download.py    多线程下载器

INCREMENTAL_READING_RE.md   渐进阅读逆向结果
```

---

## 编译

需要 **Lazarus 3.0 + FPC 3.2.2**（x86_64-win64）。

```bat
:: 重建版主程序
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19src\sm19.lpi

:: 命令行工具
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19alg\smcli.lpi
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19alg\smplan.lpi
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19alg\smhist.lpi
C:\lazarus\lazbuild.exe --build-all F:\Projects\逆向\sm19alg\smstats.lpi
```

重新生成骨架（修改 `gen_skeleton.py` 之后）：

```bat
python tools\gen_skeleton.py
python tools\prune_lfm.py
python tools\patch_features.py
```

---

## 命令行工具用法

```bat
smcli list    <collection>
smcli tree    <collection>
smcli show    <collection> <element_id>
smcli search  <collection> <text>
smcli export  <collection> <outfile.tsv>
smcli import  <collection> <qa.txt>       :: 每行 "Q: ..." / "A: ..."
smcli study   <collection> <element_id> <grade 0..5>
smcli matrix  <collection> <R> <S> <D>

smplan  <collection> --days=30 --grade=4
smhist  <collection> [--element=N]
smstats <collection>
```

---

## 已解开的文件格式

所有格式都通过**差异对比 + 真实集合验证**得出，不是猜测。

### `info/ElementInfo.dat` — 118 字节/记录

| 偏移 | 类型 | 含义 |
|---|---|---|
| +0 | u8 | flags（0x04 = 根元素，0x01 = 子元素） |
| +1 | u8 | kind（**1 = Item，2 = Topic**） |
| +2 | u16 | 元素 id |
| +6 | u32 | 在 `compon.dat` 中的偏移（0xFFFFFFFF = 无组件） |
| +10 | u16 | 组件块大小 |
| +12 | i32 | 复习次数 rep |
| +16 | u32 | `(rep << 16) \| (上次评分 + 1)` |
| +20 | f64 | 最后复习时间（TDateTime） |
| +32 | f64 | 间隔提示（新集合里为 0 或 2.0） |
| +40 | i32 | **0-based** 元素序号（contents 里用 1-based，差 1） |

### `info/contents.dat` — 37 字节/记录，元素树

| 偏移 | 含义 |
|---|---|
| +1 | parent（**1-based** 序号，根为 0） |
| +5 | first_child |
| +9 | last_child |
| +13 | prev_sibling |
| +17 | next_sibling |
| +21 | child_count |

### `info/compon.dat` — 112 字节/块

| 偏移 | 含义 |
|---|---|
| +0 | 魔数 `0xd431` |
| +2 | 块大小 0x70 (112) |
| +4 | **元素序号 + 1** |
| +74 / +105 | 有内容的元素非零（内容长度相关） |
| 其余 | 模板布局（所有元素相同） |

### `info/RepetitionHistory.dat` — 39 字节/记录

| 偏移 | 含义 |
|---|---|
| +0 | 元素 id |
| +4 | 该元素的第几次复习 |
| +10 | f64 复习时间 |
| +25 | u16，`0xFFFF` = 首次复习 |
| +27 | i32 评分（1..5） |

### `registry/Text.rtx` / `.mem` / `.ptr`

```
Text.rtx   <utf8 文本> NUL <i32 id> <u8 1>
Text.mem   30 字节/记录：status(1), kind(3), (偏移+1)<<16, 长度<<16, id<<16
Text.ptr   i32 id 列表，条目数 = 记录数
Text.lst   哈希桶目录（未解，但追加记录时不需要更新它）
```

### `stats/*.dat` — 8 字节（4 字节文件是单值）

```
[今天][总计] 两个 i32
指标：itemtotal / itemmemorized / itemoutstanding / itemreps /
      topicreps / retention / Recall / burden / reptime / total /
      memorized / outstanding / topicburden / topicprioritymissed ...
```

### `info/priority.sub` / `history.sub` — i32 数组，每元素一项

```
priority.sub  = 优先级（1..5，数值越小优先级越高）
history.sub   = 评分分布
```

### `alg17/StabilityIncrease.dat` — 21³ = 9261 个 double

索引 `flat[R*441 + S*21 + D]`。`R=0, S=1` 那一行与 SM-20 的 U-factor 表**逐位相同**。

---

## 能力清单

| 能力 | 状态 |
|---|---|
| 89 个窗体还原（控件树/属性/事件签名） | ✅ |
| 集合读取（元素/树/文本/矩阵/历史/统计） | ✅ |
| 导入卡片（Q&A → 集合，原版可读） | ✅ |
| 提取 Extract（任意深度嵌套） | ✅ |
| 导出 TSV / HTML | ✅ |
| 搜索 | ✅ |
| 学习一轮（算间隔 + 写回矩阵） | ✅ |
| 工作量预测 | ⚠️ 间隔模型未校准 |
| 界面数据填充（Contents / Browser / Statistics / Options） | ✅ |
| 事件处理器实际行为 | ⚠️ 约 20 / 2001 个已实现 |
| 渐进阅读（Topic / Cloze / 阅读点） | ⚠️ 仅 Extract |
| 算法 V4 / V6 | ❌ 缺二进制，静态解不出 |
| 图片 / 音频 | ❌ |
| RTF 正文 | ❌（原版不接 CF_RTF） |

---

## 关键结论

1. **结构容易，行为极难**：DFM 是资源可 100% 提取；方法体是 23,173 个裸汇编函数。
2. **算法数值来自真实学习数据**：`FirstInterval.dat` / `ForgettingCurve.dat` 在空集合里全是 0，静态分析拿不到信息。
3. **0-based / 1-based 混用**是这套格式最大的坑：`ElementInfo +40` 是 0-based，`contents` 序号是 1-based。
4. **写集合时不需要更新 `Text.lst`**：实测原版接受只追加 rtx/mem/ptr。

---

## 许可与用途

本项目仅用于**自有软件的学习性逆向研究**。SuperMemo 是 SuperMemo World 的商标与版权作品，本仓库不包含原程序二进制。
