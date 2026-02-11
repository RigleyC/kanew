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

abstract class UserPreference
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserPreference._({
    this.id,
    required this.authUserId,
    this.lastWorkspaceId,
    this.theme,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreference({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserPreferenceImpl;

  factory UserPreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreference(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      lastWorkspaceId: jsonSerialization['lastWorkspaceId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastWorkspaceId'],
            ),
      theme: jsonSerialization['theme'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserPreferenceTable();

  static const db = UserPreferenceRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  _i1.UuidValue? lastWorkspaceId;

  String? theme;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreference copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreference',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (lastWorkspaceId != null) 'lastWorkspaceId': lastWorkspaceId?.toJson(),
      if (theme != null) 'theme': theme,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserPreference',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (lastWorkspaceId != null) 'lastWorkspaceId': lastWorkspaceId?.toJson(),
      if (theme != null) 'theme': theme,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserPreferenceInclude include() {
    return UserPreferenceInclude._();
  }

  static UserPreferenceIncludeList includeList({
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    UserPreferenceInclude? include,
  }) {
    return UserPreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreference.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserPreference.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPreferenceImpl extends UserPreference {
  _UserPreferenceImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         lastWorkspaceId: lastWorkspaceId,
         theme: theme,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreference copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? lastWorkspaceId = _Undefined,
    Object? theme = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreference(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      lastWorkspaceId: lastWorkspaceId is _i1.UuidValue?
          ? lastWorkspaceId
          : this.lastWorkspaceId,
      theme: theme is String? ? theme : this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserPreferenceUpdateTable extends _i1.UpdateTable<UserPreferenceTable> {
  UserPreferenceUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> lastWorkspaceId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.lastWorkspaceId,
    value,
  );

  _i1.ColumnValue<String, String> theme(String? value) => _i1.ColumnValue(
    table.theme,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserPreferenceTable extends _i1.Table<_i1.UuidValue?> {
  UserPreferenceTable({super.tableRelation})
    : super(tableName: 'user_preference') {
    updateTable = UserPreferenceUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    lastWorkspaceId = _i1.ColumnUuid(
      'lastWorkspaceId',
      this,
    );
    theme = _i1.ColumnString(
      'theme',
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
  }

  late final UserPreferenceUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  late final _i1.ColumnUuid lastWorkspaceId;

  late final _i1.ColumnString theme;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    lastWorkspaceId,
    theme,
    createdAt,
    updatedAt,
  ];
}

class UserPreferenceInclude extends _i1.IncludeObject {
  UserPreferenceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserPreference.t;
}

class UserPreferenceIncludeList extends _i1.IncludeList {
  UserPreferenceIncludeList._({
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserPreference.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserPreference.t;
}

class UserPreferenceRepository {
  const UserPreferenceRepository._();

  /// Returns a list of [UserPreference]s matching the given query parameters.
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
  Future<List<UserPreference>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserPreference>(
      where: where?.call(UserPreference.t),
      orderBy: orderBy?.call(UserPreference.t),
      orderByList: orderByList?.call(UserPreference.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserPreference] matching the given query parameters.
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
  Future<UserPreference?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserPreference>(
      where: where?.call(UserPreference.t),
      orderBy: orderBy?.call(UserPreference.t),
      orderByList: orderByList?.call(UserPreference.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserPreference] by its [id] or null if no such row exists.
  Future<UserPreference?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserPreference>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserPreference]s in the list and returns the inserted rows.
  ///
  /// The returned [UserPreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserPreference>> insert(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserPreference] and returns the inserted row.
  ///
  /// The returned [UserPreference] will have its `id` field set.
  Future<UserPreference> insertRow(
    _i1.Session session,
    UserPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserPreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserPreference>> update(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.ColumnSelections<UserPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserPreference>(
      rows,
      columns: columns?.call(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserPreference> updateRow(
    _i1.Session session,
    UserPreference row, {
    _i1.ColumnSelections<UserPreferenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserPreference>(
      row,
      columns: columns?.call(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreference] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserPreference?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserPreferenceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserPreference>(
      id,
      columnValues: columnValues(UserPreference.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserPreference]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserPreference>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserPreferenceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserPreferenceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPreferenceTable>? orderBy,
    _i1.OrderByListBuilder<UserPreferenceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserPreference>(
      columnValues: columnValues(UserPreference.t.updateTable),
      where: where(UserPreference.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreference.t),
      orderByList: orderByList?.call(UserPreference.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserPreference]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserPreference>> delete(
    _i1.Session session,
    List<UserPreference> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserPreference>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserPreference].
  Future<UserPreference> deleteRow(
    _i1.Session session,
    UserPreference row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserPreference>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserPreferenceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserPreference>(
      where: where(UserPreference.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPreferenceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserPreference>(
      where: where?.call(UserPreference.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
