import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../di/injection.dart';

/// Service to check authentication state
/// Works with FlutterAuthSessionManager's secure storage
class AuthService {
  /// Check if user has a stored auth token
  static Future<bool> isAuthenticated() async {
    final authManager = getIt<FlutterAuthSessionManager>();
    final signedIn = authManager.isAuthenticated;
    debugPrint('AuthService.isAuthenticated: $signedIn');
    return signedIn;
  }

  /// Sign out user properly using Serverpod Auth
  static Future<void> signOut() async {
    try {
      final authManager = getIt<FlutterAuthSessionManager>();
      await authManager.signOutDevice();
    } catch (e) {
      debugPrint('AuthService: Error signing out: $e');
    }
  }
}
