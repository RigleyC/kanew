import 'package:zenrouter/zenrouter.dart';
import 'app_routes.dart';

class AppCoordinator extends Coordinator<AppRoute> {
  @override
  AppRoute parseRouteFromUri(Uri uri) {
    final segments = uri.pathSegments;

    return switch (segments) {
      // Home
      [] => HomeRoute(),

      // Auth routes
      ['auth', 'login'] => LoginRoute(),
      ['auth', 'signup'] => SignupRoute(),
      ['auth', 'forgot-password'] => ForgotPasswordRoute(),
      ['auth', 'reset-password'] => ResetPasswordRoute(
        email: uri.queryParameters['email'] ?? '',
        accountRequestId: uri.queryParameters['accountRequestId'] ?? '',
      ),
      ['auth', 'verification'] => VerificationRoute(
        email: uri.queryParameters['email'] ?? '',
        accountRequestId: uri.queryParameters['accountRequestId'] ?? '',
      ),

      // Not found
      _ => NotFoundRoute(),
    };
  }
}

/// Global coordinator instance
final appCoordinator = AppCoordinator();
