package com.smreader.ui.reader

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextRange
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.smreader.domain.SelectionOps
import com.smreader.ui.ReaderViewModel
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ReaderScreen(
    elementId: Long,
    vm: ReaderViewModel,
    onBack: () -> Unit,
    onOpenChild: (Long) -> Unit
) {
    LaunchedEffect(elementId) { vm.load(elementId) }
    val element by vm.element.collectAsState()
    val children by vm.children.collectAsState()
    val savedOffset by vm.savedOffset.collectAsState()
    val message by vm.message.collectAsState()
    val scroll = rememberScrollState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    // A read-only BasicTextField is used instead of Text: only TextFieldValue
    // exposes the selection range, which we need for accurate extract offsets.
    var value by remember(elementId) { mutableStateOf(TextFieldValue("", TextRange.Zero)) }
    var appliedText by remember(elementId) { mutableStateOf("") }

    LaunchedEffect(element) {
        val e = element ?: return@LaunchedEffect
        if (appliedText != e.body) {
            appliedText = e.body
            value = TextFieldValue(e.body, TextRange.Zero)
        }
    }

    // Restore the saved character offset.
    //
    // Two hazards this handles:
    //  1. scroll.maxValue is 0 during the first composition, so a one-shot check
    //     would silently never restore. We await the first non-zero maxValue.
    //  2. recomposition would re-run the restore and yank the user back. The
    //     "already restored" flag is rememberSaveable keyed by element so it
    //     survives recomposition and configuration changes.
    var restored by rememberSaveable(elementId) { mutableStateOf(false) }
    LaunchedEffect(elementId, element?.body?.length) {
        val e = element ?: return@LaunchedEffect
        if (restored || savedOffset <= 0 || e.body.isEmpty()) return@LaunchedEffect
        // wait until content has been measured
        val max = snapshotFlow { scroll.maxValue }.first { it > 0 }
        val ratio = savedOffset.toFloat() / e.body.length.toFloat()
        scroll.scrollTo((max * ratio).toInt().coerceIn(0, max))
        restored = true
    }

    // Persist position while scrolling.
    LaunchedEffect(scroll, element) {
        val e = element ?: return@LaunchedEffect
        snapshotFlow { scroll.value to scroll.maxValue }
            .debounce(400)
            .collect { (v, max) ->
                if (max > 0) vm.saveOffset((e.body.length * (v.toFloat() / max)).toInt())
            }
    }

    DisposableEffect(elementId) {
        onDispose {
            val e = element
            if (e != null && scroll.maxValue > 0) {
                vm.saveOffset((e.body.length * (scroll.value.toFloat() / scroll.maxValue)).toInt())
            }
        }
    }

    LaunchedEffect(message) {
        message?.let {
            snackbar.showSnackbar(it)
            vm.clearMessage()
        }
    }

    val selection = SelectionOps.trimmed(
        element?.body ?: "",
        value.selection.start,
        value.selection.end
    )

    Scaffold(
        snackbarHost = { SnackbarHost(snackbar) },
        topBar = {
            TopAppBar(
                title = { Text(element?.title ?: "加载中…", maxLines = 1) },
                navigationIcon = { TextButton(onClick = onBack) { Text("返回") } }
            )
        },
        bottomBar = {
            if (selection != null) {
                SelectionBar(
                    text = selection.text,
                    onExtract = {
                        vm.extract(selection.start, selection.end)
                        value = value.copy(selection = TextRange.Zero)
                    }
                )
            }
        }
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad).verticalScroll(scroll).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // The body text is rendered with extracted ranges highlighted.
            // sourceFrom/sourceTo are character offsets into this same string,
            // so they stay valid no matter how the text is laid out.
            val annotated = remember(element?.body, element?.spans, children) {
                buildAnnotatedString {
                    append(element?.body ?: "")
                    // Formatting captured at import time, applied by character range.
                    com.smreader.domain.SpanCodec.decode(element?.spans).forEach { sp ->
                        if (sp.start >= 0 && sp.end <= length && sp.start < sp.end) {
                            addStyle(
                                SpanStyle(
                                    fontWeight = if (sp.bold) FontWeight.Bold else null,
                                    fontStyle = if (sp.italic) FontStyle.Italic else null,
                                    textDecoration = when {
                                        sp.underline && sp.strike -> TextDecoration.combine(
                                            listOf(TextDecoration.Underline, TextDecoration.LineThrough)
                                        )
                                        sp.underline -> TextDecoration.Underline
                                        sp.strike -> TextDecoration.LineThrough
                                        else -> null
                                    },
                                    fontFamily = if (sp.code) FontFamily.Monospace else null,
                                    fontSize = if (sp.scale != 1f) (18f * sp.scale).sp else androidx.compose.ui.unit.TextUnit.Unspecified,
                                    color = sp.color?.let { Color(it) } ?: Color.Unspecified
                                ),
                                sp.start,
                                sp.end
                            )
                        }
                    }
                    // Extracted ranges are highlighted on top of formatting.
                    children.forEach { c ->
                        val f = c.sourceFrom
                        val t = c.sourceTo
                        if (f != null && t != null && f >= 0 && t <= length && f < t) {
                            addStyle(SpanStyle(background = Color(0x334FC3F7)), f, t)
                        }
                    }
                }
            }

            BasicTextField(
                value = value.copy(annotatedString = annotated),
                onValueChange = { value = it },
                readOnly = true,
                textStyle = MaterialTheme.typography.bodyLarge.copy(fontSize = 18.sp, lineHeight = 30.sp),
                modifier = Modifier.fillMaxWidth()
            )

            if (children.isNotEmpty()) {
                HorizontalDivider(Modifier.padding(vertical = 8.dp))
                Text("已提取（${children.size}）", style = MaterialTheme.typography.titleSmall)
                children.forEach { c ->
                    Text(
                        text = "· ${c.title}",
                        style = MaterialTheme.typography.bodyMedium,
                        textDecoration = TextDecoration.Underline,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp)
                            .clickableChild { onOpenChild(c.id) }
                    )
                }
            }
        }
    }
}

private fun Modifier.clickableChild(onClick: () -> Unit): Modifier =
    this.clickable(onClick = onClick)

@Composable
private fun SelectionBar(text: String, onExtract: () -> Unit) {
    Surface(tonalElevation = 3.dp) {
        Column(Modifier.fillMaxWidth().padding(12.dp)) {
            Text(
                "已选 ${text.length} 字：${SelectionOps.excerpt(text)}",
                style = MaterialTheme.typography.bodySmall,
                maxLines = 2
            )
            Row(horizontalArrangement = Arrangement.End) {
                TextButton(onClick = onExtract) { Text("提取为子主题") }
            }
        }
    }
}