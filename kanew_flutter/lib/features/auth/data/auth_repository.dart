import 'package:kanew_client/kanew_client.dart';

/// Repository interface for authentication operations.
///
/// This abstraction allows for easy testing and dependency injection.
abstract class AuthRepository {
  /// Attempts to log in a user with email and password.
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// Starts the signup process for a new user.
  Future<AuthResult> startSignup({required String email});

  /// Verifies the registration code.
  Future<AuthResult> verifyCode({
    required String accountRequestId,
    required String code,
  });

  /// Finishes the signup process, creating the user account.
  Future<AuthResult> finishSignup({
    required String registrationToken,
    required String name,
    required String password,
  });

  /// Resends the verification code for a pending registration.
  Future<AuthResult> resendCode({required String email});
}

/// Implementation of [AuthRepository] using Serverpod client.
class AuthRepositoryImpl implements AuthRepository {
  final Client _client;

  AuthRepositoryImpl({required Client client}) : _client = client;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    return _client.auth.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResult> startSignup({required String email}) async {
    return _client.auth.startSignup(email: email);
  }

  @override
  Future<AuthResult> verifyCode({
    required String accountRequestId,
    required String code,
  }) async {
    return _client.auth.verifyCode(
      accountRequestId: accountRequestId,
      code: code,
    );
  }

  @override
  Future<AuthResult> finishSignup({
    required String registrationToken,
    required String name,
    required String password,
  }) async {
    return _client.auth.finishSignup(
      registrationToken: registrationToken,
      name: name,
      password: password,
    );
  }

  @override
  Future<AuthResult> resendCode({required String email}) async {
    return _client.auth.resendCode(email: email);
  }
}
