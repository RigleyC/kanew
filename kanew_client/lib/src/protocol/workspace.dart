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

abstract class Workspace implements _i1.SerializableModel {
  Workspace._({
    this.id,
    required this.uuid,
    required this.title,
    required this.slug,
    required this.ownerId,
    required this.createdAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory Workspace({
    int? id,
    required _i1.UuidValue uuid,
    required String title,
    required String slug,
    required _i1.UuidValue ownerId,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      title: jsonSerialization['title'] as String,
      slug: jsonSerialization['slug'] as String,
      ownerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerId'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
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
  int? id;

  _i1.UuidValue uuid;

  String title;

  String slug;

  _i1.UuidValue ownerId;

  DateTime createdAt;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Workspace copyWith({
    int? id,
    _i1.UuidValue? uuid,
    String? title,
    String? slug,
    _i1.UuidValue? ownerId,
    DateTime? createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Workspace',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      'title': title,
      'slug': slug,
      'ownerId': ownerId.toJson(),
      'createdAt': createdAt.toJson(),
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

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    int? id,
    required _i1.UuidValue uuid,
    required String title,
    required String slug,
    required _i1.UuidValue ownerId,
    required DateTime createdAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         uuid: uuid,
         title: title,
         slug: slug,
         ownerId: ownerId,
         createdAt: createdAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    String? title,
    String? slug,
    _i1.UuidValue? ownerId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return Workspace(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}
