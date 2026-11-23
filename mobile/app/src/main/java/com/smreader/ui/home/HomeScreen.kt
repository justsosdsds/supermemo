package com.smreader.ui.home

import androidx.compose.foundation.background
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.VerticalDivider
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.smreader.domain.TreeBuilder
import com.smreader.domain.TreeRow
import com.smreader.ui.ArticleListViewModel

/**
 * Contents view, modelled on SuperMemo's contents window: a collapsible tree of
 * topics and items with a command bar at the bottom.
 *
 * Long-pressing a row opens the element context menu. Menu entries that have no
 * implementation behind them are shown disabled rather than hidden, so the shape
 * of the workflow stays visible without pretending the features work.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    vm: ArticleListViewModel,
    onOpen: (Long) -> Unit,
    onImport: () -> Unit
) {
    val rows by vm.rows.collectAsState()
    val viewMode by vm.viewMode.collectAsState()

    var showInsert by remember { mutableStateOf(false) }
    var renameTarget by remember { mutableStateOf<TreeRow?>(null) }
    var moveTarget by remember { mutableStateOf<TreeRow?>(null) }
    var deleteTarget by remember { mutableStateOf<TreeRow?>(null) }

    val clipboard = LocalClipboardManager.current
    val ctx = androidx.compose.ui.platform.LocalContext.current

    if (viewMode == ArticleListViewModel.ViewMode.STATS) {
        com.smreader.ui.stats.StatsScreen(vm)
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Contents") },
                actions = {
                    Text(
                        "${rows.size} 项",
                        style = MaterialTheme.typography.bodySmall,
                        modifier = Modifier.padding(end = 12.dp)
                    )
                }
            )
        },
        bottomBar = {
            CommandBar(
                onAdd = onImport,
                onInsert = { showInsert = true },
                onView = { vm.setView(ArticleListViewModel.ViewMode.STATS) }
            )
        }
    ) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {
            if (rows.isEmpty()) {
                Column(
                    Modifier.fillMaxSize().padding(24.dp),
                    verticalArrangement = Arrangement.Center
                ) {
                    Text("还没有内容", style = MaterialTheme.typography.titleMedium)
                    Text("点下方「Add」导入文本或 HTML 文件")
                }
            } else {
                LazyColumn(Modifier.fillMaxSize()) {
                    items(rows, key = { it.element.id }) { row ->
                        ContentsRow(
                            row = row,
                            vm = vm,
                            onOpen = { onOpen(row.element.id) },
                            onRename = { renameTarget = row },
                            onMove = { moveTarget = row },
                            onDelete = { deleteTarget = row },
                            onCopy = {
                                vm.exportText(row.element.id) { clipboard.setText(androidx.compose.ui.text.AnnotatedString(it)) }
                            },
                            onExport = { text ->
                                shareText(ctx, text)
                            }
                        )
                        HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                    }
                }
            }
        }
    }

    if (showInsert) {
        TextInputDialog(
            title = "插入新元素",
            label = "标题",
            confirmLabel = "插入",
            onDismiss = { showInsert = false },
            onConfirm = { t ->
                vm.insertBlank(t)
                showInsert = false
            }
        )
    }

    renameTarget?.let { target ->
        TextInputDialog(
            title = "重命名",
            label = "标题",
            initial = target.element.title,
            confirmLabel = "保存",
            onDismiss = { renameTarget = null },
            onConfirm = { t ->
                vm.renameElement(target.element.id, t)
                renameTarget = null
            }
        )
    }

    moveTarget?.let { target ->
        MoveDialog(
            rows = rows,
            movingId = target.element.id,
            onDismiss = { moveTarget = null },
            onConfirm = { newParent ->
                vm.moveElement(target.element.id, newParent)
                moveTarget = null
            }
        )
    }

    deleteTarget?.let { target ->
        val kids = TreeBuilder.descendantCount(rows.map { it.element }, target.element.id)
        AlertDialog(
            onDismissRequest = { deleteTarget = null },
            title = { Text("删除") },
            text = {
                Text(
                    if (kids > 0)
                        "将删除《${target.element.title}》及其 $kids 个子元素，无法撤销。"
                    else
                        "将删除《${target.element.title}》，无法撤销。"
                )
            },
            confirmButton = {
                TextButton(onClick = {
                    vm.deleteSubtree(target.element.id)
                    deleteTarget = null
                }) { Text("删除") }
            },
            dismissButton = {
                TextButton(onClick = { deleteTarget = null }) { Text("取消") }
            }
        )
    }
}

@Composable
private fun ContentsRow(
    row: TreeRow,
    vm: ArticleListViewModel,
    onOpen: () -> Unit,
    onRename: () -> Unit,
    onMove: () -> Unit,
    onDelete: () -> Unit,
    onCopy: () -> Unit,
    onExport: (String) -> Unit
) {
    val e = row.element
    var menuOpen by remember { mutableStateOf(false) }

    Box {
        Row(
            Modifier
                .fillMaxWidth()
                .combinedClickable(
                    onClick = onOpen,
                    onLongClick = { menuOpen = true }
                )
                .padding(start = (8 + row.depth * 20).dp, end = 12.dp, top = 8.dp, bottom = 8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(Modifier.width(24.dp), contentAlignment = Alignment.Center) {
                if (row.hasChildren) {
                    Text(
                        if (row.expanded) "\u25BE" else "\u25B8",
                        fontSize = 14.sp,
                        modifier = Modifier.clickable { vm.toggle(e.id) }
                    )
                }
            }
            Text(
                TreeBuilder.glyph(e.type, row.hasChildren),
                fontSize = 16.sp,
                modifier = Modifier.padding(end = 6.dp)
            )
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(1.dp)) {
                Text(
                    e.title,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = if (row.depth == 0) FontWeight.Medium else FontWeight.Normal,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    buildString {
                        append(e.body.length); append(" 字")
                        if (row.childCount > 0) { append(" · "); append(row.childCount); append(" 子项") }
                    },
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        // Context menu, mirroring SuperMemo's right-click menu on a contents row.
        DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
            MenuItem("新建子项") { vm.insertBlank("未命名", parentId = e.id); menuOpen = false }
            MenuItem("打开阅读") { menuOpen = false; onOpen() }
            MenuItem("重命名") { menuOpen = false; onRename() }
            MenuDivider()
            MenuItem("复制到剪贴板") { menuOpen = false; onCopy() }
            MenuItem("粘贴", enabled = false) { }
            MenuItem("删除") { menuOpen = false; onDelete() }
            MenuItem("移动到…") { menuOpen = false; onMove() }
            MenuDivider()
            MenuItem("Learn", enabled = false) { }
            MenuItem("Dismiss", enabled = false) { }
            MenuItem("Search", enabled = false) { }
            MenuDivider()
            MenuItem("Concept", enabled = false) { }
            MenuItem("导出文本") {
                menuOpen = false
                vm.exportText(e.id) { onExport(it) }
            }
            MenuItem("Tools", enabled = false) { }
            MenuItem("Font", enabled = false) { }
            MenuDivider()
            MenuItem("处理分支", enabled = false) { }
            MenuDivider()
            MenuItem("关闭") { menuOpen = false }
        }
    }
}

@Composable
private fun MenuItem(label: String, enabled: Boolean = true, onClick: () -> Unit) {
    DropdownMenuItem(
        text = {
            Text(
                label,
                color = if (enabled) MaterialTheme.colorScheme.onSurface
                else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
            )
        },
        enabled = enabled,
        onClick = onClick
    )
}

@Composable
private fun MenuDivider() = HorizontalDivider(Modifier.padding(vertical = 4.dp))

@Composable
private fun TextInputDialog(
    title: String,
    label: String,
    initial: String = "",
    confirmLabel: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit
) {
    var text by remember { mutableStateOf(initial) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                label = { Text(label) },
                modifier = Modifier.fillMaxWidth()
            )
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(text) }, enabled = text.isNotBlank()) { Text(confirmLabel) }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text("取消") } }
    )
}

/** Pick a new parent for an element; the element's own subtree is excluded. */
@Composable
private fun MoveDialog(
    rows: List<TreeRow>,
    movingId: Long,
    onDismiss: () -> Unit,
    onConfirm: (Long?) -> Unit
) {
    // Exclude the element itself and everything under it: moving there would cycle.
    val blocked = remember(rows, movingId) {
        val all = rows.map { it.element }
        val byParent = all.groupBy { it.parentId }
        val out = mutableSetOf(movingId)
        fun collect(x: Long, guard: Int = 0) {
            if (guard > 100) return
            byParent[x]?.forEach { out.add(it.id); collect(it.id, guard + 1) }
        }
        collect(movingId)
        out
    }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("移动到") },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
                TextButton(onClick = { onConfirm(null) }) { Text("（移到根级）") }
                rows.filter { it.element.id !in blocked }.forEach { r ->
                    TextButton(onClick = { onConfirm(r.element.id) }) {
                        Text(
                            "  ".repeat(r.depth) + r.element.title,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }
            }
        },
        confirmButton = {},
        dismissButton = { TextButton(onClick = onDismiss) { Text("取消") } }
    )
}

/** Hand the text to another app so the user can save or share it. */
private fun shareText(ctx: android.content.Context, text: String) {
    runCatching {
        val intent = android.content.Intent(android.content.Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(android.content.Intent.EXTRA_TEXT, text)
        }
        ctx.startActivity(
            android.content.Intent.createChooser(intent, "导出").addFlags(
                android.content.Intent.FLAG_ACTIVITY_NEW_TASK
            )
        )
    }
}

/** Bottom command bar mirroring SuperMemo's docked buttons. */
@Composable
private fun CommandBar(onAdd: () -> Unit, onInsert: () -> Unit, onView: () -> Unit) {
    Surface(tonalElevation = 3.dp) {
        Row(
            Modifier.fillMaxWidth().height(52.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            CommandButton("Learn", enabled = false, modifier = Modifier.weight(1f), onClick = {})
            VerticalDivider(Modifier.height(24.dp))
            CommandButton("Add", enabled = true, modifier = Modifier.weight(1f), onClick = onAdd)
            VerticalDivider(Modifier.height(24.dp))
            CommandButton("Insert", enabled = true, modifier = Modifier.weight(1f), onClick = onInsert)
            VerticalDivider(Modifier.height(24.dp))
            CommandButton("Accept", enabled = false, modifier = Modifier.weight(1f), onClick = {})
            VerticalDivider(Modifier.height(24.dp))
            CommandButton("View", enabled = true, modifier = Modifier.weight(1f), onClick = onView)
        }
    }
}

@Composable
private fun CommandButton(
    label: String,
    enabled: Boolean,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Box(
        modifier
            .fillMaxSize()
            .clickable(enabled = enabled, onClick = onClick)
            .background(androidx.compose.ui.graphics.Color.Transparent),
        contentAlignment = Alignment.Center
    ) {
        Text(
            label,
            style = MaterialTheme.typography.labelLarge,
            color = if (enabled) MaterialTheme.colorScheme.primary
            else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f)
        )
    }
}
