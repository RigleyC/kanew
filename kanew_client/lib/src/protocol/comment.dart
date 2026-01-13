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

abstract class Comment implements _i1.SerializableModel {
  Comment._({
    this.id,
    required this.cardId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Comment({
    int? id,
    required int cardId,
    required int authorId,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _CommentImpl;

  factory Comment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Comment(
      id: jsonSerialization['id'] as int?,
      cardId: jsonSerialization['cardId'] as int,
      authorId: jsonSerialization['authorId'] as int,
      content: jsonSerialization['content'] as String,
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
  int? id;

  int cardId;

  int authorId;

  String content;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Comment copyWith({
    int? id,
    int? cardId,
    int? authorId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Comment',
      if (id != null) 'id': id,
      'cardId': cardId,
      'authorId': authorId,
      'content': content,
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

class _CommentImpl extends Comment {
  _CommentImpl({
    int? id,
    required int cardId,
    required int authorId,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         cardId: cardId,
         authorId: authorId,
         content: content,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Comment copyWith({
    Object? id = _Undefined,
    int? cardId,
    int? authorId,
    String? content,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
  }) {
    return Comment(
      id: id is int? ? id : this.id,
      cardId: cardId ?? this.cardId,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
