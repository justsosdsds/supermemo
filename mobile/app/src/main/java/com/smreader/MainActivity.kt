package com.smreader

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.lifecycle.viewmodel.compose.viewModel
import com.smreader.ui.ArticleListViewModel
import com.smreader.ui.ReaderViewModel
import com.smreader.ui.home.HomeScreen
import com.smreader.ui.import_.ImportScreen
import com.smreader.ui.reader.ReaderScreen
import com.smreader.ui.theme.SmReaderTheme

private sealed interface Dest {
    data object Home : Dest
    data object Import : Dest
    data class Reader(val id: Long) : Dest
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val app = application as SmApp
        setContent {
            SmReaderTheme {
                var dest by remember { mutableStateOf<Dest>(Dest.Home) }
                val listVm: ArticleListViewModel = viewModel { ArticleListViewModel(app.articles) }
                val readerVm: ReaderViewModel = viewModel { ReaderViewModel(app.articles) }

                when (val d = dest) {
                    Dest.Home -> HomeScreen(
                        vm = listVm,
                        onOpen = { dest = Dest.Reader(it) },
                        onImport = { dest = Dest.Import }
                    )
                    Dest.Import -> ImportScreen(
                        onImport = { text ->
                            listVm.import(text)
                            dest = Dest.Home
                        },
                        onBack = { dest = Dest.Home }
                    )
                    is Dest.Reader -> ReaderScreen(
                        elementId = d.id,
                        vm = readerVm,
                        onBack = { dest = Dest.Home }
                    )
                }
            }
        }
    }
}
