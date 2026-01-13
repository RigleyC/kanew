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

abstract class MemberPermission implements _i1.SerializableModel {
  MemberPermission._({
    this.id,
    required this.workspaceMemberId,
    required this.permissionId,
    this.scopeBoardId,
  });

  factory MemberPermission({
    int? id,
    required int workspaceMemberId,
    required int permissionId,
    int? scopeBoardId,
  }) = _MemberPermissionImpl;

  factory MemberPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberPermission(
      id: jsonSerialization['id'] as int?,
      workspaceMemberId: jsonSerialization['workspaceMemberId'] as int,
      permissionId: jsonSerialization['permissionId'] as int,
      scopeBoardId: jsonSerialization['scopeBoardId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceMemberId;

  int permissionId;

  int? scopeBoardId;

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MemberPermission copyWith({
    int? id,
    int? workspaceMemberId,
    int? permissionId,
    int? scopeBoardId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id,
      'workspaceMemberId': workspaceMemberId,
      'permissionId': permissionId,
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberPermissionImpl extends MemberPermission {
  _MemberPermissionImpl({
    int? id,
    required int workspaceMemberId,
    required int permissionId,
    int? scopeBoardId,
  }) : super._(
         id: id,
         workspaceMemberId: workspaceMemberId,
         permissionId: permissionId,
         scopeBoardId: scopeBoardId,
       );

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MemberPermission copyWith({
    Object? id = _Undefined,
    int? workspaceMemberId,
    int? permissionId,
    Object? scopeBoardId = _Undefined,
  }) {
    return MemberPermission(
      id: id is int? ? id : this.id,
      workspaceMemberId: workspaceMemberId ?? this.workspaceMemberId,
      permissionId: permissionId ?? this.permissionId,
      scopeBoardId: scopeBoardId is int? ? scopeBoardId : this.scopeBoardId,
    );
  }
}
