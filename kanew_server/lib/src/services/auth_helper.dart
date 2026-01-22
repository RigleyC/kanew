import 'package:serverpod/serverpod.dart';

/// Helper class for authentication-related utilities.
///
/// Centralizes common authentication functions used across endpoints
/// to avoid code duplication.
class AuthHelper {
  /// Gets the authenticated user's numeric ID from the session.
  ///
  /// Throws an exception if the user is not authenticated.
  static int getAuthenticatedUserId(Session session) {
    final authenticated = session.authenticated;
    if (authenticated == null) {
      throw Exception('User not authenticated');
    }
    return parseUserIdToInt(authenticated.userIdentifier);
  }

  /// Parses a user ID string to an integer.
  ///
  /// The user ID is expected to be in the format "provider:id"
  /// (e.g., "email:123"). This method extracts and returns
  /// the numeric part.
  static int parseUserIdToInt(String userId) {
    // Try direct parse first
    final parsed = int.tryParse(userId);
    if (parsed != null) {
      return parsed;
    }
    // Format is typically "email:123" - extract the numeric part
    final parts = userId.split(':');
    final numericPart = parts.length > 1 ? parts.last : userId;
    return int.tryParse(numericPart) ?? userId.hashCode.abs();
  }
}
