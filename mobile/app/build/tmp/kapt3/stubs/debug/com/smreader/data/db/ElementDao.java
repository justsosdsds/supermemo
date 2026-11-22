package com.smreader.data.db;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Transaction;
import androidx.room.Update;
import com.smreader.data.model.Element;
import com.smreader.data.model.ElementType;
import com.smreader.data.model.ReadingPosition;
import kotlinx.coroutines.flow.Flow;

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0003\bg\u0018\u00002\u00020\u0001J\u001c\u0010\u0002\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u00032\u0006\u0010\u0006\u001a\u00020\u0007H\'J\u0014\u0010\b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u0003H\'J\u0018\u0010\t\u001a\u0004\u0018\u00010\u00052\u0006\u0010\n\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\fJ\u0018\u0010\r\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u00032\u0006\u0010\n\u001a\u00020\u000bH\'J\u001c\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u000f\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\fJ\u0016\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\fJ\u0016\u0010\u0013\u001a\u00020\u000b2\u0006\u0010\u0014\u001a\u00020\u0005H\u00a7@\u00a2\u0006\u0002\u0010\u0015J\u0016\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0014\u001a\u00020\u0005H\u00a7@\u00a2\u0006\u0002\u0010\u0015J\u0016\u0010\u0018\u001a\u00020\u00172\u0006\u0010\n\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\fJ\u0016\u0010\u0019\u001a\u00020\u000b2\u0006\u0010\u0014\u001a\u00020\u0005H\u0097@\u00a2\u0006\u0002\u0010\u0015\u00a8\u0006\u001a\u00c0\u0006\u0003"}, d2 = {"Lcom/smreader/data/db/ElementDao;", "", "observeByType", "Lkotlinx/coroutines/flow/Flow;", "", "Lcom/smreader/data/model/Element;", "type", "Lcom/smreader/data/model/ElementType;", "observeRoots", "findById", "id", "", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "observeById", "treeOf", "rootId", "childCount", "", "parentId", "insert", "e", "(Lcom/smreader/data/model/Element;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "update", "", "deleteById", "insertRoot", "app_debug"})
@androidx.room.Dao()
public abstract interface ElementDao {
    
    @androidx.room.Query(value = "SELECT * FROM elements WHERE type = :type ORDER BY createdAt DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.smreader.data.model.Element>> observeByType(@org.jetbrains.annotations.NotNull()
    com.smreader.data.model.ElementType type);
    
    @androidx.room.Query(value = "SELECT * FROM elements WHERE parentId IS NULL ORDER BY createdAt DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.smreader.data.model.Element>> observeRoots();
    
    @androidx.room.Query(value = "SELECT * FROM elements WHERE id = :id")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object findById(long id, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super com.smreader.data.model.Element> $completion);
    
    @androidx.room.Query(value = "SELECT * FROM elements WHERE id = :id")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<com.smreader.data.model.Element> observeById(long id);
    
    @androidx.room.Query(value = "SELECT * FROM elements WHERE rootId = :rootId ORDER BY sortKey, id")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object treeOf(long rootId, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.util.List<com.smreader.data.model.Element>> $completion);
    
    @androidx.room.Query(value = "SELECT COUNT(*) FROM elements WHERE parentId = :parentId")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object childCount(long parentId, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.lang.Integer> $completion);
    
    @androidx.room.Insert()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object insert(@org.jetbrains.annotations.NotNull()
    com.smreader.data.model.Element e, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.lang.Long> $completion);
    
    @androidx.room.Update()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object update(@org.jetbrains.annotations.NotNull()
    com.smreader.data.model.Element e, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM elements WHERE id = :id")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object deleteById(long id, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    /**
     * Insert an article and, in the same transaction, point its rootId at itself.
     */
    @androidx.room.Transaction()
    @org.jetbrains.annotations.Nullable()
    public default java.lang.Object insertRoot(@org.jetbrains.annotations.NotNull()
    com.smreader.data.model.Element e, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.lang.Long> $completion) {
        return null;
    }
    
    @kotlin.Metadata(mv = {2, 2, 0}, k = 3, xi = 48)
    public static final class DefaultImpls {
        
        /**
         * Insert an article and, in the same transaction, point its rootId at itself.
         */
        @androidx.room.Transaction()
        @org.jetbrains.annotations.Nullable()
        @java.lang.Deprecated()
        public static java.lang.Object insertRoot(@org.jetbrains.annotations.NotNull()
        com.smreader.data.db.ElementDao $this, @org.jetbrains.annotations.NotNull()
        com.smreader.data.model.Element e, @org.jetbrains.annotations.NotNull()
        kotlin.coroutines.Continuation<? super java.lang.Long> $completion) {
            return null;
        }
    }
}