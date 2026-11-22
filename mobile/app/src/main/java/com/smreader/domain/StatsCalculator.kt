package com.smreader.domain

import com.smreader.data.model.Element
import com.smreader.data.model.ElementType

/** Collection statistics, matching what SuperMemo shows in its statistics view. */
data class CollectionStats(
    val total: Int,
    val topics: Int,
    val items: Int,
    val rootCount: Int,
    val totalChars: Int,
    val longestTitle: String,
    val longestChars: Int,
    val depthMax: Int,
    val emptyBodies: Int
)

object StatsCalculator {

    fun of(all: List<Element>): CollectionStats {
        if (all.isEmpty()) {
            return CollectionStats(0, 0, 0, 0, 0, "", 0, 0, 0)
        }
        val topics = all.count { it.type == ElementType.TOPIC }
        val items = all.count { it.type == ElementType.ITEM }
        val roots = all.count { it.parentId == null }
        val totalChars = all.sumOf { it.body.length }
        val longest = all.maxByOrNull { it.body.length }
        return CollectionStats(
            total = all.size,
            topics = topics,
            items = items,
            rootCount = roots,
            totalChars = totalChars,
            longestTitle = longest?.title ?: "",
            longestChars = longest?.body?.length ?: 0,
            depthMax = depthOf(all),
            emptyBodies = all.count { it.body.isBlank() }
        )
    }

    /** Deepest nesting level, 1 when only roots exist. */
    private fun depthOf(all: List<Element>): Int {
        val byId = all.associateBy { it.id }
        var max = 0
        for (e in all) {
            var d = 1
            var p = e.parentId
            var guard = 0
            while (p != null && guard < 100) {
                p = byId[p]?.parentId
                d++
                guard++
            }
            if (d > max) max = d
        }
        return max
    }
}