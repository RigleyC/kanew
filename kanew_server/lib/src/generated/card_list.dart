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

abstract class CardList
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CardList._({
    this.id,
    required this.uuid,
    required this.boardId,
    required this.title,
    required this.rank,
    required this.archived,
    required this.createdAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory CardList({
    int? id,
    required _i1.UuidValue uuid,
    required int boardId,
    required String title,
    required String rank,
    required bool archived,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _CardListImpl;

  factory CardList.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardList(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      boardId: jsonSerialization['boardId'] as int,
      title: jsonSerialization['title'] as String,
      rank: jsonSerialization['rank'] as String,
      archived: jsonSerialization['archived'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['deletedBy']),
    );
  }

  static final t = CardListTable();

  static const db = CardListRepository._();

  @override
  int? id;

  _i1.UuidValue uuid;

  int boardId;

  String title;

  String rank;

  bool archived;

  DateTime createdAt;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardList copyWith({
    int? id,
    _i1.UuidValue? uuid,
    int? boardId,
    String? title,
    String? rank,
    bool? archived,
    DateTime? createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardList',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'boardId': boardId,
      'title': title,
      'rank': rank,
      'archived': archived,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CardList',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'boardId': boardId,
      'title': title,
      'rank': rank,
      'archived': archived,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  static CardListInclude include() {
    return CardListInclude._();
  }

  static CardListIncludeList includeList({
    _i1.WhereExpressionBuilder<CardListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardListTable>? orderByList,
    CardListInclude? include,
  }) {
    return CardListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardList.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CardList.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardListImpl extends CardList {
  _CardListImpl({
    int? id,
    required _i1.UuidValue uuid,
    required int boardId,
    required String title,
    required String rank,
    required bool archived,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         uuid: uuid,
         boardId: boardId,
         title: title,
         rank: rank,
         archived: archived,
         createdAt: createdAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [CardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardList copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    int? boardId,
    String? title,
    String? rank,
    bool? archived,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return CardList(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      boardId: boardId ?? this.boardId,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}

class CardListUpdateTable extends _i1.UpdateTable<CardListTable> {
  CardListUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> uuid(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.uuid,
        value,
      );

  _i1.ColumnValue<int, int> boardId(int value) => _i1.ColumnValue(
    table.boardId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> rank(String value) => _i1.ColumnValue(
    table.rank,
    value,
  );

  _i1.ColumnValue<bool, bool> archived(bool value) => _i1.ColumnValue(
    table.archived,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
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

class CardListTable extends _i1.Table<int?> {
  CardListTable({super.tableRelation}) : super(tableName: 'card_list') {
    updateTable = CardListUpdateTable(this);
    uuid = _i1.ColumnUuid(
      'uuid',
      this,
    );
    boardId = _i1.ColumnInt(
      'boardId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    rank = _i1.ColumnString(
      'rank',
      this,
    );
    archived = _i1.ColumnBool(
      'archived',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
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

  late final CardListUpdateTable updateTable;

  late final _i1.ColumnUuid uuid;

  late final _i1.ColumnInt boardId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString rank;

  late final _i1.ColumnBool archived;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnUuid deletedBy;

  @override
  List<_i1.Column> get columns => [
    id,
    uuid,
    boardId,
    title,
    rank,
    archived,
    createdAt,
    deletedAt,
    deletedBy,
  ];
}

class CardListInclude extends _i1.IncludeObject {
  CardListInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CardList.t;
}

class CardListIncludeList extends _i1.IncludeList {
  CardListIncludeList._({
    _i1.WhereExpressionBuilder<CardListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CardList.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CardList.t;
}

class CardListRepository {
  const CardListRepository._();

  /// Returns a list of [CardList]s matching the given query parameters.
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
  Future<List<CardList>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CardList>(
      where: where?.call(CardList.t),
      orderBy: orderBy?.call(CardList.t),
      orderByList: orderByList?.call(CardList.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CardList] matching the given query parameters.
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
  Future<CardList?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardListTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CardList>(
      where: where?.call(CardList.t),
      orderBy: orderBy?.call(CardList.t),
      orderByList: orderByList?.call(CardList.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CardList] by its [id] or null if no such row exists.
  Future<CardList?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CardList>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CardList]s in the list and returns the inserted rows.
  ///
  /// The returned [CardList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CardList>> insert(
    _i1.Session session,
    List<CardList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CardList>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CardList] and returns the inserted row.
  ///
  /// The returned [CardList] will have its `id` field set.
  Future<CardList> insertRow(
    _i1.Session session,
    CardList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CardList>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CardList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CardList>> update(
    _i1.Session session,
    List<CardList> rows, {
    _i1.ColumnSelections<CardListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CardList>(
      rows,
      columns: columns?.call(CardList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CardList> updateRow(
    _i1.Session session,
    CardList row, {
    _i1.ColumnSelections<CardListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CardList>(
      row,
      columns: columns?.call(CardList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardList] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CardList?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CardListUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CardList>(
      id,
      columnValues: columnValues(CardList.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CardList]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CardList>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CardListUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CardListTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardListTable>? orderBy,
    _i1.OrderByListBuilder<CardListTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CardList>(
      columnValues: columnValues(CardList.t.updateTable),
      where: where(CardList.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardList.t),
      orderByList: orderByList?.call(CardList.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CardList]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CardList>> delete(
    _i1.Session session,
    List<CardList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CardList>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CardList].
  Future<CardList> deleteRow(
    _i1.Session session,
    CardList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CardList>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CardList>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardListTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CardList>(
      where: where(CardList.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardListTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CardList>(
      where: where?.call(CardList.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
