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

abstract class MemberWithUser implements _i1.SerializableModel {
  MemberWithUser._({
    required this.member,
    required this.userName,
    required this.userEmail,
    this.userImageUrl,
  });

  factory MemberWithUser({
    required _i2.WorkspaceMember member,
    required String userName,
    required String userEmail,
    String? userImageUrl,
  }) = _MemberWithUserImpl;

  factory MemberWithUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberWithUser(
      member: _i3.Protocol().deserialize<_i2.WorkspaceMember>(
        jsonSerialization['member'],
      ),
      userName: jsonSerialization['userName'] as String,
      userEmail: jsonSerialization['userEmail'] as String,
      userImageUrl: jsonSerialization['userImageUrl'] as String?,
    );
  }

  _i2.WorkspaceMember member;

  String userName;

  String userEmail;

  String? userImageUrl;

  /// Returns a shallow copy of this [MemberWithUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MemberWithUser copyWith({
    _i2.WorkspaceMember? member,
    String? userName,
    String? userEmail,
    String? userImageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberWithUser',
      'member': member.toJson(),
      'userName': userName,
      'userEmail': userEmail,
      if (userImageUrl != null) 'userImageUrl': userImageUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberWithUserImpl extends MemberWithUser {
  _MemberWithUserImpl({
    required _i2.WorkspaceMember member,
    required String userName,
    required String userEmail,
    String? userImageUrl,
  }) : super._(
         member: member,
         userName: userName,
         userEmail: userEmail,
         userImageUrl: userImageUrl,
       );

  /// Returns a shallow copy of this [MemberWithUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MemberWithUser copyWith({
    _i2.WorkspaceMember? member,
    String? userName,
    String? userEmail,
    Object? userImageUrl = _Undefined,
  }) {
    return MemberWithUser(
      member: member ?? this.member.copyWith(),
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImageUrl: userImageUrl is String? ? userImageUrl : this.userImageUrl,
    );
  }
}
