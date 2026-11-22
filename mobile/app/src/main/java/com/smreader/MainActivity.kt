package com.smreader

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.snapshots.SnapshotStateList
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

/**
 * Navigate by pushing onto a stack and popping it, so the system back gesture
 * (edge swipe or hardware/gesture nav bar) goes to the previous screen instead of
 * finishing the activity.
 *
 * The stack also means opening a child element from a reader pushes a new Reader
 * entry: back returns to the parent reader, not straight to the contents list.
 */
private class NavStack(val entries: SnapshotStateList<Dest>) {

    val current: Dest get() = entries.lastOrNull() ?: Dest.Home
    val canGoBack: Boolean get() = entries.size > 1

    fun push(dest: Dest) {
        // Guard against pushing the same reader twice (double tap).
        if (entries.lastOrNull() == dest) return
        entries.add(dest)
    }

    /** Replace the top entry, used after importing so back does not reopen the form. */
    fun replaceTop(dest: Dest) {
        if (entries.isNotEmpty()) entries.removeAt(entries.lastIndex)
        push(dest)
    }

    /** Returns false when there is nothing left to pop. */
    fun pop(): Boolean {
        if (!canGoBack) return false
        entries.removeAt(entries.lastIndex)
        return true
    }

    /** Drop back to the contents list. */
    fun toRoot() {
        while (entries.size > 1) entries.removeAt(entries.lastIndex)
    }
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val app = application as SmApp
        setContent {
            SmReaderTheme {
                val entries = remember { mutableStateListOf<Dest>(Dest.Home) }
                val nav = remember { NavStack(entries) }
                val listVm: ArticleListViewModel = viewModel { ArticleListViewModel(app.articles) }
                val readerVm: ReaderViewModel = viewModel { ReaderViewModel(app.articles) }

                // Intercept the system back gesture. Enabled only when there is
                // somewhere to go back to; on the contents list the gesture exits
                // the app, which is the expected Android behaviour.
                BackHandler(enabled = nav.canGoBack) { nav.pop() }

                when (val d = nav.current) {
                    Dest.Home -> HomeScreen(
                        vm = listVm,
                        onOpen = { nav.push(Dest.Reader(it)) },
                        onImport = { nav.push(Dest.Import) }
                    )

                    Dest.Import -> ImportScreen(
                        onImport = { text, spans ->
                            listVm.import(text, spans)
                            // Back from the list must not return to the import form.
                            nav.replaceTop(Dest.Home)
                        },
                        onBack = { nav.pop() }
                    )

                    is Dest.Reader -> ReaderScreen(
                        elementId = d.id,
                        vm = readerVm,
                        onBack = { nav.pop() },
                        onOpenChild = { childId -> nav.push(Dest.Reader(childId)) }
                    )
                }
            }
        }
    }
}
