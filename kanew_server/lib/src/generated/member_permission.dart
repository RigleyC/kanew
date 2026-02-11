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
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  MemberPermission._({
    this.id,
    required this.workspaceMemberId,
    required this.permissionId,
    this.scopeBoardId,
    bool? isRemoved,
    this.grantedAt,
  }) : isRemoved = isRemoved ?? false;

  factory MemberPermission({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceMemberId,
    required _i1.UuidValue permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  }) = _MemberPermissionImpl;

  factory MemberPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberPermission(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceMemberId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceMemberId'],
      ),
      permissionId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['permissionId'],
      ),
      scopeBoardId: jsonSerialization['scopeBoardId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['scopeBoardId'],
            ),
      isRemoved: jsonSerialization['isRemoved'] as bool?,
      grantedAt: jsonSerialization['grantedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['grantedAt']),
    );
  }

  static final t = MemberPermissionTable();

  static const db = MemberPermissionRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue workspaceMemberId;

  _i1.UuidValue permissionId;

  _i1.UuidValue? scopeBoardId;

  bool isRemoved;

  DateTime? grantedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MemberPermission copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? workspaceMemberId,
    _i1.UuidValue? permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id?.toJson(),
      'workspaceMemberId': workspaceMemberId.toJson(),
      'permissionId': permissionId.toJson(),
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId?.toJson(),
      'isRemoved': isRemoved,
      if (grantedAt != null) 'grantedAt': grantedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id?.toJson(),
      'workspaceMemberId': workspaceMemberId.toJson(),
      'permissionId': permissionId.toJson(),
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId?.toJson(),
      'isRemoved': isRemoved,
      if (grantedAt != null) 'grantedAt': grantedAt?.toJson(),
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
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceMemberId,
    required _i1.UuidValue permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  }) : super._(
         id: id,
         workspaceMemberId: workspaceMemberId,
         permissionId: permissionId,
         scopeBoardId: scopeBoardId,
         isRemoved: isRemoved,
         grantedAt: grantedAt,
       );

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MemberPermission copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? workspaceMemberId,
    _i1.UuidValue? permissionId,
    Object? scopeBoardId = _Undefined,
    bool? isRemoved,
    Object? grantedAt = _Undefined,
  }) {
    return MemberPermission(
      id: id is _i1.UuidValue? ? id : this.id,
      workspaceMemberId: workspaceMemberId ?? this.workspaceMemberId,
      permissionId: permissionId ?? this.permissionId,
      scopeBoardId: scopeBoardId is _i1.UuidValue?
          ? scopeBoardId
          : this.scopeBoardId,
      isRemoved: isRemoved ?? this.isRemoved,
      grantedAt: grantedAt is DateTime? ? grantedAt : this.grantedAt,
    );
  }
}

class MemberPermissionUpdateTable
    extends _i1.UpdateTable<MemberPermissionTable> {
  MemberPermissionUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> workspaceMemberId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.workspaceMemberId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> permissionId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.permissionId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> scopeBoardId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.scopeBoardId,
    value,
  );

  _i1.ColumnValue<bool, bool> isRemoved(bool value) => _i1.ColumnValue(
    table.isRemoved,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> grantedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.grantedAt,
        value,
      );
}

class MemberPermissionTable extends _i1.Table<_i1.UuidValue?> {
  MemberPermissionTable({super.tableRelation})
    : super(tableName: 'member_permission') {
    updateTable = MemberPermissionUpdateTable(this);
    workspaceMemberId = _i1.ColumnUuid(
      'workspaceMemberId',
      this,
    );
    permissionId = _i1.ColumnUuid(
      'permissionId',
      this,
    );
    scopeBoardId = _i1.ColumnUuid(
      'scopeBoardId',
      this,
    );
    isRemoved = _i1.ColumnBool(
      'isRemoved',
      this,
      hasDefault: true,
    );
    grantedAt = _i1.ColumnDateTime(
      'grantedAt',
      this,
    );
  }

  late final MemberPermissionUpdateTable updateTable;

  late final _i1.ColumnUuid workspaceMemberId;

  late final _i1.ColumnUuid permissionId;

  late final _i1.ColumnUuid scopeBoardId;

  late final _i1.ColumnBool isRemoved;

  late final _i1.ColumnDateTime grantedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    workspaceMemberId,
    permissionId,
    scopeBoardId,
    isRemoved,
    grantedAt,
  ];
}

class MemberPermissionInclude extends _i1.IncludeObject {
  MemberPermissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => MemberPermission.t;
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
  _i1.Table<_i1.UuidValue?> get table => MemberPermission.t;
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
    _i1.UuidValue id, {
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
    _i1.UuidValue id, {
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
