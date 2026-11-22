package com.smreader.data.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Transaction
import androidx.room.Update
import com.smreader.data.model.Element
import com.smreader.data.model.ElementType
import com.smreader.data.model.ReadingPosition
import kotlinx.coroutines.flow.Flow

@Dao
interface ElementDao {

    @Query("SELECT * FROM elements WHERE type = :type ORDER BY createdAt DESC")
    fun observeByType(type: ElementType): Flow<List<Element>>

    @Query("SELECT * FROM elements WHERE parentId IS NULL ORDER BY createdAt DESC")
    fun observeRoots(): Flow<List<Element>>

    /** Every element, ordered so the tree can be built in one pass. */
    @Query("SELECT * FROM elements ORDER BY parentId IS NULL DESC, parentId, sortKey, id")
    fun observeAll(): Flow<List<Element>>

    @Query("SELECT * FROM elements ORDER BY parentId IS NULL DESC, parentId, sortKey, id")
    suspend fun all(): List<Element>

    @Query("SELECT * FROM elements WHERE id = :id")
    suspend fun findById(id: Long): Element?

    @Query("SELECT * FROM elements WHERE id = :id")
    fun observeById(id: Long): Flow<Element?>

    @Query("SELECT * FROM elements WHERE rootId = :rootId ORDER BY sortKey, id")
    suspend fun treeOf(rootId: Long): List<Element>

    @Query("SELECT COUNT(*) FROM elements WHERE parentId = :parentId")
    suspend fun childCount(parentId: Long): Int

    @Query("SELECT * FROM elements WHERE parentId = :parentId ORDER BY sortKey, id")
    fun observeChildren(parentId: Long): Flow<List<Element>>

    @Query("SELECT * FROM elements WHERE parentId = :parentId ORDER BY sortKey, id")
    suspend fun childrenOf(parentId: Long): List<Element>

    @Query("SELECT COALESCE(MAX(sortKey), -1) FROM elements WHERE parentId = :parentId")
    suspend fun maxSortKey(parentId: Long): Int

    @Insert
    suspend fun insert(e: Element): Long

    @Update
    suspend fun update(e: Element)

    @Query("DELETE FROM elements WHERE id = :id")
    suspend fun deleteById(id: Long)

    /** Insert an article and, in the same transaction, point its rootId at itself. */
    @Transaction
    suspend fun insertRoot(e: Element): Long {
        val id = insert(e.copy(rootId = 0))
        val saved = findById(id) ?: return id
        update(saved.copy(rootId = id))
        return id
    }
}

@Dao
interface ReadingPositionDao {

    @Query("SELECT * FROM reading_positions WHERE elementId = :elementId")
    suspend fun find(elementId: Long): ReadingPosition?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(p: ReadingPosition)

    @Query("DELETE FROM reading_positions WHERE elementId = :elementId")
    suspend fun delete(elementId: Long)
}
