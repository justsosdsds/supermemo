package com.smreader.domain

/**
 * Pure text handling for imports. No Android dependencies so it can be unit
 * tested on the JVM.
 */
object TextImport {

    /**
     * Normalise line endings and trim.
     *
     * Offsets stored for reading positions and cloze ranges must be stable, so
     * CRLF and lone CR are folded to LF before anything computes an index.
     */
    fun normalise(raw: String): String =
        raw.replace("\r\n", "\n").replace('\r', '\n').trim()

    /**
     * Build a display title from the body: first non-blank line, capped so a
     * whole paragraph cannot become the title.
     */
    fun titleOf(text: String, maxLen: Int = 80): String {
        val first = text.lineSequence().firstOrNull { it.isNotBlank() }?.trim()
        if (first.isNullOrEmpty()) return "Untitled"
        return if (first.length <= maxLen) first else first.take(maxLen) + "…"
    }

    /**
     * Decode bytes to text. UTF-8 is tried first; if the result contains the
     * replacement character the platform default charset is used instead, which
     * is what Chinese Windows users' GBK-encoded .txt files need.
     */
    fun decode(bytes: ByteArray, fallbackCharset: String? = null): String {
        val utf8 = bytes.toString(Charsets.UTF_8)
        if ('\uFFFD' !in utf8) return utf8
        return runCatching {
            bytes.toString(java.nio.charset.Charset.forName(fallbackCharset ?: "GBK"))
        }.getOrDefault(utf8)
    }

    /** Split a body into paragraphs with their character start offsets. */
    fun paragraphs(body: String): List<Pair<Int, String>> {
        val out = mutableListOf<Pair<Int, String>>()
        var idx = 0
        for (line in body.split('\n')) {
            out.add(idx to line)
            idx += line.length + 1
        }
        return out
    }
}