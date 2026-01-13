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
    required this.userInfoId,
    required this.workspaceId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory WorkspaceMember({
    int? id,
    required int userInfoId,
    required int workspaceId,
    required _i2.MemberRole role,
    required _i3.MemberStatus status,
    required DateTime joinedAt,
    DateTime? deletedAt,
    int? deletedBy,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      workspaceId: jsonSerialization['workspaceId'] as int,
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
      deletedBy: jsonSerialization['deletedBy'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  int workspaceId;

  _i2.MemberRole role;

  _i3.MemberStatus status;

  DateTime joinedAt;

  DateTime? deletedAt;

  int? deletedBy;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMember copyWith({
    int? id,
    int? userInfoId,
    int? workspaceId,
    _i2.MemberRole? role,
    _i3.MemberStatus? status,
    DateTime? joinedAt,
    DateTime? deletedAt,
    int? deletedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'workspaceId': workspaceId,
      'role': role.toJson(),
      'status': status.toJson(),
      'joinedAt': joinedAt.toJson(),
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

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    int? id,
    required int userInfoId,
    required int workspaceId,
    required _i2.MemberRole role,
    required _i3.MemberStatus status,
    required DateTime joinedAt,
    DateTime? deletedAt,
    int? deletedBy,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
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
    int? userInfoId,
    int? workspaceId,
    _i2.MemberRole? role,
    _i3.MemberStatus? status,
    DateTime? joinedAt,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
  }) {
    return WorkspaceMember(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      workspaceId: workspaceId ?? this.workspaceId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is int? ? deletedBy : this.deletedBy,
    );
  }
}
