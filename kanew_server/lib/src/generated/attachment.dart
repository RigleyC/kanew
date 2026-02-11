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

abstract class Attachment
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Attachment._({
    this.id,
    required this.cardId,
    required this.workspaceId,
    required this.fileName,
    required this.mimeType,
    required this.size,
    required this.storageKey,
    this.fileUrl,
    required this.uploaderId,
    required this.createdAt,
    this.deletedAt,
  });

  factory Attachment({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue workspaceId,
    required String fileName,
    required String mimeType,
    required int size,
    required String storageKey,
    String? fileUrl,
    required _i1.UuidValue uploaderId,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      workspaceId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      size: jsonSerialization['size'] as int,
      storageKey: jsonSerialization['storageKey'] as String,
      fileUrl: jsonSerialization['fileUrl'] as String?,
      uploaderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['uploaderId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = AttachmentTable();

  static const db = AttachmentRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  _i1.UuidValue workspaceId;

  String fileName;

  String mimeType;

  int size;

  String storageKey;

  String? fileUrl;

  _i1.UuidValue uploaderId;

  DateTime createdAt;

  DateTime? deletedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attachment copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    _i1.UuidValue? workspaceId,
    String? fileName,
    String? mimeType,
    int? size,
    String? storageKey,
    String? fileUrl,
    _i1.UuidValue? uploaderId,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'workspaceId': workspaceId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'size': size,
      'storageKey': storageKey,
      if (fileUrl != null) 'fileUrl': fileUrl,
      'uploaderId': uploaderId.toJson(),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'workspaceId': workspaceId.toJson(),
      'fileName': fileName,
      'mimeType': mimeType,
      'size': size,
      'storageKey': storageKey,
      if (fileUrl != null) 'fileUrl': fileUrl,
      'uploaderId': uploaderId.toJson(),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static AttachmentInclude include() {
    return AttachmentInclude._();
  }

  static AttachmentIncludeList includeList({
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    AttachmentInclude? include,
  }) {
    return AttachmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attachment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Attachment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required _i1.UuidValue workspaceId,
    required String fileName,
    required String mimeType,
    required int size,
    required String storageKey,
    String? fileUrl,
    required _i1.UuidValue uploaderId,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         workspaceId: workspaceId,
         fileName: fileName,
         mimeType: mimeType,
         size: size,
         storageKey: storageKey,
         fileUrl: fileUrl,
         uploaderId: uploaderId,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attachment copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    _i1.UuidValue? workspaceId,
    String? fileName,
    String? mimeType,
    int? size,
    String? storageKey,
    Object? fileUrl = _Undefined,
    _i1.UuidValue? uploaderId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Attachment(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      workspaceId: workspaceId ?? this.workspaceId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      storageKey: storageKey ?? this.storageKey,
      fileUrl: fileUrl is String? ? fileUrl : this.fileUrl,
      uploaderId: uploaderId ?? this.uploaderId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class AttachmentUpdateTable extends _i1.UpdateTable<AttachmentTable> {
  AttachmentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> cardId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.cardId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> workspaceId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.workspaceId,
    value,
  );

  _i1.ColumnValue<String, String> fileName(String value) => _i1.ColumnValue(
    table.fileName,
    value,
  );

  _i1.ColumnValue<String, String> mimeType(String value) => _i1.ColumnValue(
    table.mimeType,
    value,
  );

  _i1.ColumnValue<int, int> size(int value) => _i1.ColumnValue(
    table.size,
    value,
  );

  _i1.ColumnValue<String, String> storageKey(String value) => _i1.ColumnValue(
    table.storageKey,
    value,
  );

  _i1.ColumnValue<String, String> fileUrl(String? value) => _i1.ColumnValue(
    table.fileUrl,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> uploaderId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.uploaderId,
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
}

class AttachmentTable extends _i1.Table<_i1.UuidValue?> {
  AttachmentTable({super.tableRelation}) : super(tableName: 'attachment') {
    updateTable = AttachmentUpdateTable(this);
    cardId = _i1.ColumnUuid(
      'cardId',
      this,
    );
    workspaceId = _i1.ColumnUuid(
      'workspaceId',
      this,
    );
    fileName = _i1.ColumnString(
      'fileName',
      this,
    );
    mimeType = _i1.ColumnString(
      'mimeType',
      this,
    );
    size = _i1.ColumnInt(
      'size',
      this,
    );
    storageKey = _i1.ColumnString(
      'storageKey',
      this,
    );
    fileUrl = _i1.ColumnString(
      'fileUrl',
      this,
    );
    uploaderId = _i1.ColumnUuid(
      'uploaderId',
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
  }

  late final AttachmentUpdateTable updateTable;

  late final _i1.ColumnUuid cardId;

  late final _i1.ColumnUuid workspaceId;

  late final _i1.ColumnString fileName;

  late final _i1.ColumnString mimeType;

  late final _i1.ColumnInt size;

  late final _i1.ColumnString storageKey;

  late final _i1.ColumnString fileUrl;

  late final _i1.ColumnUuid uploaderId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cardId,
    workspaceId,
    fileName,
    mimeType,
    size,
    storageKey,
    fileUrl,
    uploaderId,
    createdAt,
    deletedAt,
  ];
}

class AttachmentInclude extends _i1.IncludeObject {
  AttachmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Attachment.t;
}

class AttachmentIncludeList extends _i1.IncludeList {
  AttachmentIncludeList._({
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Attachment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Attachment.t;
}

class AttachmentRepository {
  const AttachmentRepository._();

  /// Returns a list of [Attachment]s matching the given query parameters.
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
  Future<List<Attachment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Attachment>(
      where: where?.call(Attachment.t),
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Attachment] matching the given query parameters.
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
  Future<Attachment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Attachment>(
      where: where?.call(Attachment.t),
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Attachment] by its [id] or null if no such row exists.
  Future<Attachment?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Attachment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Attachment]s in the list and returns the inserted rows.
  ///
  /// The returned [Attachment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Attachment>> insert(
    _i1.Session session,
    List<Attachment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Attachment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Attachment] and returns the inserted row.
  ///
  /// The returned [Attachment] will have its `id` field set.
  Future<Attachment> insertRow(
    _i1.Session session,
    Attachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Attachment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Attachment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Attachment>> update(
    _i1.Session session,
    List<Attachment> rows, {
    _i1.ColumnSelections<AttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Attachment>(
      rows,
      columns: columns?.call(Attachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attachment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Attachment> updateRow(
    _i1.Session session,
    Attachment row, {
    _i1.ColumnSelections<AttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Attachment>(
      row,
      columns: columns?.call(Attachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attachment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Attachment?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AttachmentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Attachment>(
      id,
      columnValues: columnValues(Attachment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Attachment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Attachment>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AttachmentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AttachmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Attachment>(
      columnValues: columnValues(Attachment.t.updateTable),
      where: where(Attachment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Attachment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Attachment>> delete(
    _i1.Session session,
    List<Attachment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Attachment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Attachment].
  Future<Attachment> deleteRow(
    _i1.Session session,
    Attachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Attachment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Attachment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AttachmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Attachment>(
      where: where(Attachment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Attachment>(
      where: where?.call(Attachment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
