package com.smreader.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Where the reader was left.
 *
 * A character offset is stored rather than a pixel scroll value: pixels break as
 * soon as font size or screen width changes, an offset survives both.
 */
@Entity(tableName = "reading_positions")
data class ReadingPosition(
    @PrimaryKey val elementId: Long,
    val offset: Int,
    val updatedAt: Long = System.currentTimeMillis()
)
