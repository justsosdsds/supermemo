package com.smreader.data.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

/** Element kinds. A whole article is a topic; a cloze or Q&A card is an item. */
enum class ElementType { TOPIC, ITEM }

/**
 * One node of the knowledge tree.
 *
 * A root article: parentId == null, sourceFrom/sourceTo == null.
 * An extracted child: parentId points at the source element, and
 * sourceFrom/sourceTo record the character range inside the parent's body, so
 * "go to origin" can scroll back to the exact spot.
 */
@Entity(
    tableName = "elements",
    indices = [Index("parentId"), Index("rootId"), Index("type")]
)
data class Element(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val type: ElementType,
    val parentId: Long? = null,
    val rootId: Long = 0,
    val title: String,
    val body: String,
    val answer: String? = null,
    val sourceFrom: Int? = null,
    val sourceTo: Int? = null,
    /** Encoded formatting spans from HtmlImport.SpanCodec; empty for plain text. */
    val spans: String = "",
    val createdAt: Long = System.currentTimeMillis(),
    val sortKey: Int = 0
)
