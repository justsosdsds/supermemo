# Text registry：2026-11-22 核对记录

本轮只读取原版集合文件，没有运行原版、没有修改原版集合。
以下证据来自源码和离线字节读取，不是 REA 运行时 Evidence。

## 已确认的字段与修复

SuperMemoAssistant 固定版本 `82ade9699f82420532b68f78b3a51263f7e82e3d`：

- [RegMemElem17.cs](https://github.com/supermemo/SuperMemoAssistant/blob/82ade9699f82420532b68f78b3a51263f7e82e3d/src/Core/SuperMemoAssistant.Core/SuperMemo/SuperMemo17/Files/RegMemElem17.cs)
- [RegistryUpdater17.cs](https://github.com/supermemo/SuperMemoAssistant/blob/82ade9699f82420532b68f78b3a51263f7e82e3d/src/Core/SuperMemoAssistant.Core/SuperMemo/SuperMemo17/Registry/RegistryUpdater17.cs)

30 字节的 Text.mem 记录：

| 偏移 | 类型 | 含义 |
|---|---|---|
| 0 | int32 | useCount，引用次数，不是布尔 status |
| 4 | byte | linkType |
| 5 | byte | unknown1 |
| 6 | int32 | unknown2 |
| 10 | int32 | rtxOffset，一基偏移 |
| 14 | int32 | rtxLength，包括 NUL、int32 尾部编号和末尾 byte |
| 18 | int32 | lstRelated，不是文本 ID |
| 22 | int32 | slotIdOrOffset |
| 26 | int32 | slotLengthOrConceptGroup |

旧代码把 10/14/18 错当成 8/12/16 再左移 16 位，小数字碰巧产生同样字节，
大于 32767 后溢出。修复为在真实偏移写入完整 int32。
新增 encode_text_mem_record；所有打包和输入校验先完成，再修改缓冲区。

成员 ID 使用 mem 一基行号。原始 EXTEST 中 row 3 对应 RTX 尾部编号 3，
但 mem +18 是 37，明确否定“+18 是成员 ID”。追加 ID 不应从 ptr 的排列或
遗留 RTX 记录推算。

## lst / ptr 仍阻止安全的原版集合写入

EXTEST 的全部 14 个 useCount>0 的 mem 记录均可这样解释：
lstRelated 是 Text.lst 的一基节点编号；每节点 8 字节，两个 int32，
第一个与引用元素槽位对应，第二个为下一节点编号，0 为结束。
链长与 useCount 全部一致。例如：

- member 2：useCount=2，lstRelated=31，引用链槽位 `[8, 4]`。
- member 3：useCount=4，lstRelated=37，引用链槽位 `[9, 9, 3, 3]`。
- member 14：useCount=3，lstRelated=46，引用链槽位 `[11, 10, 10]`。

重复槽位说明不能简单使用“去重后的元素数”作为引用数。
Text.ptr 含成员 ID 的排列，例如 EXTEST 开头为 `[9,16,13,2,6,10,12,7]`。
其与文本排序相符，但原版的大小写、语言、重复文本排序规则尚未确认。
因此“直接追加 ptr、不维护 lst 就全面兼容”的旧结论缺少依据。

add_text 默认拒绝写入；研究代码必须显式传 `experimental=True`。
此模式只供可丢弃副本：新增 mem 以 useCount=0、lstRelated=0 表示尚未链接，
不再伪造 lstRelated=文本 ID；ptr 仍只追加，**不声称原版索引兼容**。
将这样的记录用于元素后，仍需维护引用链和排序索引，才能作为正式原版写入器。

未来需补：独立的单次新增/删除/重用/共享文本样本，验证 lst 链的更新，
以及中文、大小写和同名文本的 ptr 排序，然后扩展写入 API 以包含 lst。

## 样本身份

读取路径：`C:/supermemo/systems/<集合名>/registry/Text.<后缀>`。

| 集合 / 文件 | 字节 | SHA-256 |
|---|---:|---|
| EXTEST_base / mem |150|a335f42b172dc29f040cff4a5f10af2a9ad6f75efb4748daad6680739d1ada38|
| EXTEST_base / rtx |2167|c567ced3204e7ad39530bd3e945b14881ad3aa5ca300ab11c05366617052a30e|
| EXTEST_base / ptr |16|c1c833e5114c119dc8622b06d448a2910cee198828fec8e0caf10d4f1f157838|
| EXTEST_base / lst |88|23163ecb70655ce6bd5360ae5f69c6b95ea69aca04c06029b13b0e9d0730ed14|
| EXTEST / mem |480|d7fdec24769425edee0ca3af288390d22ab59db3c6dbfa45e06e3788295b634a|
| EXTEST / rtx |3192|8b01c31a87649f7c9d3fb37a5ba529a3ccd021220286cb3999578647e4f1ab35|
| EXTEST / ptr |60|3f72cff4e7846b5fb06a3362d4ca41d987fe2039b3bd7bf30f2acf963549cfba|
| EXTEST / lst |376|137b7f1fc334a6739d4f60dcda13036055e1026152417c7dd3220b76a94f59b5|

## 验证

`python -B -m unittest discover -s tests -p test_text_registry.py -v`

7 项通过：原始 mem 字节夹具、跨 32KB/64KB 的偏移、连续大段中文追加、
mem 行号 ID、默认拒绝无副作用、非法输入不部分写入、引用计数/链指针一致性。
这些测试证明字段编码及研究模式行为，不等同于原版打开/保存验证。
