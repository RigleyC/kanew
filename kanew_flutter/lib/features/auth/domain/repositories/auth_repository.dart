import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

abstract class AuthRepository {
  Future<AuthSuccess> login({
    required String email,
    required String password,
  });

  Future<UuidValue> startRegistration({required String email});

  Future<String> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String code,
  });

  Future<AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  });

  Future<UuidValue> startPasswordReset({required String email});

  Future<String> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  });

  Future<void> finishPasswordReset({
    required String token,
    required String newPassword,
  });
}
