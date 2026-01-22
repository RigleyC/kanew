import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../services/activity_service.dart';

class LabelEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets all labels defined for a board
  Future<List<LabelDef>> getLabels(
    Session session,
    int boardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final board = await Board.db.findById(session, boardId);
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
      throw Exception('User does not have permission to read labels for this board');
    }

    return await LabelDef.db.find(
      session,
      where: (l) => l.boardId.equals(boardId) & l.deletedAt.equals(null),
      orderBy: (l) => l.name,
    );
  }

  /// Creates a new label definition
  Future<LabelDef> createLabel(
    Session session,
    int boardId,
    String name,
    String colorHex,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final board = await Board.db.findById(session, boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to create labels');
    }

    final label = LabelDef(
      boardId: boardId,
      name: name,
      colorHex: colorHex,
    );

    return await LabelDef.db.insertRow(session, label);
  }

  /// Updates a label definition
  Future<LabelDef> updateLabel(
    Session session,
    int labelId,
    String name,
    String colorHex,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final label = await LabelDef.db.findById(session, labelId);
    if (label == null || label.deletedAt != null) {
      throw Exception('Label not found');
    }

    final board = await Board.db.findById(session, label.boardId);
    if (board == null) throw Exception('Board not found');

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update labels');
    }

    final updated = label.copyWith(
      name: name,
      colorHex: colorHex,
    );

    return await LabelDef.db.updateRow(session, updated);
  }

  /// Deletes a label definition (soft delete)
  Future<void> deleteLabel(
    Session session,
    int labelId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final label = await LabelDef.db.findById(session, labelId);
    if (label == null || label.deletedAt != null) {
      throw Exception('Label not found');
    }

    final board = await Board.db.findById(session, label.boardId);
    if (board == null) throw Exception('Board not found');

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to delete labels');
    }

    final updated = label.copyWith(
      deletedAt: DateTime.now(),
    );

    await LabelDef.db.updateRow(session, updated);
  }

  /// Attaches a label to a card
  Future<void> attachLabel(
    Session session,
    int cardId,
    int labelId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) throw Exception('Card not found');

    final label = await LabelDef.db.findById(session, labelId);
    if (label == null || label.deletedAt != null) throw Exception('Label not found');

    final board = await Board.db.findById(session, card.boardId);
    if (board == null) throw Exception('Board not found');

    if (label.boardId != board.id) throw Exception('Label does not belong to this board');

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this card');
    }

    // Check if already attached
    final existing = await CardLabel.db.findFirstRow(
      session,
      where: (cl) => cl.cardId.equals(cardId) & cl.labelDefId.equals(labelId),
    );

    if (existing != null) return; // Already attached

    final cardLabel = CardLabel(
      cardId: cardId,
      labelDefId: labelId,
    );

    await CardLabel.db.insertRow(session, cardLabel);

    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.update,
      details: 'Added label "${label.name}"',
    );
  }

  /// Detaches a label from a card
  Future<void> detachLabel(
    Session session,
    int cardId,
    int labelId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null) throw Exception('Card not found');

    final board = await Board.db.findById(session, card.boardId);
    if (board == null) throw Exception('Board not found');

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this card');
    }

    final label = await LabelDef.db.findById(session, labelId);

    // Delete relation
    await CardLabel.db.deleteWhere(
      session,
      where: (cl) => cl.cardId.equals(cardId) & cl.labelDefId.equals(labelId),
    );

    if (label != null) {
      await ActivityService.log(
        session,
        cardId: cardId,
        actorId: numericUserId,
        type: ActivityType.update,
        details: 'Removed label "${label.name}"',
      );
    }
  }

  /// Get labels attached to a card
  Future<List<LabelDef>> getCardLabels(
    Session session,
    int cardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) throw Exception('Card not found');

    final board = await Board.db.findById(session, card.boardId);
    if (board == null) throw Exception('Board not found');

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this card');
    }

    // This is a manual join since Serverpod doesn't support complex joins in `find` easily yet
    // 1. Get CardLabel relations
    final relations = await CardLabel.db.find(
      session,
      where: (cl) => cl.cardId.equals(cardId),
    );

    if (relations.isEmpty) return [];

    final labelIds = relations.map((r) => r.labelDefId).toList();

    // 2. Get LabelDefs
    // Serverpod doesn't have `in` clause easily in WhereExpressionBuilder for ints yet in all versions,
    // but we can construct an OR expression.
    // Or just iterate if list is small. Labels on a card are few.
    // Let's assume list is small.

    // Better approach: Since we can't easily do `id IN list`, let's construct ORs
    // or if the list is huge, this is bad. But card labels are usually < 10.

    // NOTE: Using a loop with `findById` is n+1 but acceptable for small N.
    // Let's try to build an expression.

    /*
    Expression expression = Constant.bool(false); // Default false
    for (var id in labelIds) {
      expression = expression | LabelDef.t.id.equals(id);
    }
    But we need to start with something.
    */

    // Let's stick to simple logic for MVP.
    var labels = <LabelDef>[];
    for (var id in labelIds) {
      final l = await LabelDef.db.findById(session, id);
      if (l != null && l.deletedAt == null) {
        labels.add(l);
      }
    }

    return labels;
  }
}
