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

abstract class Workspace
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Workspace._({
    this.id,
    required this.uuid,
    required this.title,
    required this.slug,
    required this.ownerId,
    required this.createdAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory Workspace({
    int? id,
    required _i1.UuidValue uuid,
    required String title,
    required String slug,
    required _i1.UuidValue ownerId,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      ownerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
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

  static final t = WorkspaceTable();

  static const db = WorkspaceRepository._();

  @override
  int? id;

  _i1.UuidValue uuid;

  String title;

  String slug;

  _i1.UuidValue ownerId;

  DateTime createdAt;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Workspace copyWith({
    int? id,
    _i1.UuidValue? uuid,
    String? title,
    String? slug,
    _i1.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Workspace',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'title': title,
      'slug': slug,
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Workspace',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'title': title,
      'slug': slug,
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  static WorkspaceInclude include() {
    return WorkspaceInclude._();
  }

  static WorkspaceIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    WorkspaceInclude? include,
  }) {
    return WorkspaceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Workspace.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Workspace.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    int? id,
    required _i1.UuidValue uuid,
    required String title,
    required String slug,
    required _i1.UuidValue ownerId,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         uuid: uuid,
         title: title,
         slug: slug,
         ownerId: ownerId,
         createdAt: createdAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    String? title,
    String? slug,
    _i1.UuidValue? ownerId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return Workspace(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}

class WorkspaceUpdateTable extends _i1.UpdateTable<WorkspaceTable> {
  WorkspaceUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> uuid(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.uuid,
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

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> ownerId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.ownerId,
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

class WorkspaceTable extends _i1.Table<int?> {
  WorkspaceTable({super.tableRelation}) : super(tableName: 'workspace') {
    updateTable = WorkspaceUpdateTable(this);
    uuid = _i1.ColumnUuid(
      'uuid',
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
    ownerId = _i1.ColumnUuid(
      'ownerId',
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

  late final WorkspaceUpdateTable updateTable;

  late final _i1.ColumnUuid uuid;

  late final _i1.ColumnString title;

  late final _i1.ColumnString slug;

  late final _i1.ColumnUuid ownerId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnUuid deletedBy;

  @override
  List<_i1.Column> get columns => [
    id,
    uuid,
    title,
    slug,
    ownerId,
    createdAt,
    deletedAt,
    deletedBy,
  ];
}

class WorkspaceInclude extends _i1.IncludeObject {
  WorkspaceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Workspace.t;
}

class WorkspaceIncludeList extends _i1.IncludeList {
  WorkspaceIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Workspace.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Workspace.t;
}

class WorkspaceRepository {
  const WorkspaceRepository._();

  /// Returns a list of [Workspace]s matching the given query parameters.
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
  Future<List<Workspace>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Workspace>(
      where: where?.call(Workspace.t),
      orderBy: orderBy?.call(Workspace.t),
      orderByList: orderByList?.call(Workspace.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Workspace] matching the given query parameters.
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
  Future<Workspace?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Workspace>(
      where: where?.call(Workspace.t),
      orderBy: orderBy?.call(Workspace.t),
      orderByList: orderByList?.call(Workspace.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Workspace] by its [id] or null if no such row exists.
  Future<Workspace?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Workspace>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Workspace]s in the list and returns the inserted rows.
  ///
  /// The returned [Workspace]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Workspace>> insert(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Workspace>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Workspace] and returns the inserted row.
  ///
  /// The returned [Workspace] will have its `id` field set.
  Future<Workspace> insertRow(
    _i1.Session session,
    Workspace row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Workspace>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Workspace]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Workspace>> update(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.ColumnSelections<WorkspaceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Workspace>(
      rows,
      columns: columns?.call(Workspace.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Workspace]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Workspace> updateRow(
    _i1.Session session,
    Workspace row, {
    _i1.ColumnSelections<WorkspaceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Workspace>(
      row,
      columns: columns?.call(Workspace.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Workspace] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Workspace?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<WorkspaceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Workspace>(
      id,
      columnValues: columnValues(Workspace.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Workspace]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Workspace>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<WorkspaceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WorkspaceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Workspace>(
      columnValues: columnValues(Workspace.t.updateTable),
      where: where(Workspace.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Workspace.t),
      orderByList: orderByList?.call(Workspace.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Workspace]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Workspace>> delete(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Workspace>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Workspace].
  Future<Workspace> deleteRow(
    _i1.Session session,
    Workspace row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Workspace>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Workspace>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Workspace>(
      where: where(Workspace.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Workspace>(
      where: where?.call(Workspace.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
