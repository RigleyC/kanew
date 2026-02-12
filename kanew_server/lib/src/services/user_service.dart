import 'package:serverpod/serverpod.dart';

/// Service for retrieving user information from Serverpod 3.x auth tables.
/// 
/// This service provides a clean API to access user data without exposing
/// the internal database structure.
class UserService {
  /// Gets user email by authUserId from the email identity provider.
  /// 
  /// Returns the email address if found, null otherwise.
  static Future<String?> getUserEmail(
    Session session,
    UuidValue authUserId,
  ) async {
    try {
      session.log('UserService.getUserEmail: Looking for authUserId = ${authUserId.toString()}');
      
      // Query the email identity provider table
      final rows = await session.db.unsafeQuery(
        'SELECT email FROM serverpod_auth_idp_email_account '
        'WHERE "authUserId" = \'${authUserId.toString()}\' '
        'LIMIT 1',
      );

      session.log('UserService.getUserEmail: Query returned ${rows.length} rows');
      if (rows.isNotEmpty) {
        session.log('UserService.getUserEmail: First row = ${rows.first}');
      return rows.first[0] as String;
      }
      
      return null;
    } catch (e) {
      session.log('Error getting user email: $e');
      return null;
    }
  }

  /// Gets user display name from email.
  /// 
  /// Extracts the username part from the email address.
  /// Returns 'Usuario' if email is null or empty.
  static String getDisplayName(String? email) {
    if (email == null || email.isEmpty) {
      return 'Usuario';
    }
    
    final parts = email.split('@');
    if (parts.isEmpty || parts[0].isEmpty) {
      return 'Usuario';
    }
    
    return parts[0];
  }

  /// Gets complete user info by authUserId.
  /// 
  /// Returns a map with email and displayName, or defaults if not found.
  static Future<Map<String, String>> getUserInfo(
    Session session,
    UuidValue authUserId,
  ) async {
    final email = await getUserEmail(session, authUserId);
    final displayName = getDisplayName(email);
    
    return {
      'email': email ?? 'email@exemplo.com',
      'displayName': displayName,
    };
  }
}
