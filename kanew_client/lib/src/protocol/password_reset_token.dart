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

abstract class PasswordResetToken implements _i1.SerializableModel {
  PasswordResetToken._({
    this.id,
    required this.authUserId,
    required this.token,
    required this.expiresAt,
  });

  factory PasswordResetToken({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    required String token,
    required DateTime expiresAt,
  }) = _PasswordResetTokenImpl;

  factory PasswordResetToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasswordResetToken(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      token: jsonSerialization['token'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  String token;

  DateTime expiresAt;

  /// Returns a shallow copy of this [PasswordResetToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasswordResetToken copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    String? token,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PasswordResetToken',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PasswordResetTokenImpl extends PasswordResetToken {
  _PasswordResetTokenImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    required String token,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         token: token,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [PasswordResetToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasswordResetToken copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    String? token,
    DateTime? expiresAt,
  }) {
    return PasswordResetToken(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
