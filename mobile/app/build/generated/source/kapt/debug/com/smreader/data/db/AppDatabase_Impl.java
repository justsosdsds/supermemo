package com.smreader.data.db;

import androidx.annotation.NonNull;
import androidx.room.InvalidationTracker;
import androidx.room.RoomOpenDelegate;
import androidx.room.migration.AutoMigrationSpec;
import androidx.room.migration.Migration;
import androidx.room.util.DBUtil;
import androidx.room.util.TableInfo;
import androidx.sqlite.SQLite;
import androidx.sqlite.SQLiteConnection;
import java.lang.Class;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.processing.Generated;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation", "removal"})
public final class AppDatabase_Impl extends AppDatabase {
  private volatile ElementDao _elementDao;

  private volatile ReadingPositionDao _readingPositionDao;

  @Override
  @NonNull
  protected RoomOpenDelegate createOpenDelegate() {
    final RoomOpenDelegate _openDelegate = new RoomOpenDelegate(1, "493d41d660f2638f4bad88b4110dd822", "775f9eb62733e7b3f87f570340fd5c2a") {
      @Override
      public void createAllTables(@NonNull final SQLiteConnection connection) {
        SQLite.execSQL(connection, "CREATE TABLE IF NOT EXISTS `elements` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `type` TEXT NOT NULL, `parentId` INTEGER, `rootId` INTEGER NOT NULL, `title` TEXT NOT NULL, `body` TEXT NOT NULL, `answer` TEXT, `sourceFrom` INTEGER, `sourceTo` INTEGER, `createdAt` INTEGER NOT NULL, `sortKey` INTEGER NOT NULL)");
        SQLite.execSQL(connection, "CREATE INDEX IF NOT EXISTS `index_elements_parentId` ON `elements` (`parentId`)");
        SQLite.execSQL(connection, "CREATE INDEX IF NOT EXISTS `index_elements_rootId` ON `elements` (`rootId`)");
        SQLite.execSQL(connection, "CREATE INDEX IF NOT EXISTS `index_elements_type` ON `elements` (`type`)");
        SQLite.execSQL(connection, "CREATE TABLE IF NOT EXISTS `reading_positions` (`elementId` INTEGER NOT NULL, `offset` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, PRIMARY KEY(`elementId`))");
        SQLite.execSQL(connection, "CREATE TABLE IF NOT EXISTS room_master_table (id INTEGER PRIMARY KEY,identity_hash TEXT)");
        SQLite.execSQL(connection, "INSERT OR REPLACE INTO room_master_table (id,identity_hash) VALUES(42, '493d41d660f2638f4bad88b4110dd822')");
      }

      @Override
      public void dropAllTables(@NonNull final SQLiteConnection connection) {
        SQLite.execSQL(connection, "DROP TABLE IF EXISTS `elements`");
        SQLite.execSQL(connection, "DROP TABLE IF EXISTS `reading_positions`");
      }

      @Override
      public void onCreate(@NonNull final SQLiteConnection connection) {
      }

      @Override
      public void onOpen(@NonNull final SQLiteConnection connection) {
        internalInitInvalidationTracker(connection);
      }

      @Override
      public void onPreMigrate(@NonNull final SQLiteConnection connection) {
        DBUtil.dropFtsSyncTriggers(connection);
      }

      @Override
      public void onPostMigrate(@NonNull final SQLiteConnection connection) {
      }

      @Override
      @NonNull
      public RoomOpenDelegate.ValidationResult onValidateSchema(
          @NonNull final SQLiteConnection connection) {
        final Map<String, TableInfo.Column> _columnsElements = new HashMap<String, TableInfo.Column>(11);
        _columnsElements.put("id", new TableInfo.Column("id", "INTEGER", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("type", new TableInfo.Column("type", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("parentId", new TableInfo.Column("parentId", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("rootId", new TableInfo.Column("rootId", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("title", new TableInfo.Column("title", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("body", new TableInfo.Column("body", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("answer", new TableInfo.Column("answer", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("sourceFrom", new TableInfo.Column("sourceFrom", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("sourceTo", new TableInfo.Column("sourceTo", "INTEGER", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("createdAt", new TableInfo.Column("createdAt", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsElements.put("sortKey", new TableInfo.Column("sortKey", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final Set<TableInfo.ForeignKey> _foreignKeysElements = new HashSet<TableInfo.ForeignKey>(0);
        final Set<TableInfo.Index> _indicesElements = new HashSet<TableInfo.Index>(3);
        _indicesElements.add(new TableInfo.Index("index_elements_parentId", false, Arrays.asList("parentId"), Arrays.asList("ASC")));
        _indicesElements.add(new TableInfo.Index("index_elements_rootId", false, Arrays.asList("rootId"), Arrays.asList("ASC")));
        _indicesElements.add(new TableInfo.Index("index_elements_type", false, Arrays.asList("type"), Arrays.asList("ASC")));
        final TableInfo _infoElements = new TableInfo("elements", _columnsElements, _foreignKeysElements, _indicesElements);
        final TableInfo _existingElements = TableInfo.read(connection, "elements");
        if (!_infoElements.equals(_existingElements)) {
          return new RoomOpenDelegate.ValidationResult(false, "elements(com.smreader.data.model.Element).\n"
                  + " Expected:\n" + _infoElements + "\n"
                  + " Found:\n" + _existingElements);
        }
        final Map<String, TableInfo.Column> _columnsReadingPositions = new HashMap<String, TableInfo.Column>(3);
        _columnsReadingPositions.put("elementId", new TableInfo.Column("elementId", "INTEGER", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsReadingPositions.put("offset", new TableInfo.Column("offset", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsReadingPositions.put("updatedAt", new TableInfo.Column("updatedAt", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final Set<TableInfo.ForeignKey> _foreignKeysReadingPositions = new HashSet<TableInfo.ForeignKey>(0);
        final Set<TableInfo.Index> _indicesReadingPositions = new HashSet<TableInfo.Index>(0);
        final TableInfo _infoReadingPositions = new TableInfo("reading_positions", _columnsReadingPositions, _foreignKeysReadingPositions, _indicesReadingPositions);
        final TableInfo _existingReadingPositions = TableInfo.read(connection, "reading_positions");
        if (!_infoReadingPositions.equals(_existingReadingPositions)) {
          return new RoomOpenDelegate.ValidationResult(false, "reading_positions(com.smreader.data.model.ReadingPosition).\n"
                  + " Expected:\n" + _infoReadingPositions + "\n"
                  + " Found:\n" + _existingReadingPositions);
        }
        return new RoomOpenDelegate.ValidationResult(true, null);
      }
    };
    return _openDelegate;
  }

  @Override
  @NonNull
  protected InvalidationTracker createInvalidationTracker() {
    final Map<String, String> _shadowTablesMap = new HashMap<String, String>(0);
    final Map<String, Set<String>> _viewTables = new HashMap<String, Set<String>>(0);
    return new InvalidationTracker(this, _shadowTablesMap, _viewTables, "elements", "reading_positions");
  }

  @Override
  public void clearAllTables() {
    super.performClear(false, "elements", "reading_positions");
  }

  @Override
  @NonNull
  protected Map<Class<?>, List<Class<?>>> getRequiredTypeConverters() {
    final Map<Class<?>, List<Class<?>>> _typeConvertersMap = new HashMap<Class<?>, List<Class<?>>>();
    _typeConvertersMap.put(ElementDao.class, ElementDao_Impl.getRequiredConverters());
    _typeConvertersMap.put(ReadingPositionDao.class, ReadingPositionDao_Impl.getRequiredConverters());
    return _typeConvertersMap;
  }

  @Override
  @NonNull
  public Set<Class<? extends AutoMigrationSpec>> getRequiredAutoMigrationSpecs() {
    final Set<Class<? extends AutoMigrationSpec>> _autoMigrationSpecsSet = new HashSet<Class<? extends AutoMigrationSpec>>();
    return _autoMigrationSpecsSet;
  }

  @Override
  @NonNull
  public List<Migration> getAutoMigrations(
      @NonNull final Map<Class<? extends AutoMigrationSpec>, AutoMigrationSpec> autoMigrationSpecs) {
    final List<Migration> _autoMigrations = new ArrayList<Migration>();
    return _autoMigrations;
  }

  @Override
  public ElementDao elementDao() {
    if (_elementDao != null) {
      return _elementDao;
    } else {
      synchronized(this) {
        if(_elementDao == null) {
          _elementDao = new ElementDao_Impl(this);
        }
        return _elementDao;
      }
    }
  }

  @Override
  public ReadingPositionDao readingPositionDao() {
    if (_readingPositionDao != null) {
      return _readingPositionDao;
    } else {
      synchronized(this) {
        if(_readingPositionDao == null) {
          _readingPositionDao = new ReadingPositionDao_Impl(this);
        }
        return _readingPositionDao;
      }
    }
  }
}
