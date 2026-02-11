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

abstract class UserPreference implements _i1.SerializableModel {
  UserPreference._({
    this.id,
    required this.authUserId,
    this.lastWorkspaceId,
    this.theme,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreference({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserPreferenceImpl;

  factory UserPreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreference(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      lastWorkspaceId: jsonSerialization['lastWorkspaceId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastWorkspaceId'],
            ),
      theme: jsonSerialization['theme'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  _i1.UuidValue? lastWorkspaceId;

  String? theme;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreference copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreference',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (lastWorkspaceId != null) 'lastWorkspaceId': lastWorkspaceId?.toJson(),
      if (theme != null) 'theme': theme,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPreferenceImpl extends UserPreference {
  _UserPreferenceImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i1.UuidValue? lastWorkspaceId,
    String? theme,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         lastWorkspaceId: lastWorkspaceId,
         theme: theme,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreference copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? lastWorkspaceId = _Undefined,
    Object? theme = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreference(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      lastWorkspaceId: lastWorkspaceId is _i1.UuidValue?
          ? lastWorkspaceId
          : this.lastWorkspaceId,
      theme: theme is String? ? theme : this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
