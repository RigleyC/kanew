import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zenrouter/zenrouter.dart';

import '../auth/auth_service.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/auth/view/forgot_password_screen.dart';
import '../../features/auth/view/reset_password_screen.dart';
import '../../features/auth/view/verification_screen.dart';
import '../../features/auth/view/set_password_screen.dart';
import '../../features/workspace/view/workspace_list_screen.dart';

/// Base class for all app routes
abstract class AppRoute extends RouteTarget with RouteUnique {}

/// Home/Workspace list - protected route
class HomeRoute extends AppRoute with RouteRedirect {
  @override
  Uri toUri() => Uri.parse('/');

  @override
  FutureOr<RouteTarget> redirect() async {
    // Check if user is authenticated via secure storage
    final isAuthenticated = await AuthService.isAuthenticated();
    debugPrint('HomeRoute.redirect: isAuthenticated=$isAuthenticated');

    if (!isAuthenticated) {
      debugPrint('HomeRoute.redirect: Redirecting to LoginRoute');
      return LoginRoute();
    }
    return this;
  }

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return WorkspaceListScreen(coordinator: coordinator);
  }
}

/// Login screen
class LoginRoute extends AppRoute {
  final String? email;

  LoginRoute({this.email});

  @override
  Uri toUri() {
    if (email != null) {
      return Uri.parse('/auth/login?email=$email');
    }
    return Uri.parse('/auth/login');
  }

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return LoginScreen(coordinator: coordinator, email: email);
  }
}

/// Signup screen
class SignupRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/auth/signup');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return SignupScreen(coordinator: coordinator);
  }
}

/// Forgot password screen
class ForgotPasswordRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/auth/forgot-password');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ForgotPasswordScreen(coordinator: coordinator);
  }
}

/// Reset password screen with token
class ResetPasswordRoute extends AppRoute {
  final String email;
  final String accountRequestId;

  ResetPasswordRoute({
    required this.email,
    required this.accountRequestId,
  });

  @override
  Uri toUri() => Uri.parse(
    '/auth/reset-password?email=$email&accountRequestId=$accountRequestId',
  );

  @override
  Widget build(Coordinator coordinator, BuildContext context) =>
      ResetPasswordScreen(
        coordinator: coordinator,
        email: email,
        accountRequestId: accountRequestId,
      );
}

/// Verification screen
class VerificationRoute extends AppRoute {
  final String email;
  final String accountRequestId;

  VerificationRoute({
    required this.email,
    required this.accountRequestId,
  });

  @override
  Uri toUri() => Uri.parse(
    '/auth/verification?email=$email&accountRequestId=$accountRequestId',
  );

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return VerificationScreen(
      coordinator: coordinator,
      email: email,
      accountRequestId: accountRequestId,
    );
  }
}

/// Set password screen (after email verification)
class SetPasswordRoute extends AppRoute {
  final String email;
  final String registrationToken;

  SetPasswordRoute({
    required this.email,
    required this.registrationToken,
  });

  @override
  Uri toUri() => Uri.parse(
    '/auth/set-password?email=$email',
  );

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return SetPasswordScreen(
      coordinator: coordinator,
      email: email,
      registrationToken: registrationToken,
    );
  }
}

/// 404 Not Found
class NotFoundRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/404');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }
}
