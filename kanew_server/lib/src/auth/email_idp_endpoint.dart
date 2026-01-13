import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import '../services/user_registration_service.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// This enables:
/// - startRegistration(email) → Sends verification code
/// - verifyRegistrationCode(accountRequestId, code) → Returns registration token
/// - finishRegistration(registrationToken, password) → Creates user + workspace
/// - login(email, password) → Returns session token
/// - startPasswordReset(email) → Sends password reset code
/// - verifyPasswordResetCode(passwordResetRequestId, code) → Returns reset token
/// - finishPasswordReset(token, newPassword) → Resets password
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  /// Override finishRegistration to also create default workspace and preferences
  @override
  Future<AuthSuccess> finishRegistration(
    Session session, {
    required String registrationToken,
    required String password,
  }) async {
    // Call parent to create the user
    final result = await super.finishRegistration(
      session,
      registrationToken: registrationToken,
      password: password,
    );

    // After successful registration, create workspace and preferences
    // authUserId is the UuidValue identifying the user
    final userId = result.authUserId;

    // Convert UuidValue to int for our database tables
    // Using hashCode.abs() to get a deterministic positive integer
    final numericUserId = userId.toString().hashCode.abs();

    await UserRegistrationService.onUserRegistered(
      session,
      userId: numericUserId,
      // userName will be collected via profile update later
      userName: null,
    );

    return result;
  }
}
