import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// Extends EmailIdpBaseEndpoint to expose email auth endpoints.
///
/// All standard auth methods are inherited from EmailIdpBaseEndpoint:
/// - startRegistration(email) → Sends verification code
/// - verifyRegistrationCode(accountRequestId, code) → Returns registration token
/// - finishRegistration(registrationToken, password) → Creates user
/// - login(email, password) → Returns session token
/// - startPasswordReset(email) → Sends password reset code
/// - verifyPasswordResetCode(passwordResetRequestId, code) → Returns reset token
/// - finishPasswordReset(token, newPassword) → Resets password
///
/// The workspace creation hook is configured via `onAfterAccountCreated`
/// in server.dart, so no override is needed here.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  /// Checks if an email address is already registered.
  ///
  /// Returns `true` if the email has an existing account, `false` otherwise.
  /// This allows the client to show appropriate error messages before
  /// attempting registration.
  Future<bool> isEmailRegistered(
    Session session, {
    required String email,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;
    final admin = emailIdp.admin;

    final account = await admin.findAccount(
      session,
      email: email.trim().toLowerCase(),
    );

    return account != null;
  }
}
