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
import 'package:serverpod/serverpod.dart' as _i1;
import 'workspace_invite.dart' as _i2;
import 'package:kanew_server/src/generated/protocol.dart' as _i3;

abstract class InviteDetails
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  InviteDetails._({
    required this.invite,
    required this.workspaceName,
    required this.workspaceSlug,
  });

  factory InviteDetails({
    required _i2.WorkspaceInvite invite,
    required String workspaceName,
    required String workspaceSlug,
  }) = _InviteDetailsImpl;

  factory InviteDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return InviteDetails(
      invite: _i3.Protocol().deserialize<_i2.WorkspaceInvite>(
        jsonSerialization['invite'],
      ),
      workspaceName: jsonSerialization['workspaceName'] as String,
      workspaceSlug: jsonSerialization['workspaceSlug'] as String,
    );
  }

  _i2.WorkspaceInvite invite;

  String workspaceName;

  String workspaceSlug;

  /// Returns a shallow copy of this [InviteDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InviteDetails copyWith({
    _i2.WorkspaceInvite? invite,
    String? workspaceName,
    String? workspaceSlug,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InviteDetails',
      'invite': invite.toJson(),
      'workspaceName': workspaceName,
      'workspaceSlug': workspaceSlug,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InviteDetails',
      'invite': invite.toJsonForProtocol(),
      'workspaceName': workspaceName,
      'workspaceSlug': workspaceSlug,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _InviteDetailsImpl extends InviteDetails {
  _InviteDetailsImpl({
    required _i2.WorkspaceInvite invite,
    required String workspaceName,
    required String workspaceSlug,
  }) : super._(
         invite: invite,
         workspaceName: workspaceName,
         workspaceSlug: workspaceSlug,
       );

  /// Returns a shallow copy of this [InviteDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InviteDetails copyWith({
    _i2.WorkspaceInvite? invite,
    String? workspaceName,
    String? workspaceSlug,
  }) {
    return InviteDetails(
      invite: invite ?? this.invite.copyWith(),
      workspaceName: workspaceName ?? this.workspaceName,
      workspaceSlug: workspaceSlug ?? this.workspaceSlug,
    );
  }
}
