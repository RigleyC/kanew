import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';

/// Service for handling custom authentication logic.
///
/// This service wraps the Serverpod email IDP to provide clear responses
/// for the frontend, handling all auth flow scenarios.
class AuthService {
  /// Attempts to log in a user with email and password.
  ///
  /// Returns:
  /// - [AuthStatus.success] with authToken if successful
  /// - [AuthStatus.accountNotFound] if no account exists
  /// - [AuthStatus.emailNotVerified] if account exists but not verified (sends code)
  /// - [AuthStatus.invalidCredentials] if password is wrong
  static Future<AuthResult> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;
    final admin = emailIdp.admin;

    // 1. Check if account exists
    final account = await admin.findAccount(session, email: email);

    if (account == null) {
      // No account registered
      return AuthResult(
        status: AuthStatus.accountNotFound,
        message: 'Nenhuma conta encontrada com este email',
      );
    }

    // 2. Account exists - try to authenticate using the IDP's login method
    try {
      final authSuccess = await emailIdp.login(
        session,
        email: email,
        password: password,
      );

      // Authentication successful

      // Check product-level verification status
      final verification = await UserVerification.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(authSuccess.authUserId as dynamic),
      );

      // Default to true for legacy users or if record missing
      final isVerified = verification?.emailVerified ?? true;

      return AuthResult(
        status: AuthStatus.success,
        message: 'Login realizado com sucesso',
        authToken: authSuccess.refreshToken,
        userId: authSuccess.authUserId.toString(),
        emailVerified: isVerified,
      );
    } catch (e) {
      session.log('[AuthService] Login failed: $e');

      // Check if the error message indicates invalid credentials
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('invalid') ||
          errorMessage.contains('incorrect') ||
          errorMessage.contains('wrong')) {
        return AuthResult(
          status: AuthStatus.invalidCredentials,
          message: 'Email ou senha incorretos',
        );
      }

      // For other errors, still return invalid credentials
      // (most login failures are due to wrong password)
      return AuthResult(
        status: AuthStatus.invalidCredentials,
        message: 'Email ou senha incorretos',
      );
    }
  }

  /// Starts the signup process for a new user.
  ///
  /// Returns:
  /// - [AuthStatus.verificationCodeSent] with accountRequestId for new signups
  /// - [AuthStatus.emailNotVerified] with accountRequestId if account exists but unverified
  /// - [AuthStatus.accountAlreadyExists] if account is fully verified
  static Future<AuthResult> startSignup(
    Session session, {
    required String email,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;
    final admin = emailIdp.admin;

    // 2. Start new registration (sends verification code)
    try {
      final accountRequestId = await emailIdp.startRegistration(
        session,
        email: email,
      );

      session.log(
        '[AuthService] Registration started for $email, requestId: $accountRequestId',
      );

      return AuthResult(
        status: AuthStatus.verificationCodeSent,
        message: 'Código de verificação enviado para $email',
        accountRequestId: accountRequestId.toString(),
      );
    } catch (e) {
      session.log('[AuthService] Start signup error: $e');
      rethrow;
    }
  }

  /// Verifies the registration code.
  ///
  /// Returns:
  /// - [AuthStatus.success] with registrationToken if code is valid
  /// - [AuthStatus.verificationCodeInvalid] if code is wrong
  /// - [AuthStatus.verificationCodeExpired] if code expired
  static Future<AuthResult> verifyCode(
    Session session, {
    required String accountRequestId,
    required String code,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;

    try {
      final registrationToken = await emailIdp.verifyRegistrationCode(
        session,
        accountRequestId: UuidValue.fromString(accountRequestId),
        verificationCode: code,
      );

      session.log('[AuthService] Code verified, token: $registrationToken');

      return AuthResult(
        status: AuthStatus.success,
        message: 'Código verificado com sucesso',
        registrationToken: registrationToken,
      );
    } catch (e) {
      session.log('[AuthService] Code verification failed: $e');

      // Check if it's an expiration error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('expired')) {
        return AuthResult(
          status: AuthStatus.verificationCodeExpired,
          message: 'Código expirado. Solicite um novo código.',
        );
      }

      return AuthResult(
        status: AuthStatus.verificationCodeInvalid,
        message: 'Código inválido',
      );
    }
  }

  /// Finishes the signup process, creating the user account.
  ///
  /// Returns:
  /// - [AuthStatus.registrationComplete] with authToken if successful
  static Future<AuthResult> finishSignup(
    Session session, {
    required String registrationToken,
    required String name,
    required String password,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;

    try {
      final authSuccess = await emailIdp.finishRegistration(
        session,
        registrationToken: registrationToken,
        password: password,
      );

      // After successful registration, create workspace
      // Note: The EmailIdpEndpoint already calls WorkspaceService in onAfterAccountCreated
      // but we might need to update the user's name

      session.log(
        '[AuthService] Registration complete for user ${authSuccess.authUserId}',
      );

      // Create product-level verification record (default to true as email is verified by IDP)
      await UserVerification.db.insertRow(
        session,
        UserVerification(
          userId: authSuccess.authUserId as dynamic,
          emailVerified: true,
          createdAt: DateTime.now(),
        ),
      );

      // TODO: Update user name if UserInfo table supports it
      // For now, the name will be stored in a future profile update

      return AuthResult(
        status: AuthStatus.registrationComplete,
        message: 'Conta criada com sucesso',
        authToken: authSuccess.refreshToken,
        userId: authSuccess.authUserId.toString(),
      );
    } catch (e) {
      session.log('[AuthService] Finish signup error: $e');
      rethrow;
    }
  }

  /// Resends the verification code for a pending registration.
  ///
  /// Returns:
  /// - [AuthStatus.verificationCodeSent] with new accountRequestId
  static Future<AuthResult> resendCode(
    Session session, {
    required String email,
  }) async {
    // Simply restart the registration process
    // This will generate a new code and send it
    return startSignup(session, email: email);
  }

  /// Prints verification code to console in development mode.
  /// Called by the EmailIdpConfig callback.
  static void printVerificationCode({
    required String email,
    required String code,
    required String type,
  }) {
    stdout.writeln('');
    stdout.writeln(
      '╔════════════════════════════════════════════════════════╗',
    );
    stdout.writeln('║  📧 $type');
    stdout.writeln(
      '╠════════════════════════════════════════════════════════╣',
    );
    stdout.writeln('║  Email: $email');
    stdout.writeln('║  Code:  $code');
    stdout.writeln(
      '╚════════════════════════════════════════════════════════╝',
    );
    stdout.writeln('');
  }
}
