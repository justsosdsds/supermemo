package com.smreader

import com.smreader.domain.HtmlImport
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class HtmlImportTest {

    @Test
    fun paragraphsBecomeSeparateLines() {
        val html = "<html><body><p>第一段</p><p>第二段</p></body></html>"
        val out = requireNotNull(HtmlImport.toPlainText(html))
        assertEquals("第一段\n第二段", out)
    }

    @Test
    fun brBecomesNewline() {
        val out = requireNotNull(HtmlImport.toPlainText("<div>上行<br>下行</div>"))
        assertEquals("上行\n下行", out)
    }

    @Test
    fun scriptAndStyleAreDropped() {
        val html = """
            <html><head><style>body{color:red}</style></head>
            <body><script>alert('x')</script><p>正文</p></body></html>
        """.trimIndent()
        val out = requireNotNull(HtmlImport.toPlainText(html))
        assertEquals("正文", out)
    }

    @Test
    fun entitiesAreDecoded() {
        val out = requireNotNull(HtmlImport.toPlainText("<p>A &amp; B &lt;tag&gt; &#20013;&#25991;</p>"))
        assertEquals("A & B <tag> 中文", out)
    }

    @Test
    fun nbspBecomesSpace() {
        val out = requireNotNull(HtmlImport.toPlainText("<p>A&nbsp;&nbsp;B</p>"))
        assertTrue(out.contains("A"))
        assertTrue(out.contains("B"))
        assertFalse(out.contains('\u00A0'))
    }

    @Test
    fun headingsBecomeOwnParagraphs() {
        val out = requireNotNull(HtmlImport.toPlainText("<h1>标题</h1><p>正文</p>"))
        assertEquals("标题\n正文", out)
    }

    @Test
    fun listItemsBecomeLines() {
        val out = requireNotNull(HtmlImport.toPlainText("<ul><li>甲</li><li>乙</li></ul>"))
        assertEquals("甲\n乙", out)
    }

    @Test
    fun blankInputReturnsNull() {
        assertNull(HtmlImport.toPlainText("   "))
    }

    @Test
    fun markupOnlyReturnsNull() {
        assertNull(HtmlImport.toPlainText("<html><body><script>x</script></body></html>"))
    }

    @Test
    fun nestedInlineTagsKeepText() {
        val out = requireNotNull(HtmlImport.toPlainText("<p>前<b>粗</b><i>斜</i>后</p>"))
        assertEquals("前粗斜后", out)
    }

    @Test
    fun looksLikeHtml_byExtension() {
        assertTrue(HtmlImport.looksLikeHtml("任意内容", "a.HTML"))
        assertTrue(HtmlImport.looksLikeHtml("任意内容", "b.htm"))
        assertFalse(HtmlImport.looksLikeHtml("任意内容", "c.txt"))
    }

    @Test
    fun looksLikeHtml_byDoctype() {
        assertTrue(HtmlImport.looksLikeHtml("<!DOCTYPE html><html></html>"))
    }

    @Test
    fun looksLikeHtml_plainTextIsNot() {
        assertFalse(HtmlImport.looksLikeHtml("这是一段普通中文文本，没有任何标签。"))
    }

    @Test
    fun looksLikeHtml_singleTagIsNotEnough() {
        assertFalse(HtmlImport.looksLikeHtml("价格 < 100 且 > 50"))
    }

    @Test
    fun chineseArticleSurvivesRoundTrip() {
        val html = """
            <html><body>
            <h2>间隔重复</h2>
            <p>人的记忆不是一次成型的。</p>
            <p>只有在即将遗忘时回忆，记忆才会加固。</p>
            </body></html>
        """.trimIndent()
        val out = requireNotNull(HtmlImport.toPlainText(html))
        assertTrue(out.contains("间隔重复"))
        assertTrue(out.contains("记忆不是一次成型的"))
        assertTrue(out.contains("只有在即将遗忘时回忆"))
    }
}