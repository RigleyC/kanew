import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/lexorank_service.dart';
import '../services/auth_helper.dart';
import '../services/board_broadcast_service.dart';

/// Endpoint for managing lists within a board
class CardListEndpoint extends Endpoint {
  /// Require user to be logged in for all methods in this endpoint
  @override
  bool get requireLogin => true;

  /// Gets all lists for a board
  /// Requires: board.read permission
  Future<List<CardList>> getLists(
    Session session,
    UuidValue boardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // Get the board to find workspace
    final board = await Board.db.findById(session, boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Verify user has permission to read boards
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this board');
    }

    final lists = await CardList.db.find(
      session,
      where: (l) => l.boardId.equals(boardId) & l.deletedAt.equals(null),
      orderBy: (l) => l.rank,
      orderDescending: false,
    );

    return lists;
  }

  /// Creates a new list in a board
  /// Requires: board.update permission
  Future<CardList> createList(
    Session session,
    UuidValue boardId,
    String title,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // Get the board to find workspace
    final board = await Board.db.findById(session, boardId);
    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Verify user has permission to update boards (create list is board.update)
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this board');
    }

    // Get the last list's rank to generate a new rank after it
    final existingLists = await CardList.db.find(
      session,
      where: (l) => l.boardId.equals(boardId) & l.deletedAt.equals(null),
      orderBy: (l) => l.rank,
      orderDescending: true,
      limit: 1,
    );

    final lastRank = existingLists.isNotEmpty ? existingLists.first.rank : null;
    final newRank = LexoRankService.generateRankAfter(lastRank);

    final cardList = CardList(      boardId: boardId,
      title: title,
      rank: newRank,
      archived: false,
      createdAt: DateTime.now(),
    );

    final created = await CardList.db.insertRow(session, cardList);

    session.log(
      '[CardListEndpoint] Created list "${created.title}" (rank: ${created.rank}) in board $boardId',
    );

    // Broadcast list created event
    BoardBroadcastService.listCreated(
      session,
      boardId: created.boardId,
      listId: created.id!,
      actorId: numericUserId,
      cardList: created,
    );

    return created;
  }

  /// Updates a list's title
  /// Requires: board.update permission
  Future<CardList> updateList(
    Session session,
    UuidValue listId,
    String title,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final cardList = await CardList.db.findById(session, listId);
    if (cardList == null || cardList.deletedAt != null) {
      throw Exception('List not found');
    }

    // Get the board to check permission
    final board = await Board.db.findById(session, cardList.boardId);
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
      throw Exception('User does not have permission to modify this board');
    }

    final updated = cardList.copyWith(title: title);
    final result = await CardList.db.updateRow(session, updated);

    session.log('[CardListEndpoint] Updated list "${result.title}"');

    // Broadcast list updated event
    BoardBroadcastService.listUpdated(
      session,
      boardId: result.boardId,
      listId: result.id!,
      actorId: numericUserId,
      cardList: result,
    );

    return result;
  }

  /// Reorders lists within a board
  /// Receives an ordered list of list IDs and recalculates ranks
  /// Requires: board.update permission
  Future<List<CardList>> reorderLists(
    Session session,
    UuidValue boardId,
    List<UuidValue> orderedListIds,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // Get the board to check permission
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
      throw Exception('User does not have permission to modify this board');
    }

    // Generate new ranks for all lists
    final updatedLists = <CardList>[];
    String? previousRank;

    for (final listId in orderedListIds) {
      final cardList = await CardList.db.findById(session, listId);
      if (cardList == null ||
          cardList.deletedAt != null ||
          cardList.boardId != boardId) {
        continue; // Skip invalid lists
      }

      final newRank = LexoRankService.generateRankAfter(previousRank);
      final updated = cardList.copyWith(rank: newRank);
      final result = await CardList.db.updateRow(session, updated);
      updatedLists.add(result);
      previousRank = newRank;
    }

    session.log(
      '[CardListEndpoint] Reordered ${updatedLists.length} lists in board $boardId',
    );

    // Broadcast list reordered event
    BoardBroadcastService.listReordered(
      session,
      boardId: boardId,
      actorId: numericUserId,
      orderedListIds: orderedListIds,
    );

    return updatedLists;
  }

  /// Soft deletes a list
  /// Requires: board.update permission
  Future<void> deleteList(
    Session session,
    UuidValue listId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final cardList = await CardList.db.findById(session, listId);
    if (cardList == null || cardList.deletedAt != null) {
      throw Exception('List not found');
    }

    // Get the board to check permission
    final board = await Board.db.findById(session, cardList.boardId);
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
      throw Exception('User does not have permission to modify this board');
    }

    // Soft delete all cards in this list (cascade)
    final cardsInList = await Card.db.find(
      session,
      where: (c) => c.listId.equals(listId) & c.deletedAt.equals(null),
    );

    for (final card in cardsInList) {
      await Card.db.updateRow(
        session,
        card.copyWith(
          deletedAt: DateTime.now(),
          deletedBy: numericUserId,
        ),
      );
    }

    session.log(
      '[CardListEndpoint] Soft deleted ${cardsInList.length} cards from list $listId',
    );

    // Soft delete the list itself
    final updated = cardList.copyWith(
      deletedAt: DateTime.now(),
      deletedBy: numericUserId,
    );

    await CardList.db.updateRow(session, updated);

    session.log(
      '[CardListEndpoint] Soft deleted list "${cardList.title}" by user $numericUserId',
    );

    // Broadcast list deleted event
    BoardBroadcastService.listDeleted(
      session,
      boardId: cardList.boardId,
      listId: listId,
      actorId: numericUserId,
    );
  }

  /// Archives a list (sets archived = true)
  /// Requires: board.update permission
  Future<CardList> archiveList(
    Session session,
    UuidValue listId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final cardList = await CardList.db.findById(session, listId);
    if (cardList == null || cardList.deletedAt != null) {
      throw Exception('List not found');
    }

    final board = await Board.db.findById(session, cardList.boardId);
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
      throw Exception('User does not have permission to modify this board');
    }

    final updated = cardList.copyWith(archived: true);
    final result = await CardList.db.updateRow(session, updated);

    session.log('[CardListEndpoint] Archived list "${result.title}"');

    return result;
  }
}
