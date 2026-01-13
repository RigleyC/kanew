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

abstract class Checklist
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Checklist._({
    this.id,
    required this.cardId,
    required this.title,
    required this.rank,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Checklist({
    int? id,
    required int cardId,
    required String title,
    required String rank,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _ChecklistImpl;

  factory Checklist.fromJson(Map<String, dynamic> jsonSerialization) {
    return Checklist(
      id: jsonSerialization['id'] as int?,
      cardId: jsonSerialization['cardId'] as int,
      title: jsonSerialization['title'] as String,
      rank: jsonSerialization['rank'] as String,
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

  static final t = ChecklistTable();

  static const db = ChecklistRepository._();

  @override
  int? id;

  int cardId;

  String title;

  String rank;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Checklist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Checklist copyWith({
    int? id,
    int? cardId,
    String? title,
    String? rank,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Checklist',
      if (id != null) 'id': id,
      'cardId': cardId,
      'title': title,
      'rank': rank,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Checklist',
      if (id != null) 'id': id,
      'cardId': cardId,
      'title': title,
      'rank': rank,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static ChecklistInclude include() {
    return ChecklistInclude._();
  }

  static ChecklistIncludeList includeList({
    _i1.WhereExpressionBuilder<ChecklistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistTable>? orderByList,
    ChecklistInclude? include,
  }) {
    return ChecklistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Checklist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Checklist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistImpl extends Checklist {
  _ChecklistImpl({
    int? id,
    required int cardId,
    required String title,
    required String rank,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         title: title,
         rank: rank,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Checklist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Checklist copyWith({
    Object? id = _Undefined,
    int? cardId,
    String? title,
    String? rank,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
  }) {
    return Checklist(
      id: id is int? ? id : this.id,
      cardId: cardId ?? this.cardId,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class ChecklistUpdateTable extends _i1.UpdateTable<ChecklistTable> {
  ChecklistUpdateTable(super.table);

  _i1.ColumnValue<int, int> cardId(int value) => _i1.ColumnValue(
    table.cardId,
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

class ChecklistTable extends _i1.Table<int?> {
  ChecklistTable({super.tableRelation}) : super(tableName: 'checklist') {
    updateTable = ChecklistUpdateTable(this);
    cardId = _i1.ColumnInt(
      'cardId',
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

  late final ChecklistUpdateTable updateTable;

  late final _i1.ColumnInt cardId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString rank;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cardId,
    title,
    rank,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class ChecklistInclude extends _i1.IncludeObject {
  ChecklistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Checklist.t;
}

class ChecklistIncludeList extends _i1.IncludeList {
  ChecklistIncludeList._({
    _i1.WhereExpressionBuilder<ChecklistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Checklist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Checklist.t;
}

class ChecklistRepository {
  const ChecklistRepository._();

  /// Returns a list of [Checklist]s matching the given query parameters.
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
  Future<List<Checklist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Checklist>(
      where: where?.call(Checklist.t),
      orderBy: orderBy?.call(Checklist.t),
      orderByList: orderByList?.call(Checklist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Checklist] matching the given query parameters.
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
  Future<Checklist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChecklistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Checklist>(
      where: where?.call(Checklist.t),
      orderBy: orderBy?.call(Checklist.t),
      orderByList: orderByList?.call(Checklist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Checklist] by its [id] or null if no such row exists.
  Future<Checklist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Checklist>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Checklist]s in the list and returns the inserted rows.
  ///
  /// The returned [Checklist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Checklist>> insert(
    _i1.Session session,
    List<Checklist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Checklist>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Checklist] and returns the inserted row.
  ///
  /// The returned [Checklist] will have its `id` field set.
  Future<Checklist> insertRow(
    _i1.Session session,
    Checklist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Checklist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Checklist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Checklist>> update(
    _i1.Session session,
    List<Checklist> rows, {
    _i1.ColumnSelections<ChecklistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Checklist>(
      rows,
      columns: columns?.call(Checklist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Checklist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Checklist> updateRow(
    _i1.Session session,
    Checklist row, {
    _i1.ColumnSelections<ChecklistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Checklist>(
      row,
      columns: columns?.call(Checklist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Checklist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Checklist?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChecklistUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Checklist>(
      id,
      columnValues: columnValues(Checklist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Checklist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Checklist>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChecklistUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ChecklistTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistTable>? orderBy,
    _i1.OrderByListBuilder<ChecklistTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Checklist>(
      columnValues: columnValues(Checklist.t.updateTable),
      where: where(Checklist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Checklist.t),
      orderByList: orderByList?.call(Checklist.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Checklist]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Checklist>> delete(
    _i1.Session session,
    List<Checklist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Checklist>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Checklist].
  Future<Checklist> deleteRow(
    _i1.Session session,
    Checklist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Checklist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Checklist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChecklistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Checklist>(
      where: where(Checklist.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Checklist>(
      where: where?.call(Checklist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
