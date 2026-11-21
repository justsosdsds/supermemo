# sm19alg — SM-20 算法（Pascal）+ SM-19 集合读取 + 调度引擎

把 `sm20-re` 解出的 SuperMemo 20 间隔重复算法移植成 Object Pascal，并与从
SuperMemo 19 二进制里逆出的集合结构打通，形成可编译、可运行的调度引擎。

## 三个单元

| 文件 | 作用 |
|---|---|
| `sm20alg.pas` | SM-20 算法本体：DSR 模型、V2/V4/V6 三版公式、21³ 矩阵、3×3×3 贝叶斯平滑、索引换算、取整钳制、U-factor 表 |
| `smcollection.pas` | SuperMemo 集合读取器：读 `alg17/*.dat` 矩阵与 `registry/*.rtx` 文本池，支持回写 |
| `smengine.pas` | 调度引擎：把卡片状态 + 真实矩阵 → 下次复习间隔，并回写观测 |

## 集合格式（实测，非公开文档）

SuperMemo 的 `.Kno` **不是单文件**，是「索引文件 + 同名目录」：

```
<name>.Kno                    索引/元数据（int32 字段）
<name>/collection.ini         INI 设置
<name>/info/*.dat             元素与组件记录
<name>/info/sm8opt.dat        SM-8 优化数据（18876 字节）
<name>/alg17/*.dat            算法矩阵   <-- 关键
<name>/registry/<R>.*         文本池 .rtx/.lst/.ptr/.mem
<name>/stats/*.dat            计数器
```

### 算法矩阵（全部小端）

| 文件 | 结构 | 字节数 |
|---|---|---|
| `StabilityIncrease.dat` | 21×21×21 double | 74,088 |
| `StabilityIncreaseCases.dat` | 21×21×21 int32 | 37,044 |
| `Recall.dat` / `RecallCases.dat` | 21×21×21 int32 | 37,044 |
| `FirstInterval.dat` | 21×21×36 double | 127,008 |
| `ForgettingCurve.dat` | 36 double | 288 |
| `DifficultyDistribution.dat` | 20 int32 | 80 |

索引公式 `flat[R*441 + S*21 + D]`，与 `sm20-re` 从 sm20.exe 内存里挖出的布局完全一致。

### 文本池

`registry/<Res>.rtx`：`<UTF-8 字符串> NUL <int32 a> <byte b>`，记录首尾相接。
`.lst` 是 int32 索引表，`.ptr` 是 int32 指针表，`.mem` 是槽位表。

## 验证

`algotest.exe` —— Pascal 移植 vs Python 参考实现对拍：

| 项 | Python | Pascal | 差 |
|---|---|---|---|
| V4 公式 | 6.020000 | 6.020000 | 0 |
| V6 公式 | 1.406126 | 1.406126 | 0 |
| V2 @ rep=1 | 3.488355 | 3.488366 | 1.1e-5 |

`algodemo.exe` —— 端到端：读真实集合矩阵 → 卡片状态 → 调度决策。

```
matrix loaded: 9261 cells
U-factor row probes (R=0):
  S=1 D=0..4 : 13.822076 8.212571 6.056511 4.879609 4.126662   <- 与 SM-20 U-factor 表一致
  S=0 D=0..4 : 14.244807 8.463742 6.241743 5.028846 4.252871
card: stability=12.40  difficulty=0.32  rep=5  interval=12.40  R=0.87
cell [R=4,S=2,D=6]  U-factor=2.8756  ->  next interval 35.66 days  (source=matrix)
```

## 重要发现

1. **SM-19 与 SM-20 同源**：SM-19 的 `StabilityIncrease.dat` 中 R=0/S=1 行与
   sm20-re 提取的 SM-20 U-factor 表**逐位一致**（13.822076, 8.212571, …）。
2. SM-19 的 S=0 行 = S=1 行 × 1.030584（固定比例）。
3. 之前在 `sm19.exe` 里搜不到这些常量，是因为**数据在外部集合文件里，不在 exe 里**。
4. V4/V6 只有公式，7 参数到 DSR 的映射在原项目里仍标为未解，所以只有 V2 链路可完整运行。

## 编译

```powershell
C:\lazarus\lazbuild.exe --build-all algotest.lpi     # 算法对拍
C:\lazarus\lazbuild.exe --build-all algodemo.lpi     # 端到端调度
```

`algodemo` 的集合路径为 `F:\SMCollections\ABC`（纯 ASCII 路径，避免 FPC 字符串编码问题）。
