package com.smreader.ui.home

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
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
 * Only "Add" (import) is wired up so far. Learn / Insert / Accept / View are
 * shown disabled so the shape of the workflow is visible without pretending the
 * features exist.
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
    var showInsert by androidx.compose.runtime.remember {
        androidx.compose.runtime.mutableStateOf(false)
    }

    if (viewMode == com.smreader.ui.ArticleListViewModel.ViewMode.STATS) {
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
                onView = {
                    vm.setView(
                        if (viewMode == com.smreader.ui.ArticleListViewModel.ViewMode.CONTENTS)
                            com.smreader.ui.ArticleListViewModel.ViewMode.STATS
                        else
                            com.smreader.ui.ArticleListViewModel.ViewMode.CONTENTS
                    )
                }
            )
        }
    ) { pad ->
        if (showInsert) {
            InsertDialog(
                onDismiss = { showInsert = false },
                onConfirm = { title ->
                    vm.insertBlank(title)
                    showInsert = false
                }
            )
        }

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
                            onOpen = { onOpen(row.element.id) },
                            onToggle = { vm.toggle(row.element.id) }
                        )
                        HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                    }
                }
            }
        }
    }
}

@Composable
private fun ContentsRow(
    row: TreeRow,
    onOpen: () -> Unit,
    onToggle: () -> Unit
) {
    val e = row.element
    Row(
        Modifier
            .fillMaxWidth()
            .clickable(onClick = onOpen)
            .padding(start = (8 + row.depth * 20).dp, end = 12.dp, top = 8.dp, bottom = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // expand / collapse affordance
        Box(Modifier.width(24.dp), contentAlignment = Alignment.Center) {
            if (row.hasChildren) {
                Text(
                    if (row.expanded) "\u25BE" else "\u25B8",   // ▾ ▸
                    fontSize = 14.sp,
                    modifier = Modifier.clickable(onClick = onToggle)
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
/** Minimal dialog to create an empty topic. */
@Composable
private fun InsertDialog(onDismiss: () -> Unit, onConfirm: (String) -> Unit) {
    var title by androidx.compose.runtime.remember { androidx.compose.runtime.mutableStateOf("") }
    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("插入新元素") },
        text = {
            androidx.compose.material3.OutlinedTextField(
                value = title,
                onValueChange = { title = it },
                label = { Text("标题") },
                modifier = Modifier.fillMaxWidth()
            )
        },
        confirmButton = {
            androidx.compose.material3.TextButton(
                onClick = { onConfirm(title) },
                enabled = title.isNotBlank()
            ) { Text("插入") }
        },
        dismissButton = {
            androidx.compose.material3.TextButton(onClick = onDismiss) { Text("取消") }
        }
    )
}