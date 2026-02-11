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
    bool? isRemoved,
    this.grantedAt,
  }) : isRemoved = isRemoved ?? false;

  factory MemberPermission({
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceMemberId,
    required _i1.UuidValue permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  }) = _MemberPermissionImpl;

  factory MemberPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberPermission(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceMemberId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceMemberId'],
      ),
      permissionId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['permissionId'],
      ),
      scopeBoardId: jsonSerialization['scopeBoardId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['scopeBoardId'],
            ),
      isRemoved: jsonSerialization['isRemoved'] as bool?,
      grantedAt: jsonSerialization['grantedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['grantedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue workspaceMemberId;

  _i1.UuidValue permissionId;

  _i1.UuidValue? scopeBoardId;

  bool isRemoved;

  DateTime? grantedAt;

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MemberPermission copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? workspaceMemberId,
    _i1.UuidValue? permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberPermission',
      if (id != null) 'id': id?.toJson(),
      'workspaceMemberId': workspaceMemberId.toJson(),
      'permissionId': permissionId.toJson(),
      if (scopeBoardId != null) 'scopeBoardId': scopeBoardId?.toJson(),
      'isRemoved': isRemoved,
      if (grantedAt != null) 'grantedAt': grantedAt?.toJson(),
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
    _i1.UuidValue? id,
    required _i1.UuidValue workspaceMemberId,
    required _i1.UuidValue permissionId,
    _i1.UuidValue? scopeBoardId,
    bool? isRemoved,
    DateTime? grantedAt,
  }) : super._(
         id: id,
         workspaceMemberId: workspaceMemberId,
         permissionId: permissionId,
         scopeBoardId: scopeBoardId,
         isRemoved: isRemoved,
         grantedAt: grantedAt,
       );

  /// Returns a shallow copy of this [MemberPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MemberPermission copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? workspaceMemberId,
    _i1.UuidValue? permissionId,
    Object? scopeBoardId = _Undefined,
    bool? isRemoved,
    Object? grantedAt = _Undefined,
  }) {
    return MemberPermission(
      id: id is _i1.UuidValue? ? id : this.id,
      workspaceMemberId: workspaceMemberId ?? this.workspaceMemberId,
      permissionId: permissionId ?? this.permissionId,
      scopeBoardId: scopeBoardId is _i1.UuidValue?
          ? scopeBoardId
          : this.scopeBoardId,
      isRemoved: isRemoved ?? this.isRemoved,
      grantedAt: grantedAt is DateTime? ? grantedAt : this.grantedAt,
    );
  }
}
