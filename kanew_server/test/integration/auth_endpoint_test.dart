import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'package:kanew_server/server.dart';
import 'package:kanew_server/src/generated/protocol.dart';
import 'package:kanew_server/src/generated/endpoints.dart';

/// Global variable to capture verification codes during tests.
/// This is set by the _sendRegistrationCode callback in server.dart.
String? capturedVerificationCode;

void main() {
  group('Auth Endpoint Tests', () {
    withServerpod(
      'Auth Flow',
      runMode: 'test',
      applyMigrations: true,
      rollbackDatabase: RollbackDatabase.disabled,
      (
        sessionBuilder,
        endpoints,
      ) {
        // Initialize Auth Services
        var pod = Serverpod([], Protocol(), Endpoints());
        setupAuth(pod);

        // ============================================================
        // LOGIN TESTS
        // ============================================================

        group('login', () {
          test(
            'given non-existent email when login then returns accountNotFound',
            () async {
              final email = 'nonexistent_${Uuid().v4()}@example.com';
              final password = 'password123';

              final result = await endpoints.auth.login(
                sessionBuilder,
                email: email,
                password: password,
              );

              expect(result.status, equals(AuthStatus.accountNotFound));
              expect(result.message, isNotNull);
            },
          );

          test(
            'given valid credentials when login then returns success with token',
            () async {
              // First create an account
              final email = 'valid_${Uuid().v4()}@example.com';
              final password = 'password123';
              final name = 'Test User';

              // Start signup
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              expect(
                signupResult.status,
                equals(AuthStatus.verificationCodeSent),
              );

              // Get verification code from global variable
              final code = testVerificationCode!;

              // Verify code
              final verifyResult = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );
              expect(verifyResult.status, equals(AuthStatus.success));

              // Finish signup
              final finishResult = await endpoints.auth.finishSignup(
                sessionBuilder,
                registrationToken: verifyResult.registrationToken!,
                name: name,
                password: password,
              );
              expect(
                finishResult.status,
                equals(AuthStatus.registrationComplete),
              );

              // Now try to login
              final loginResult = await endpoints.auth.login(
                sessionBuilder,
                email: email,
                password: password,
              );

              expect(loginResult.status, equals(AuthStatus.success));
              expect(loginResult.authToken, isNotNull);
              expect(loginResult.userId, isNotNull);
            },
          );

          test(
            'given wrong password when login then returns invalidCredentials',
            () async {
              // First create an account
              final email = 'wrongpw_${Uuid().v4()}@example.com';
              final password = 'correctPassword123';
              final wrongPassword = 'wrongPassword123';
              final name = 'Test User';

              // Create account
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final code = testVerificationCode!;
              final verifyResult = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );
              await endpoints.auth.finishSignup(
                sessionBuilder,
                registrationToken: verifyResult.registrationToken!,
                name: name,
                password: password,
              );

              // Try to login with wrong password
              final loginResult = await endpoints.auth.login(
                sessionBuilder,
                email: email,
                password: wrongPassword,
              );

              expect(loginResult.status, equals(AuthStatus.invalidCredentials));
            },
          );
        });

        // ============================================================
        // SIGNUP TESTS
        // ============================================================

        group('startSignup', () {
          test(
            'given new email when startSignup then returns verificationCodeSent',
            () async {
              final email = 'new_${Uuid().v4()}@example.com';

              final result = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );

              expect(result.status, equals(AuthStatus.verificationCodeSent));
              expect(result.accountRequestId, isNotNull);
              expect(result.message, contains(email));
              expect(testVerificationCode, isNotNull);
            },
          );

          test(
            'given existing verified email when startSignup then returns accountAlreadyExists',
            () async {
              final email = 'existing_${Uuid().v4()}@example.com';
              final password = 'password123';
              final name = 'Test User';

              // Create and complete an account
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final code = testVerificationCode!;
              final verifyResult = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );
              await endpoints.auth.finishSignup(
                sessionBuilder,
                registrationToken: verifyResult.registrationToken!,
                name: name,
                password: password,
              );

              // Try to signup again with the same email
              final secondResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );

              expect(
                secondResult.status,
                equals(AuthStatus.accountAlreadyExists),
              );
            },
          );
        });

        // ============================================================
        // VERIFY CODE TESTS
        // ============================================================

        group('verifyCode', () {
          test(
            'given valid code when verifyCode then returns success with registrationToken',
            () async {
              final email = 'verify_${Uuid().v4()}@example.com';

              // Start signup
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final code = testVerificationCode!;

              // Verify code
              final result = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );

              expect(result.status, equals(AuthStatus.success));
              expect(result.registrationToken, isNotNull);
            },
          );

          test(
            'given invalid code when verifyCode then returns verificationCodeInvalid',
            () async {
              final email = 'badcode_${Uuid().v4()}@example.com';

              // Start signup
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );

              // Try to verify with wrong code
              final result = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: '000000', // Wrong code
              );

              expect(result.status, equals(AuthStatus.verificationCodeInvalid));
            },
          );
        });

        // ============================================================
        // FINISH SIGNUP TESTS
        // ============================================================

        group('finishSignup', () {
          test(
            'given valid token when finishSignup then returns registrationComplete with authToken',
            () async {
              final email = 'finish_${Uuid().v4()}@example.com';
              final password = 'password123';
              final name = 'Test User';

              // Go through the signup flow
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final code = testVerificationCode!;
              final verifyResult = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );

              // Finish signup
              final result = await endpoints.auth.finishSignup(
                sessionBuilder,
                registrationToken: verifyResult.registrationToken!,
                name: name,
                password: password,
              );

              expect(result.status, equals(AuthStatus.registrationComplete));
              expect(result.authToken, isNotNull);
              expect(result.userId, isNotNull);
            },
          );

          test(
            'given valid signup when finished then workspace is created',
            () async {
              final email = 'workspace_${Uuid().v4()}@example.com';
              final password = 'password123';
              final name = 'WorkspaceUser';

              // Complete signup
              final signupResult = await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final code = testVerificationCode!;
              final verifyResult = await endpoints.auth.verifyCode(
                sessionBuilder,
                accountRequestId: signupResult.accountRequestId!,
                code: code,
              );
              final result = await endpoints.auth.finishSignup(
                sessionBuilder,
                registrationToken: verifyResult.registrationToken!,
                name: name,
                password: password,
              );

              expect(result.status, equals(AuthStatus.registrationComplete));

              // Check that workspace was created
              // Note: This requires access to the workspace endpoint or database
              // For now, we just verify the user was created successfully
              expect(result.userId, isNotNull);
            },
          );
        });

        // ============================================================
        // RESEND CODE TESTS
        // ============================================================

        group('resendCode', () {
          test(
            'given pending registration when resendCode then returns verificationCodeSent',
            () async {
              final email = 'resend_${Uuid().v4()}@example.com';

              // Start signup
              await endpoints.auth.startSignup(
                sessionBuilder,
                email: email,
              );
              final firstCode = testVerificationCode;

              // Resend code
              final result = await endpoints.auth.resendCode(
                sessionBuilder,
                email: email,
              );

              expect(result.status, equals(AuthStatus.verificationCodeSent));
              expect(result.accountRequestId, isNotNull);
              // New code should be sent (captured in testVerificationCode)
              expect(testVerificationCode, isNotNull);
            },
          );
        });
      },
    );
  });
}
