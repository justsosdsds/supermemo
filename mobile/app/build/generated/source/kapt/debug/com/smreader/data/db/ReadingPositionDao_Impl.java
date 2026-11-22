package com.smreader.data.db;

import androidx.annotation.NonNull;
import androidx.room.EntityInsertAdapter;
import androidx.room.RoomDatabase;
import androidx.room.util.DBUtil;
import androidx.room.util.SQLiteStatementUtil;
import androidx.sqlite.SQLiteStatement;
import com.smreader.data.model.ReadingPosition;
import java.lang.Class;
import java.lang.NullPointerException;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.Collections;
import java.util.List;
import javax.annotation.processing.Generated;
import kotlin.Unit;
import kotlin.coroutines.Continuation;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation", "removal"})
public final class ReadingPositionDao_Impl implements ReadingPositionDao {
  private final RoomDatabase __db;

  private final EntityInsertAdapter<ReadingPosition> __insertAdapterOfReadingPosition;

  public ReadingPositionDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertAdapterOfReadingPosition = new EntityInsertAdapter<ReadingPosition>() {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `reading_positions` (`elementId`,`offset`,`updatedAt`) VALUES (?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SQLiteStatement statement,
          @NonNull final ReadingPosition entity) {
        statement.bindLong(1, entity.getElementId());
        statement.bindLong(2, entity.getOffset());
        statement.bindLong(3, entity.getUpdatedAt());
      }
    };
  }

  @Override
  public Object upsert(final ReadingPosition p, final Continuation<? super Unit> $completion) {
    if (p == null) throw new NullPointerException();
    return DBUtil.performSuspending(__db, false, true, (_connection) -> {
      __insertAdapterOfReadingPosition.insert(_connection, p);
      return Unit.INSTANCE;
    }, $completion);
  }

  @Override
  public Object find(final long elementId,
      final Continuation<? super ReadingPosition> $completion) {
    final String _sql = "SELECT * FROM reading_positions WHERE elementId = ?";
    return DBUtil.performSuspending(__db, true, false, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, elementId);
        final int _columnIndexOfElementId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "elementId");
        final int _columnIndexOfOffset = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "offset");
        final int _columnIndexOfUpdatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "updatedAt");
        final ReadingPosition _result;
        if (_stmt.step()) {
          final long _tmpElementId;
          _tmpElementId = _stmt.getLong(_columnIndexOfElementId);
          final int _tmpOffset;
          _tmpOffset = (int) (_stmt.getLong(_columnIndexOfOffset));
          final long _tmpUpdatedAt;
          _tmpUpdatedAt = _stmt.getLong(_columnIndexOfUpdatedAt);
          _result = new ReadingPosition(_tmpElementId,_tmpOffset,_tmpUpdatedAt);
        } else {
          _result = null;
        }
        return _result;
      } finally {
        _stmt.close();
      }
    }, $completion);
  }

  @Override
  public Object delete(final long elementId, final Continuation<? super Unit> $completion) {
    final String _sql = "DELETE FROM reading_positions WHERE elementId = ?";
    return DBUtil.performSuspending(__db, false, true, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, elementId);
        _stmt.step();
        return Unit.INSTANCE;
      } finally {
        _stmt.close();
      }
    }, $completion);
  }

  @NonNull
  public static List<Class<?>> getRequiredConverters() {
    return Collections.emptyList();
  }
}
