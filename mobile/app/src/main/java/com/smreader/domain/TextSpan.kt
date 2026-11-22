package com.smreader.domain

/**
 * A formatting span over a character range of an element's plain-text body.
 *
 * Spans are stored separately from the body so that character offsets remain the
 * single source of truth for selection, extract and cloze. Rendering overlays
 * these spans onto the text; nothing here can shift an offset.
 *
 * Serialised as compact JSON so it fits in one SQLite column.
 */
data class TextSpan(
    val start: Int,
    val end: Int,
    val bold: Boolean = false,
    val italic: Boolean = false,
    val underline: Boolean = false,
    val strike: Boolean = false,
    val code: Boolean = false,
    /** Scale factor for headings: 1.0 = body text. */
    val scale: Float = 1f,
    /** 0xAARRGGBB, or null to inherit the theme colour. */
    val color: Int? = null
) {
    val isValid: Boolean get() = start >= 0 && end > start
}

/** A plain-text body plus the spans that describe its original formatting. */
data class RichText(val text: String, val spans: List<TextSpan> = emptyList())

/**
 * Minimal JSON codec for [TextSpan]. Hand-written on purpose: adding kotlinx
 * serialization for one small list is not worth the dependency.
 */
object SpanCodec {

    fun encode(spans: List<TextSpan>): String {
        if (spans.isEmpty()) return ""
        return spans.joinToString("|") { s ->
            buildString {
                append(s.start); append(','); append(s.end)
                if (s.bold) append(",b")
                if (s.italic) append(",i")
                if (s.underline) append(",u")
                if (s.strike) append(",s")
                if (s.code) append(",c")
                if (s.scale != 1f) { append(",z"); append(s.scale) }
                if (s.color != null) { append(",h"); append(s.color) }
            }
        }
    }

    fun decode(raw: String?): List<TextSpan> {
        if (raw.isNullOrBlank()) return emptyList()
        val out = mutableListOf<TextSpan>()
        for (part in raw.split('|')) {
            val f = part.split(',')
            if (f.size < 2) continue
            val start = f[0].toIntOrNull() ?: continue
            val end = f[1].toIntOrNull() ?: continue
            var bold = false; var italic = false; var underline = false
            var strike = false; var code = false; var scale = 1f; var color: Int? = null
            var i = 2
            while (i < f.size) {
                when (f[i]) {
                    "b" -> bold = true
                    "i" -> italic = true
                    "u" -> underline = true
                    "s" -> strike = true
                    "c" -> code = true
                    "z" -> { i++; scale = f.getOrNull(i)?.toFloatOrNull() ?: 1f }
                    "h" -> { i++; color = f.getOrNull(i)?.toIntOrNull() }
                }
                i++
            }
            if (end > start) out.add(TextSpan(start, end, bold, italic, underline, strike, code, scale, color))
        }
        return out
    }
}