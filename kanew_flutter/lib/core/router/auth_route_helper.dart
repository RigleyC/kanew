import 'package:go_router/go_router.dart';

/// Helper para construir URLs de auth preservando o redirect
class AuthRouteHelper {
  static String login({String? redirect}) =>
      _buildPath('/auth/login', redirect: redirect);

  static String signup({String? redirect}) =>
      _buildPath('/auth/signup', redirect: redirect);

  static String resetPassword({
    required String email,
    required String requestId,
  }) {
    final params = <String, String>{
      'email': email,
      'requestId': requestId,
      // Transitional compatibility with old query key.
      'accountRequestId': requestId,
    };
    return Uri(path: '/auth/reset-password', queryParameters: params).toString();
  }

  static String verification({
    required String email,
    required String accountRequestId,
    String? redirect,
  }) {
    final params = <String, String>{
      'email': email,
      'accountRequestId': accountRequestId,
      if (redirect != null) 'redirect': redirect,
    };
    return Uri(path: '/auth/verification', queryParameters: params).toString();
  }

  static String setPassword({
    required String email,
    required String token,
    String? redirect,
  }) {
    final params = <String, String>{
      'email': email,
      'token': token,
      if (redirect != null) 'redirect': redirect,
    };
    return Uri(path: '/auth/set-password', queryParameters: params).toString();
  }

  /// Extrai o redirect dos query parameters do router state
  static String? getRedirect(GoRouterState state) =>
      state.uri.queryParameters['redirect'];

  static String _buildPath(String base, {String? redirect}) {
    if (redirect == null || redirect.isEmpty) return base;
    return Uri(
      path: base,
      queryParameters: {'redirect': redirect},
    ).toString();
  }
}
