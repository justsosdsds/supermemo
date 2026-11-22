package com.smreader.ui.home

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.smreader.ui.ArticleListViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    vm: ArticleListViewModel,
    onOpen: (Long) -> Unit,
    onImport: () -> Unit
) {
    val articles by vm.articles.collectAsState()

    Scaffold(
        topBar = { TopAppBar(title = { Text("我的文章") }) },
        floatingActionButton = {
            ExtendedFloatingActionButton(
                onClick = onImport,
                content = { Text("导入") }
            )
        }
    ) { pad ->
        if (articles.isEmpty()) {
            Column(
                modifier = Modifier.fillMaxSize().padding(pad).padding(24.dp),
                verticalArrangement = Arrangement.Center
            ) {
                Text("还没有文章", style = MaterialTheme.typography.titleMedium)
                Text("点右下角「导入」粘贴文本或选择 TXT 文件")
            }
        } else {
            LazyColumn(
                modifier = Modifier.fillMaxSize().padding(pad),
                contentPadding = PaddingValues(bottom = 96.dp)
            ) {
                items(articles, key = { it.id }) { a ->
                    Column(
                        Modifier.fillMaxWidth().clickable { onOpen(a.id) }
                            .padding(horizontal = 16.dp, vertical = 12.dp)
                    ) {
                        Text(a.title, style = MaterialTheme.typography.titleMedium, maxLines = 2,
                            overflow = TextOverflow.Ellipsis)
                        Text("${a.body.length} 字", style = MaterialTheme.typography.bodySmall)
                    }
                    HorizontalDivider()
                }
            }
        }
    }
}
