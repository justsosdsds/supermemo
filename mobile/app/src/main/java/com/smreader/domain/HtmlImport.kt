package com.smreader.domain

import org.jsoup.Jsoup
import org.jsoup.nodes.Element
import org.jsoup.nodes.Node
import org.jsoup.nodes.TextNode

/**
 * Convert an HTML document into plain text plus formatting spans.
 *
 * Why spans instead of rendering HTML: the reader is a Compose BasicTextField so
 * that character offsets are available for extract and cloze. A WebView would
 * render richer HTML but has no offset model, which would break incremental
 * reading. So formatting is captured as (start, end, style) triples over the
 * plain text and re-applied at render time. Offsets never shift.
 *
 * Supported: bold, italic, underline, strike, inline code, heading scale, colour.
 * Degraded: tables/lists become line-separated text, images are dropped,
 *            links keep their text but not the href, CSS is not interpreted.
 */
object HtmlImport {

    private val BLOCK = setOf(
        "p", "div", "section", "article", "header", "footer", "main", "aside",
        "h1", "h2", "h3", "h4", "h5", "h6", "blockquote", "pre",
        "ul", "ol", "li", "dl", "dt", "dd",
        "table", "tr", "td", "th", "caption",
        "figure", "figcaption", "address", "hr", "form"
    )

    private val DROP = setOf("script", "style", "noscript", "template", "svg", "head", "meta", "link")

    /** Formatting state inherited while walking down the tree. */
    private data class Style(
        val bold: Boolean = false,
        val italic: Boolean = false,
        val underline: Boolean = false,
        val strike: Boolean = false,
        val code: Boolean = false,
        val scale: Float = 1f,
        val color: Int? = null
    ) {
        val isPlain: Boolean
            get() = !bold && !italic && !underline && !strike && !code && scale == 1f && color == null
    }

    /** Plain text only (kept for callers that do not need formatting). */
    fun toPlainText(html: String): String? = toRichText(html)?.text

    /**
     * Parse [html] into a body string and its spans. Returns null when nothing
     * readable remains (empty input, markup-only payload, script-only page).
     */
    fun toRichText(html: String): RichText? {
        if (html.isBlank()) return null
        val doc = Jsoup.parse(html)
        doc.select(DROP.joinToString(",")).remove()
        val root = doc.body() ?: return null

        val sb = StringBuilder()
        val spans = mutableListOf<TextSpan>()
        walk(root, Style(), sb, spans)

        // Normalise: trim each line, collapse blank runs. Trimming changes offsets,
        // so spans are rebuilt against the normalised text in one pass.
        val normalised = normalise(sb.toString())
        val adjusted = remap(spans, sb.toString(), normalised.text)
        return RichText(normalised.text, adjusted)
    }

    private fun walk(node: Node, style: Style, sb: StringBuilder, spans: MutableList<TextSpan>) {
        when (node) {
            is TextNode -> {
                val raw = node.text()
                if (raw.isEmpty()) return
                val start = sb.length
                sb.append(raw)
                val end = sb.length
                if (end > start && !style.isPlain) {
                    spans.add(
                        TextSpan(
                            start = start,
                            end = end,
                            bold = style.bold,
                            italic = style.italic,
                            underline = style.underline,
                            strike = style.strike,
                            code = style.code,
                            scale = style.scale,
                            color = style.color
                        )
                    )
                }
            }
            is Element -> {
                val tag = node.tagName().lowercase()
                if (tag in DROP) return
                if (tag == "br") { sb.append('\n'); return }
                if (tag == "img") {
                    // keep a placeholder so the reader shows that something was there
                    val alt = node.attr("alt").ifBlank { "图片" }
                    sb.append('[').append(alt).append(']')
                    return
                }
                val block = tag in BLOCK
                if (block) sb.append('\n')
                val inner = styleFor(tag, style)
                node.childNodes().forEach { walk(it, inner, sb, spans) }
                if (block) sb.append('\n')
            }
            else -> node.childNodes().forEach { walk(it, style, sb, spans) }
        }
    }

    private fun styleFor(tag: String, parent: Style): Style = when (tag) {
        "b", "strong" -> parent.copy(bold = true)
        "i", "em", "cite" -> parent.copy(italic = true)
        "u", "ins" -> parent.copy(underline = true)
        "s", "strike", "del" -> parent.copy(strike = true)
        "code", "kbd", "samp", "tt" -> parent.copy(code = true)
        "h1" -> parent.copy(bold = true, scale = 1.8f)
        "h2" -> parent.copy(bold = true, scale = 1.5f)
        "h3" -> parent.copy(bold = true, scale = 1.3f)
        "h4" -> parent.copy(bold = true, scale = 1.15f)
        "h5", "h6" -> parent.copy(bold = true, scale = 1.05f)
        else -> parent
    }

    private data class Normalised(val text: String, val keepFrom: IntArray)

    /**
     * Trim line ends and collapse runs of 3+ newlines, remembering which source
     * index每个 output index came from so spans can be remapped.
     */
    private fun normalise(raw: String): Normalised {
        val out = StringBuilder(raw.length)
        val origin = IntArray(raw.length + 1)
        var i = 0
        var pendingNewlines = 0
        var lineStart = true
        while (i < raw.length) {
            val c = raw[i]
            if (c == '\n') {
                pendingNewlines++
                lineStart = true
                i++
                continue
            }
            if (c == '\u00A0' || c == ' ' || c == '\t') {
                if (lineStart) { i++; continue }      // drop leading whitespace
                if (out.isNotEmpty() && out.last() == ' ') { i++; continue }
                origin[out.length] = i
                out.append(' ')
                i++
                continue
            }
            if (pendingNewlines > 0) {
                val count = minOf(pendingNewlines, 2)
                repeat(count) {
                    origin[out.length] = i
                    out.append('\n')
                }
                pendingNewlines = 0
            }
            lineStart = false
            origin[out.length] = i
            out.append(c)
            i++
        }
        // trailing whitespace
        while (out.isNotEmpty() && (out.last() == ' ' || out.last() == '\n')) out.deleteCharAt(out.length - 1)
        origin[out.length] = raw.length

        val keepFrom = IntArray(out.length + 1)
        for (k in 0..out.length) keepFrom[k] = if (k < origin.size) origin[k] else raw.length
        return Normalised(out.toString(), keepFrom)
    }

    /**
     * Map spans from the raw buffer onto the normalised text.
     *
     * The normaliser only deletes characters, so a span [s,e) maps to the range
     * covering the surviving characters it originally contained.
     */
    private fun remap(spans: List<TextSpan>, raw: String, normalised: String): List<TextSpan> {
        if (spans.isEmpty() || normalised.isEmpty()) return emptyList()
        // Build raw index -> normalised index map by walking both strings once.
        val map = HashMap<Int, Int>()
        var r = 0
        var n = 0
        while (r < raw.length && n < normalised.length) {
            if (raw[r] == normalised[n]) { map[r] = n; r++; n++ } else { r++ }
        }
        val out = mutableListOf<TextSpan>()
        for (s in spans) {
            var ns = -1
            var ne = -1
            var k = s.start
            while (k < s.end && k < raw.length) {
                val m = map[k]
                if (m != null) {
                    if (ns < 0) ns = m
                    ne = m + 1
                }
                k++
            }
            if (ns >= 0 && ne > ns && ne <= normalised.length) {
                out.add(s.copy(start = ns, end = ne))
            }
        }
        return out
    }

    /** True when the payload looks like HTML rather than plain text. */
    fun looksLikeHtml(text: String, fileName: String? = null): Boolean {
        if (fileName != null) {
            val n = fileName.lowercase()
            if (n.endsWith(".html") || n.endsWith(".htm") || n.endsWith(".xhtml")) return true
        }
        val head = text.take(2048).lowercase()
        if (head.contains("<!doctype html")) return true
        if (head.contains("<html")) return true
        if (head.contains("<body")) return true
        var hits = 0
        for (t in listOf("<p>", "<p ", "<div", "<br", "<span", "<h1", "<h2", "<ul", "<li")) {
            if (head.contains(t)) hits++
        }
        return hits >= 2
    }
}