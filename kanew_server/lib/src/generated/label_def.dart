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

abstract class LabelDef
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LabelDef._({
    this.id,
    required this.boardId,
    required this.name,
    required this.colorHex,
    this.deletedAt,
  });

  factory LabelDef({
    int? id,
    required int boardId,
    required String name,
    required String colorHex,
    DateTime? deletedAt,
  }) = _LabelDefImpl;

  factory LabelDef.fromJson(Map<String, dynamic> jsonSerialization) {
    return LabelDef(
      id: jsonSerialization['id'] as int?,
      boardId: jsonSerialization['boardId'] as int,
      name: jsonSerialization['name'] as String,
      colorHex: jsonSerialization['colorHex'] as String,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = LabelDefTable();

  static const db = LabelDefRepository._();

  @override
  int? id;

  int boardId;

  String name;

  String colorHex;

  DateTime? deletedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LabelDef]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LabelDef copyWith({
    int? id,
    int? boardId,
    String? name,
    String? colorHex,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LabelDef',
      if (id != null) 'id': id,
      'boardId': boardId,
      'name': name,
      'colorHex': colorHex,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LabelDef',
      if (id != null) 'id': id,
      'boardId': boardId,
      'name': name,
      'colorHex': colorHex,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static LabelDefInclude include() {
    return LabelDefInclude._();
  }

  static LabelDefIncludeList includeList({
    _i1.WhereExpressionBuilder<LabelDefTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabelDefTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelDefTable>? orderByList,
    LabelDefInclude? include,
  }) {
    return LabelDefIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LabelDef.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LabelDef.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LabelDefImpl extends LabelDef {
  _LabelDefImpl({
    int? id,
    required int boardId,
    required String name,
    required String colorHex,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         boardId: boardId,
         name: name,
         colorHex: colorHex,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [LabelDef]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LabelDef copyWith({
    Object? id = _Undefined,
    int? boardId,
    String? name,
    String? colorHex,
    Object? deletedAt = _Undefined,
  }) {
    return LabelDef(
      id: id is int? ? id : this.id,
      boardId: boardId ?? this.boardId,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class LabelDefUpdateTable extends _i1.UpdateTable<LabelDefTable> {
  LabelDefUpdateTable(super.table);

  _i1.ColumnValue<int, int> boardId(int value) => _i1.ColumnValue(
    table.boardId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> colorHex(String value) => _i1.ColumnValue(
    table.colorHex,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );
}

class LabelDefTable extends _i1.Table<int?> {
  LabelDefTable({super.tableRelation}) : super(tableName: 'label_def') {
    updateTable = LabelDefUpdateTable(this);
    boardId = _i1.ColumnInt(
      'boardId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    colorHex = _i1.ColumnString(
      'colorHex',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final LabelDefUpdateTable updateTable;

  late final _i1.ColumnInt boardId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString colorHex;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    boardId,
    name,
    colorHex,
    deletedAt,
  ];
}

class LabelDefInclude extends _i1.IncludeObject {
  LabelDefInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LabelDef.t;
}

class LabelDefIncludeList extends _i1.IncludeList {
  LabelDefIncludeList._({
    _i1.WhereExpressionBuilder<LabelDefTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LabelDef.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LabelDef.t;
}

class LabelDefRepository {
  const LabelDefRepository._();

  /// Returns a list of [LabelDef]s matching the given query parameters.
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
  Future<List<LabelDef>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelDefTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabelDefTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelDefTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LabelDef>(
      where: where?.call(LabelDef.t),
      orderBy: orderBy?.call(LabelDef.t),
      orderByList: orderByList?.call(LabelDef.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [LabelDef] matching the given query parameters.
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
  Future<LabelDef?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelDefTable>? where,
    int? offset,
    _i1.OrderByBuilder<LabelDefTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelDefTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<LabelDef>(
      where: where?.call(LabelDef.t),
      orderBy: orderBy?.call(LabelDef.t),
      orderByList: orderByList?.call(LabelDef.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [LabelDef] by its [id] or null if no such row exists.
  Future<LabelDef?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<LabelDef>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [LabelDef]s in the list and returns the inserted rows.
  ///
  /// The returned [LabelDef]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LabelDef>> insert(
    _i1.Session session,
    List<LabelDef> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LabelDef>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LabelDef] and returns the inserted row.
  ///
  /// The returned [LabelDef] will have its `id` field set.
  Future<LabelDef> insertRow(
    _i1.Session session,
    LabelDef row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LabelDef>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LabelDef]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LabelDef>> update(
    _i1.Session session,
    List<LabelDef> rows, {
    _i1.ColumnSelections<LabelDefTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LabelDef>(
      rows,
      columns: columns?.call(LabelDef.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LabelDef]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LabelDef> updateRow(
    _i1.Session session,
    LabelDef row, {
    _i1.ColumnSelections<LabelDefTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LabelDef>(
      row,
      columns: columns?.call(LabelDef.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LabelDef] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LabelDef?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LabelDefUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LabelDef>(
      id,
      columnValues: columnValues(LabelDef.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LabelDef]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LabelDef>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LabelDefUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LabelDefTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabelDefTable>? orderBy,
    _i1.OrderByListBuilder<LabelDefTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LabelDef>(
      columnValues: columnValues(LabelDef.t.updateTable),
      where: where(LabelDef.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LabelDef.t),
      orderByList: orderByList?.call(LabelDef.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LabelDef]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LabelDef>> delete(
    _i1.Session session,
    List<LabelDef> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LabelDef>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LabelDef].
  Future<LabelDef> deleteRow(
    _i1.Session session,
    LabelDef row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LabelDef>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LabelDef>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LabelDefTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LabelDef>(
      where: where(LabelDef.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelDefTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LabelDef>(
      where: where?.call(LabelDef.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
