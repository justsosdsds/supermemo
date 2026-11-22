package com.smreader.ui.reader

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.smreader.ui.ReaderViewModel
import kotlinx.coroutines.flow.debounce

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ReaderScreen(
    elementId: Long,
    vm: ReaderViewModel,
    onBack: () -> Unit
) {
    LaunchedEffect(elementId) { vm.load(elementId) }
    val element by vm.element.collectAsState()
    val savedOffset by vm.savedOffset.collectAsState()
    val scroll = rememberScrollState()

    // Restore the saved character offset once the text is available.
    var restored = false
    LaunchedEffect(element, savedOffset) {
        val e = element ?: return@LaunchedEffect
        if (!restored && savedOffset > 0 && e.body.isNotEmpty()) {
            val ratio = savedOffset.toFloat() / e.body.length.toFloat()
            scroll.scrollTo((scroll.maxValue * ratio).toInt().coerceIn(0, scroll.maxValue))
            restored = true
        }
    }

    // Persist the position while scrolling, debounced so we do not write per frame.
    LaunchedEffect(scroll, element) {
        val e = element ?: return@LaunchedEffect
        snapshotFlow { scroll.value to scroll.maxValue }
            .debounce(400)
            .collect { (value, max) ->
                if (max > 0) {
                    val ratio = value.toFloat() / max.toFloat()
                    vm.saveOffset((e.body.length * ratio).toInt())
                }
            }
    }

    DisposableEffect(elementId) {
        onDispose {
            // last-chance save when leaving the screen
            val e = element
            if (e != null && scroll.maxValue > 0) {
                val ratio = scroll.value.toFloat() / scroll.maxValue.toFloat()
                vm.saveOffset((e.body.length * ratio).toInt())
            }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(element?.title ?: "加载中…", maxLines = 1) },
                navigationIcon = { TextButton(onClick = onBack) { Text("返回") } }
            )
        }
    ) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad).verticalScroll(scroll).padding(16.dp)
        ) {
            Text(
                text = element?.body ?: "",
                fontSize = 18.sp,
                lineHeight = 30.sp,
                fontFamily = FontFamily.Serif,
                style = MaterialTheme.typography.bodyLarge
            )
        }
    }
}
