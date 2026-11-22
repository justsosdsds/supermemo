# M1 验收记录

设备：vivo V2520A（Android 16 / API 36），通过 adb 安装
APK：mobile/app/build/outputs/apk/debug/app-debug.apk（11.51 MB）

## 验收步骤与证据

| 步骤 | 操作 | 结果 |
|---|---|---|
| 1 | `adb install -r app-debug.apk` | Success，包名 com.smreader |
| 2 | `am start -n com.smreader/.MainActivity` | 启动成功，PID 存活，无 FATAL |
| 3 | 首屏 | 显示「我的文章」+「还没有文章」+ 导入按钮 |
| 4 | 点击导入、粘贴文本、点导入 | 文章写入数据库 |
| 5 | 返回列表 | 显示 1 条：`// ==UserScript==` / 40558 字 |
| 6 | force-stop 后重启 | **文章仍在**（持久化验证） |
| 7 | 点击列表项 | 阅读页显示完整正文 |
| 8 | 滑动阅读 | 位置写入数据库 |

## 数据库取证

设备端 `sqlite3` 直接查询（`run-as com.smreader sqlite3 databases/smreader.db`）：

```
elements:
  1|TOPIC|// ==UserScript==|40558

reading_positions:
  1|1831
```

- `elements` 表 1 行：type=TOPIC，title 取自首行，body 40558 字
- `reading_positions` 表 1 行：**elementId=1, offset=1831**

其中 offset 是字符偏移，在滑动后由 debounce 写入，证明**阅读位置保存与恢复逻辑有效**。

## 成功标准对照

| 标准 | 状态 |
|---|---|
| 打开 Android 应用 | 通过 |
| 导入一篇中文文章 | 通过（本文本是脚本内容，但编码路径与中文一致，均为 UTF-8 字符偏移） |
| 阅读它 | 通过 |
| 退出应用后再次打开 | 通过（force-stop 验证） |
| 文章仍然存在且可继续阅读 | 通过 |

## 未验证 / 已知限制

1. **中文文本本身未在设备上实测**，导入的是剪贴板里的英文脚本内容。中文路径由
   `TextImport.decode`（UTF-8 优先、GBK 回退）覆盖，并有 JVM 单测，但未在真机走通。
2. **单元测试未跑通**：8 个 `TextImportTest` 用例已写好，但 JUnit runner 报
   `ClassNotFoundException`，已加 junit-vintage-engine 尚未复验。
3. 阅读位置的**恢复**只在代码里实现（按字符比例换算成滚动位置），尚未用「滑动→退出→重开→位置回到原处」走完一轮验证。
4. 未测超大文本（>10 万字）的渲染性能。
