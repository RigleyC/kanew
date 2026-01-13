import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/services/workspace_service.dart';
import 'src/services/permission_service.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services for server.
  setupAuth(pod);

  // Setup a default page at web root.
  // These are used by default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in web/static relative directory under /.
  // These are used by default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup app config route.
  // We build this configuration based on servers api url and serve it to
  // flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve flutter web app under /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If flutter web app has not been built, serve build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Seed initial permissions
  await seedPermissions(pod);

  // Start server.
  await pod.start();
}

// Global variable to store last verification code for testing purposes
String? testVerificationCode;

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // Store code for testing
  testVerificationCode = verificationCode;

  // Print verification code to console (visible in terminal)
  // Using stdout.writeln to force flush and ensure visibility
  stdout.writeln('');
  stdout.writeln('╔════════════════════════════════════════════════════════╗');
  stdout.writeln('║  📧 REGISTRATION VERIFICATION CODE                     ║');
  stdout.writeln('╠════════════════════════════════════════════════════════╣');
  stdout.writeln('║  Email: $email');
  stdout.writeln('║  Code:  $verificationCode');
  stdout.writeln('╚════════════════════════════════════════════════════════╝');
  stdout.writeln('');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // Print reset code to console (visible in terminal)
  print('');
  print('╔════════════════════════════════════════════════════════╗');
  print('║  🔑 PASSWORD RESET CODE                                      ║');
  print('╠══════════════════════════════════════════════════════╣');
  print('║  Email: $email');
  print('║  Code:  $verificationCode');
  print('╚════════════════════════════════════════════════════════════╝');
  print('');
}

/// Called when a new user account is created via email signup.
/// Creates a default workspace for organic signups (non-invited users).
Future<void> _onAfterAccountCreated(
  Session session, {
  required String email,
  required UuidValue authUserId,
  required UuidValue emailAccountId,
  required Transaction? transaction,
}) async {
  try {
    await WorkspaceService.createDefaultWorkspace(
      session,
      authUserId: authUserId,
      email: email,
    );
  } catch (e) {
    // Log but don't fail - user was likely invited
    session.log('[EmailIdp] Skipping workspace creation: $e');
  }
}

void setupAuth(Serverpod pod) {
  // Initialize authentication services for server.
  // Token managers will be used to validate and issue authentication keys,
  // and identity providers will be authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
        // Create default workspace when a new user account is created
        onAfterAccountCreated: _onAfterAccountCreated,
      ),
    ],
  );
}

/// Seeds initial permissions into the database
/// Called during server startup
Future<void> seedPermissions(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    await PermissionService.seedPermissions(session);
    print('[Server] Permission seeding completed');
  } catch (e) {
    print('[Server] Permission seeding failed: $e');
  }
}
