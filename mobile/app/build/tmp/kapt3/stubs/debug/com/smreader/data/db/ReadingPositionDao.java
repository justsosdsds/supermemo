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

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\bg\u0018\u00002\u00020\u0001J\u0018\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u00a7@\u00a2\u0006\u0002\u0010\u0006J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0003H\u00a7@\u00a2\u0006\u0002\u0010\nJ\u0016\u0010\u000b\u001a\u00020\b2\u0006\u0010\u0004\u001a\u00020\u0005H\u00a7@\u00a2\u0006\u0002\u0010\u0006\u00a8\u0006\f\u00c0\u0006\u0003"}, d2 = {"Lcom/smreader/data/db/ReadingPositionDao;", "", "find", "Lcom/smreader/data/model/ReadingPosition;", "elementId", "", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "upsert", "", "p", "(Lcom/smreader/data/model/ReadingPosition;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "delete", "app_debug"})
@androidx.room.Dao()
public abstract interface ReadingPositionDao {
    
    @androidx.room.Query(value = "SELECT * FROM reading_positions WHERE elementId = :elementId")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object find(long elementId, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super com.smreader.data.model.ReadingPosition> $completion);
    
    @androidx.room.Insert(onConflict = 1)
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object upsert(@org.jetbrains.annotations.NotNull()
    com.smreader.data.model.ReadingPosition p, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM reading_positions WHERE elementId = :elementId")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object delete(long elementId, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
}