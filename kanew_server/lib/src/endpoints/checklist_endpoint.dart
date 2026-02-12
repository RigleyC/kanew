import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/lexorank_service.dart';
import '../services/auth_helper.dart';
import '../services/activity_service.dart';
import '../services/board_broadcast_service.dart';

/// Endpoint for managing checklists within a card
class ChecklistEndpoint extends Endpoint {
  /// Require user to be logged in for all methods in this endpoint
  @override
  bool get requireLogin => true;

  /// Gets all checklists for a card
  /// Requires: board.read permission
  Future<List<Checklist>> getChecklists(
    Session session,
    UuidValue cardId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Get card to check existence
    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    // Get board to check permission
    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Verify user has permission to read
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this card');
    }

    // Fetch checklists
    final checklists = await Checklist.db.find(
      session,
      where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
      orderBy: (c) => c.rank,
    );

    // For each checklist, fetch its items
    // Note: In a real world scenario with large datasets we might want to optimize this query
    // or fetch items separately. For now, fetching eagerly is fine.
    // However, Serverpod doesn't support easy relation loading yet in find,
    // so we assume the client might want to fetch items separately or we construct a DTO.
    // For this MVP, let's keep it simple: client calls getChecklists, then calls getItems for each?
    // Or we return a custom DTO.
    // Given the protocol definition in definition_project.json, Checklist doesn't have a list of items field in the table.
    // But we can fetch items here if we wanted to return a richer object, but the generated class maps to the table.
    // So the client will have to make a separate call or we rely on the client to fetch items for each checklist ID.
    // Let's stick to returning just the Checklists here, and add a method to get items.

    return checklists;
  }

  /// Gets all items for a checklist
  /// Requires: board.read permission
  Future<List<ChecklistItem>> getItems(
    Session session,
    UuidValue checklistId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final checklist = await Checklist.db.findById(session, checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this checklist');
    }

    final items = await ChecklistItem.db.find(
      session,
      where: (i) =>
          i.checklistId.equals(checklistId) & i.deletedAt.equals(null),
      orderBy: (i) => i.rank,
    );

    return items;
  }

  /// Creates a new checklist in a card
  /// Requires: board.update permission
  Future<Checklist> createChecklist(
    Session session,
    UuidValue cardId,
    String title,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

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
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this card');
    }

    // Generate rank at the end
    final lastChecklist = await Checklist.db.findFirstRow(
      session,
      where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
      orderBy: (c) => c.rank,
      orderDescending: true,
    );
    final rank = LexoRankService.generateRankAfter(lastChecklist?.rank);

    final checklist = Checklist(
      cardId: cardId,
      title: title,
      rank: rank,
      createdAt: DateTime.now(),
    );

    final created = await Checklist.db.insertRow(session, checklist);

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: userId,
      type: ActivityType.update,
      details: 'adicionou a checklist "${created.title}"',
    );

    return created;
  }

  /// Updates a checklist
  /// Requires: board.update permission
  Future<Checklist> updateChecklist(
    Session session,
    UuidValue checklistId,
    String title,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final checklist = await Checklist.db.findById(session, checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this checklist');
    }

    final previousTitle = checklist.title;
    final updated = checklist.copyWith(
      title: title,
      updatedAt: DateTime.now(),
    );

    final result = await Checklist.db.updateRow(session, updated);

    // Log activity
    await ActivityService.log(
      session,
      cardId: result.cardId,
      actorId: userId,
      type: ActivityType.update,
      details:
          'alterou a checklist de "${previousTitle}" para "${result.title}"',
    );

    return result;
  }

  /// Soft deletes a checklist
  /// Requires: board.update permission
  Future<void> deleteChecklist(
    Session session,
    UuidValue checklistId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final checklist = await Checklist.db.findById(session, checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this checklist');
    }

    final updated = checklist.copyWith(
      deletedAt: DateTime.now(),
    );

    await Checklist.db.updateRow(session, updated);

    // Log activity
    await ActivityService.log(
      session,
      cardId: checklist.cardId,
      actorId: userId,
      type: ActivityType.update,
      details: 'removeu a checklist "${checklist.title}"',
    );
  }

  /// Creates a new item in a checklist
  /// Requires: board.update permission
  Future<ChecklistItem> addItem(
    Session session,
    UuidValue checklistId,
    String title,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final checklist = await Checklist.db.findById(session, checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this checklist');
    }

    // Generate rank at the end
    final lastItem = await ChecklistItem.db.findFirstRow(
      session,
      where: (i) =>
          i.checklistId.equals(checklistId) & i.deletedAt.equals(null),
      orderBy: (i) => i.rank,
      orderDescending: true,
    );
    final rank = LexoRankService.generateRankAfter(lastItem?.rank);

    final item = ChecklistItem(
      checklistId: checklistId,
      title: title,
      isChecked: false,
      rank: rank,
    );

    final created = await ChecklistItem.db.insertRow(session, item);

    // Log activity
    await ActivityService.log(
      session,
      cardId: checklist.cardId,
      actorId: userId,
      type: ActivityType.update,
      details:
          'adicionou o item "${created.title}" na checklist "${checklist.title}"',
    );

    return created;
  }

  /// Updates a checklist item
  /// Requires: board.update permission
  Future<ChecklistItem> updateItem(
    Session session,
    UuidValue itemId, {
    String? title,
    bool? isChecked,
  }) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final item = await ChecklistItem.db.findById(session, itemId);
    if (item == null || item.deletedAt != null) {
      throw Exception('Item not found');
    }

    final checklist = await Checklist.db.findById(session, item.checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this item');
    }

    final previousTitle = item.title;
    final previousChecked = item.isChecked;
    final updated = item.copyWith(
      title: title ?? item.title,
      isChecked: isChecked ?? item.isChecked,
    );

    final result = await ChecklistItem.db.updateRow(session, updated);

    // Log activity
    String details = 'alterou o item "${result.title}"';
    if (isChecked != null && previousChecked != result.isChecked) {
      details = result.isChecked
          ? 'marcou o item "${result.title}" como concluído'
          : 'desmarcou o item "${result.title}"';
    } else if (title != null && previousTitle != result.title) {
      details = 'alterou o item de "${previousTitle}" para "${result.title}"';
    }

    await ActivityService.log(
      session,
      cardId: checklist.cardId,
      actorId: userId,
      type: ActivityType.update,
      details: '$details na checklist "${checklist.title}"',
    );

    return result;
  }

  /// Soft deletes a checklist item
  /// Requires: board.update permission
  Future<void> deleteItem(
    Session session,
    UuidValue itemId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final item = await ChecklistItem.db.findById(session, itemId);
    if (item == null || item.deletedAt != null) {
      throw Exception('Item not found');
    }

    final checklist = await Checklist.db.findById(session, item.checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this item');
    }

    final updated = item.copyWith(
      deletedAt: DateTime.now(),
    );

    await ChecklistItem.db.updateRow(session, updated);

    // Log activity
    await ActivityService.log(
      session,
      cardId: checklist.cardId,
      actorId: userId,
      type: ActivityType.update,
      details:
          'removeu o item "${item.title}" da checklist "${checklist.title}"',
    );
  }

  /// Reorders checklist items.
  /// Receives all active item IDs in desired order and recalculates ranks.
  /// Requires: board.update permission
  Future<List<ChecklistItem>> reorderItems(
    Session session,
    UuidValue checklistId,
    List<UuidValue> orderedItemIds,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final checklist = await Checklist.db.findById(session, checklistId);
    if (checklist == null || checklist.deletedAt != null) {
      throw Exception('Checklist not found');
    }

    final card = await Card.db.findById(session, checklist.cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this checklist');
    }

    final activeItems = await ChecklistItem.db.find(
      session,
      where: (i) =>
          i.checklistId.equals(checklistId) & i.deletedAt.equals(null),
    );

    if (orderedItemIds.length != activeItems.length) {
      throw Exception('Invalid item ordering payload');
    }

    final uniqueOrderedIds = orderedItemIds.toSet();
    if (uniqueOrderedIds.length != orderedItemIds.length) {
      throw Exception('Duplicate item IDs in reorder payload');
    }

    final existingIds = activeItems.map((i) => i.id!).toSet();
    if (!existingIds.containsAll(uniqueOrderedIds) ||
        !uniqueOrderedIds.containsAll(existingIds)) {
      throw Exception('Invalid item IDs for this checklist');
    }

    final itemsById = {for (final item in activeItems) item.id!: item};
    final updatedItems = <ChecklistItem>[];
    String? previousRank;

    for (final itemId in orderedItemIds) {
      final item = itemsById[itemId];
      if (item == null) {
        continue;
      }

      final newRank = LexoRankService.generateRankAfter(previousRank);
      final updated = item.copyWith(rank: newRank);
      final result = await ChecklistItem.db.updateRow(session, updated);
      updatedItems.add(result);
      previousRank = newRank;
    }

    await ActivityService.log(
      session,
      cardId: checklist.cardId,
      actorId: userId,
      type: ActivityType.update,
      details: 'reordenou os itens da checklist "${checklist.title}"',
    );

    BoardBroadcastService.checklistItemsReordered(
      session,
      boardId: board.id!,
      checklistId: checklistId,
      actorId: userId,
      orderedItemIds: orderedItemIds,
    );

    return updatedItems;
  }
}
