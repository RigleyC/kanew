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

abstract class MemberPermission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MemberPermission._({
    this.id,
    required this.workspaceMemberId,
    required this.permissionId,
    this.scopeBoardId,
  });

  factory MemberPermission({
    int? id,
    required int workspaceMemberId,
    required int permissionId,
    int? scopeBoardId,
  }) = _MemberPermissionImpl;

  factory MemberPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberPermission(
      id: jsonSerialization['id'] as int?,
      workspaceMemberId: jsonSerialization['workspaceMemberId'] as int,
      permissionId: jsonSerialization['permissionId'] as int,
      scopeBoardId: jsonSerialization['scopeBoardId'] as int?,
    );
  }

  static final t = MemberPermissionTable();

  static const db = MemberPermissionRepository._();

  @override
  int? id;

  int workspaceMemberId;

  int permissionId;

  int? scopeBoardId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MemberPermission copyWith({
    int? id,
    int? workspaceMemberId,
    int? permissionId,
    int? scopeBoardId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id,
      'workspaceMemberId': workspaceMemberId,
      'permissionId': permissionId,
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id,
      'workspaceMemberId': workspaceMemberId,
      'permissionId': permissionId,
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId,
    };
  }

  static MemberPermissionInclude include() {
    return MemberPermissionInclude._();
  }

  static MemberPermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<MemberPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MemberPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberPermissionTable>? orderByList,
    MemberPermissionInclude? include,
  }) {
    return MemberPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MemberPermission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MemberPermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberPermissionImpl extends MemberPermission {
  _MemberPermissionImpl({
    int? id,
    required int workspaceMemberId,
    required int permissionId,
    int? scopeBoardId,
  }) : super._(
         id: id,
         workspaceMemberId: workspaceMemberId,
         permissionId: permissionId,
         scopeBoardId: scopeBoardId,
       );

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MemberPermission copyWith({
    Object? id = _Undefined,
    int? workspaceMemberId,
    int? permissionId,
    Object? scopeBoardId = _Undefined,
  }) {
    return MemberPermission(
      id: id is int? ? id : this.id,
      workspaceMemberId: workspaceMemberId ?? this.workspaceMemberId,
      permissionId: permissionId ?? this.permissionId,
      scopeBoardId: scopeBoardId is int? ? scopeBoardId : this.scopeBoardId,
    );
  }
}

class MemberPermissionUpdateTable
    extends _i1.UpdateTable<MemberPermissionTable> {
  MemberPermissionUpdateTable(super.table);

  _i1.ColumnValue<int, int> workspaceMemberId(int value) => _i1.ColumnValue(
    table.workspaceMemberId,
    value,
  );

  _i1.ColumnValue<int, int> permissionId(int value) => _i1.ColumnValue(
    table.permissionId,
    value,
  );

  _i1.ColumnValue<int, int> scopeBoardId(int? value) => _i1.ColumnValue(
    table.scopeBoardId,
    value,
  );
}

class MemberPermissionTable extends _i1.Table<int?> {
  MemberPermissionTable({super.tableRelation})
    : super(tableName: 'member_permission') {
    updateTable = MemberPermissionUpdateTable(this);
    workspaceMemberId = _i1.ColumnInt(
      'workspaceMemberId',
      this,
    );
    permissionId = _i1.ColumnInt(
      'permissionId',
      this,
    );
    scopeBoardId = _i1.ColumnInt(
      'scopeBoardId',
      this,
    );
  }

  late final MemberPermissionUpdateTable updateTable;

  late final _i1.ColumnInt workspaceMemberId;

  late final _i1.ColumnInt permissionId;

  late final _i1.ColumnInt scopeBoardId;

  @override
  List<_i1.Column> get columns => [
    id,
    workspaceMemberId,
    permissionId,
    scopeBoardId,
  ];
}

class MemberPermissionInclude extends _i1.IncludeObject {
  MemberPermissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MemberPermission.t;
}

class MemberPermissionIncludeList extends _i1.IncludeList {
  MemberPermissionIncludeList._({
    _i1.WhereExpressionBuilder<MemberPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MemberPermission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MemberPermission.t;
}

class MemberPermissionRepository {
  const MemberPermissionRepository._();

  /// Returns a list of [MemberPermission]s matching the given query parameters.
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
  Future<List<MemberPermission>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MemberPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberPermissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MemberPermission>(
      where: where?.call(MemberPermission.t),
      orderBy: orderBy?.call(MemberPermission.t),
      orderByList: orderByList?.call(MemberPermission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MemberPermission] matching the given query parameters.
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
  Future<MemberPermission?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberPermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<MemberPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MemberPermissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MemberPermission>(
      where: where?.call(MemberPermission.t),
      orderBy: orderBy?.call(MemberPermission.t),
      orderByList: orderByList?.call(MemberPermission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MemberPermission] by its [id] or null if no such row exists.
  Future<MemberPermission?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MemberPermission>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MemberPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [MemberPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MemberPermission>> insert(
    _i1.Session session,
    List<MemberPermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MemberPermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MemberPermission] and returns the inserted row.
  ///
  /// The returned [MemberPermission] will have its `id` field set.
  Future<MemberPermission> insertRow(
    _i1.Session session,
    MemberPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MemberPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MemberPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MemberPermission>> update(
    _i1.Session session,
    List<MemberPermission> rows, {
    _i1.ColumnSelections<MemberPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MemberPermission>(
      rows,
      columns: columns?.call(MemberPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MemberPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MemberPermission> updateRow(
    _i1.Session session,
    MemberPermission row, {
    _i1.ColumnSelections<MemberPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MemberPermission>(
      row,
      columns: columns?.call(MemberPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MemberPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MemberPermission?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<MemberPermissionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MemberPermission>(
      id,
      columnValues: columnValues(MemberPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MemberPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MemberPermission>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MemberPermissionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<MemberPermissionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MemberPermissionTable>? orderBy,
    _i1.OrderByListBuilder<MemberPermissionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MemberPermission>(
      columnValues: columnValues(MemberPermission.t.updateTable),
      where: where(MemberPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MemberPermission.t),
      orderByList: orderByList?.call(MemberPermission.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MemberPermission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MemberPermission>> delete(
    _i1.Session session,
    List<MemberPermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MemberPermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MemberPermission].
  Future<MemberPermission> deleteRow(
    _i1.Session session,
    MemberPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MemberPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MemberPermission>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MemberPermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MemberPermission>(
      where: where(MemberPermission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MemberPermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MemberPermission>(
      where: where?.call(MemberPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
