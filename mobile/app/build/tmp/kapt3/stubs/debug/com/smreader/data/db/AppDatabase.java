package com.smreader.data.db;

import android.content.Context;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverters;
import com.smreader.data.model.Element;
import com.smreader.data.model.ReadingPosition;

@kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\'\u0018\u0000 \b2\u00020\u0001:\u0001\bB\u0007\u00a2\u0006\u0004\b\u0002\u0010\u0003J\b\u0010\u0004\u001a\u00020\u0005H&J\b\u0010\u0006\u001a\u00020\u0007H&\u00a8\u0006\t"}, d2 = {"Lcom/smreader/data/db/AppDatabase;", "Landroidx/room/RoomDatabase;", "<init>", "()V", "elementDao", "Lcom/smreader/data/db/ElementDao;", "readingPositionDao", "Lcom/smreader/data/db/ReadingPositionDao;", "Companion", "app_debug"})
@androidx.room.Database(entities = {com.smreader.data.model.Element.class, com.smreader.data.model.ReadingPosition.class}, version = 1, exportSchema = false)
@androidx.room.TypeConverters(value = {com.smreader.data.db.Converters.class})
public abstract class AppDatabase extends androidx.room.RoomDatabase {
    @kotlin.jvm.Volatile()
    @org.jetbrains.annotations.Nullable()
    private static volatile com.smreader.data.db.AppDatabase inst;
    @org.jetbrains.annotations.NotNull()
    public static final com.smreader.data.db.AppDatabase.Companion Companion = null;
    
    public AppDatabase() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public abstract com.smreader.data.db.ElementDao elementDao();
    
    @org.jetbrains.annotations.NotNull()
    public abstract com.smreader.data.db.ReadingPositionDao readingPositionDao();
    
    @kotlin.Metadata(mv = {2, 2, 0}, k = 1, xi = 48, d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002\u00a2\u0006\u0004\b\u0002\u0010\u0003J\u000e\u0010\u0006\u001a\u00020\u00052\u0006\u0010\u0007\u001a\u00020\bJ\u000e\u0010\t\u001a\u00020\u00052\u0006\u0010\u0007\u001a\u00020\bR\u0010\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0082\u000e\u00a2\u0006\u0002\n\u0000\u00a8\u0006\n"}, d2 = {"Lcom/smreader/data/db/AppDatabase$Companion;", "", "<init>", "()V", "inst", "Lcom/smreader/data/db/AppDatabase;", "get", "context", "Landroid/content/Context;", "inMemory", "app_debug"})
    public static final class Companion {
        
        private Companion() {
            super();
        }
        
        @org.jetbrains.annotations.NotNull()
        public final com.smreader.data.db.AppDatabase get(@org.jetbrains.annotations.NotNull()
        android.content.Context context) {
            return null;
        }
        
        /**
         * For tests: an in-memory database that dies with the process.
         */
        @org.jetbrains.annotations.NotNull()
        public final com.smreader.data.db.AppDatabase inMemory(@org.jetbrains.annotations.NotNull()
        android.content.Context context) {
            return null;
        }
    }
}