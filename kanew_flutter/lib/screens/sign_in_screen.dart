import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../core/di/injection.dart';

/// Legacy SignInScreen - uses Serverpod's default SignInWidget.
/// For custom auth flow, use the screens in features/auth/view/ instead.
class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;
  late final Client _client;
  late final FlutterAuthSessionManager _authManager;

  @override
  void initState() {
    super.initState();
    _client = getIt<Client>();
    _authManager = getIt<FlutterAuthSessionManager>();
    _authManager.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = _authManager.isAuthenticated;
  }

  @override
  void dispose() {
    _authManager.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = _authManager.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn
        ? widget.child
        : Center(
            child: SignInWidget(
              client: _client,
              onAuthenticated: () {},
            ),
          );
  }
}
