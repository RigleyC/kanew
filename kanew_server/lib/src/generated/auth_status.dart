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

enum AuthStatus implements _i1.SerializableModel {
  success,
  accountNotFound,
  emailNotVerified,
  invalidCredentials,
  verificationCodeSent,
  verificationCodeInvalid,
  verificationCodeExpired,
  registrationComplete,
  accountAlreadyExists;

  static AuthStatus fromJson(String name) {
    switch (name) {
      case 'success':
        return AuthStatus.success;
      case 'accountNotFound':
        return AuthStatus.accountNotFound;
      case 'emailNotVerified':
        return AuthStatus.emailNotVerified;
      case 'invalidCredentials':
        return AuthStatus.invalidCredentials;
      case 'verificationCodeSent':
        return AuthStatus.verificationCodeSent;
      case 'verificationCodeInvalid':
        return AuthStatus.verificationCodeInvalid;
      case 'verificationCodeExpired':
        return AuthStatus.verificationCodeExpired;
      case 'registrationComplete':
        return AuthStatus.registrationComplete;
      case 'accountAlreadyExists':
        return AuthStatus.accountAlreadyExists;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AuthStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
