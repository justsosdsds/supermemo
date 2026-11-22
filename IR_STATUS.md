# 渐进阅读：当前实现与验证边界

更新：2026-11-22。本文优先于 README 和 INCREMENTAL_READING_RE 中的早期实验结论。

## 本次完成

- Text.mem 的 RTX 偏移、长度改为 +10/+14 的完整 int32，修复约 32 KB 时的溢出。文本 ID 按 mem 的一基行号分配。证据见 [TEXT_REGISTRY_EVIDENCE.md](TEXT_REGISTRY_EVIDENCE.md)。
- Extract/Cloze 可用 `--occurrence N` 指定第 N 处字面文本，或用 `--byte-offset N` 指定 UTF-8 源字节位置。重复文本未指定位置会报错；不在 HTML 标签、属性、实体或 script/style 中替换。
- Cloze 为新子元素写出含 `class=clozed` 的正文；已有子元素不再因包含同词被批量修改。该修改满足当前产品行为测试，尚未证明与原版全部传播规则一致。
- Extract/Cloze 的数据文件和 HTML 统一通过备份、journal、逐文件替换提交。普通失败回滚，进程中断后要求显式恢复。
- 发现同一个标题文本 ID 可以被多个元素共享，目前这种输入会拒绝，避免选错元素。后续界面应以元素槽位选择对象。

## 关键未完成项

原版文本注册表不是“追加 rtx/mem/ptr 即可”：Text.lst 存引用链，Text.ptr 存排序索引。现有写入 API 没有维护它们。因此默认写入会明确拒绝；只有显式 `--experimental-registry` 才生成研究用数据。

实验模式下新 mem 记录的 useCount/lstRelated 为 0，ptr 仅追加。这些文件只适合一次性副本上的研究，不能当作原版兼容产物。旧导入脚本和 Pascal 写入层尚未迁移，也不能绕过这个限制当作可用替代。

此外，模板中的未知状态字段仍被复制；contents 字段宽度、任意 HTML 选区、实体/跨标签选择、Extract 子正文范围、来源语义、阅读位置、界面及调度均未完成全面验证。Python 和 Pascal 仍存在格式解释差异。

## 验证结果

运行 `python -B -m unittest discover -s tests -v`：25 项全部通过。

覆盖：中文大文本连续追加、文本字段原版样本对照、重复关键词指定第二处、HTML 属性保护、提取后挖空、连续挖空后重新读取、保留已有子卡、dry-run 无修改、默认拒绝未验证写入、异常回滚、进程中断及恢复重试。

另复制 `C:\supermemo\systems\EXTEST_base` 和 `T2_base`，在副本上分别执行提取后挖空、第二个同名词挖空，成功生成子正文。原始目录全部文件的 SHA-256 前后相同。实验结果保留在 `_tmp/ir_validation__dm1h5wd/result.json`。

没有启动原版进行显示、答案揭示或保存重开验收。这里的“重新读取”是 Python 读取落盘文件，不代表原版界面验收通过。现有原版 EXTEST 已混合多轮操作，不能用它直接证明单次操作全部字节一致。

## 研究命令

先关闭原版；以下 collection 必须是一次性副本：

```powershell
python tools/sm_cloze.py <collection> <title_id> "second" --occurrence 2 --experimental-registry
python tools/sm_extract.py <collection> <title_id> "BBB second paragraph" --experimental-registry
python tools/sm_transaction.py check <collection>
python tools/sm_transaction.py recover <collection>
```

事务不是多个文件同时可见，也不保证断电一致性。锁仅协调本模块的提交/恢复，读取阶段不是锁定快照，且不协调原版；只支持原版关闭时单写入者操作。存在 pending journal 时应先恢复，不能打开混合状态的集合。

## 接下来的验收顺序

1. 用干净的单次原版操作样本，补齐 Text.lst 引用增删和 Text.ptr 排序规则，再解除实验模式限制。
2. 原版验证中文提取、第二处同词挖空、连续挖空、答案揭示及关闭重开。
3. 统一 Pascal 数据层，补来源导航、阅读位置，接入界面。
