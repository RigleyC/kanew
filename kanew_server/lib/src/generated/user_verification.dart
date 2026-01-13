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

abstract class UserVerification
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserVerification._({
    this.id,
    required this.userId,
    bool? emailVerified,
    DateTime? createdAt,
    this.updatedAt,
  }) : emailVerified = emailVerified ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory UserVerification({
    int? id,
    required int userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserVerificationImpl;

  factory UserVerification.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserVerification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      emailVerified: jsonSerialization['emailVerified'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserVerificationTable();

  static const db = UserVerificationRepository._();

  @override
  int? id;

  int userId;

  bool emailVerified;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserVerification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVerification copyWith({
    int? id,
    int? userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVerification',
      if (id != null) 'id': id,
      'userId': userId,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserVerification',
      if (id != null) 'id': id,
      'userId': userId,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static UserVerificationInclude include() {
    return UserVerificationInclude._();
  }

  static UserVerificationIncludeList includeList({
    _i1.WhereExpressionBuilder<UserVerificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationTable>? orderByList,
    UserVerificationInclude? include,
  }) {
    return UserVerificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVerification.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserVerification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVerificationImpl extends UserVerification {
  _UserVerificationImpl({
    int? id,
    required int userId,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         emailVerified: emailVerified,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVerification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVerification copyWith({
    Object? id = _Undefined,
    int? userId,
    bool? emailVerified,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return UserVerification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class UserVerificationUpdateTable
    extends _i1.UpdateTable<UserVerificationTable> {
  UserVerificationUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> emailVerified(bool value) => _i1.ColumnValue(
    table.emailVerified,
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
}

class UserVerificationTable extends _i1.Table<int?> {
  UserVerificationTable({super.tableRelation})
    : super(tableName: 'user_verification') {
    updateTable = UserVerificationUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    emailVerified = _i1.ColumnBool(
      'emailVerified',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserVerificationUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnBool emailVerified;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    emailVerified,
    createdAt,
    updatedAt,
  ];
}

class UserVerificationInclude extends _i1.IncludeObject {
  UserVerificationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserVerification.t;
}

class UserVerificationIncludeList extends _i1.IncludeList {
  UserVerificationIncludeList._({
    _i1.WhereExpressionBuilder<UserVerificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserVerification.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserVerification.t;
}

class UserVerificationRepository {
  const UserVerificationRepository._();

  /// Returns a list of [UserVerification]s matching the given query parameters.
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
  Future<List<UserVerification>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserVerification>(
      where: where?.call(UserVerification.t),
      orderBy: orderBy?.call(UserVerification.t),
      orderByList: orderByList?.call(UserVerification.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserVerification] matching the given query parameters.
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
  Future<UserVerification?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserVerificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserVerification>(
      where: where?.call(UserVerification.t),
      orderBy: orderBy?.call(UserVerification.t),
      orderByList: orderByList?.call(UserVerification.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserVerification] by its [id] or null if no such row exists.
  Future<UserVerification?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserVerification>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserVerification]s in the list and returns the inserted rows.
  ///
  /// The returned [UserVerification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserVerification>> insert(
    _i1.Session session,
    List<UserVerification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserVerification>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserVerification] and returns the inserted row.
  ///
  /// The returned [UserVerification] will have its `id` field set.
  Future<UserVerification> insertRow(
    _i1.Session session,
    UserVerification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserVerification>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserVerification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserVerification>> update(
    _i1.Session session,
    List<UserVerification> rows, {
    _i1.ColumnSelections<UserVerificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserVerification>(
      rows,
      columns: columns?.call(UserVerification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVerification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserVerification> updateRow(
    _i1.Session session,
    UserVerification row, {
    _i1.ColumnSelections<UserVerificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserVerification>(
      row,
      columns: columns?.call(UserVerification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVerification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserVerification?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserVerificationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserVerification>(
      id,
      columnValues: columnValues(UserVerification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserVerification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserVerification>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserVerificationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserVerificationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationTable>? orderBy,
    _i1.OrderByListBuilder<UserVerificationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserVerification>(
      columnValues: columnValues(UserVerification.t.updateTable),
      where: where(UserVerification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVerification.t),
      orderByList: orderByList?.call(UserVerification.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserVerification]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserVerification>> delete(
    _i1.Session session,
    List<UserVerification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserVerification>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserVerification].
  Future<UserVerification> deleteRow(
    _i1.Session session,
    UserVerification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserVerification>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserVerification>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserVerificationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserVerification>(
      where: where(UserVerification.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserVerification>(
      where: where?.call(UserVerification.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
