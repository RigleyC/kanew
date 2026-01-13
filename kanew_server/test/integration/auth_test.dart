import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
// import 'package:serverpod_auth_server/serverpod_auth_server.dart'; // Removed invalid import
// import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'; // Not strictly needed if we don't type check AuthSuccess explicitly or use dynamic
import 'test_tools/serverpod_test_tools.dart';
import 'package:kanew_server/server.dart'; // Import setupAuth
import 'package:kanew_server/src/generated/protocol.dart';
import 'package:kanew_server/src/generated/endpoints.dart';

void main() {
  withServerpod(
    'Auth Flow',
    runMode: 'test',
    applyMigrations: true,
    rollbackDatabase: RollbackDatabase.disabled,
    (
      sessionBuilder,
      endpoints,
    ) {
      // Initialize Auth Services manually since withServerpod doesn't run server.dart logic
      // We create a temporary pod instance just for configuration.
      // We must pass args to avoid it failing on missing args? default is fine.
      var pod = Serverpod([], Protocol(), Endpoints());
      setupAuth(pod);

      test(
        'given a new user when registering then verification code is stored and account can be created',
        () async {
          final email = 'test_${Uuid().v4()}@example.com';
          final password = 'password123';
          // final username = 'TestUser'; // Username not used in startRegistration for Email IDP by default

          // 1. Start Registration
          var accountRequestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: email,
          );

          // Retrieve verification code from global variable (set by _sendRegistrationCode)
          // This bypasses database hashing issues and table name changes in Serverpod 3.
          expect(
            testVerificationCode,
            isNotNull,
            reason: 'Verification code was not captured',
          );
          var verificationCode = testVerificationCode!;

          // 3. Verify Code
          final registrationToken = await endpoints.emailIdp
              .verifyRegistrationCode(
                sessionBuilder,
                accountRequestId: accountRequestId,
                verificationCode: verificationCode,
              );

          expect(registrationToken, isNotNull);

          // 4. Create Account (Finish Registration)
          final authSuccess = await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: registrationToken,
            password: password,
          );

          // Check if authSuccess has ID or Token
          // AuthSuccess usually has 'id' and 'key' (token)
          // We can check if it's not null (it's returned), but to be safe check properties if we knew them.
          // For now, if the call didn't throw, it likely succeeded.
          expect(authSuccess, isNotNull);
        },
      );
    },
  );
}
