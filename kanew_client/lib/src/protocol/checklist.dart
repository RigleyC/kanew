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

abstract class Checklist implements _i1.SerializableModel {
  Checklist._({
    this.id,
    required this.cardId,
    required this.title,
    required this.rank,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Checklist({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required String title,
    required String rank,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _ChecklistImpl;

  factory Checklist.fromJson(Map<String, dynamic> jsonSerialization) {
    return Checklist(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      cardId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['cardId']),
      title: jsonSerialization['title'] as String,
      rank: jsonSerialization['rank'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue cardId;

  String title;

  String rank;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Checklist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Checklist copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? cardId,
    String? title,
    String? rank,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Checklist',
      if (id != null) 'id': id?.toJson(),
      'cardId': cardId.toJson(),
      'title': title,
      'rank': rank,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistImpl extends Checklist {
  _ChecklistImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue cardId,
    required String title,
    required String rank,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         title: title,
         rank: rank,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Checklist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Checklist copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? cardId,
    String? title,
    String? rank,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
  }) {
    return Checklist(
      id: id is _i1.UuidValue? ? id : this.id,
      cardId: cardId ?? this.cardId,
      title: title ?? this.title,
      rank: rank ?? this.rank,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
