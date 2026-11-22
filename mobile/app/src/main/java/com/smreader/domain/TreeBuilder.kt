package com.smreader.domain

import com.smreader.data.model.Element
import com.smreader.data.model.ElementType

/**
 * One row of the contents tree.
 *
 * The tree is flattened on demand so a LazyColumn can render it: rows carry
 * their depth and whether they have children, which is all the UI needs.
 */
data class TreeRow(
    val element: Element,
    val depth: Int,
    val childCount: Int,
    val expanded: Boolean
) {
    val hasChildren: Boolean get() = childCount > 0
}

/**
 * Flatten elements into display rows.
 *
 * [collapsed] holds ids whose children must be hidden. Rows whose ancestors are
 * all expanded are included; anything deeper is skipped.
 */
object TreeBuilder {

    fun flatten(
        all: List<Element>,
        collapsed: Set<Long> = emptySet()
    ): List<TreeRow> {
        if (all.isEmpty()) return emptyList()

        val byParent = all.groupBy { it.parentId }
        val childCount = all.groupingBy { it.parentId }.eachCount()
        val out = mutableListOf<TreeRow>()

        fun emit(parent: Long?, depth: Int) {
            val kids = byParent[parent] ?: return
            // roots keep their query order; siblings are ordered by sortKey then id
            val ordered = if (parent == null) kids else kids.sortedWith(compareBy({ it.sortKey }, { it.id }))
            for (e in ordered) {
                val count = childCount[e.id] ?: 0
                val expanded = e.id !in collapsed
                out.add(TreeRow(e, depth, count, expanded))
                if (count > 0 && expanded) emit(e.id, depth + 1)
            }
        }

        emit(null, 0)
        return out
    }

    /** Total number of descendants, used for the summary line. */
    fun descendantCount(all: List<Element>, id: Long): Int {
        val byParent = all.groupBy { it.parentId }
        fun count(parent: Long, guard: Int = 0): Int {
            if (guard > 50) return 0
            return (byParent[parent] ?: emptyList()).sumOf { 1 + count(it.id, guard + 1) }
        }
        return count(id)
    }

    /** Symbol shown in front of a row, matching the type distinction. */
    fun glyph(type: ElementType, hasChildren: Boolean): String = when {
        type == ElementType.ITEM -> "\uD83D\uDCC4"                      // 📄
        hasChildren -> "\uD83D\uDCDA"                                   // 📚
        else -> "\uD83D\uDCD6"                                          // 📖
    }
}