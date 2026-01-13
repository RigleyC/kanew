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

abstract class CardList implements _i1.SerializableModel {
  CardList._({
    this.id,
    required this.uuid,
    required this.boardId,
    required this.title,
    required this.rank,
    required this.archived,
    required this.createdAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory CardList({
    int? id,
    required _i1.UuidValue uuid,
    required int boardId,
    required String title,
    required String rank,
    required bool archived,
    required DateTime createdAt,
    DateTime? deletedAt,
    int? deletedBy,
  }) = _CardListImpl;

  factory CardList.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardList(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      boardId: jsonSerialization['boardId'] as int,
      title: jsonSerialization['title'] as String,
      rank: jsonSerialization['rank'] as String,
      archived: jsonSerialization['archived'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuid;

  int boardId;

  String title;

  String rank;

  bool archived;

  DateTime createdAt;

  DateTime? deletedAt;

  int? deletedBy;

  /// Returns a shallow copy of this [CardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardList copyWith({
    int? id,
    _i1.UuidValue? uuid,
    int? boardId,
    String? title,
    String? rank,
    bool? archived,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardList',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'boardId': boardId,
      'title': title,
      'rank': rank,
      'archived': archived,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardListImpl extends CardList {
  _CardListImpl({
    int? id,
    required _i1.UuidValue uuid,
    required int boardId,
    required String title,
    required String rank,
    required bool archived,
    required DateTime createdAt,
    DateTime? deletedAt,
    int? deletedBy,
  }) : super._(
         id: id,
         uuid: uuid,
         boardId: boardId,
         title: title,
         rank: rank,
         archived: archived,
         createdAt: createdAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [CardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardList copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    int? boardId,
    String? title,
    String? rank,
    bool? archived,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return CardList(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      boardId: boardId ?? this.boardId,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is int? ? deletedBy : this.deletedBy,
    );
  }
}
