package com.smreader.domain

import org.jsoup.Jsoup
import org.jsoup.nodes.Element
import org.jsoup.nodes.Node
import org.jsoup.nodes.TextNode

/**
 * Convert an HTML document into the plain text the reader displays.
 *
 * Why not render HTML directly: the reader is a Compose BasicTextField so that
 * character offsets are available for extract and cloze. Rendering HTML would
 * require a WebView and a second, incompatible offset model. Importing converts
 * once, and everything downstream works on plain text.
 *
 * Block elements become paragraph breaks, <br> becomes a newline, and
 * script/style/noscript are dropped. Entities are decoded by jsoup.
 */
object HtmlImport {

    /** Elements whose content starts a new paragraph. */
    private val BLOCK = setOf(
        "p", "div", "section", "article", "header", "footer", "main", "aside",
        "h1", "h2", "h3", "h4", "h5", "h6", "blockquote", "pre",
        "ul", "ol", "li", "dl", "dt", "dd",
        "table", "tr", "td", "th", "caption",
        "figure", "figcaption", "address", "hr", "form"
    )

    /** Elements whose entire content is discarded. */
    private val DROP = setOf("script", "style", "noscript", "template", "svg", "head", "meta", "link")

    /**
     * Return plain text for [html], or null when nothing usable remains.
     * Throws nothing: malformed markup is tolerated by jsoup.
     */
    fun toPlainText(html: String): String? {
        if (html.isBlank()) return null
        val doc = Jsoup.parse(html)
        doc.select(DROP.joinToString(",")).remove()

        val sb = StringBuilder()
        val root = doc.body() ?: return null
        walk(root, sb)

        // collapse runs of blank lines, trim each line
        val cleaned = sb.toString()
            .lines()
            .map { it.replace('\u00A0', ' ').trim() }
            .joinToString("\n")
            .replace(Regex("\n{3,}"), "\n\n")
            .trim()
        return cleaned.ifBlank { null }
    }

    private fun walk(node: Node, sb: StringBuilder) {
        when (node) {
            is TextNode -> sb.append(node.text())
            is Element -> {
                val tag = node.tagName().lowercase()
                if (tag in DROP) return
                if (tag == "br") {
                    sb.append('\n')
                    return
                }
                val block = tag in BLOCK
                if (block) sb.append('\n')
                node.childNodes().forEach { walk(it, sb) }
                if (block) sb.append('\n')
            }
            else -> node.childNodes().forEach { walk(it, sb) }
        }
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
        // a few common tags are enough even for fragments
        var hits = 0
        for (t in listOf("<p>", "<p ", "<div", "<br", "<span", "<h1", "<h2", "<ul", "<li")) {
            if (head.contains(t)) hits++
        }
        return hits >= 2
    }
}