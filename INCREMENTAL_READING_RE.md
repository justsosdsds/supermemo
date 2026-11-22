> **2026-11-22 校正：本文保留早期实验记录，其中格式与“原版兼容”结论有误。当前状态、使用边界与验证结果见 [IR_STATUS.md](IR_STATUS.md)，文本池字段以新的证据记录为准。不要依据下面的旧格式表直接写正式集合。

# SuperMemo 19 渐进阅读（Incremental Reading）逆向结果

本文档基于以下证据整理：

- `SuperMemo19_payload.exe`（13,166,592 字节）的 ASCII / UTF-16 字符串表
- 真实集合 `run\systems\ABC of SuperMemo 19` 的数据文件
- 89 个窗体的 DFM 结构（`sm19src\units\u*.lfm`）

---

## 1. 元素类型系统

元素由 `info\ElementInfo.dat` 的 `+0`（flags）和 `+1`（kind）两个字节共同决定。

实测分布（8 个元素）：

| flags | kind | 数量 | 元素 id | 判定 |
|---|---|---|---|---|
| `0x04` | 2 | 1 | 1 | **Topic**（阅读材料，根节点） |
| `0x01` | 1 | 7 | 2,3,4,6,8,9,10 | **Item**（问答卡，子节点） |

与 `stats\` 的统计交叉验证：

```
itemtotal.dat    = [3, 5]    今天 3 个 item，累计 5 个
total.dat        = [1, 6]    今天 1 个元素，累计 6 个
topicreps.dat    = [4]       Topic 复习 4 次
```

即：**kind = 1 → Item，kind = 2 → Topic**；`flags` 的 bit0 表示"是某个父元素的子节点"，bit2（0x04）出现在作为集合根的 Topic 上。

> 注意：渐进阅读的前提是 Topic 与 Item 分离。我们此前的导入器把新卡片一律写成 `kind=1`（Item），这对问答卡是对的，但**无法创建新的 Topic**。

---

## 2. 优先级系统

### 2.1 优先级存储

```
info\priority.sub    20 字节 = 5 个 int32
内容： [5, 4, 3, 2, 1]
```

这是**按元素顺序排列的优先级数组**（1–5，数值越小优先级越高，与 SuperMemo 惯例一致）。

配套的 `history.sub`（20 字节）是评分分布 `[5,3,4,2,1]`，两者格式相同（每元素一个 int32），区别只在语义。

### 2.2 优先级 → 遗忘指数（核心公式）

从 exe 字符串表提取到的公式标签：

```
,    FI=Exp(A*Priority+B)
```

即**遗忘指数（Forgetting Index）由优先级指数映射**：

```
FI = Exp(A * Priority + B)
```

这是渐进阅读的调节旋钮：优先级越高（数值越小）→ FI 越低 → 复习更频繁 → 间隔更短。

配套参数（同批字符串）：

```
Topic priority protection
Item priority protection
topicprioritymissed      (统计文件)
itemprioritymissed       (统计文件)
Cannot compute decline priority
Cannot compute deadline priority
```

`prioritymissed` 两个文件的实测值都是 `[10000000, 10000000]`，这个 10,000,000 是一个**哨兵值**（表示尚未计算/无超期），也解释了为什么之前读到的数字这么奇怪。

### 2.3 优先级相关窗体（DFM 已确认存在）

| 窗体 | 用途 |
|---|---|
| `TPriorityDlg` | 单元素优先级编辑 |
| `TSpreadPrioritiesDlg` | 批量分配优先级 |
| `TPostponeDlg` | 推迟（重新排期） |
| `TElementFilter` | 按属性筛元素（优先级、间隔、类型） |

---

## 3. Topic 专属参数

从字符串表提取（全部是面向用户的选项名）：

```
TopicDelay
Topic max interval
Topic min interval
Topic workload
Topic burden
Topic load
Topic overload
Topics only
Topics and tasks
Topic delay
Topic priority protection
```

对应的统计文件（`stats\` 目录）：

| 文件 | 实测值 | 含义 |
|---|---|---|
| `topicburden.dat` | `[0, 0]` | Topic 学习负担 |
| `topicreps.dat` | `[4]` | Topic 复习次数 |
| `topicprioritymissed.dat` | `[10000000, 10000000]` | Topic 优先级超期 |
| `topicload.dat` | （按需创建） | Topic 负载 |
| `topic overload.dat` | （按需创建） | Topic 超载 |
| `otopic.dat` | （按需创建） | 待学 Topic |
| `topicmemorized.dat` | （按需创建） | 已记住 Topic |

**结论**：Topic 有独立的调度参数（min/max interval、delay），不套用 Item 的间隔规则。这与 SuperMemo 的设计一致 —— Topic 是"读的"，Item 是"背的"。

---

## 4. 增量阅读的核心动作

### 4.1 Extract（提取）

字符串证据：

```
ExtractItem
Extract
ExtractPair
cnExtracted          ← Contents 窗口的列名
ExtractToString / ExtractToStream / ExtractToBytes（RTL，非业务）
TopicDelay
```

**`cnExtracted` 是 Contents 窗口的一列**，说明原版在内容树里直接标记"哪些元素是提取出来的"。

数据层面，提取 = 在 `contents.dat` 里创建 `parent = 指定元素` 的子记录。这部分格式我们已完全解出（`+1` parent、`+5` first child、`+9` last child、`+13` prev、`+17` next、`+21` child count）。

**已实现**：`tools\sm_extract.py` 能按指定父节点创建子元素，三级嵌套已验证，原版可正常打开。

### 4.2 事后遗忘处理（post-lapse）

字符串证据：

```
Cannot compute post-lapse forgetting curve decay
Zero lapses for post-lapse interval
Cannot read the lapse interval matrix
```

**遗忘（lapse）后走独立的间隔矩阵**，与正常复习的 `StabilityIncrease.dat` 分开。这张矩阵我们尚未定位到文件（可能是 `alg17\` 下的某个表，或内嵌在 `ForgettingCurve.dat`）。

### 4.3 遗忘曲线

```
\ForgettingCurve.dat
Cannot read the first forgetting curve data
Cannot compute forgetting curve decay
Cannot compute stability from forgetting curve decay
Cannot compute the optimum interval
Opt.Interval=
\stats\ForgettingCurve.csv
First forgetting curve collected with Algorithm SM-17
Interval, Recall, Pass grades, Repetitions
```

`ForgettingCurve.dat` 实测 **288 字节 = 72 个 int32，全为 0**（集合从未真正学过）。

从 CSV 导出格式反推，它的结构是：

```
Interval, Recall, Pass grades, Repetitions
```

即每条曲线记录 = `(间隔, 召回率, 通过评分, 重复次数)` 四元组。

### 4.4 首间隔

```
\FirstInterval.dat
Interval [days]
First Interval
```

`FirstInterval.dat` 实测 **127,008 字节 = 15,876 个 double = 21×21×36**，布局与 `StabilityIncrease.dat` 相同，但**全为 0**。

它由学习行为填充，不存在于空集合。

---

## 5. 完整数据文件清单

### 渐进阅读直接相关

| 路径 | 格式 | 状态 |
|---|---|---|
| `info\ElementInfo.dat` | 118 字节/记录，kind 见 §1 | ✅ 已解 |
| `info\contents.dat` | 37 字节/记录，树结构 | ✅ 已解 |
| `info\priority.sub` | int32 数组，优先级 | ✅ 已解 |
| `info\history.sub` | int32 数组，评分分布 | ✅ 已解 |
| `info\RepetitionHistory.dat` | 39 字节/记录 | ✅ 已解 |
| `info\sm8opt.dat` | 18,876 字节，选项参数 | ⚠️ 部分定位 |
| `alg17\FirstInterval.dat` | 15,876 double | ⚠️ 格式已知，全 0 |
| `alg17\ForgettingCurve.dat` | 72 int32 | ⚠️ 格式已知，全 0 |
| `alg17\StabilityIncrease.dat` | 74,088 字节 = 21³ | ✅ 已解（含 SM-20 U-factor） |

### Topic 专项统计

`stats\` 下 8 个字节的 `[今天][总计]` 结构：`topicburden`、`topicreps`、`topicprioritymissed`、`topicload`、`otopic`、`topicmemorized`、`topic overload`、`itemtotal`、`itemmemorized`、`itemoutstanding`、`itemreps`、`itemprioritymissed`、`total`、`memorized`、`outstanding`、`retention`、`Recall`、`burden`、`reptime`。

---

## 6. 我们已实现 / 未实现

| 能力 | 状态 | 说明 |
|---|---|---|
| 读元素类型（Topic/Item） | ✅ | `flags` / `kind` 语义已确认 |
| 读内容树（任意深度） | ✅ | `smcli tree` 输出带缩进 |
| **Extract 提取** | ✅ | `tools\sm_extract.py`，三级嵌套验证 |
| 读优先级数组 | ⚠️ | 文件格式已知，未接入代码 |
| 读 Topic 统计 | ✅ | `smstats.exe` 输出 12 指标 |
| 创建 Topic 元素 | ❌ | 导入器只写 `kind=1` |
| Cloze 填空 | ❌ | 未找到专门的实现入口 |
| 阅读点（read point） | ❌ | 未定位到字段 |
| 优先级 → FI → 间隔 | ❌ | 公式已知（`FI=Exp(A*Priority+B)`），A/B 未取到 |
| 事后遗忘（post-lapse） | ❌ | 矩阵未定位 |
| 遗忘曲线 / 首间隔 | ❌ | 文件格式已知，但集合里全 0 |

---

## 7. 下一步的技术路径

1. **取 A / B 系数**：`FI=Exp(A*Priority+B)` 的 A、B 是常量还是运行期计算，需要看 `Cannot compute forgetting curve decay` 附近的代码路径。可行手段：改优先级 → 观察 `fi.dat` 变化（差异法）。
2. **创建 Topic**：把导入器的 `kind` 从 1 改成 2、`flags` 保持 `0x01`，验证原版是否把它当 Topic 处理。
3. **优先级写入**：`priority.sub` 是纯 int32 数组，直接改值即可，比 `sm8opt.dat` 简单得多，是打通"优先级 → 调度"的最短路径。
4. **让集合产生真实学习数据**：`FirstInterval.dat` / `ForgettingCurve.dat` 全 0 是当前所有数值校准的瓶颈。需要让原版真正学若干张卡并跨越天级间隔。
