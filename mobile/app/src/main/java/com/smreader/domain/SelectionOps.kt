package com.smreader.domain

/**
 * Selection handling for extract. Pure Kotlin so it can be unit tested on the JVM.
 *
 * All offsets are character indices into the *normalised* body (CRLF folded to
 * LF), which is what TextImport.normalise produces at import time.
 */
object SelectionOps {

    data class Selection(val start: Int, val end: Int, val text: String) {
        val length: Int get() = end - start
        val isValid: Boolean get() = length > 0 && text.isNotBlank()
    }

    /**
     * Build a selection from raw start/end and the body it belongs to.
     * Returns null when the range is empty, out of bounds, or blank.
     */
    fun of(body: String, start: Int, end: Int): Selection? {
        val s = minOf(start, end).coerceIn(0, body.length)
        val e = maxOf(start, end).coerceIn(0, body.length)
        if (e <= s) return null
        val text = body.substring(s, e)
        val sel = Selection(s, e, text)
        return if (sel.isValid) sel else null
    }

    /**
     * Trim surrounding whitespace from a selection while keeping offsets valid.
     * Selecting a paragraph in a reader usually drags in a leading newline.
     */
    fun trimmed(body: String, start: Int, end: Int): Selection? {
        val base = of(body, start, end) ?: return null
        var s = base.start
        var e = base.end
        while (s < e && body[s].isWhitespace()) s++
        while (e > s && body[e - 1].isWhitespace()) e--
        return of(body, s, e)
    }

    /** Title for a newly extracted child: first line, capped. */
    fun titleOf(text: String, maxLen: Int = 60): String {
        val line = text.lineSequence().firstOrNull { it.isNotBlank() }?.trim() ?: return "摘录"
        return if (line.length <= maxLen) line else line.take(maxLen) + "…"
    }

    /**
     * A short excerpt shown under the parent article to mark the extracted
     * range. Not stored in the body: the body is never mutated, the range is
     * kept in sourceFrom/sourceTo instead.
     */
    fun excerpt(text: String, maxLen: Int = 40): String {
        val one = text.replace('\n', ' ').trim()
        return if (one.length <= maxLen) one else one.take(maxLen) + "…"
    }
}