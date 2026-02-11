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
import 'activity_type.dart' as _i2;

abstract class CardActivity
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  CardActivity._({
    this.id,
    required this.cardId,
    required this.actorId,
    required this.type,
    this.details,
    required this.createdAt,
  });

  factory CardActivity({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue actorId,
    required _i2.ActivityType type,
    String? details,
    required DateTime createdAt,
  }) = _CardActivityImpl;

  factory CardActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardActivity(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      actorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorId'],
      ),
      type: _i2.ActivityType.fromJson((jsonSerialization['type'] as String)),
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CardActivityTable();

  static const db = CardActivityRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  _i1.UuidValue actorId;

  _i2.ActivityType type;

  String? details;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [CardActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardActivity copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    _i1.UuidValue? actorId,
    _i2.ActivityType? type,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardActivity',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'actorId': actorId.toJson(),
      'type': type.toJson(),
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CardActivity',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'actorId': actorId.toJson(),
      'type': type.toJson(),
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  static CardActivityInclude include() {
    return CardActivityInclude._();
  }

  static CardActivityIncludeList includeList({
    _i1.WhereExpressionBuilder<CardActivityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardActivityTable>? orderByList,
    CardActivityInclude? include,
  }) {
    return CardActivityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardActivity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CardActivity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardActivityImpl extends CardActivity {
  _CardActivityImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue actorId,
    required _i2.ActivityType type,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cardId: cardId,
         actorId: actorId,
         type: type,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CardActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardActivity copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    _i1.UuidValue? actorId,
    _i2.ActivityType? type,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return CardActivity(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      actorId: actorId ?? this.actorId,
      type: type ?? this.type,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CardActivityUpdateTable extends _i1.UpdateTable<CardActivityTable> {
  CardActivityUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> cardId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.cardId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> actorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.actorId,
        value,
      );

  _i1.ColumnValue<_i2.ActivityType, _i2.ActivityType> type(
    _i2.ActivityType value,
  ) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> details(String? value) => _i1.ColumnValue(
    table.details,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CardActivityTable extends _i1.Table<_i1.UuidValue?> {
  CardActivityTable({super.tableRelation}) : super(tableName: 'card_activity') {
    updateTable = CardActivityUpdateTable(this);
    cardId = _i1.ColumnUuid(
      'cardId',
      this,
    );
    actorId = _i1.ColumnUuid(
      'actorId',
      this,
    );
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byName,
    );
    details = _i1.ColumnString(
      'details',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CardActivityUpdateTable updateTable;

  late final _i1.ColumnUuid cardId;

  late final _i1.ColumnUuid actorId;

  late final _i1.ColumnEnum<_i2.ActivityType> type;

  late final _i1.ColumnString details;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cardId,
    actorId,
    type,
    details,
    createdAt,
  ];
}

class CardActivityInclude extends _i1.IncludeObject {
  CardActivityInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CardActivity.t;
}

class CardActivityIncludeList extends _i1.IncludeList {
  CardActivityIncludeList._({
    _i1.WhereExpressionBuilder<CardActivityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CardActivity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => CardActivity.t;
}

class CardActivityRepository {
  const CardActivityRepository._();

  /// Returns a list of [CardActivity]s matching the given query parameters.
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
  Future<List<CardActivity>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardActivityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardActivityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CardActivity>(
      where: where?.call(CardActivity.t),
      orderBy: orderBy?.call(CardActivity.t),
      orderByList: orderByList?.call(CardActivity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CardActivity] matching the given query parameters.
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
  Future<CardActivity?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardActivityTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardActivityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CardActivity>(
      where: where?.call(CardActivity.t),
      orderBy: orderBy?.call(CardActivity.t),
      orderByList: orderByList?.call(CardActivity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CardActivity] by its [id] or null if no such row exists.
  Future<CardActivity?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CardActivity>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CardActivity]s in the list and returns the inserted rows.
  ///
  /// The returned [CardActivity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CardActivity>> insert(
    _i1.Session session,
    List<CardActivity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CardActivity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CardActivity] and returns the inserted row.
  ///
  /// The returned [CardActivity] will have its `id` field set.
  Future<CardActivity> insertRow(
    _i1.Session session,
    CardActivity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CardActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CardActivity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CardActivity>> update(
    _i1.Session session,
    List<CardActivity> rows, {
    _i1.ColumnSelections<CardActivityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CardActivity>(
      rows,
      columns: columns?.call(CardActivity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardActivity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CardActivity> updateRow(
    _i1.Session session,
    CardActivity row, {
    _i1.ColumnSelections<CardActivityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CardActivity>(
      row,
      columns: columns?.call(CardActivity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardActivity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CardActivity?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CardActivityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CardActivity>(
      id,
      columnValues: columnValues(CardActivity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CardActivity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CardActivity>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CardActivityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CardActivityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardActivityTable>? orderBy,
    _i1.OrderByListBuilder<CardActivityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CardActivity>(
      columnValues: columnValues(CardActivity.t.updateTable),
      where: where(CardActivity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardActivity.t),
      orderByList: orderByList?.call(CardActivity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CardActivity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CardActivity>> delete(
    _i1.Session session,
    List<CardActivity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CardActivity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CardActivity].
  Future<CardActivity> deleteRow(
    _i1.Session session,
    CardActivity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CardActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CardActivity>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardActivityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CardActivity>(
      where: where(CardActivity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardActivityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CardActivity>(
      where: where?.call(CardActivity.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
