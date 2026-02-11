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
import 'package:kanew_server/src/generated/protocol.dart' as _i2;

abstract class WorkspaceInvite
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  WorkspaceInvite._({
    this.id,
    this.email,
    required this.code,
    required this.workspaceId,
    required this.createdBy,
    required this.initialPermissions,
    this.acceptedAt,
    this.revokedAt,
    required this.createdAt,
  });

  factory WorkspaceInvite({
    _i1.UuidValue? id,
    String? email,
    required String code,
    required _i1.UuidValue workspaceId,
    required _i1.UuidValue createdBy,
    required List<_i1.UuidValue> initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    required DateTime createdAt,
  }) = _WorkspaceInviteImpl;

  factory WorkspaceInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceInvite(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String?,
      code: jsonSerialization['code'] as String,
      workspaceId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      createdBy: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      initialPermissions: _i2.Protocol().deserialize<List<_i1.UuidValue>>(
        jsonSerialization['initialPermissions'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = WorkspaceInviteTable();

  static const db = WorkspaceInviteRepository._();

  @override
  _i1.UuidValue? id;

  String? email;

  String code;

  _i1.UuidValue workspaceId;

  _i1.UuidValue createdBy;

  List<_i1.UuidValue> initialPermissions;

  DateTime? acceptedAt;

  DateTime? revokedAt;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [WorkspaceInvite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceInvite copyWith({
    _i1.UuidValue? id,
    String? email,
    String? code,
    _i1.UuidValue? workspaceId,
    _i1.UuidValue? createdBy,
    List<_i1.UuidValue>? initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceInvite',
      if (id != null) 'id': id?.toJson(),
      if (email != null) 'email': email,
      'code': code,
      'workspaceId': workspaceId.toJson(),
      'createdBy': createdBy.toJson(),
      'initialPermissions': initialPermissions.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceInvite',
      if (id != null) 'id': id?.toJson(),
      if (email != null) 'email': email,
      'code': code,
      'workspaceId': workspaceId.toJson(),
      'createdBy': createdBy.toJson(),
      'initialPermissions': initialPermissions.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static WorkspaceInviteInclude include() {
    return WorkspaceInviteInclude._();
  }

  static WorkspaceInviteIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceInviteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInviteTable>? orderByList,
    WorkspaceInviteInclude? include,
  }) {
    return WorkspaceInviteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceInvite.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkspaceInvite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceInviteImpl extends WorkspaceInvite {
  _WorkspaceInviteImpl({
    _i1.UuidValue? id,
    String? email,
    required String code,
    required _i1.UuidValue workspaceId,
    required _i1.UuidValue createdBy,
    required List<_i1.UuidValue> initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         code: code,
         workspaceId: workspaceId,
         createdBy: createdBy,
         initialPermissions: initialPermissions,
         acceptedAt: acceptedAt,
         revokedAt: revokedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceInvite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceInvite copyWith({
    Object? id = _Undefined,
    Object? email = _Undefined,
    String? code,
    _i1.UuidValue? workspaceId,
    _i1.UuidValue? createdBy,
    List<_i1.UuidValue>? initialPermissions,
    Object? acceptedAt = _Undefined,
    Object? revokedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return WorkspaceInvite(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email is String? ? email : this.email,
      code: code ?? this.code,
      workspaceId: workspaceId ?? this.workspaceId,
      createdBy: createdBy ?? this.createdBy,
      initialPermissions:
          initialPermissions ??
          this.initialPermissions.map((e0) => e0).toList(),
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WorkspaceInviteUpdateTable extends _i1.UpdateTable<WorkspaceInviteTable> {
  WorkspaceInviteUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> workspaceId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.workspaceId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> createdBy(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<List<_i1.UuidValue>, List<_i1.UuidValue>> initialPermissions(
    List<_i1.UuidValue> value,
  ) => _i1.ColumnValue(
    table.initialPermissions,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.acceptedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> revokedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.revokedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class WorkspaceInviteTable extends _i1.Table<_i1.UuidValue?> {
  WorkspaceInviteTable({super.tableRelation})
    : super(tableName: 'workspace_invite') {
    updateTable = WorkspaceInviteUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    workspaceId = _i1.ColumnUuid(
      'workspaceId',
      this,
    );
    createdBy = _i1.ColumnUuid(
      'createdBy',
      this,
    );
    initialPermissions = _i1.ColumnSerializable<List<_i1.UuidValue>>(
      'initialPermissions',
      this,
    );
    acceptedAt = _i1.ColumnDateTime(
      'acceptedAt',
      this,
    );
    revokedAt = _i1.ColumnDateTime(
      'revokedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WorkspaceInviteUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnString code;

  late final _i1.ColumnUuid workspaceId;

  late final _i1.ColumnUuid createdBy;

  late final _i1.ColumnSerializable<List<_i1.UuidValue>> initialPermissions;

  late final _i1.ColumnDateTime acceptedAt;

  late final _i1.ColumnDateTime revokedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    code,
    workspaceId,
    createdBy,
    initialPermissions,
    acceptedAt,
    revokedAt,
    createdAt,
  ];
}

class WorkspaceInviteInclude extends _i1.IncludeObject {
  WorkspaceInviteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => WorkspaceInvite.t;
}

class WorkspaceInviteIncludeList extends _i1.IncludeList {
  WorkspaceInviteIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceInviteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkspaceInvite.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => WorkspaceInvite.t;
}

class WorkspaceInviteRepository {
  const WorkspaceInviteRepository._();

  /// Returns a list of [WorkspaceInvite]s matching the given query parameters.
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
  Future<List<WorkspaceInvite>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInviteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInviteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WorkspaceInvite>(
      where: where?.call(WorkspaceInvite.t),
      orderBy: orderBy?.call(WorkspaceInvite.t),
      orderByList: orderByList?.call(WorkspaceInvite.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WorkspaceInvite] matching the given query parameters.
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
  Future<WorkspaceInvite?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInviteTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInviteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WorkspaceInvite>(
      where: where?.call(WorkspaceInvite.t),
      orderBy: orderBy?.call(WorkspaceInvite.t),
      orderByList: orderByList?.call(WorkspaceInvite.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WorkspaceInvite] by its [id] or null if no such row exists.
  Future<WorkspaceInvite?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WorkspaceInvite>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WorkspaceInvite]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkspaceInvite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WorkspaceInvite>> insert(
    _i1.Session session,
    List<WorkspaceInvite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WorkspaceInvite>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WorkspaceInvite] and returns the inserted row.
  ///
  /// The returned [WorkspaceInvite] will have its `id` field set.
  Future<WorkspaceInvite> insertRow(
    _i1.Session session,
    WorkspaceInvite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkspaceInvite>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceInvite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkspaceInvite>> update(
    _i1.Session session,
    List<WorkspaceInvite> rows, {
    _i1.ColumnSelections<WorkspaceInviteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkspaceInvite>(
      rows,
      columns: columns?.call(WorkspaceInvite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceInvite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkspaceInvite> updateRow(
    _i1.Session session,
    WorkspaceInvite row, {
    _i1.ColumnSelections<WorkspaceInviteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkspaceInvite>(
      row,
      columns: columns?.call(WorkspaceInvite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceInvite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkspaceInvite?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<WorkspaceInviteUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkspaceInvite>(
      id,
      columnValues: columnValues(WorkspaceInvite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceInvite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WorkspaceInvite>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<WorkspaceInviteUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<WorkspaceInviteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInviteTable>? orderBy,
    _i1.OrderByListBuilder<WorkspaceInviteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WorkspaceInvite>(
      columnValues: columnValues(WorkspaceInvite.t.updateTable),
      where: where(WorkspaceInvite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceInvite.t),
      orderByList: orderByList?.call(WorkspaceInvite.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WorkspaceInvite]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkspaceInvite>> delete(
    _i1.Session session,
    List<WorkspaceInvite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkspaceInvite>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkspaceInvite].
  Future<WorkspaceInvite> deleteRow(
    _i1.Session session,
    WorkspaceInvite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkspaceInvite>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkspaceInvite>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceInviteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkspaceInvite>(
      where: where(WorkspaceInvite.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInviteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkspaceInvite>(
      where: where?.call(WorkspaceInvite.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
