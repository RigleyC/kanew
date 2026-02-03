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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'card_priority.dart' as _i2;

abstract class Card implements _i1.SerializableModel {
  Card._({
    this.id,
    required this.uuid,
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
    int? id,
    required _i1.UuidValue uuid,
    required int listId,
    required int boardId,
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
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      listId: jsonSerialization['listId'] as int,
      boardId: jsonSerialization['boardId'] as int,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuid;

  int listId;

  int boardId;

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

  /// Returns a shallow copy of this [Card]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Card copyWith({
    int? id,
    _i1.UuidValue? uuid,
    int? listId,
    int? boardId,
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
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'listId': listId,
      'boardId': boardId,
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardImpl extends Card {
  _CardImpl({
    int? id,
    required _i1.UuidValue uuid,
    required int listId,
    required int boardId,
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
         uuid: uuid,
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
    _i1.UuidValue? uuid,
    int? listId,
    int? boardId,
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
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
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
