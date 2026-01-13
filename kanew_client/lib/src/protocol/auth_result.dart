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
import 'auth_status.dart' as _i2;

abstract class AuthResult implements _i1.SerializableModel {
  AuthResult._({
    required this.status,
    this.message,
    this.accountRequestId,
    this.registrationToken,
    this.authToken,
    this.userId,
    this.emailVerified,
  });

  factory AuthResult({
    required _i2.AuthStatus status,
    String? message,
    String? accountRequestId,
    String? registrationToken,
    String? authToken,
    String? userId,
    bool? emailVerified,
  }) = _AuthResultImpl;

  factory AuthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResult(
      status: _i2.AuthStatus.fromJson((jsonSerialization['status'] as String)),
      message: jsonSerialization['message'] as String?,
      accountRequestId: jsonSerialization['accountRequestId'] as String?,
      registrationToken: jsonSerialization['registrationToken'] as String?,
      authToken: jsonSerialization['authToken'] as String?,
      userId: jsonSerialization['userId'] as String?,
      emailVerified: jsonSerialization['emailVerified'] as bool?,
    );
  }

  _i2.AuthStatus status;

  String? message;

  String? accountRequestId;

  String? registrationToken;

  String? authToken;

  String? userId;

  bool? emailVerified;

  /// Returns a shallow copy of this [AuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResult copyWith({
    _i2.AuthStatus? status,
    String? message,
    String? accountRequestId,
    String? registrationToken,
    String? authToken,
    String? userId,
    bool? emailVerified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResult',
      'status': status.toJson(),
      if (message != null) 'message': message,
      if (accountRequestId != null) 'accountRequestId': accountRequestId,
      if (registrationToken != null) 'registrationToken': registrationToken,
      if (authToken != null) 'authToken': authToken,
      if (userId != null) 'userId': userId,
      if (emailVerified != null) 'emailVerified': emailVerified,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResultImpl extends AuthResult {
  _AuthResultImpl({
    required _i2.AuthStatus status,
    String? message,
    String? accountRequestId,
    String? registrationToken,
    String? authToken,
    String? userId,
    bool? emailVerified,
  }) : super._(
         status: status,
         message: message,
         accountRequestId: accountRequestId,
         registrationToken: registrationToken,
         authToken: authToken,
         userId: userId,
         emailVerified: emailVerified,
       );

  /// Returns a shallow copy of this [AuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResult copyWith({
    _i2.AuthStatus? status,
    Object? message = _Undefined,
    Object? accountRequestId = _Undefined,
    Object? registrationToken = _Undefined,
    Object? authToken = _Undefined,
    Object? userId = _Undefined,
    Object? emailVerified = _Undefined,
  }) {
    return AuthResult(
      status: status ?? this.status,
      message: message is String? ? message : this.message,
      accountRequestId: accountRequestId is String?
          ? accountRequestId
          : this.accountRequestId,
      registrationToken: registrationToken is String?
          ? registrationToken
          : this.registrationToken,
      authToken: authToken is String? ? authToken : this.authToken,
      userId: userId is String? ? userId : this.userId,
      emailVerified: emailVerified is bool?
          ? emailVerified
          : this.emailVerified,
    );
  }
}
