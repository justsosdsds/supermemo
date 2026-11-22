# Android 版 SuperMemo —— M0 技术设计

> 目标：把 Windows 版 SuperMemo 19 的**核心学习能力**重做成一个现代 Android 应用。
> 不复刻界面、不转换 Delphi 代码、不读写原版集合格式。
> 逆向工程目录（`sm19src/`、`sm19alg/`、`tools/`）只作为功能与数据关系的参考。

## 1. 与逆向工程的关系

| 保留 | 用途 |
|---|---|
| `sm19src/` `sm19alg/` `tools/` | 逆向研究，不影响 Android 工程 |
| `INCREMENTAL_READING_RE.md` `IR_STATUS.md` | 功能设计参考（Extract/Cloze/优先级语义） |

**明确不做**：

- 不把 Pascal/Delphi 代码翻译成 Kotlin
- 不读写 SuperMemo 19 的 `.Kno` / `info/*.dat` / `registry/Text.*`
- 不打包或分发原版二进制
- 不把逆向得出的格式结论当作「已验证兼容」——那套格式里有多个字段（`AF[6]`、`ordinal[5]`、`Text.ptr` 排序）仍未解

Android 应用使用**自己的 Room 数据库**。

## 2. 技术栈（版本取自本机 Gradle 缓存，保证离线可构建）

| 组件 | 版本 | 依据 |
|---|---|---|
| JDK | 21 | 本机已装 |
| Gradle | 8.13 | 本机缓存有 `gradle-8.13-bin` |
| AGP | 8.13.2 | 缓存有 8.13.2 |
| Kotlin | 2.2.21 | 缓存有 2.2.21（2.4.x 也可，选稳定的） |
| Compose BOM | 2026.08.00 | 缓存有 |
| Room | 2.8.4 | 缓存有 |
| activity-compose | 1.13.0 | 缓存有 |
| compileSdk / targetSdk | 36 | `platforms/android-36` 已装 |
| minSdk | 26 | 覆盖绝大多数在用设备，且 Compose 要求 ≥21 |
| build-tools | 36.0.0 | 已装 |

## 3. 数据模型

### 3.1 核心思路：一张 `elements` 表 + 类型字段

原版用一个元素数组 + `contents.dat` 链表表达层级。Android 侧用**单表 + 自引用外键**，简单且便于查询。

```
elements
  id            Long PK autoincrement
  type          TEXT   "topic" | "item"
  parentId      Long?  指向父元素（根为 null）
  rootId        Long   所属文章的根元素 id（便于整棵树查询）
  title         TEXT   列表显示用的首行摘要
  body          TEXT   正文（Topic 的完整内容 / Item 的问题文本）
  answer        TEXT?  仅 item 用：Cloze 的答案；普通填空卡为 null
  sourceFrom    Int?   Cloze 在父正文中的起始 offset
  sourceTo      Int?   Cloze 在父正文中的结束 offset
  createdAt     Long
  sortKey       Int    同级排序
```

**为什么不用 Article + Topic + Item 三张表**：文章本身就是一个 Topic（根元素）。三张表会带来大量 JOIN 与迁移负担，而单表加 `type` 已能表达全部关系。

### 3.2 阅读位置

```
reading_positions
  elementId   Long PK  外键 elements.id
  offset      Int      正文中的字符偏移（不是像素滚动量）
  updatedAt   Long
```

**为什么存字符偏移而不是滚动像素**：字号、屏幕宽度变化后像素值失效；字符偏移在任何设备上都指向同一段文字。

### 3.3 复习调度（FSRS）

```
review_states
  elementId     Long PK
  stability     REAL     S，记忆稳定度（天）
  difficulty    REAL     D，难度（0..1）
  dueAt         Long     到期时间
  lastReviewAt  Long?
  reps          Int      复习次数
  lapses        Int      遗忘次数
  state         TEXT     "new" | "learning" | "review" | "relearning"

review_logs
  id            Long PK
  elementId     Long
  rating        Int      1=Again 2=Hard 3=Good 4=Easy
  reviewedAt    Long
  previousS     REAL    复习前的 S
  previousD     REAL
  nextS         REAL    复习后的 S
  nextD         REAL
  nextDueAt     Long
```

日志保存**前后状态**，用于回溯与算法一致性测试。

### 3.4 来源关系

`elements.parentId` 已表达父子。额外需要「这个 Cloze 是从父正文哪一段挖出来的」：

- `sourceFrom` / `sourceTo` 记录在**父元素正文中的字符区间**
- 这样点击「来源」可以直接滚到父文章对应位置

## 4. 文本选区方案

这是 M2 的关键风险。两条路线：

| 方案 | 优点 | 风险 |
|---|---|---|
| **Compose `SelectionContainer` + `TextField`** | 纯 Compose，能拿到 `TextRange` | 长文本性能；`SelectionContainer` 在只读文本上取选区能力有限 |
| **WebView + JS bridge** | 选区、滚动、锚点都成熟 | 需要 WebView 与 JS 交互，字体与主题要额外处理 |

**决策：M1 先用 `TextField`（只读）+ `SelectionContainer` 做原型**，M2 开始时用一段 5000 字中文文章实测：

- 能否稳定取到 `TextRange`
- 跨段落选择是否返回正确的起止
- 拖选长文本是否卡顿

若不能满足，切 WebView（保留同一套 `SelectionProvider` 接口，UI 层可替换）。

## 5. 模块结构

```
mobile/
  settings.gradle.kts
  build.gradle.kts
  gradle.properties
  gradle/libs.versions.toml        版本目录
  app/
    build.gradle.kts
    src/main/AndroidManifest.xml
    src/main/java/com/smreader/
      SmApp.kt                      Application，持有 DB 与 Repository
      data/
        db/
          AppDatabase.kt
          ElementDao.kt
          ReadingPositionDao.kt
          ReviewDao.kt
          Converters.kt
        model/
          Element.kt  ElementType.kt
          ReadingPosition.kt
          ReviewState.kt  ReviewLog.kt
        repo/
          ArticleRepository.kt      文章 CRUD、导入
          ReviewRepository.kt       复习流程
      domain/
        fsrs/
          Fsrs.kt                   FSRS 算法（纯函数，可单测）
          FsrsParams.kt
          Rating.kt
      ui/
        theme/  Color.kt Theme.kt Type.kt
        nav/    AppNav.kt
        home/   HomeScreen.kt HomeViewModel.kt
        list/   ArticleListScreen.kt ArticleListViewModel.kt
        import_/ ImportScreen.kt ImportViewModel.kt
        reader/ ReaderScreen.kt ReaderViewModel.kt
    src/test/java/com/smreader/   JVM 单测（FSRS、解析、DAO 用 Room in-memory）
    src/androidTest/java/com/smreader/  仪器测试（可选）
```

**不引入 Hilt**：首版依赖注入用简单的手写容器（`SmApp` 持有单例），减少构建复杂度与版本冲突。

## 6. 分阶段任务

### M0（本次）架构与规范
- [x] 环境勘察：Android SDK / AGP / Kotlin / Compose / Room 版本
- [x] 数据模型设计
- [x] 选区方案与降级路线
- [x] 模块结构
- [x] 本文件

### M1（本次）可运行基础版
- [ ] Gradle 工程可构建
- [ ] Room 数据库（elements / reading_positions）
- [ ] 导入：粘贴文本 + TXT 文件
- [ ] 文章列表
- [ ] 阅读页（滚动 + 阅读位置保存 + 恢复）
- [ ] 至少 3 个单测（DAO 往返、阅读位置保存、导入解析）
- [ ] Debug APK

### M2 Extract
- [ ] 可靠的中文选区
- [ ] 选区 → 子 Topic，记录 `sourceFrom/sourceTo`
- [ ] 来源跳转
- [ ] 重复词/跨段/HTML 特殊内容的明确处理

### M3 Cloze
- [ ] 选词 → Item，父正文不改动（用 `sourceFrom/sourceTo` 定位，不替换原文）
- [ ] 问题/答案展示
- [ ] 卡片编辑

### M4 复习
- [ ] FSRS 实现 + 官方测试向量
- [ ] 四档评分、队列、到期计算
- [ ] 复习日志

### M5 闭环
- [ ] 阅读→提取→挖空→复习一体
- [ ] 关闭重开、异常恢复
- [ ] 本地备份导出/恢复

### M6 测试与交付
- [ ] 单测 + 迁移测试 + UI 测试
- [ ] Debug APK + 安装说明 + 测试报告

## 7. 关键设计决策记录

| 决策 | 理由 |
|---|---|
| 单表 `elements` 而非多表 | 层级用 `parentId` 足够；少 JOIN、少迁移 |
| 阅读位置存字符偏移 | 屏幕尺寸变化后仍有效 |
| Cloze 不改父正文，只记区间 | 避免「改一处破坏另一处」，这是 Windows 版反复出问题的地方 |
| 不引入 Hilt | 首版减少依赖冲突；手写容器足够 |
| FSRS 做成纯函数 | 便于用官方测试向量验证，不依赖数据库 |
| minSdk 26 | 覆盖主流设备，Compose 与 Room 均支持 |
| 先用 Compose 选区，失败再切 WebView | 保留接口，UI 可替换 |
