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

    private val _collapsed = MutableStateFlow<Set<Long>>(emptySet())

    /** Flattened contents tree, recomputed whenever elements or collapse state change. */
    val rows: StateFlow<List<com.smreader.domain.TreeRow>> =
        kotlinx.coroutines.flow.combine(
            repo.observeAll(),
            _collapsed
        ) { all, collapsed ->
            com.smreader.domain.TreeBuilder.flatten(all, collapsed)
        }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun toggle(id: Long) {
        _collapsed.value = _collapsed.value.let { if (id in it) it - id else it + id }
    }


    private val _message = MutableStateFlow<String?>(null)
    val message: StateFlow<String?> = _message.asStateFlow()

    fun import(text: String, spans: String = "") {
        viewModelScope.launch {
            try {
                val id = repo.importText(text, spans)
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

    private val _children = MutableStateFlow<List<Element>>(emptyList())
    val children: StateFlow<List<Element>> = _children.asStateFlow()

    private val _message = MutableStateFlow<String?>(null)
    val message: StateFlow<String?> = _message.asStateFlow()

    private var loadedId: Long? = null
    private var childJob: kotlinx.coroutines.Job? = null

    val currentId: Long? get() = loadedId

    fun load(id: Long) {
        if (loadedId == id) return
        loadedId = id
        viewModelScope.launch {
            _element.value = repo.get(id)
            _savedOffset.value = repo.loadPosition(id)
        }
        childJob?.cancel()
        childJob = viewModelScope.launch {
            repo.observeChildren(id).collect { _children.value = it }
        }
    }

    fun saveOffset(offset: Int) {
        val id = loadedId ?: return
        viewModelScope.launch { repo.savePosition(id, offset) }
    }

    /** Extract the given character range of the current element into a child topic. */
    fun extract(start: Int, end: Int) {
        val id = loadedId ?: return
        viewModelScope.launch {
            try {
                val childId = repo.extract(id, start, end)
                _message.value = "已提取（id=$childId）"
            } catch (t: Throwable) {
                _message.value = "提取失败：${t.message}"
            }
        }
    }

    fun clearMessage() { _message.value = null }
}