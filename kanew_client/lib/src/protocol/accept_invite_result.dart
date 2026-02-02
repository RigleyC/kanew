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
import 'workspace_member.dart' as _i2;
import 'package:kanew_client/src/protocol/protocol.dart' as _i3;

abstract class AcceptInviteResult implements _i1.SerializableModel {
  AcceptInviteResult._({
    required this.member,
    required this.workspaceSlug,
  });

  factory AcceptInviteResult({
    required _i2.WorkspaceMember member,
    required String workspaceSlug,
  }) = _AcceptInviteResultImpl;

  factory AcceptInviteResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AcceptInviteResult(
      member: _i3.Protocol().deserialize<_i2.WorkspaceMember>(
        jsonSerialization['member'],
      ),
      workspaceSlug: jsonSerialization['workspaceSlug'] as String,
    );
  }

  _i2.WorkspaceMember member;

  String workspaceSlug;

  /// Returns a shallow copy of this [AcceptInviteResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AcceptInviteResult copyWith({
    _i2.WorkspaceMember? member,
    String? workspaceSlug,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AcceptInviteResult',
      'member': member.toJson(),
      'workspaceSlug': workspaceSlug,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AcceptInviteResultImpl extends AcceptInviteResult {
  _AcceptInviteResultImpl({
    required _i2.WorkspaceMember member,
    required String workspaceSlug,
  }) : super._(
         member: member,
         workspaceSlug: workspaceSlug,
       );

  /// Returns a shallow copy of this [AcceptInviteResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AcceptInviteResult copyWith({
    _i2.WorkspaceMember? member,
    String? workspaceSlug,
  }) {
    return AcceptInviteResult(
      member: member ?? this.member.copyWith(),
      workspaceSlug: workspaceSlug ?? this.workspaceSlug,
    );
  }
}
