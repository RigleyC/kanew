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

abstract class Permission implements _i1.SerializableModel {
  Permission._({
    this.id,
    required this.slug,
    this.description,
  });

  factory Permission({
    _i1.UuidValue? id,
    required String slug,
    String? description,
  }) = _PermissionImpl;

  factory Permission.fromJson(Map<String, dynamic> jsonSerialization) {
    return Permission(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      slug: jsonSerialization['slug'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String slug;

  String? description;

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Permission copyWith({
    _i1.UuidValue? id,
    String? slug,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Permission',
      if (id != null) 'id': id?.toJson(),
      'slug': slug,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionImpl extends Permission {
  _PermissionImpl({
    _i1.UuidValue? id,
    required String slug,
    String? description,
  }) : super._(
         id: id,
         slug: slug,
         description: description,
       );

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Permission copyWith({
    Object? id = _Undefined,
    String? slug,
    Object? description = _Undefined,
  }) {
    return Permission(
      id: id is _i1.UuidValue? ? id : this.id,
      slug: slug ?? this.slug,
      description: description is String? ? description : this.description,
    );
  }
}
