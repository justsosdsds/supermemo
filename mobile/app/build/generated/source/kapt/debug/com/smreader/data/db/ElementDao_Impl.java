package com.smreader.data.db;

import androidx.annotation.NonNull;
import androidx.room.EntityDeleteOrUpdateAdapter;
import androidx.room.EntityInsertAdapter;
import androidx.room.RoomDatabase;
import androidx.room.coroutines.FlowUtil;
import androidx.room.util.DBUtil;
import androidx.room.util.SQLiteStatementUtil;
import androidx.sqlite.SQLiteStatement;
import com.smreader.data.model.Element;
import com.smreader.data.model.ElementType;
import java.lang.Class;
import java.lang.Integer;
import java.lang.Long;
import java.lang.NullPointerException;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.annotation.processing.Generated;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.Flow;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation", "removal"})
public final class ElementDao_Impl implements ElementDao {
  private final RoomDatabase __db;

  private final EntityInsertAdapter<Element> __insertAdapterOfElement;

  private final Converters __converters = new Converters();

  private final EntityDeleteOrUpdateAdapter<Element> __updateAdapterOfElement;

  public ElementDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertAdapterOfElement = new EntityInsertAdapter<Element>() {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR ABORT INTO `elements` (`id`,`type`,`parentId`,`rootId`,`title`,`body`,`answer`,`sourceFrom`,`sourceTo`,`createdAt`,`sortKey`) VALUES (nullif(?, 0),?,?,?,?,?,?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SQLiteStatement statement, @NonNull final Element entity) {
        statement.bindLong(1, entity.getId());
        final String _tmp = __converters.fromType(entity.getType());
        if (_tmp == null) {
          statement.bindNull(2);
        } else {
          statement.bindText(2, _tmp);
        }
        if (entity.getParentId() == null) {
          statement.bindNull(3);
        } else {
          statement.bindLong(3, entity.getParentId());
        }
        statement.bindLong(4, entity.getRootId());
        if (entity.getTitle() == null) {
          statement.bindNull(5);
        } else {
          statement.bindText(5, entity.getTitle());
        }
        if (entity.getBody() == null) {
          statement.bindNull(6);
        } else {
          statement.bindText(6, entity.getBody());
        }
        if (entity.getAnswer() == null) {
          statement.bindNull(7);
        } else {
          statement.bindText(7, entity.getAnswer());
        }
        if (entity.getSourceFrom() == null) {
          statement.bindNull(8);
        } else {
          statement.bindLong(8, entity.getSourceFrom());
        }
        if (entity.getSourceTo() == null) {
          statement.bindNull(9);
        } else {
          statement.bindLong(9, entity.getSourceTo());
        }
        statement.bindLong(10, entity.getCreatedAt());
        statement.bindLong(11, entity.getSortKey());
      }
    };
    this.__updateAdapterOfElement = new EntityDeleteOrUpdateAdapter<Element>() {
      @Override
      @NonNull
      protected String createQuery() {
        return "UPDATE OR ABORT `elements` SET `id` = ?,`type` = ?,`parentId` = ?,`rootId` = ?,`title` = ?,`body` = ?,`answer` = ?,`sourceFrom` = ?,`sourceTo` = ?,`createdAt` = ?,`sortKey` = ? WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SQLiteStatement statement, @NonNull final Element entity) {
        statement.bindLong(1, entity.getId());
        final String _tmp = __converters.fromType(entity.getType());
        if (_tmp == null) {
          statement.bindNull(2);
        } else {
          statement.bindText(2, _tmp);
        }
        if (entity.getParentId() == null) {
          statement.bindNull(3);
        } else {
          statement.bindLong(3, entity.getParentId());
        }
        statement.bindLong(4, entity.getRootId());
        if (entity.getTitle() == null) {
          statement.bindNull(5);
        } else {
          statement.bindText(5, entity.getTitle());
        }
        if (entity.getBody() == null) {
          statement.bindNull(6);
        } else {
          statement.bindText(6, entity.getBody());
        }
        if (entity.getAnswer() == null) {
          statement.bindNull(7);
        } else {
          statement.bindText(7, entity.getAnswer());
        }
        if (entity.getSourceFrom() == null) {
          statement.bindNull(8);
        } else {
          statement.bindLong(8, entity.getSourceFrom());
        }
        if (entity.getSourceTo() == null) {
          statement.bindNull(9);
        } else {
          statement.bindLong(9, entity.getSourceTo());
        }
        statement.bindLong(10, entity.getCreatedAt());
        statement.bindLong(11, entity.getSortKey());
        statement.bindLong(12, entity.getId());
      }
    };
  }

  @Override
  public Object insert(final Element e, final Continuation<? super Long> $completion) {
    if (e == null) throw new NullPointerException();
    return DBUtil.performSuspending(__db, false, true, (_connection) -> {
      return __insertAdapterOfElement.insertAndReturnId(_connection, e);
    }, $completion);
  }

  @Override
  public Object update(final Element e, final Continuation<? super Unit> $completion) {
    if (e == null) throw new NullPointerException();
    return DBUtil.performSuspending(__db, false, true, (_connection) -> {
      __updateAdapterOfElement.handle(_connection, e);
      return Unit.INSTANCE;
    }, $completion);
  }

  @Override
  public Object insertRoot(final Element e, final Continuation<? super Long> $completion) {
    return DBUtil.performInTransactionSuspending(__db, (_cont) -> {
      return ElementDao.super.insertRoot(e, _cont);
    }, $completion);
  }

  @Override
  public Flow<List<Element>> observeByType(final ElementType type) {
    final String _sql = "SELECT * FROM elements WHERE type = ? ORDER BY createdAt DESC";
    return FlowUtil.createFlow(__db, false, new String[] {"elements"}, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        final String _tmp = __converters.fromType(type);
        if (_tmp == null) {
          _stmt.bindNull(_argIndex);
        } else {
          _stmt.bindText(_argIndex, _tmp);
        }
        final int _columnIndexOfId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "id");
        final int _columnIndexOfType = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "type");
        final int _columnIndexOfParentId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "parentId");
        final int _columnIndexOfRootId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "rootId");
        final int _columnIndexOfTitle = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "title");
        final int _columnIndexOfBody = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "body");
        final int _columnIndexOfAnswer = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "answer");
        final int _columnIndexOfSourceFrom = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceFrom");
        final int _columnIndexOfSourceTo = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceTo");
        final int _columnIndexOfCreatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "createdAt");
        final int _columnIndexOfSortKey = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sortKey");
        final List<Element> _result = new ArrayList<Element>();
        while (_stmt.step()) {
          final Element _item;
          final long _tmpId;
          _tmpId = _stmt.getLong(_columnIndexOfId);
          final ElementType _tmpType;
          final String _tmp_1;
          if (_stmt.isNull(_columnIndexOfType)) {
            _tmp_1 = null;
          } else {
            _tmp_1 = _stmt.getText(_columnIndexOfType);
          }
          _tmpType = __converters.toType(_tmp_1);
          final Long _tmpParentId;
          if (_stmt.isNull(_columnIndexOfParentId)) {
            _tmpParentId = null;
          } else {
            _tmpParentId = _stmt.getLong(_columnIndexOfParentId);
          }
          final long _tmpRootId;
          _tmpRootId = _stmt.getLong(_columnIndexOfRootId);
          final String _tmpTitle;
          if (_stmt.isNull(_columnIndexOfTitle)) {
            _tmpTitle = null;
          } else {
            _tmpTitle = _stmt.getText(_columnIndexOfTitle);
          }
          final String _tmpBody;
          if (_stmt.isNull(_columnIndexOfBody)) {
            _tmpBody = null;
          } else {
            _tmpBody = _stmt.getText(_columnIndexOfBody);
          }
          final String _tmpAnswer;
          if (_stmt.isNull(_columnIndexOfAnswer)) {
            _tmpAnswer = null;
          } else {
            _tmpAnswer = _stmt.getText(_columnIndexOfAnswer);
          }
          final Integer _tmpSourceFrom;
          if (_stmt.isNull(_columnIndexOfSourceFrom)) {
            _tmpSourceFrom = null;
          } else {
            _tmpSourceFrom = (int) (_stmt.getLong(_columnIndexOfSourceFrom));
          }
          final Integer _tmpSourceTo;
          if (_stmt.isNull(_columnIndexOfSourceTo)) {
            _tmpSourceTo = null;
          } else {
            _tmpSourceTo = (int) (_stmt.getLong(_columnIndexOfSourceTo));
          }
          final long _tmpCreatedAt;
          _tmpCreatedAt = _stmt.getLong(_columnIndexOfCreatedAt);
          final int _tmpSortKey;
          _tmpSortKey = (int) (_stmt.getLong(_columnIndexOfSortKey));
          _item = new Element(_tmpId,_tmpType,_tmpParentId,_tmpRootId,_tmpTitle,_tmpBody,_tmpAnswer,_tmpSourceFrom,_tmpSourceTo,_tmpCreatedAt,_tmpSortKey);
          _result.add(_item);
        }
        return _result;
      } finally {
        _stmt.close();
      }
    });
  }

  @Override
  public Flow<List<Element>> observeRoots() {
    final String _sql = "SELECT * FROM elements WHERE parentId IS NULL ORDER BY createdAt DESC";
    return FlowUtil.createFlow(__db, false, new String[] {"elements"}, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        final int _columnIndexOfId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "id");
        final int _columnIndexOfType = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "type");
        final int _columnIndexOfParentId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "parentId");
        final int _columnIndexOfRootId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "rootId");
        final int _columnIndexOfTitle = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "title");
        final int _columnIndexOfBody = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "body");
        final int _columnIndexOfAnswer = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "answer");
        final int _columnIndexOfSourceFrom = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceFrom");
        final int _columnIndexOfSourceTo = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceTo");
        final int _columnIndexOfCreatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "createdAt");
        final int _columnIndexOfSortKey = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sortKey");
        final List<Element> _result = new ArrayList<Element>();
        while (_stmt.step()) {
          final Element _item;
          final long _tmpId;
          _tmpId = _stmt.getLong(_columnIndexOfId);
          final ElementType _tmpType;
          final String _tmp;
          if (_stmt.isNull(_columnIndexOfType)) {
            _tmp = null;
          } else {
            _tmp = _stmt.getText(_columnIndexOfType);
          }
          _tmpType = __converters.toType(_tmp);
          final Long _tmpParentId;
          if (_stmt.isNull(_columnIndexOfParentId)) {
            _tmpParentId = null;
          } else {
            _tmpParentId = _stmt.getLong(_columnIndexOfParentId);
          }
          final long _tmpRootId;
          _tmpRootId = _stmt.getLong(_columnIndexOfRootId);
          final String _tmpTitle;
          if (_stmt.isNull(_columnIndexOfTitle)) {
            _tmpTitle = null;
          } else {
            _tmpTitle = _stmt.getText(_columnIndexOfTitle);
          }
          final String _tmpBody;
          if (_stmt.isNull(_columnIndexOfBody)) {
            _tmpBody = null;
          } else {
            _tmpBody = _stmt.getText(_columnIndexOfBody);
          }
          final String _tmpAnswer;
          if (_stmt.isNull(_columnIndexOfAnswer)) {
            _tmpAnswer = null;
          } else {
            _tmpAnswer = _stmt.getText(_columnIndexOfAnswer);
          }
          final Integer _tmpSourceFrom;
          if (_stmt.isNull(_columnIndexOfSourceFrom)) {
            _tmpSourceFrom = null;
          } else {
            _tmpSourceFrom = (int) (_stmt.getLong(_columnIndexOfSourceFrom));
          }
          final Integer _tmpSourceTo;
          if (_stmt.isNull(_columnIndexOfSourceTo)) {
            _tmpSourceTo = null;
          } else {
            _tmpSourceTo = (int) (_stmt.getLong(_columnIndexOfSourceTo));
          }
          final long _tmpCreatedAt;
          _tmpCreatedAt = _stmt.getLong(_columnIndexOfCreatedAt);
          final int _tmpSortKey;
          _tmpSortKey = (int) (_stmt.getLong(_columnIndexOfSortKey));
          _item = new Element(_tmpId,_tmpType,_tmpParentId,_tmpRootId,_tmpTitle,_tmpBody,_tmpAnswer,_tmpSourceFrom,_tmpSourceTo,_tmpCreatedAt,_tmpSortKey);
          _result.add(_item);
        }
        return _result;
      } finally {
        _stmt.close();
      }
    });
  }

  @Override
  public Object findById(final long id, final Continuation<? super Element> $completion) {
    final String _sql = "SELECT * FROM elements WHERE id = ?";
    return DBUtil.performSuspending(__db, true, false, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, id);
        final int _columnIndexOfId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "id");
        final int _columnIndexOfType = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "type");
        final int _columnIndexOfParentId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "parentId");
        final int _columnIndexOfRootId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "rootId");
        final int _columnIndexOfTitle = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "title");
        final int _columnIndexOfBody = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "body");
        final int _columnIndexOfAnswer = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "answer");
        final int _columnIndexOfSourceFrom = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceFrom");
        final int _columnIndexOfSourceTo = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceTo");
        final int _columnIndexOfCreatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "createdAt");
        final int _columnIndexOfSortKey = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sortKey");
        final Element _result;
        if (_stmt.step()) {
          final long _tmpId;
          _tmpId = _stmt.getLong(_columnIndexOfId);
          final ElementType _tmpType;
          final String _tmp;
          if (_stmt.isNull(_columnIndexOfType)) {
            _tmp = null;
          } else {
            _tmp = _stmt.getText(_columnIndexOfType);
          }
          _tmpType = __converters.toType(_tmp);
          final Long _tmpParentId;
          if (_stmt.isNull(_columnIndexOfParentId)) {
            _tmpParentId = null;
          } else {
            _tmpParentId = _stmt.getLong(_columnIndexOfParentId);
          }
          final long _tmpRootId;
          _tmpRootId = _stmt.getLong(_columnIndexOfRootId);
          final String _tmpTitle;
          if (_stmt.isNull(_columnIndexOfTitle)) {
            _tmpTitle = null;
          } else {
            _tmpTitle = _stmt.getText(_columnIndexOfTitle);
          }
          final String _tmpBody;
          if (_stmt.isNull(_columnIndexOfBody)) {
            _tmpBody = null;
          } else {
            _tmpBody = _stmt.getText(_columnIndexOfBody);
          }
          final String _tmpAnswer;
          if (_stmt.isNull(_columnIndexOfAnswer)) {
            _tmpAnswer = null;
          } else {
            _tmpAnswer = _stmt.getText(_columnIndexOfAnswer);
          }
          final Integer _tmpSourceFrom;
          if (_stmt.isNull(_columnIndexOfSourceFrom)) {
            _tmpSourceFrom = null;
          } else {
            _tmpSourceFrom = (int) (_stmt.getLong(_columnIndexOfSourceFrom));
          }
          final Integer _tmpSourceTo;
          if (_stmt.isNull(_columnIndexOfSourceTo)) {
            _tmpSourceTo = null;
          } else {
            _tmpSourceTo = (int) (_stmt.getLong(_columnIndexOfSourceTo));
          }
          final long _tmpCreatedAt;
          _tmpCreatedAt = _stmt.getLong(_columnIndexOfCreatedAt);
          final int _tmpSortKey;
          _tmpSortKey = (int) (_stmt.getLong(_columnIndexOfSortKey));
          _result = new Element(_tmpId,_tmpType,_tmpParentId,_tmpRootId,_tmpTitle,_tmpBody,_tmpAnswer,_tmpSourceFrom,_tmpSourceTo,_tmpCreatedAt,_tmpSortKey);
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
  public Flow<Element> observeById(final long id) {
    final String _sql = "SELECT * FROM elements WHERE id = ?";
    return FlowUtil.createFlow(__db, false, new String[] {"elements"}, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, id);
        final int _columnIndexOfId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "id");
        final int _columnIndexOfType = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "type");
        final int _columnIndexOfParentId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "parentId");
        final int _columnIndexOfRootId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "rootId");
        final int _columnIndexOfTitle = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "title");
        final int _columnIndexOfBody = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "body");
        final int _columnIndexOfAnswer = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "answer");
        final int _columnIndexOfSourceFrom = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceFrom");
        final int _columnIndexOfSourceTo = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceTo");
        final int _columnIndexOfCreatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "createdAt");
        final int _columnIndexOfSortKey = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sortKey");
        final Element _result;
        if (_stmt.step()) {
          final long _tmpId;
          _tmpId = _stmt.getLong(_columnIndexOfId);
          final ElementType _tmpType;
          final String _tmp;
          if (_stmt.isNull(_columnIndexOfType)) {
            _tmp = null;
          } else {
            _tmp = _stmt.getText(_columnIndexOfType);
          }
          _tmpType = __converters.toType(_tmp);
          final Long _tmpParentId;
          if (_stmt.isNull(_columnIndexOfParentId)) {
            _tmpParentId = null;
          } else {
            _tmpParentId = _stmt.getLong(_columnIndexOfParentId);
          }
          final long _tmpRootId;
          _tmpRootId = _stmt.getLong(_columnIndexOfRootId);
          final String _tmpTitle;
          if (_stmt.isNull(_columnIndexOfTitle)) {
            _tmpTitle = null;
          } else {
            _tmpTitle = _stmt.getText(_columnIndexOfTitle);
          }
          final String _tmpBody;
          if (_stmt.isNull(_columnIndexOfBody)) {
            _tmpBody = null;
          } else {
            _tmpBody = _stmt.getText(_columnIndexOfBody);
          }
          final String _tmpAnswer;
          if (_stmt.isNull(_columnIndexOfAnswer)) {
            _tmpAnswer = null;
          } else {
            _tmpAnswer = _stmt.getText(_columnIndexOfAnswer);
          }
          final Integer _tmpSourceFrom;
          if (_stmt.isNull(_columnIndexOfSourceFrom)) {
            _tmpSourceFrom = null;
          } else {
            _tmpSourceFrom = (int) (_stmt.getLong(_columnIndexOfSourceFrom));
          }
          final Integer _tmpSourceTo;
          if (_stmt.isNull(_columnIndexOfSourceTo)) {
            _tmpSourceTo = null;
          } else {
            _tmpSourceTo = (int) (_stmt.getLong(_columnIndexOfSourceTo));
          }
          final long _tmpCreatedAt;
          _tmpCreatedAt = _stmt.getLong(_columnIndexOfCreatedAt);
          final int _tmpSortKey;
          _tmpSortKey = (int) (_stmt.getLong(_columnIndexOfSortKey));
          _result = new Element(_tmpId,_tmpType,_tmpParentId,_tmpRootId,_tmpTitle,_tmpBody,_tmpAnswer,_tmpSourceFrom,_tmpSourceTo,_tmpCreatedAt,_tmpSortKey);
        } else {
          _result = null;
        }
        return _result;
      } finally {
        _stmt.close();
      }
    });
  }

  @Override
  public Object treeOf(final long rootId, final Continuation<? super List<Element>> $completion) {
    final String _sql = "SELECT * FROM elements WHERE rootId = ? ORDER BY sortKey, id";
    return DBUtil.performSuspending(__db, true, false, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, rootId);
        final int _columnIndexOfId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "id");
        final int _columnIndexOfType = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "type");
        final int _columnIndexOfParentId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "parentId");
        final int _columnIndexOfRootId = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "rootId");
        final int _columnIndexOfTitle = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "title");
        final int _columnIndexOfBody = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "body");
        final int _columnIndexOfAnswer = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "answer");
        final int _columnIndexOfSourceFrom = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceFrom");
        final int _columnIndexOfSourceTo = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sourceTo");
        final int _columnIndexOfCreatedAt = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "createdAt");
        final int _columnIndexOfSortKey = SQLiteStatementUtil.getColumnIndexOrThrow(_stmt, "sortKey");
        final List<Element> _result = new ArrayList<Element>();
        while (_stmt.step()) {
          final Element _item;
          final long _tmpId;
          _tmpId = _stmt.getLong(_columnIndexOfId);
          final ElementType _tmpType;
          final String _tmp;
          if (_stmt.isNull(_columnIndexOfType)) {
            _tmp = null;
          } else {
            _tmp = _stmt.getText(_columnIndexOfType);
          }
          _tmpType = __converters.toType(_tmp);
          final Long _tmpParentId;
          if (_stmt.isNull(_columnIndexOfParentId)) {
            _tmpParentId = null;
          } else {
            _tmpParentId = _stmt.getLong(_columnIndexOfParentId);
          }
          final long _tmpRootId;
          _tmpRootId = _stmt.getLong(_columnIndexOfRootId);
          final String _tmpTitle;
          if (_stmt.isNull(_columnIndexOfTitle)) {
            _tmpTitle = null;
          } else {
            _tmpTitle = _stmt.getText(_columnIndexOfTitle);
          }
          final String _tmpBody;
          if (_stmt.isNull(_columnIndexOfBody)) {
            _tmpBody = null;
          } else {
            _tmpBody = _stmt.getText(_columnIndexOfBody);
          }
          final String _tmpAnswer;
          if (_stmt.isNull(_columnIndexOfAnswer)) {
            _tmpAnswer = null;
          } else {
            _tmpAnswer = _stmt.getText(_columnIndexOfAnswer);
          }
          final Integer _tmpSourceFrom;
          if (_stmt.isNull(_columnIndexOfSourceFrom)) {
            _tmpSourceFrom = null;
          } else {
            _tmpSourceFrom = (int) (_stmt.getLong(_columnIndexOfSourceFrom));
          }
          final Integer _tmpSourceTo;
          if (_stmt.isNull(_columnIndexOfSourceTo)) {
            _tmpSourceTo = null;
          } else {
            _tmpSourceTo = (int) (_stmt.getLong(_columnIndexOfSourceTo));
          }
          final long _tmpCreatedAt;
          _tmpCreatedAt = _stmt.getLong(_columnIndexOfCreatedAt);
          final int _tmpSortKey;
          _tmpSortKey = (int) (_stmt.getLong(_columnIndexOfSortKey));
          _item = new Element(_tmpId,_tmpType,_tmpParentId,_tmpRootId,_tmpTitle,_tmpBody,_tmpAnswer,_tmpSourceFrom,_tmpSourceTo,_tmpCreatedAt,_tmpSortKey);
          _result.add(_item);
        }
        return _result;
      } finally {
        _stmt.close();
      }
    }, $completion);
  }

  @Override
  public Object childCount(final long parentId, final Continuation<? super Integer> $completion) {
    final String _sql = "SELECT COUNT(*) FROM elements WHERE parentId = ?";
    return DBUtil.performSuspending(__db, true, false, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, parentId);
        final Integer _result;
        if (_stmt.step()) {
          final Integer _tmp;
          if (_stmt.isNull(0)) {
            _tmp = null;
          } else {
            _tmp = (int) (_stmt.getLong(0));
          }
          _result = _tmp;
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
  public Object deleteById(final long id, final Continuation<? super Unit> $completion) {
    final String _sql = "DELETE FROM elements WHERE id = ?";
    return DBUtil.performSuspending(__db, false, true, (_connection) -> {
      final SQLiteStatement _stmt = _connection.prepare(_sql);
      try {
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, id);
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
