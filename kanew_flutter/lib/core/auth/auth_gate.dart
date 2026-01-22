import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../di/injection.dart';

/// Widget that listens to authentication state and automatically
/// switches between authenticated and unauthenticated views.
///
/// This centralizes navigation logic and removes the need for
/// individual screens to handle navigation after login/logout.
class AuthGate extends StatefulWidget {
  /// Widget to show when user is authenticated
  final Widget authenticatedChild;

  /// Widget to show when user is not authenticated
  final Widget unauthenticatedChild;

  const AuthGate({
    super.key,
    required this.authenticatedChild,
    required this.unauthenticatedChild,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final FlutterAuthSessionManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = getIt<FlutterAuthSessionManager>();
    _authManager.authInfoListenable.addListener(_onAuthChange);
  }

  @override
  void dispose() {
    _authManager.authInfoListenable.removeListener(_onAuthChange);
    super.dispose();
  }

  void _onAuthChange() {
    debugPrint(
      '[AuthGate] Auth state changed: ${_authManager.isAuthenticated}',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[AuthGate] Building: isAuthenticated=${_authManager.isAuthenticated}',
    );

    return _authManager.isAuthenticated
        ? widget.authenticatedChild
        : widget.unauthenticatedChild;
  }
}
