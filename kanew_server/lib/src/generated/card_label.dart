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

abstract class CardLabel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CardLabel._({
    this.id,
    required this.cardId,
    required this.labelDefId,
  });

  factory CardLabel({
    int? id,
    required int cardId,
    required int labelDefId,
  }) = _CardLabelImpl;

  factory CardLabel.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardLabel(
      id: jsonSerialization['id'] as int?,
      cardId: jsonSerialization['cardId'] as int,
      labelDefId: jsonSerialization['labelDefId'] as int,
    );
  }

  static final t = CardLabelTable();

  static const db = CardLabelRepository._();

  @override
  int? id;

  int cardId;

  int labelDefId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardLabel copyWith({
    int? id,
    int? cardId,
    int? labelDefId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardLabel',
      if (id != null) 'id': id,
      'cardId': cardId,
      'labelDefId': labelDefId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CardLabel',
      if (id != null) 'id': id,
      'cardId': cardId,
      'labelDefId': labelDefId,
    };
  }

  static CardLabelInclude include() {
    return CardLabelInclude._();
  }

  static CardLabelIncludeList includeList({
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    CardLabelInclude? include,
  }) {
    return CardLabelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardLabel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CardLabel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardLabelImpl extends CardLabel {
  _CardLabelImpl({
    int? id,
    required int cardId,
    required int labelDefId,
  }) : super._(
         id: id,
         cardId: cardId,
         labelDefId: labelDefId,
       );

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardLabel copyWith({
    Object? id = _Undefined,
    int? cardId,
    int? labelDefId,
  }) {
    return CardLabel(
      id: id is int? ? id : this.id,
      cardId: cardId ?? this.cardId,
      labelDefId: labelDefId ?? this.labelDefId,
    );
  }
}

class CardLabelUpdateTable extends _i1.UpdateTable<CardLabelTable> {
  CardLabelUpdateTable(super.table);

  _i1.ColumnValue<int, int> cardId(int value) => _i1.ColumnValue(
    table.cardId,
    value,
  );

  _i1.ColumnValue<int, int> labelDefId(int value) => _i1.ColumnValue(
    table.labelDefId,
    value,
  );
}

class CardLabelTable extends _i1.Table<int?> {
  CardLabelTable({super.tableRelation}) : super(tableName: 'card_label') {
    updateTable = CardLabelUpdateTable(this);
    cardId = _i1.ColumnInt(
      'cardId',
      this,
    );
    labelDefId = _i1.ColumnInt(
      'labelDefId',
      this,
    );
  }

  late final CardLabelUpdateTable updateTable;

  late final _i1.ColumnInt cardId;

  late final _i1.ColumnInt labelDefId;

  @override
  List<_i1.Column> get columns => [
    id,
    cardId,
    labelDefId,
  ];
}

class CardLabelInclude extends _i1.IncludeObject {
  CardLabelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CardLabel.t;
}

class CardLabelIncludeList extends _i1.IncludeList {
  CardLabelIncludeList._({
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CardLabel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CardLabel.t;
}

class CardLabelRepository {
  const CardLabelRepository._();

  /// Returns a list of [CardLabel]s matching the given query parameters.
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
  Future<List<CardLabel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CardLabel>(
      where: where?.call(CardLabel.t),
      orderBy: orderBy?.call(CardLabel.t),
      orderByList: orderByList?.call(CardLabel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CardLabel] matching the given query parameters.
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
  Future<CardLabel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CardLabel>(
      where: where?.call(CardLabel.t),
      orderBy: orderBy?.call(CardLabel.t),
      orderByList: orderByList?.call(CardLabel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CardLabel] by its [id] or null if no such row exists.
  Future<CardLabel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CardLabel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CardLabel]s in the list and returns the inserted rows.
  ///
  /// The returned [CardLabel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CardLabel>> insert(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CardLabel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CardLabel] and returns the inserted row.
  ///
  /// The returned [CardLabel] will have its `id` field set.
  Future<CardLabel> insertRow(
    _i1.Session session,
    CardLabel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CardLabel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CardLabel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CardLabel>> update(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.ColumnSelections<CardLabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CardLabel>(
      rows,
      columns: columns?.call(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardLabel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CardLabel> updateRow(
    _i1.Session session,
    CardLabel row, {
    _i1.ColumnSelections<CardLabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CardLabel>(
      row,
      columns: columns?.call(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardLabel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CardLabel?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CardLabelUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CardLabel>(
      id,
      columnValues: columnValues(CardLabel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CardLabel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CardLabel>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CardLabelUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CardLabelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CardLabel>(
      columnValues: columnValues(CardLabel.t.updateTable),
      where: where(CardLabel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardLabel.t),
      orderByList: orderByList?.call(CardLabel.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CardLabel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CardLabel>> delete(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CardLabel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CardLabel].
  Future<CardLabel> deleteRow(
    _i1.Session session,
    CardLabel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CardLabel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CardLabel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardLabelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CardLabel>(
      where: where(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CardLabel>(
      where: where?.call(CardLabel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
