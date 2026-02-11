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

abstract class ChecklistItem
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ChecklistItem._({
    this.id,
    required this.checklistId,
    required this.title,
    required this.isChecked,
    required this.rank,
    this.deletedAt,
  });

  factory ChecklistItem({
    _i1.UuidValue? id,
    required _i1.UuidValue checklistId,
    required String title,
    required bool isChecked,
    required String rank,
    DateTime? deletedAt,
  }) = _ChecklistItemImpl;

  factory ChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistItem(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      checklistId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checklistId'],
      ),
      title: jsonSerialization['title'] as String,
      isChecked: jsonSerialization['isChecked'] as bool,
      rank: jsonSerialization['rank'] as String,
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = ChecklistItemTable();

  static const db = ChecklistItemRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue checklistId;

  String title;

  bool isChecked;

  String rank;

  DateTime? deletedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChecklistItem copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checklistId,
    String? title,
    bool? isChecked,
    String? rank,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'checklistId': checklistId.toJson(),
      'title': title,
      'isChecked': isChecked,
      'rank': rank,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'checklistId': checklistId.toJson(),
      'title': title,
      'isChecked': isChecked,
      'rank': rank,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static ChecklistItemInclude include() {
    return ChecklistItemInclude._();
  }

  static ChecklistItemIncludeList includeList({
    _i1.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistItemTable>? orderByList,
    ChecklistItemInclude? include,
  }) {
    return ChecklistItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChecklistItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChecklistItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistItemImpl extends ChecklistItem {
  _ChecklistItemImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue checklistId,
    required String title,
    required bool isChecked,
    required String rank,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         checklistId: checklistId,
         title: title,
         isChecked: isChecked,
         rank: rank,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChecklistItem copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? checklistId,
    String? title,
    bool? isChecked,
    String? rank,
    Object? deletedAt = _Undefined,
  }) {
    return ChecklistItem(
      id: id is _i1.UuidValue? ? id : this.id,
      checklistId: checklistId ?? this.checklistId,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      rank: rank ?? this.rank,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class ChecklistItemUpdateTable extends _i1.UpdateTable<ChecklistItemTable> {
  ChecklistItemUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> checklistId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.checklistId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<bool, bool> isChecked(bool value) => _i1.ColumnValue(
    table.isChecked,
    value,
  );

  _i1.ColumnValue<String, String> rank(String value) => _i1.ColumnValue(
    table.rank,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deletedAt,
        value,
      );
}

class ChecklistItemTable extends _i1.Table<_i1.UuidValue?> {
  ChecklistItemTable({super.tableRelation})
    : super(tableName: 'checklist_item') {
    updateTable = ChecklistItemUpdateTable(this);
    checklistId = _i1.ColumnUuid(
      'checklistId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    isChecked = _i1.ColumnBool(
      'isChecked',
      this,
    );
    rank = _i1.ColumnString(
      'rank',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final ChecklistItemUpdateTable updateTable;

  late final _i1.ColumnUuid checklistId;

  late final _i1.ColumnString title;

  late final _i1.ColumnBool isChecked;

  late final _i1.ColumnString rank;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    checklistId,
    title,
    isChecked,
    rank,
    deletedAt,
  ];
}

class ChecklistItemInclude extends _i1.IncludeObject {
  ChecklistItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ChecklistItem.t;
}

class ChecklistItemIncludeList extends _i1.IncludeList {
  ChecklistItemIncludeList._({
    _i1.WhereExpressionBuilder<ChecklistItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChecklistItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ChecklistItem.t;
}

class ChecklistItemRepository {
  const ChecklistItemRepository._();

  /// Returns a list of [ChecklistItem]s matching the given query parameters.
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
  Future<List<ChecklistItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ChecklistItem] matching the given query parameters.
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
  Future<ChecklistItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChecklistItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChecklistItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ChecklistItem] by its [id] or null if no such row exists.
  Future<ChecklistItem?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChecklistItem>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ChecklistItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ChecklistItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChecklistItem>> insert(
    _i1.Session session,
    List<ChecklistItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChecklistItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChecklistItem] and returns the inserted row.
  ///
  /// The returned [ChecklistItem] will have its `id` field set.
  Future<ChecklistItem> insertRow(
    _i1.Session session,
    ChecklistItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChecklistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChecklistItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChecklistItem>> update(
    _i1.Session session,
    List<ChecklistItem> rows, {
    _i1.ColumnSelections<ChecklistItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChecklistItem>(
      rows,
      columns: columns?.call(ChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChecklistItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChecklistItem> updateRow(
    _i1.Session session,
    ChecklistItem row, {
    _i1.ColumnSelections<ChecklistItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChecklistItem>(
      row,
      columns: columns?.call(ChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChecklistItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChecklistItem?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ChecklistItemUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChecklistItem>(
      id,
      columnValues: columnValues(ChecklistItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChecklistItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChecklistItem>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChecklistItemUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ChecklistItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChecklistItemTable>? orderBy,
    _i1.OrderByListBuilder<ChecklistItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChecklistItem>(
      columnValues: columnValues(ChecklistItem.t.updateTable),
      where: where(ChecklistItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChecklistItem.t),
      orderByList: orderByList?.call(ChecklistItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChecklistItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChecklistItem>> delete(
    _i1.Session session,
    List<ChecklistItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChecklistItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChecklistItem].
  Future<ChecklistItem> deleteRow(
    _i1.Session session,
    ChecklistItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChecklistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChecklistItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChecklistItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChecklistItem>(
      where: where(ChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChecklistItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChecklistItem>(
      where: where?.call(ChecklistItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
