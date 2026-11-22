package com.smreader

import com.smreader.domain.SelectionOps
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class SelectionOpsTest {

    private val body = "第一段：STM32 小车需要保存障碍物距离。\n第二段：左轮目标转速。\n第三段：结束。"

    @Test
    fun of_returnsSelectionForValidRange() {
        val s = requireNotNull(SelectionOps.of(body, 0, 5))
        assertEquals("第一段：S", s.text)
        assertEquals(0, s.start)
        assertEquals(5, s.end)
    }

    @Test
    fun of_rejectsEmptyRange() {
        assertNull(SelectionOps.of(body, 3, 3))
    }

    @Test
    fun of_rejectsReversedRangeByNormalising() {
        val s = requireNotNull(SelectionOps.of(body, 5, 2))
        assertEquals(2, s.start)
        assertEquals(5, s.end)
    }

    @Test
    fun of_clampsOutOfBounds() {
        val s = requireNotNull(SelectionOps.of(body, -10, body.length + 100))
        assertEquals(0, s.start)
        assertEquals(body.length, s.end)
    }

    @Test
    fun trimmed_removesLeadingAndTrailingWhitespaceAndKeepsOffsets() {
        val raw = "  STM32 小车  "
        val s = requireNotNull(SelectionOps.trimmed(body, 4, 4 + raw.length))
        assertEquals("STM32 小车", s.text)
        // offsets must still point into the original body
        assertEquals("STM32 小车", body.substring(s.start, s.end))
    }

    @Test
    fun trimmed_returnsNullForAllWhitespace() {
        assertNull(SelectionOps.trimmed(body, 0, 0))
    }

    @Test
    fun titleOf_usesFirstNonBlankLine() {
        val multi = "\n  障碍物距离  \n左轮转速"
        assertEquals("障碍物距离", SelectionOps.titleOf(multi))
    }

    @Test
    fun titleOf_capsLongText() {
        val long = "字".repeat(100)
        val t = SelectionOps.titleOf(long, maxLen = 10)
        assertEquals(11, t.length)
        assertTrue(t.endsWith("…"))
    }

    @Test
    fun excerpt_collapsesNewlines() {
        val e = SelectionOps.excerpt("A\nB\nC")
        assertEquals("A B C", e)
    }

    @Test
    fun extractRange_pointsAtSameTextAfterTrim() {
        // selecting a whole paragraph including its trailing newline
        val start = body.indexOf("第二段")
        val end = body.indexOf("\n第三段")
        val s = requireNotNull(SelectionOps.trimmed(body, start, end))
        assertEquals("第二段：左轮目标转速。", s.text)
        assertEquals(start, s.start)
    }
}