/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Comment
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Comment._({
    this.id,
    required this.cardId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Comment({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue authorId,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _CommentImpl;

  factory Comment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Comment(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      authorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      content: jsonSerialization['content'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = CommentTable();

  static const db = CommentRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  _i1.UuidValue authorId;

  String content;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Comment copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    _i1.UuidValue? authorId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Comment',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'authorId': authorId.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Comment',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'authorId': authorId.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static CommentInclude include() {
    return CommentInclude._();
  }

  static CommentIncludeList includeList({
    _i1.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentTable>? orderByList,
    CommentInclude? include,
  }) {
    return CommentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Comment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Comment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommentImpl extends Comment {
  _CommentImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue authorId,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         authorId: authorId,
         content: content,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Comment copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    _i1.UuidValue? authorId,
    String? content,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
  }) {
    return Comment(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class CommentUpdateTable extends _i1.UpdateTable<CommentTable> {
  CommentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> cardId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.cardId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.authorId,
        value,
      );

  _i1.ColumnValue<String, String> content(String value) => _i1.ColumnValue(
    table.content,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );
}

class CommentTable extends _i1.Table<_i1.UuidValue?> {
  CommentTable({super.tableRelation}) : super(tableName: 'comment') {
    updateTable = CommentUpdateTable(this);
    cardId = _i1.ColumnUuid(
      'cardId',
      this,
    );
    authorId = _i1.ColumnUuid(
      'authorId',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final CommentUpdateTable updateTable;

  late final _i1.ColumnUuid cardId;

  late final _i1.ColumnUuid authorId;

  late final _i1.ColumnString content;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cardId,
    authorId,
    content,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class CommentInclude extends _i1.IncludeObject {
  CommentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Comment.t;
}

class CommentIncludeList extends _i1.IncludeList {
  CommentIncludeList._({
    _i1.WhereExpressionBuilder<CommentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Comment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Comment.t;
}

class CommentRepository {
  const CommentRepository._();

  /// Returns a list of [Comment]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Comment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Comment] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Comment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentTable>? where,
    int? offset,
    _i1.OrderByBuilder<CommentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CommentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Comment] by its [id] or null if no such row exists.
  Future<Comment?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Comment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Comment]s in the list and returns the inserted rows.
  ///
  /// The returned [Comment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Comment>> insert(
    _i1.Session session,
    List<Comment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Comment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Comment] and returns the inserted row.
  ///
  /// The returned [Comment] will have its `id` field set.
  Future<Comment> insertRow(
    _i1.Session session,
    Comment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Comment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Comment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Comment>> update(
    _i1.Session session,
    List<Comment> rows, {
    _i1.ColumnSelections<CommentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Comment>(
      rows,
      columns: columns?.call(Comment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Comment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Comment> updateRow(
    _i1.Session session,
    Comment row, {
    _i1.ColumnSelections<CommentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Comment>(
      row,
      columns: columns?.call(Comment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Comment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Comment?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CommentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Comment>(
      id,
      columnValues: columnValues(Comment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Comment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Comment>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CommentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CommentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CommentTable>? orderBy,
    _i1.OrderByListBuilder<CommentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Comment>(
      columnValues: columnValues(Comment.t.updateTable),
      where: where(Comment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Comment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Comment>> delete(
    _i1.Session session,
    List<Comment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Comment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Comment].
  Future<Comment> deleteRow(
    _i1.Session session,
    Comment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Comment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Comment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CommentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Comment>(
      where: where(Comment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Comment>(
      where: where?.call(Comment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
