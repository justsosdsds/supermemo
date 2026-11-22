> **2026-11-22 校正：本文保留早期实验记录，其中格式与“原版兼容”结论有误。当前状态、使用边界与验证结果见 [IR_STATUS.md](IR_STATUS.md)，文本池字段以新的证据记录为准。不要依据下面的旧格式表直接写正式集合。

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

---

---

# 渐进阅读：当前实现状态

> 更新 2026-11-22。本节优先于上面的早期实验结论。
> 详细边界见 [IR_STATUS.md](IR_STATUS.md) 与 [TEXT_REGISTRY_EVIDENCE.md](TEXT_REGISTRY_EVIDENCE.md)。

## 目标

重建版程序能完整跑通渐进阅读：导入中文多段文章 → 选中段落提取为子元素 →
关键词做成 Cloze Item → 查看来源关系并跳转 → 保存阅读位置 → 关闭重开后内容与关系正确。

## 十阶段进度

| 阶段 | 状态 | 证据 |
|---|---|---|
| A 用 SMA 定义校正格式 | 完成 | 6 个字段纠错，11 个元素交叉验证 |
| B 组件块结构 | 完成 | length = 50+N×31，几何与 registryId 正确 |
| C Extract / Cloze 写入 | **部分** | 元素/组件/contents/lst 链正确，**Text.ptr 排序未完全解出** |
| D 来源导航 | 完成 | origin / extracts 与原版层级一致 |
| E 阅读位置 | 未开始 | — |
| F 原子写入与恢复 | 完成 | 备份 + journal + 逐文件替换 |
| G 界面整合 | 未开始 | 目前只有 Python 脚本 |
| H 多场景回归 | 阻塞 | T1–T4 集合已备，原版操作未落盘 |
| I 端到端验收 | 未开始 | 从未让原版打开过脚本生成的集合 |
| J 图片 / 音频 | 未开始 | SMA 有 ComponentImage/Sound/Video 可参考 |

## 已确认的格式（依据 SMA 2.1 定义 + 实测）

### 元素记录 info/ElementInfo.dat（118 字节）

依据 InfElementsElem17（SMA, Size=118）：

| 偏移 | 字段 | 说明 |
|---|---|---|
| +0 | elementType | 0=Topic, 1=Item, 4=Concept |
| +1 | unknownbyte1 | 子元素恒为 0x01 |
| +2 | titleTextId | int |
| +6 | componPos | int，-1 表示无组件 |
| +10 | unknownId | 0x00010059(Topic) / 0x00010070(Item)，**不是块大小** |
| +28 | AF[6] | A-Factor，编码未解 |
| +61 | templateId | |
| +65 | conceptId | |
| +103 | ordinal[5] | 5 字节，编码未解 |

**空槽判定**：	itleTextId == -1。
早期把 +1 当类型、把 -1 的低 2 字节当 id，读成「kind=3 / id=65535」，是错的。

**块大小不在元素里**，而在组件块自身的 +2 处。

### 组件块 info/compon.dat

`
+0   31 D4          组标记
+2   uint16 length  数据长度，块实际占用 = 4 + length
+4   int dummy      低字节 = 一基槽位号
+8   byte compCount
+9   uint16 skip     实测恒为 43
+11  保留区（43 字节）
+54  组件[0]        每个 31 字节
+85  组件[1]        仅 cloze 有

length = 50 + N*31      N=1 -> 81,  N=2 -> 112
`

组件 = 2 字节类型头 + 29 字节 HTML17：

`
类型头 0x1C0D=HTML 0x2200=Text 0x1D0C=Rtf 0x2201=Spelling
      0x1902=Image 0x3003=Sound 0x1F04=Video
HTML17: left@1 top@3 width@5 height@7 displayAt@9 isFullHtml@15 registryId@18
`

几何（实测 8/11 元素一致）：

`
单组件      left=100 top=200  w=9700 h=9300  displayAt=255
cloze 问题  left=100 top=57   w=9701 h=7848  displayAt=255
cloze 答案  left=100 top=7961 w=4989 h=1495  displayAt=223
            问题区底边 7905，答案区顶边 7961，间隙 56
`

### 文本注册表 
egistry/Text.*

Text.mem 30 字节（依据 RegMemElem17）：

| 偏移 | 字段 |
|---|---|
| +0 | useCount（引用次数） |
| +4 | linkType（内联文本为 3） |
| +10 | rtxOffset（一基） |
| +14 | rtxLength |
| +18 | lstRelated（Text.lst 链起始节点，**不是文本 ID**） |

**文本 ID = mem 的一基行号。**

Text.lst 每节点 8 字节：(引用元素槽位, 下一节点)，链长 == useCount，
同一元素可在链中重复出现（实测 member 3 → [9,9,3,3]）。

Text.ptr 存成员排列，**排序规则只解出一半**：
整体按文本字节升序，但原版把「无标记文本」排在「含 [...] / [.] 标记的文本」之前，
与纯字节序相反。当前实现按字节序插入，**不声称与原版一致**。

### contents.dat

+1 parent、+5 first、+9 last、+13 prev、+17 next、
+21 **DescendantCount（子孙总数，不是直接子数）**。
行号对应 ElementInfo 的槽位顺序。

## 工具

| 脚本 | 用途 |
|---|---|
| 	ools/smwrite.py | 集合写入层（官方偏移 + 原子写入 + 组件块） |
| 	ools/sm_textreg.py | 文本注册表（rtx/mem/lst/ptr），含链校验 |
| 	ools/sm_compblock.py | 组件块解析与构建 |
| 	ools/sm_extract.py | 提取段落为子 Topic |
| 	ools/sm_cloze.py | 关键词挖空为 Item，支持 --occurrence N |
| 	ools/sm_nav.py | 来源导航（origin / children / extracts / tree） |
| 	ools/sm_transaction.py | 备份 / journal / 检查 / 恢复 |
| 	ools/sm_selection.py | 选区定位（避开标签、属性、实体、script） |
| 	ools/compare_collections.py | 逐字段比较（60+ 检查项） |
| 	ools/diff_component.py | 组件块逐字节差异 |
| 	ools/setup_tests.py | 生成 T1/T1b/T2/T3/T4 测试集合与快照 |
| 	ools/watch_tests.py | 实时监视原版是否真的写入 |

测试：python -B -m unittest discover -s tests → **25 项通过**

## 明确未完成

1. **原版界面验收**：从未让原版打开脚本生成的集合并验证显示、答案揭示、关闭重开
2. **Text.ptr 排序规则**
3. **AF[6] / ordinal[5] / +10 unknownId 编码**（目前原样复制模板）
4. **界面整合**：重建版 Pascal 未接任何入口
5. **阅读位置**
6. **多场景回归**：T1–T4 的原版操作未成功落盘

## 关于 Ghidra

投入约 4 小时（下载、修损坏 jar、装 JDK 25、调堆到 12G），产出是确认标记为硬编码、
找到一个 4 行的 class 规范化函数。**真正的突破来自 SuperMemoAssistant 的 C# 定义**
（8 种组件的精确字节布局、元素字段名、lst 链语义）。
Ghidra 适合后续攻算法常数，不适合快速定位界面行为。
