package com.smreader

import com.smreader.domain.TextImport
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class TextImportTest {

    @Test
    fun normalise_foldsCrlfAndTrims() {
        assertEquals("A\nB\nC", TextImport.normalise("  A\r\nB\r\nC  "))
    }

    @Test
    fun normalise_foldsLoneCr() {
        assertEquals("A\nB", TextImport.normalise("A\rB"))
    }

    @Test
    fun titleOf_usesFirstNonBlankLine() {
        assertEquals("第一段标题", TextImport.titleOf("\n\n第一段标题\n第二段"))
    }

    @Test
    fun titleOf_capsLongLine() {
        val long = "字".repeat(200)
        val t = TextImport.titleOf(long)
        assertEquals(81, t.length)   // 80 chars + ellipsis
        assertTrue(t.endsWith("…"))
    }

    @Test
    fun titleOf_blankFallsBack() {
        assertEquals("Untitled", TextImport.titleOf("   \n  \n"))
    }

    @Test
    fun decode_prefersUtf8() {
        val s = "中文内容"
        assertEquals(s, TextImport.decode(s.toByteArray(Charsets.UTF_8)))
    }

    @Test
    fun decode_fallsBackForInvalidUtf8() {
        // GBK bytes for 中文 are not valid UTF-8
        val gbk = byteArrayOf(0xD6.toByte(), 0xD0.toByte(), 0xCE.toByte(), 0xC4.toByte())
        val out = TextImport.decode(gbk, "GBK")
        assertEquals("中文", out)
    }

    @Test
    fun paragraphs_offsetsAreCorrect() {
        val body = "abc\ndefg\nhi"
        val p = TextImport.paragraphs(body)
        assertEquals(listOf(0 to "abc", 4 to "defg", 9 to "hi"), p)
    }
}