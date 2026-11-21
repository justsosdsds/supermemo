"""Emit the reconstruction report (R1 deliverable) as Markdown."""
import json, glob, os, collections, datetime, hashlib

BASE = r'F:\Projects\逆向'
MANIFEST = os.path.join(BASE, 'sm19src', 'manifest.json')
DFM_SRC = os.path.join(BASE, 'work', 'dfm_json')
OUT = os.path.join(BASE, 'sm19src', 'REPORT.md')

man = json.load(open(MANIFEST, encoding='utf-8'))
classes = collections.Counter()
props = collections.Counter()
events = collections.Counter()
nodes = 0
for fn in glob.glob(os.path.join(DFM_SRC, '*.json')):
    root = json.load(open(fn, encoding='utf-8'))

    def walk(n):
        global nodes
        nodes += 1
        classes[n['cls']] += 1
        for k, (t, v) in n['props']:
            props[k] += 1
            if k.startswith('On') and t == 'ident' and v != 'nil':
                events[k] += 1
        for c in n['children']:
            walk(c)
    walk(root)

payload = os.path.join(BASE, 'extracted', 'SuperMemo19_payload.exe')
psize = os.path.getsize(payload)
psha = hashlib.sha256(open(payload, 'rb').read()).hexdigest()

L = []
w = L.append
w('# SuperMemo 19 逆向还原报告（R1 静态还原 / R2 骨架工程）')
w('')
w('生成时间：%s' % datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
w('')
w('## 1. 目标链')
w('')
w('| 阶段 | 对象 | 说明 |')
w('| --- | --- | --- |')
w('| 原始目标 | `G:\\SuperMemo19_Unlocked_Setup.exe` | 18,754,048 字节，Inno Setup 5.5.7 安装包（`SuperMemo Setup`），结构被修改导致 `innoextract` 拒收 |')
w('| 内层主程序 | `extracted\\SuperMemo19_payload.exe` | %d 字节，SHA-256 `%s` |' % (psize, psha))
w('| 编译器特征 | Delphi / Embarcadero（VCL） | PE32 i386 GUI，11 段 `.text/.itext/.data/.bss/.idata/.didata/.edata/.tls/.rdata/.reloc/.rsrc`，入口 `0x007fa38c`（`.itext`），无壳无虚拟化 |')
w('| 编译时间戳 | 2023-10-07 12:51:48 UTC | PE TimeDateStamp |')
w('| 原始文件名 | `sm19.exe` | 程序中硬编码 |')
w('')
w('## 2. 资源与代码规模')
w('')
w('| 项目 | 数值 |')
w('| --- | --- |')
w('| DFM 窗体资源（`TPF0`） | **89** |')
w('| 资源叶子总数 | 315（含 92 RCDATA、84 BITMAP、51 STRING、39 自定义类型、21 CURSOR、4 ICON 等） |')
w('| 组件对象总数 | %d |' % nodes)
w('| 组件类（distinct） | %d |' % len(classes))
w('| 事件绑定总数 | %d（%d 种事件） |' % (sum(events.values()), len(events)))
w('| 属性名（distinct） | %d |' % len(props))
w('| 导入 DLL | 20（user32 228、kernel32 158、gdi32 125、ole32 45、comctl32 37、wininet 22、msvcrt 20、oleaut32 18、advapi32 18 …） |')
w('| .NET 迹象 | 无 `mscoree` 导入；尾部存在 `BSJB` 元数据签名（内嵌资源，非主程序运行时） |')
w('')
w('## 3. 窗体清单（89 个，全部由 DFM 100% 还原）')
w('')
w('| # | 单元 | 类 | 实例名 | 字段数 | 事件方法数 | 源资源 |')
w('| --- | --- | --- | --- | --- | --- | --- |')
for i, m in enumerate(man, 1):
    w('| %d | `%s` | `%s` | `%s` | %d | %d | `%s` |' % (
        i, m['unit'], m['cls'], m['name'], m['fields'], m['events'], m['source']))
w('')
w('## 4. 组件类分布（前 40）')
w('')
w('| 类 | 数量 |')
w('| --- | --- |')
for k, v in classes.most_common(40):
    w('| `%s` | %d |' % (k, v))
w('')
w('## 5. 事件分布（全部）')
w('')
w('| 事件 | 绑定数 |')
w('| --- | --- |')
for k, v in events.most_common():
    w('| `%s` | %d |' % (k, v))
w('')
w('## 6. 还原产物')
w('')
w('```')
w('sm19src/')
w('  sm19.lpr                程序文件（Application.CreateForm(TSMMain, SMMain)）')
w('  compat.pas              LCL 缺失类的桩定义 + RegisterClass')
w('  units/u*.pas            89 个窗体单元（类声明 + 3607 组件字段 + 2441 事件方法桩）')
w('  units/u*.lfm            89 个窗体资源（由 TPF0 二进制 DFM 反序列化）')
w('  tools/propdump.lpr      LCL 已发布属性导出工具（用于裁剪 LFM 到 LCL 安全属性集）')
w('  manifest.json           单元/类/字段/事件索引')
w('```')
w('')
w('## 7. 保真度与限制')
w('')
w('已 100% 还原：')
w('- 窗体与控件树（层级、顺序、Owner 关系）')
w('- 全部 published 属性值（坐标、尺寸、标题、字体、颜色、菜单结构、Tab 序、字符串列表、集合）')
w('- 事件处理函数名与绑定点（2441 个）')
w('- 类名、实例名、资源名与单元划分')
w('')
w('不可从二进制恢复：')
w('- 过程内部实现（方法体）—— 需 R3 阶段按模块逆向重写')
w('- 局部变量名、注释、泛型与内联细节')
w('- Delphi 编译器版本精确值（仅由段布局/字符串推断为 Embarcadero VCL）')
w('- 运行时动态创建的控件与字符串拼接逻辑（不在 DFM 内）')
w('')
w('LCL 适配差异：')
w('- 4 个类 LCL 无对应实现，使用桩类：`TRichEdit→TMemo`、`TMediaPlayer→TPanel`、`TCategoryButtons→TPanel`、`TTabPage→TPanel`')
w('- `OldCreateOrder`、`PixelsPerInch` 等 Delphi 专有属性由裁剪器剔除')
w('- 与基类方法同名的事件/组件被改名（如 `TSimDlg.Close` 组件 → `Close_Ctl`）')
w('')

open(OUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(L))
print('wrote', OUT, len(L), 'lines')
print('nodes', nodes, 'classes', len(classes), 'events', sum(events.values()))
