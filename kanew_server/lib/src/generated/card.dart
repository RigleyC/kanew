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
import 'card_priority.dart' as _i2;

abstract class Card
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Card._({
    this.id,
    required this.listId,
    required this.boardId,
    required this.title,
    this.descriptionDocument,
    required this.priority,
    required this.rank,
    this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory Card({
    _i1.UuidValue? id,
    required _i1.UuidValue listId,
    required _i1.UuidValue boardId,
    required String title,
    String? descriptionDocument,
    required _i2.CardPriority priority,
    required String rank,
    DateTime? dueDate,
    required bool isCompleted,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? updatedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _CardImpl;

  factory Card.fromJson(Map<String, dynamic> jsonSerialization) {
    return Card(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      listId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['listId']),
      boardId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['boardId'],
      ),
      title: jsonSerialization['title'] as String,
      descriptionDocument: jsonSerialization['descriptionDocument'] as String?,
      priority: _i2.CardPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      rank: jsonSerialization['rank'] as String,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      isCompleted: jsonSerialization['isCompleted'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      createdBy: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['deletedBy']),
    );
  }

  static final t = CardTable();

  static const db = CardRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue listId;

  _i1.UuidValue boardId;

  String title;

  String? descriptionDocument;

  _i2.CardPriority priority;

  String rank;

  DateTime? dueDate;

  bool isCompleted;

  DateTime createdAt;

  _i1.UuidValue createdBy;

  DateTime? updatedAt;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Card]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Card copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? listId,
    _i1.UuidValue? boardId,
    String? title,
    String? descriptionDocument,
    _i2.CardPriority? priority,
    String? rank,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    DateTime? updatedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Card',
      if (id != null) 'id': id?.toJson(),
      'listId': listId.toJson(),
      'boardId': boardId.toJson(),
      'title': title,
      if (descriptionDocument != null)
        'descriptionDocument': descriptionDocument,
      'priority': priority.toJson(),
      'rank': rank,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Card',
      if (id != null) 'id': id?.toJson(),
      'listId': listId.toJson(),
      'boardId': boardId.toJson(),
      'title': title,
      if (descriptionDocument != null)
        'descriptionDocument': descriptionDocument,
      'priority': priority.toJson(),
      'rank': rank,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy?.toJson(),
    };
  }

  static CardInclude include() {
    return CardInclude._();
  }

  static CardIncludeList includeList({
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    CardInclude? include,
  }) {
    return CardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Card.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Card.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardImpl extends Card {
  _CardImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue listId,
    required _i1.UuidValue boardId,
    required String title,
    String? descriptionDocument,
    required _i2.CardPriority priority,
    required String rank,
    DateTime? dueDate,
    required bool isCompleted,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? updatedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         listId: listId,
         boardId: boardId,
         title: title,
         descriptionDocument: descriptionDocument,
         priority: priority,
         rank: rank,
         dueDate: dueDate,
         isCompleted: isCompleted,
         createdAt: createdAt,
         createdBy: createdBy,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [Card]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Card copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? listId,
    _i1.UuidValue? boardId,
    String? title,
    Object? descriptionDocument = _Undefined,
    _i2.CardPriority? priority,
    String? rank,
    Object? dueDate = _Undefined,
    bool? isCompleted,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return Card(
      id: id is _i1.UuidValue? ? id : this.id,
      listId: listId ?? this.listId,
      boardId: boardId ?? this.boardId,
      title: title ?? this.title,
      descriptionDocument: descriptionDocument is String?
          ? descriptionDocument
          : this.descriptionDocument,
      priority: priority ?? this.priority,
      rank: rank ?? this.rank,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}

class CardUpdateTable extends _i1.UpdateTable<CardTable> {
  CardUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> listId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.listId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> boardId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.boardId,
        value,
      );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> descriptionDocument(String? value) =>
      _i1.ColumnValue(
        table.descriptionDocument,
        value,
      );

  _i1.ColumnValue<_i2.CardPriority, _i2.CardPriority> priority(
    _i2.CardPriority value,
  ) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> rank(String value) => _i1.ColumnValue(
    table.rank,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dueDate(DateTime? value) =>
      _i1.ColumnValue(
        table.dueDate,
        value,
      );

  _i1.ColumnValue<bool, bool> isCompleted(bool value) => _i1.ColumnValue(
    table.isCompleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> createdBy(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
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

class CardTable extends _i1.Table<_i1.UuidValue?> {
  CardTable({super.tableRelation}) : super(tableName: 'card') {
    updateTable = CardUpdateTable(this);
    listId = _i1.ColumnUuid(
      'listId',
      this,
    );
    boardId = _i1.ColumnUuid(
      'boardId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    descriptionDocument = _i1.ColumnString(
      'descriptionDocument',
      this,
    );
    priority = _i1.ColumnEnum(
      'priority',
      this,
      _i1.EnumSerialization.byName,
    );
    rank = _i1.ColumnString(
      'rank',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    createdBy = _i1.ColumnUuid(
      'createdBy',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
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

  late final CardUpdateTable updateTable;

  late final _i1.ColumnUuid listId;

  late final _i1.ColumnUuid boardId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString descriptionDocument;

  late final _i1.ColumnEnum<_i2.CardPriority> priority;

  late final _i1.ColumnString rank;

  late final _i1.ColumnDateTime dueDate;

  late final _i1.ColumnBool isCompleted;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnUuid createdBy;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnUuid deletedBy;

  @override
  List<_i1.Column> get columns => [
    id,
    listId,
    boardId,
    title,
    descriptionDocument,
    priority,
    rank,
    dueDate,
    isCompleted,
    createdAt,
    createdBy,
    updatedAt,
    deletedAt,
    deletedBy,
  ];
}

class CardInclude extends _i1.IncludeObject {
  CardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Card.t;
}

class CardIncludeList extends _i1.IncludeList {
  CardIncludeList._({
    _i1.WhereExpressionBuilder<CardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Card.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Card.t;
}

class CardRepository {
  const CardRepository._();

  /// Returns a list of [Card]s matching the given query parameters.
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
  Future<List<Card>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Card>(
      where: where?.call(Card.t),
      orderBy: orderBy?.call(Card.t),
      orderByList: orderByList?.call(Card.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Card] matching the given query parameters.
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
  Future<Card?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Card>(
      where: where?.call(Card.t),
      orderBy: orderBy?.call(Card.t),
      orderByList: orderByList?.call(Card.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Card] by its [id] or null if no such row exists.
  Future<Card?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Card>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Card]s in the list and returns the inserted rows.
  ///
  /// The returned [Card]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Card>> insert(
    _i1.Session session,
    List<Card> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Card>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Card] and returns the inserted row.
  ///
  /// The returned [Card] will have its `id` field set.
  Future<Card> insertRow(
    _i1.Session session,
    Card row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Card>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Card]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Card>> update(
    _i1.Session session,
    List<Card> rows, {
    _i1.ColumnSelections<CardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Card>(
      rows,
      columns: columns?.call(Card.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Card]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Card> updateRow(
    _i1.Session session,
    Card row, {
    _i1.ColumnSelections<CardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Card>(
      row,
      columns: columns?.call(Card.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Card] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Card?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<CardUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Card>(
      id,
      columnValues: columnValues(Card.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Card]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Card>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CardUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CardTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Card>(
      columnValues: columnValues(Card.t.updateTable),
      where: where(Card.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Card.t),
      orderByList: orderByList?.call(Card.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Card]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Card>> delete(
    _i1.Session session,
    List<Card> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Card>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Card].
  Future<Card> deleteRow(
    _i1.Session session,
    Card row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Card>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Card>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Card>(
      where: where(Card.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Card>(
      where: where?.call(Card.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
