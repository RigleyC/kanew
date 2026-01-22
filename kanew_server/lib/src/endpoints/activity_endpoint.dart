import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';

class ActivityEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets activity log for a card
  Future<List<CardActivity>> getLog(
    Session session,
    int cardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this card');
    }

    return await CardActivity.db.find(
      session,
      where: (a) => a.cardId.equals(cardId),
      orderBy: (a) => a.createdAt,
      orderDescending: true,
      limit: 50, // Limit to 50 logs for now
    );
  }
}
