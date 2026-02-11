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
import 'member_role.dart' as _i2;
import 'member_status.dart' as _i3;

abstract class WorkspaceMember implements _i1.SerializableModel {
  WorkspaceMember._({
    this.id,
    required this.authUserId,
    required this.workspaceId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory WorkspaceMember({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    required _i1.UuidValue workspaceId,
    required _i2.MemberRole role,
    required _i3.MemberStatus status,
    required DateTime joinedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      workspaceId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      role: _i2.MemberRole.fromJson((jsonSerialization['role'] as String)),
      status: _i3.MemberStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      joinedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
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

  _i1.UuidValue authUserId;

  _i1.UuidValue workspaceId;

  _i2.MemberRole role;

  _i3.MemberStatus status;

  DateTime joinedAt;

  DateTime? deletedAt;

  _i1.UuidValue? deletedBy;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMember copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i1.UuidValue? workspaceId,
    _i2.MemberRole? role,
    _i3.MemberStatus? status,
    DateTime? joinedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      'workspaceId': workspaceId.toJson(),
      'role': role.toJson(),
      'status': status.toJson(),
      'joinedAt': joinedAt.toJson(),
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

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    required _i1.UuidValue workspaceId,
    required _i2.MemberRole role,
    required _i3.MemberStatus status,
    required DateTime joinedAt,
    DateTime? deletedAt,
    _i1.UuidValue? deletedBy,
  }) : super._(
         id: id,
         authUserId: authUserId,
         workspaceId: workspaceId,
         role: role,
         status: status,
         joinedAt: joinedAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
       );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    _i1.UuidValue? workspaceId,
    _i2.MemberRole? role,
    _i3.MemberStatus? status,
    DateTime? joinedAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return WorkspaceMember(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      workspaceId: workspaceId ?? this.workspaceId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is _i1.UuidValue? ? deletedBy : this.deletedBy,
    );
  }
}
