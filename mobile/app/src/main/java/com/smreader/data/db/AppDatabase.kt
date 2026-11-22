package com.smreader.data.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.smreader.data.model.Element
import com.smreader.data.model.ReadingPosition

@Database(
    entities = [Element::class, ReadingPosition::class],
    version = 2,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {

    abstract fun elementDao(): ElementDao
    abstract fun readingPositionDao(): ReadingPositionDao

    companion object {
        @Volatile private var inst: AppDatabase? = null

        /**
         * v1 -> v2: add the formatting-span column.
         *
         * Written as an additive ALTER TABLE. Destructive fallback is deliberately
         * NOT enabled anywhere: a schema slip must fail loudly, never wipe the
         * user's articles.
         */
        val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL("ALTER TABLE elements ADD COLUMN spans TEXT NOT NULL DEFAULT ''")
            }
        }

        fun get(context: Context): AppDatabase =
            inst ?: synchronized(this) {
                inst ?: Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "smreader.db"
                )
                    .addMigrations(MIGRATION_1_2)
                    .build()
                    .also { inst = it }
            }

        /** For tests: an in-memory database that dies with the process. */
        fun inMemory(context: Context): AppDatabase =
            Room.inMemoryDatabaseBuilder(context, AppDatabase::class.java)
                .allowMainThreadQueries()
                .build()
    }
}