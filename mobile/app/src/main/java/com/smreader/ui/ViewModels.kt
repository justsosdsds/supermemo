package com.smreader.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.smreader.data.model.Element
import com.smreader.data.repo.ArticleRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

class ArticleListViewModel(private val repo: ArticleRepository) : ViewModel() {

    val articles: StateFlow<List<Element>> =
        repo.observeArticles().stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    private val _message = MutableStateFlow<String?>(null)
    val message: StateFlow<String?> = _message.asStateFlow()

    fun import(text: String) {
        viewModelScope.launch {
            try {
                val id = repo.importText(text)
                _message.value = "已导入（id=$id）"
            } catch (t: Throwable) {
                _message.value = "导入失败：${t.message}"
            }
        }
    }

    fun delete(id: Long) {
        viewModelScope.launch { repo.delete(id) }
    }

    fun clearMessage() { _message.value = null }
}

class ReaderViewModel(private val repo: ArticleRepository) : ViewModel() {

    private val _element = MutableStateFlow<Element?>(null)
    val element: StateFlow<Element?> = _element.asStateFlow()

    private val _savedOffset = MutableStateFlow(0)
    val savedOffset: StateFlow<Int> = _savedOffset.asStateFlow()

    private var loadedId: Long? = null

    fun load(id: Long) {
        if (loadedId == id) return
        loadedId = id
        viewModelScope.launch {
            _element.value = repo.get(id)
            _savedOffset.value = repo.loadPosition(id)
        }
    }

    /** Persist the reading offset. Called on scroll stop and on leave. */
    fun saveOffset(offset: Int) {
        val id = loadedId ?: return
        viewModelScope.launch { repo.savePosition(id, offset) }
    }
}
