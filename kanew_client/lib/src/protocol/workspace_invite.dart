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
import 'package:kanew_client/src/protocol/protocol.dart' as _i2;

abstract class WorkspaceInvite implements _i1.SerializableModel {
  WorkspaceInvite._({
    this.id,
    this.email,
    required this.code,
    required this.workspaceId,
    required this.createdBy,
    required this.initialPermissions,
    this.acceptedAt,
    this.revokedAt,
    required this.createdAt,
  });

  factory WorkspaceInvite({
    int? id,
    String? email,
    required String code,
    required int workspaceId,
    required _i1.UuidValue createdBy,
    required List<int> initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    required DateTime createdAt,
  }) = _WorkspaceInviteImpl;

  factory WorkspaceInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceInvite(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String?,
      code: jsonSerialization['code'] as String,
      workspaceId: jsonSerialization['workspaceId'] as int,
      createdBy: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      initialPermissions: _i2.Protocol().deserialize<List<int>>(
        jsonSerialization['initialPermissions'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? email;

  String code;

  int workspaceId;

  _i1.UuidValue createdBy;

  List<int> initialPermissions;

  DateTime? acceptedAt;

  DateTime? revokedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [WorkspaceInvite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceInvite copyWith({
    int? id,
    String? email,
    String? code,
    int? workspaceId,
    _i1.UuidValue? createdBy,
    List<int>? initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceInvite',
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      'code': code,
      'workspaceId': workspaceId,
      'createdBy': createdBy.toJson(),
      'initialPermissions': initialPermissions.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceInviteImpl extends WorkspaceInvite {
  _WorkspaceInviteImpl({
    int? id,
    String? email,
    required String code,
    required int workspaceId,
    required _i1.UuidValue createdBy,
    required List<int> initialPermissions,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         code: code,
         workspaceId: workspaceId,
         createdBy: createdBy,
         initialPermissions: initialPermissions,
         acceptedAt: acceptedAt,
         revokedAt: revokedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceInvite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceInvite copyWith({
    Object? id = _Undefined,
    Object? email = _Undefined,
    String? code,
    int? workspaceId,
    _i1.UuidValue? createdBy,
    List<int>? initialPermissions,
    Object? acceptedAt = _Undefined,
    Object? revokedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return WorkspaceInvite(
      id: id is int? ? id : this.id,
      email: email is String? ? email : this.email,
      code: code ?? this.code,
      workspaceId: workspaceId ?? this.workspaceId,
      createdBy: createdBy ?? this.createdBy,
      initialPermissions:
          initialPermissions ??
          this.initialPermissions.map((e0) => e0).toList(),
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
