package com.smreader.ui.import_

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.smreader.domain.HtmlImport
import com.smreader.domain.SpanCodec
import com.smreader.domain.TextImport
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Paste limit for the text field. Compose renders the field content as a single
 * text layout, so a few hundred thousand characters freeze the UI. File imports
 * bypass the field entirely - they are held in [pendingText] and never rendered.
 */
private const val PASTE_LIMIT = 20_000

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ImportScreen(
    onImport: (text: String, spans: String) -> Unit,
    onBack: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    // Text typed or pasted by the user. Kept small enough to render.
    var pasteText by remember { mutableStateOf("") }
    // Full content read from a file. NEVER bound to a text field.
    var pendingText by remember { mutableStateOf<String?>(null) }
    var pendingSpans by remember { mutableStateOf("") }
    var pendingLabel by remember { mutableStateOf<String?>(null) }
    var status by remember { mutableStateOf<String?>(null) }
    var busy by remember { mutableStateOf(false) }

    val picker = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocument()
    ) { uri: Uri? ->
        if (uri == null) return@rememberLauncherForActivityResult
        busy = true
        status = "读取中…"
        scope.launch {
            val res = withContext(Dispatchers.IO) {
                runCatching {
                    val name = queryDisplayName(context, uri)
                    val raw = context.contentResolver.openInputStream(uri)?.use { ins ->
                        TextImport.decode(ins.readBytes())
                    } ?: return@runCatching null
                    val isHtml = HtmlImport.looksLikeHtml(raw, name)
                    if (isHtml) {
                        val rich = HtmlImport.toRichText(raw) ?: return@runCatching null
                        RichResult(rich.text, true, name, SpanCodec.encode(rich.spans))
                    } else {
                        if (raw.isBlank()) null else RichResult(raw, false, name, "")
                    }
                }.getOrNull()
            }
            busy = false
            if (res == null) {
                status = "文件读取失败或内容为空"
                pendingText = null
                pendingLabel = null
            } else {
                val plain = res.text
                val isHtml = res.isHtml
                val name = res.name
                pendingText = plain
                pendingSpans = res.spans
                pendingLabel = name ?: "文件"
                pasteText = ""          // clear the field; content lives in pendingText
                status = buildString {
                    append(if (isHtml) "已从 HTML 提取 " else "已读取 ")
                    append(plain.length)
                    append(" 字")
                    if (isHtml) append("（已去除标签与脚本）")
                }
            }
        }
    }

    val ready = pendingText != null || pasteText.isNotBlank()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("导入文章") },
                navigationIcon = { TextButton(onClick = onBack) { Text("返回") } }
            )
        }
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            if (pendingText != null) {
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(12.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        Text("待导入：${pendingLabel}", style = androidx.compose.material3.MaterialTheme.typography.titleSmall)
                        Text(status ?: "", style = androidx.compose.material3.MaterialTheme.typography.bodySmall)
                        Text(
                            "内容较长，不在输入框中预览以免界面卡顿",
                            style = androidx.compose.material3.MaterialTheme.typography.bodySmall
                        )
                        TextButton(onClick = {
                            pendingText = null
                            pendingSpans = ""
                            pendingLabel = null
                            status = null
                        }) { Text("清除") }
                    }
                }
            } else {
                OutlinedTextField(
                    value = pasteText,
                    onValueChange = {
                        if (it.length <= PASTE_LIMIT) {
                            pasteText = it
                            status = null
                        } else {
                            status = "粘贴内容超过 $PASTE_LIMIT 字，请改用文件导入"
                        }
                    },
                    label = { Text("粘贴文本") },
                    supportingText = {
                        Text("${pasteText.length} / $PASTE_LIMIT")
                    },
                    modifier = Modifier.fillMaxWidth().weight(1f)
                )
            }

            status?.let { Text(it) }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedButton(
                    onClick = { picker.launch(arrayOf("text/plain", "text/html", "application/xhtml+xml", "*/*")) },
                    enabled = !busy
                ) {
                    Text(if (busy) "读取中…" else "选择文件")
                }
                Button(
                    onClick = {
                        val payload = pendingText ?: pasteText
                        if (payload.isNotBlank()) onImport(payload, if (pendingText != null) pendingSpans else "")
                    },
                    enabled = ready && !busy
                ) {
                    Text("导入")
                }
            }
        }
    }
}

/** Resolve a human-readable file name so the importer can trust the extension. */
private fun queryDisplayName(context: android.content.Context, uri: Uri): String? =
    runCatching {
        context.contentResolver.query(uri, null, null, null, null)?.use { c ->
            val idx = c.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME)
            if (idx >= 0 && c.moveToFirst()) c.getString(idx) else null
        }
    }.getOrNull()
/** Result of reading a file: normalised text plus any formatting spans. */
private data class RichResult(
    val text: String,
    val isHtml: Boolean,
    val name: String?,
    val spans: String
)