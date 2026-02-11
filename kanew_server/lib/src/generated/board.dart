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
import 'board_visibility.dart' as _i2;

abstract class Board
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Board._({
    this.id,
    required this.workspaceId,
    required this.title,
    required this.slug,
    required this.visibility,
    this.backgroundUrl,
    required this.isTemplate,
    required this.createdAt,
    required this.createdBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory Board({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceId,
    required String title,
    required String slug,
    required _i2.BoardVisibility visibility,
    String? backgroundUrl,
    required bool isTemplate,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _BoardImpl;

  factory Board.fromJson(Map<String, dynamic> jsonSerialization) {
    return Board(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      visibility: _i2.BoardVisibility.fromJson(
        (jsonSerialization['visibility'] as String),
      ),
      backgroundUrl: jsonSerialization['backgroundUrl'] as String?,
      isTemplate: jsonSerialization['isTemplate'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      createdBy: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['deletedBy']),
    );
  }

  static final t = BoardTable();

  static const db = BoardRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue workspaceId;

  String title;

  String slug;

  _i2.BoardVisibility visibility;

  String? backgroundUrl;

  bool isTemplate;

  DateTime createdAt;

  _i1.UuidValue createdBy;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Board copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? workspaceId,
    String? title,
    String? slug,
    _i2.BoardVisibility? visibility,
    String? backgroundUrl,
    bool? isTemplate,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Board',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'title': title,
      'slug': slug,
      'visibility': visibility.toJson(),
      if (backgroundUrl != null) 'backgroundUrl': backgroundUrl,
      'isTemplate': isTemplate,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Board',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'title': title,
      'slug': slug,
      'visibility': visibility.toJson(),
      if (backgroundUrl != null) 'backgroundUrl': backgroundUrl,
      'isTemplate': isTemplate,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  static BoardInclude include() {
    return BoardInclude._();
  }

  static BoardIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    BoardInclude? include,
  }) {
    return BoardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Board.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Board.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardImpl extends Board {
  _BoardImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceId,
    required String title,
    required String slug,
    required _i2.BoardVisibility visibility,
    String? backgroundUrl,
    required bool isTemplate,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         title: title,
         slug: slug,
         visibility: visibility,
         backgroundUrl: backgroundUrl,
         isTemplate: isTemplate,
         createdAt: createdAt,
         createdBy: createdBy,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Board copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? workspaceId,
    String? title,
    String? slug,
    _i2.BoardVisibility? visibility,
    Object? backgroundUrl = _Undefined,
    bool? isTemplate,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return Board(
      id: id is _i1.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      visibility: visibility ?? this.visibility,
      backgroundUrl: backgroundUrl is String?
          ? backgroundUrl
          : this.backgroundUrl,
      isTemplate: isTemplate ?? this.isTemplate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}

class BoardUpdateTable extends _i1.UpdateTable<BoardTable> {
  BoardUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> workspaceId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.workspaceId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<_i2.BoardVisibility, _i2.BoardVisibility> visibility(
    _i2.BoardVisibility value,
  ) => _i1.ColumnValue(
    table.visibility,
    value,
  );

  _i1.ColumnValue<String, String> backgroundUrl(String? value) =>
      _i1.ColumnValue(
        table.backgroundUrl,
        value,
      );

  _i1.ColumnValue<bool, bool> isTemplate(bool value) => _i1.ColumnValue(
    table.isTemplate,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> createdBy(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> deletedBy(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.deletedBy,
    value,
  );
}

class BoardTable extends _i1.Table<_i1.UuidValue?> {
  BoardTable({super.tableRelation}) : super(tableName: 'board') {
    updateTable = BoardUpdateTable(this);
    workspaceId = _i1.ColumnUuid(
      'workspaceId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    visibility = _i1.ColumnEnum(
      'visibility',
      this,
      _i1.EnumSerialization.byName,
    );
    backgroundUrl = _i1.ColumnString(
      'backgroundUrl',
      this,
    );
    isTemplate = _i1.ColumnBool(
      'isTemplate',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    createdBy = _i1.ColumnUuid(
      'createdBy',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
    deletedBy = _i1.ColumnUuid(
      'deletedBy',
      this,
    );
  }

  late final BoardUpdateTable updateTable;

  late final _i1.ColumnUuid workspaceId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString slug;

  late final _i1.ColumnEnum<_i2.BoardVisibility> visibility;

  late final _i1.ColumnString backgroundUrl;

  late final _i1.ColumnBool isTemplate;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnUuid createdBy;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnUuid deletedBy;

  @override
  List<_i1.Column> get columns => [
    id,
    workspaceId,
    title,
    slug,
    visibility,
    backgroundUrl,
    isTemplate,
    createdAt,
    createdBy,
    deletedAt,
    deletedBy,
  ];
}

class BoardInclude extends _i1.IncludeObject {
  BoardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Board.t;
}

class BoardIncludeList extends _i1.IncludeList {
  BoardIncludeList._({
    _i1.WhereExpressionBuilder<BoardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Board.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Board.t;
}

class BoardRepository {
  const BoardRepository._();

  /// Returns a list of [Board]s matching the given query parameters.
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
  Future<List<Board>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Board>(
      where: where?.call(Board.t),
      orderBy: orderBy?.call(Board.t),
      orderByList: orderByList?.call(Board.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Board] matching the given query parameters.
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
  Future<Board?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Board>(
      where: where?.call(Board.t),
      orderBy: orderBy?.call(Board.t),
      orderByList: orderByList?.call(Board.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Board] by its [id] or null if no such row exists.
  Future<Board?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Board>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Board]s in the list and returns the inserted rows.
  ///
  /// The returned [Board]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Board>> insert(
    _i1.Session session,
    List<Board> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Board>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Board] and returns the inserted row.
  ///
  /// The returned [Board] will have its `id` field set.
  Future<Board> insertRow(
    _i1.Session session,
    Board row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Board>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Board]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Board>> update(
    _i1.Session session,
    List<Board> rows, {
    _i1.ColumnSelections<BoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Board>(
      rows,
      columns: columns?.call(Board.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Board]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Board> updateRow(
    _i1.Session session,
    Board row, {
    _i1.ColumnSelections<BoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Board>(
      row,
      columns: columns?.call(Board.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Board] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Board?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<BoardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Board>(
      id,
      columnValues: columnValues(Board.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Board]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Board>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BoardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BoardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Board>(
      columnValues: columnValues(Board.t.updateTable),
      where: where(Board.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Board.t),
      orderByList: orderByList?.call(Board.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Board]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Board>> delete(
    _i1.Session session,
    List<Board> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Board>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Board].
  Future<Board> deleteRow(
    _i1.Session session,
    Board row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Board>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Board>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Board>(
      where: where(Board.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Board>(
      where: where?.call(Board.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
