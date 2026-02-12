import 'package:serverpod/serverpod.dart';

import '../errors/http_exceptions.dart';

/// Helper class for authentication-related utilities.
///
/// Centralizes common authentication functions used across endpoints
/// to avoid code duplication.
class AuthHelper {
  /// Gets the authenticated user's UUID from the session.
  ///
  /// Returns the authUserId as a UuidValue which is stable across sessions.
  /// Throws an exception if the user is not authenticated.
  static UuidValue getAuthenticatedUserId(Session session) {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw UnauthorizedException(message: 'User not authenticated');
    }
    // Parse the userIdentifier string to UuidValue
    return UuidValue.fromString(authenticated.userIdentifier);
  }
}
