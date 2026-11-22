package com.smreader.data.repo

import com.smreader.data.db.AppDatabase
import com.smreader.data.model.Element
import com.smreader.data.model.ElementType
import kotlinx.coroutines.flow.Flow

class ArticleRepository(private val db: AppDatabase) {

    private val elements = db.elementDao()
    private val positions = db.readingPositionDao()

    fun observeArticles(): Flow<List<Element>> = elements.observeRoots()

    /** Every element, for the contents tree. */
    fun observeAll(): Flow<List<Element>> = elements.observeAll()

    suspend fun all(): List<Element> = elements.all()

    fun observeElement(id: Long): Flow<Element?> = elements.observeById(id)

    suspend fun get(id: Long): Element? = elements.findById(id)

    /**
     * Import plain text as a new root topic.
     *
     * The first non-blank line becomes the title; the whole text is kept as the
     * body so nothing is lost. CRLF and CR are normalised to LF so offsets stay
     * consistent across platforms.
     */
    suspend fun importText(raw: String, spans: String = ""): Long {
        val text = raw.replace("\r\n", "\n").replace('\r', '\n').trim()
        require(text.isNotEmpty()) { "text is empty" }
        val title = text.lineSequence()
            .firstOrNull { it.isNotBlank() }
            ?.trim()
            ?.take(80)
            ?: "Untitled"
        val e = Element(
            type = ElementType.TOPIC,
            rootId = 0,
            title = title,
            body = text,
            spans = spans
        )
        return elements.insertRoot(e)
    }

    suspend fun savePosition(elementId: Long, offset: Int) {
        positions.upsert(
            com.smreader.data.model.ReadingPosition(
                elementId = elementId,
                offset = offset.coerceAtLeast(0)
            )
        )
    }

    suspend fun loadPosition(elementId: Long): Int =
        positions.find(elementId)?.offset ?: 0

    suspend fun delete(id: Long) {
        positions.delete(id)
        elements.deleteById(id)
    }
    /** Direct children of an element (extracts / clozes made from it). */
    fun observeChildren(parentId: Long): Flow<List<Element>> = elements.observeChildren(parentId)

    suspend fun childrenOf(parentId: Long): List<Element> = elements.childrenOf(parentId)

    /**
     * Extract a range of a topic's body into a child topic.
     *
     * The parent body is never modified: the selected range is recorded in
     * sourceFrom/sourceTo so the reader can highlight it and jump back. This is
     * deliberate - rewriting the parent text is exactly what made the Windows
     * version fragile when the same phrase appeared more than once.
     */
    suspend fun extract(parentId: Long, start: Int, end: Int): Long {
        val parent = elements.findById(parentId)
            ?: throw IllegalArgumentException("parent $parentId not found")
        val sel = com.smreader.domain.SelectionOps.trimmed(parent.body, start, end)
            ?: throw IllegalArgumentException("selection is empty or out of range")
        val order = elements.maxSortKey(parentId) + 1
        val child = Element(
            type = ElementType.TOPIC,
            parentId = parentId,
            rootId = parent.rootId,
            title = com.smreader.domain.SelectionOps.titleOf(sel.text),
            body = sel.text,
            sourceFrom = sel.start,
            sourceTo = sel.end,
            sortKey = order
        )
        return elements.insert(child)
    }
}
