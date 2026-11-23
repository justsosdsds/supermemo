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

    /** Raw element list, used by the statistics view. */
    val allElements: StateFlow<List<Element>> =
        repo.observeAll().stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    /** Flattened contents tree, recomputed whenever elements or collapse state change. */
    val rows: StateFlow<List<com.smreader.domain.TreeRow>> =
        kotlinx.coroutines.flow.combine(
            repo.observeAll(),
            _collapsed
        ) { all, collapsed ->
            com.smreader.domain.TreeBuilder.flatten(all, collapsed)
        }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    /** Which view the home screen shows. */
    enum class ViewMode { CONTENTS, STATS }

    private val _viewMode = MutableStateFlow(ViewMode.CONTENTS)
    val viewMode: StateFlow<ViewMode> = _viewMode.asStateFlow()

    fun setView(mode: ViewMode) { _viewMode.value = mode }

    /** Insert an empty element, optionally under an existing one. */
    fun insertBlank(title: String, parentId: Long? = null) {
        viewModelScope.launch {
            try {
                val id = repo.insertBlank(title, parentId = parentId)
                _message.value = "已插入（id=$id）"
            } catch (t: Throwable) {
                _message.value = "插入失败：${t.message}"
            }
        }
    }

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

    fun renameElement(id: Long, title: String) {
        viewModelScope.launch {
            val ok = repo.rename(id, title)
            _message.value = if (ok) "已重命名" else "重命名失败：标题为空"
        }
    }

    fun deleteSubtree(id: Long) {
        viewModelScope.launch {
            val n = repo.deleteSubtree(id)
            _message.value = "已删除 $n 个元素"
        }
    }

    fun moveElement(id: Long, newParentId: Long?) {
        viewModelScope.launch {
            val ok = repo.move(id, newParentId)
            _message.value = if (ok) "已移动" else "无法移动到自身或子元素下"
        }
    }

    fun exportText(id: Long, onReady: (String) -> Unit) {
        viewModelScope.launch {
            val t = repo.plainTextOf(id)
            if (t == null) _message.value = "元素不存在" else onReady(t)
        }
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