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
import 'board_visibility.dart' as _i2;

abstract class Board implements _i1.SerializableModel {
  Board._({
    this.id,
    required this.workspaceId,
    required this.title,
    required this.slug,
    required this.visibility,
    this.backgroundUrl,
    required this.isTemplate,
    required this.createdAt,
    required this.createdBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory Board({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceId,
    required String title,
    required String slug,
    required _i2.BoardVisibility visibility,
    String? backgroundUrl,
    required bool isTemplate,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _BoardImpl;

  factory Board.fromJson(Map<String, dynamic> jsonSerialization) {
    return Board(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      visibility: _i2.BoardVisibility.fromJson(
        (jsonSerialization['visibility'] as String),
      ),
      backgroundUrl: jsonSerialization['backgroundUrl'] as String?,
      isTemplate: jsonSerialization['isTemplate'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      createdBy: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
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
  _i1.UuidValue? id;

  _i1.UuidValue workspaceId;

  String title;

  String slug;

  _i2.BoardVisibility visibility;

  String? backgroundUrl;

  bool isTemplate;

  DateTime createdAt;

  _i1.UuidValue createdBy;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Board copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? workspaceId,
    String? title,
    String? slug,
    _i2.BoardVisibility? visibility,
    String? backgroundUrl,
    bool? isTemplate,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Board',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'title': title,
      'slug': slug,
      'visibility': visibility.toJson(),
      if (backgroundUrl != null) 'backgroundUrl': backgroundUrl,
      'isTemplate': isTemplate,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy.toJson(),
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

class _BoardImpl extends Board {
  _BoardImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceId,
    required String title,
    required String slug,
    required _i2.BoardVisibility visibility,
    String? backgroundUrl,
    required bool isTemplate,
    required DateTime createdAt,
    required _i1.UuidValue createdBy,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         title: title,
         slug: slug,
         visibility: visibility,
         backgroundUrl: backgroundUrl,
         isTemplate: isTemplate,
         createdAt: createdAt,
         createdBy: createdBy,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Board copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? workspaceId,
    String? title,
    String? slug,
    _i2.BoardVisibility? visibility,
    Object? backgroundUrl = _Undefined,
    bool? isTemplate,
    DateTime? createdAt,
    _i1.UuidValue? createdBy,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return Board(
      id: id is _i1.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      visibility: visibility ?? this.visibility,
      backgroundUrl: backgroundUrl is String?
          ? backgroundUrl
          : this.backgroundUrl,
      isTemplate: isTemplate ?? this.isTemplate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}
