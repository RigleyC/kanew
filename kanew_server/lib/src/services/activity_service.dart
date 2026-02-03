import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ActivityService {
  /// Logs an activity for a card
  static Future<void> log(
    Session session, {
    required int cardId,
    required UuidValue actorId,
    required ActivityType type,
    String? details,
  }) async {
    try {
      final activity = CardActivity(
        cardId: cardId,
        actorId: actorId, // This should pass if CardActivity is updated
        type: type,
        details: details,
        createdAt: DateTime.now(),
      );

      await CardActivity.db.insertRow(session, activity);
    } catch (e) {
      // We don't want to fail the main operation if logging fails,
      // but we should log the error.
      session.log(
        'Failed to log activity: $e',
        level: LogLevel.error,
      );
    }
  }
}
