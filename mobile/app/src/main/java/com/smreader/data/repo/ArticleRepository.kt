package com.smreader.data.repo

import com.smreader.data.db.AppDatabase
import com.smreader.data.model.Element
import com.smreader.data.model.ElementType
import kotlinx.coroutines.flow.Flow

class ArticleRepository(private val db: AppDatabase) {

    private val elements = db.elementDao()
    private val positions = db.readingPositionDao()

    fun observeArticles(): Flow<List<Element>> = elements.observeRoots()

    fun observeElement(id: Long): Flow<Element?> = elements.observeById(id)

    suspend fun get(id: Long): Element? = elements.findById(id)

    /**
     * Import plain text as a new root topic.
     *
     * The first non-blank line becomes the title; the whole text is kept as the
     * body so nothing is lost. CRLF and CR are normalised to LF so offsets stay
     * consistent across platforms.
     */
    suspend fun importText(raw: String): Long {
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
            body = text
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
}
