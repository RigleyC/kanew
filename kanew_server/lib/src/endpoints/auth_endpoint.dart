import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/auth_service.dart';

/// Custom authentication endpoint providing clear responses for the frontend.
///
/// This endpoint wraps the Serverpod email IDP to provide:
/// - Clear status codes for each auth scenario
/// - Automatic code resending for unverified accounts
/// - Proper flow handling for signup, login, and verification
class AuthEndpoint extends Endpoint {
  /// Attempts to log in a user with email and password.
  ///
  /// Returns [AuthResult] with:
  /// - [AuthStatus.success] + authToken if login successful
  /// - [AuthStatus.accountNotFound] if no account exists (→ redirect to signup)
  /// - [AuthStatus.emailNotVerified] + accountRequestId if pending verification (→ redirect to verify)
  /// - [AuthStatus.invalidCredentials] if wrong password
  Future<AuthResult> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    session.log('[AuthEndpoint] Login attempt for: $email');

    return AuthService.login(
      session,
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  /// Starts the signup process for a new user.
  ///
  /// Sends a verification code to the email address.
  ///
  /// Returns [AuthResult] with:
  /// - [AuthStatus.verificationCodeSent] + accountRequestId for new signups
  /// - [AuthStatus.accountAlreadyExists] if email is already registered and verified
  Future<AuthResult> startSignup(
    Session session, {
    required String email,
  }) async {
    session.log('[AuthEndpoint] Start signup for: $email');

    return AuthService.startSignup(
      session,
      email: email.trim().toLowerCase(),
    );
  }

  /// Verifies the registration code entered by the user.
  ///
  /// Returns [AuthResult] with:
  /// - [AuthStatus.success] + registrationToken if code is valid
  /// - [AuthStatus.verificationCodeInvalid] if code is wrong
  /// - [AuthStatus.verificationCodeExpired] if code expired
  Future<AuthResult> verifyCode(
    Session session, {
    required String accountRequestId,
    required String code,
  }) async {
    session.log('[AuthEndpoint] Verify code for request: $accountRequestId');

    return AuthService.verifyCode(
      session,
      accountRequestId: accountRequestId,
      code: code.trim(),
    );
  }

  /// Finishes the signup process, creating the user account.
  ///
  /// Called after verification with:
  /// - registrationToken from verifyCode
  /// - name: user's full name
  /// - password: user's chosen password
  ///
  /// Returns [AuthResult] with:
  /// - [AuthStatus.registrationComplete] + authToken if successful
  Future<AuthResult> finishSignup(
    Session session, {
    required String registrationToken,
    required String name,
    required String password,
  }) async {
    session.log('[AuthEndpoint] Finish signup with token: $registrationToken');

    return AuthService.finishSignup(
      session,
      registrationToken: registrationToken,
      name: name.trim(),
      password: password,
    );
  }

  /// Resends the verification code for a pending registration.
  ///
  /// Use this when:
  /// - User didn't receive the code
  /// - Code expired
  ///
  /// Returns [AuthResult] with:
  /// - [AuthStatus.verificationCodeSent] + new accountRequestId
  Future<AuthResult> resendCode(
    Session session, {
    required String email,
  }) async {
    session.log('[AuthEndpoint] Resend code for: $email');

    return AuthService.resendCode(
      session,
      email: email.trim().toLowerCase(),
    );
  }
}
