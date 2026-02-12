import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../../domain/auth_exception.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client _client;

  AuthRepositoryImpl({required Client client}) : _client = client;

  @override
  Future<AuthSuccess> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.emailIdp.login(
        email: email.trim().toLowerCase(),
        password: password,
      );
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('invalid') ||
          errorMsg.contains('incorrect') ||
          errorMsg.contains('wrong') ||
          errorMsg.contains('password')) {
        throw const AuthInvalidCredentialsException();
      }
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<UuidValue> startRegistration({required String email}) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      final isRegistered = await _client.emailIdp.isEmailRegistered(
        email: normalizedEmail,
      );

      if (isRegistered) {
        throw const AuthAccountExistsException();
      }

      return await _client.emailIdp.startRegistration(
        email: normalizedEmail,
      );
    } on AuthAccountExistsException {
      rethrow;
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('exists') ||
          errorMsg.contains('already') ||
          errorMsg.contains('registered')) {
        throw const AuthAccountExistsException();
      }
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<String> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String code,
  }) async {
    try {
      return await _client.emailIdp.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: code.trim(),
      );
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('expired')) {
        throw const AuthCodeExpiredException();
      }
      if (errorMsg.contains('invalid') || errorMsg.contains('code')) {
        throw const AuthCodeInvalidException();
      }
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) async {
    try {
      return await _client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
    } catch (e) {
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<UuidValue> startPasswordReset({required String email}) async {
    try {
      return await _client.emailIdp.startPasswordReset(
        email: email.trim().toLowerCase(),
      );
    } catch (e) {
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<String> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  }) async {
    try {
      return await _client.emailIdp.verifyPasswordResetCode(
        passwordResetRequestId: requestId,
        verificationCode: code.trim(),
      );
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('expired')) {
        throw const AuthCodeExpiredException();
      }
      if (errorMsg.contains('invalid') || errorMsg.contains('code')) {
        throw const AuthCodeInvalidException();
      }
      throw AuthNetworkException(e.toString());
    }
  }

  @override
  Future<void> finishPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _client.emailIdp.finishPasswordReset(
        finishPasswordResetToken: token,
        newPassword: newPassword,
      );
    } catch (e) {
      throw AuthNetworkException(e.toString());
    }
  }
}
