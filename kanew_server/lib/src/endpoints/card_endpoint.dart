import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/lexorank_service.dart';
import '../services/auth_helper.dart';
import '../services/activity_service.dart';

/// Endpoint for managing cards within a list
class CardEndpoint extends Endpoint {
  /// Require user to be logged in for all methods in this endpoint
  @override
  bool get requireLogin => true;

  /// Gets all cards for a list
  /// Requires: board.read permission
  Future<List<Card>> getCards(
    Session session,
    int listId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // Get the list to find board
    final cardList = await CardList.db.findById(session, listId);
    if (cardList == null || cardList.deletedAt != null) {
      throw Exception('List not found');
    }

    // Get the board to check permission
    final board = await Board.db.findById(session, cardList.boardId);
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

    final cards = await Card.db.find(
      session,
      where: (c) => c.listId.equals(listId) & c.deletedAt.equals(null),
      orderBy: (c) => c.priority,
      orderDescending: false,
    );

    // Secondary sort by rank within same priority
    cards.sort((a, b) {
      final priorityCompare = a.priority.index.compareTo(b.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return a.rank.compareTo(b.rank);
    });

    return cards;
  }

  /// Gets all cards for a board (across all lists)
  /// Requires: board.read permission
  Future<List<Card>> getCardsByBoard(
    Session session,
    int boardId,
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
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this board');
    }

    final cards = await Card.db.find(
      session,
      where: (c) => c.boardId.equals(boardId) & c.deletedAt.equals(null),
      orderBy: (c) => c.priority,
      orderDescending: false,
    );

    // Secondary sort by rank
    cards.sort((a, b) {
      final priorityCompare = a.priority.index.compareTo(b.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return a.rank.compareTo(b.rank);
    });

    return cards;
  }

  /// Gets a single card by ID
  /// Requires: board.read permission
  Future<Card?> getCard(
    Session session,
    int cardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      return null;
    }

    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      return null;
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      return null;
    }

    return card;
  }

  /// Creates a new card in a list
  /// Requires: board.update permission
  Future<Card> createCard(
    Session session,
    int listId,
    String title, {
    String? description,
    CardPriority priority = CardPriority.none,
    DateTime? dueDate,
  }) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // Get the list to find board
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

    // Get the last card's rank in this list with same priority
    final existingCards = await Card.db.find(
      session,
      where: (c) =>
          c.listId.equals(listId) &
          c.priority.equals(priority) &
          c.deletedAt.equals(null),
      orderBy: (c) => c.rank,
      orderDescending: true,
      limit: 1,
    );

    final lastRank = existingCards.isNotEmpty ? existingCards.first.rank : null;
    final newRank = LexoRankService.generateRankAfter(lastRank);

    final card = Card(
      uuid: const Uuid().v4obj(),
      listId: listId,
      boardId: cardList.boardId,
      title: title,
      descriptionDocument: description,
      priority: priority,
      rank: newRank,
      dueDate: dueDate,
      isCompleted: false,
      createdAt: DateTime.now(),
      createdBy: numericUserId,
    );

    final created = await Card.db.insertRow(session, card);

    session.log(
      '[CardEndpoint] Created card "${created.title}" (rank: ${created.rank}) in list $listId',
    );

    // Log activity
    await ActivityService.log(
      session,
      cardId: created.id!,
      actorId: numericUserId,
      type: ActivityType.create,
      details: 'Created card',
    );

    return created;
  }

  /// Updates a card's details
  /// Requires: board.update permission
  Future<Card> updateCard(
    Session session,
    int cardId, {
    String? title,
    String? description,
    CardPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
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
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this board');
    }

    final updated = card.copyWith(
      title: title ?? card.title,
      descriptionDocument: description ?? card.descriptionDocument,
      priority: priority ?? card.priority,
      dueDate: dueDate ?? card.dueDate,
      isCompleted: isCompleted ?? card.isCompleted,
      updatedAt: DateTime.now(),
    );

    final result = await Card.db.updateRow(session, updated);

    session.log('[CardEndpoint] Updated card "${result.title}"');

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.update,
      details: 'Updated card details',
    );

    return result;
  }

  /// Moves a card to a different list and/or reorders within the list
  /// Requires: board.update permission
  Future<Card> moveCard(
    Session session,
    int cardId,
    int targetListId, {
    String? afterRank,
    String? beforeRank,
    CardPriority? newPriority,
  }) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      throw Exception('Card not found');
    }

    // Verify target list exists
    final targetList = await CardList.db.findById(session, targetListId);
    if (targetList == null || targetList.deletedAt != null) {
      throw Exception('Target list not found');
    }

    final board = await Board.db.findById(session, card.boardId);
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

    // Calculate new rank based on position
    String newRank;
    if (afterRank != null && beforeRank != null) {
      newRank = LexoRankService.generateRankBetween(afterRank, beforeRank);
    } else if (afterRank != null) {
      newRank = LexoRankService.generateRankAfter(afterRank);
    } else if (beforeRank != null) {
      newRank = LexoRankService.generateRankBefore(beforeRank);
    } else {
      // Moving to empty list or end of list
      newRank = LexoRankService.generateRankAfter(null);
    }

    final updated = card.copyWith(
      listId: targetListId,
      rank: newRank,
      priority: newPriority ?? card.priority,
      updatedAt: DateTime.now(),
    );

    final result = await Card.db.updateRow(session, updated);

    session.log(
      '[CardEndpoint] Moved card "${result.title}" to list $targetListId with rank ${result.rank}',
    );

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.move,
      details: 'Moved card to another list',
    );

    return result;
  }

  /// Soft deletes a card
  /// Requires: board.update permission
  Future<void> deleteCard(
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
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this board');
    }

    final updated = card.copyWith(
      deletedAt: DateTime.now(),
      deletedBy: numericUserId,
    );

    await Card.db.updateRow(session, updated);

    session.log(
      '[CardEndpoint] Soft deleted card "${card.title}" by user $numericUserId',
    );

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.delete,
      details: 'Deleted card',
    );
  }

  /// Toggles card completion status
  /// Requires: board.update permission
  Future<Card> toggleComplete(
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
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to modify this board');
    }

    final updated = card.copyWith(
      isCompleted: !card.isCompleted,
      updatedAt: DateTime.now(),
    );

    final result = await Card.db.updateRow(session, updated);

    session.log(
      '[CardEndpoint] Card "${result.title}" marked as ${result.isCompleted ? 'completed' : 'incomplete'}',
    );

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.update,
      details: result.isCompleted ? 'Completed card' : 'Marked card as incomplete',
    );

    return result;
  }

  /// Gets complete card details including all related data
  /// Requires: board.read permission
  /// 
  /// This is an aggregate endpoint that returns everything needed for the card detail page
  /// in a single request, reducing the number of HTTP calls from 7+ to 1.
  Future<CardDetail?> getCardDetail(
    Session session,
    int cardId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    // 1. Get card
    final card = await Card.db.findById(session, cardId);
    if (card == null || card.deletedAt != null) {
      return null;
    }

    // 2. Get board and validate permission
    final board = await Board.db.findById(session, card.boardId);
    if (board == null || board.deletedAt != null) {
      return null;
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      return null;
    }

    // 3. Get current list
    final currentList = await CardList.db.findById(session, card.listId);
    if (currentList == null || currentList.deletedAt != null) {
      return null;
    }

    // 4. Get workspace
    final workspace = await Workspace.db.findById(session, board.workspaceId);
    if (workspace == null || workspace.deletedAt != null) {
      return null;
    }

    // 5. Fetch all related data in parallel
    final results = await Future.wait([
      // Board lists
      CardList.db.find(
        session,
        where: (l) => l.boardId.equals(card.boardId) & l.deletedAt.equals(null),
        orderBy: (l) => l.rank,
      ),
      
      // Board labels
      LabelDef.db.find(
        session,
        where: (l) => l.boardId.equals(card.boardId) & l.deletedAt.equals(null),
      ),
      
      // Workspace members
      WorkspaceMember.db.find(
        session,
        where: (m) => m.workspaceId.equals(board.workspaceId) & m.deletedAt.equals(null),
      ),
      
      // Checklists
      Checklist.db.find(
        session,
        where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
        orderBy: (c) => c.rank,
      ),
      
      // Attachments
      Attachment.db.find(
        session,
        where: (a) => a.cardId.equals(cardId) & a.deletedAt.equals(null),
      ),
      
      // Card labels (via join table)
      _getCardLabels(session, cardId),
      
      // Comments (last 20)
      Comment.db.find(
        session,
        where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
        orderBy: (c) => c.createdAt,
        orderDescending: true,
        limit: 20,
      ),
      
      // Activities (last 20)
      CardActivity.db.find(
        session,
        where: (a) => a.cardId.equals(cardId),
        orderBy: (a) => a.createdAt,
        orderDescending: true,
        limit: 20,
      ),
      
      // Total comments count
      Comment.db.count(
        session,
        where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
      ),
      
      // Total activities count
      CardActivity.db.count(
        session,
        where: (a) => a.cardId.equals(cardId),
      ),
    ]);

    final boardLists = results[0] as List<CardList>;
    final boardLabels = results[1] as List<LabelDef>;
    final members = results[2] as List<WorkspaceMember>;
    final checklists = results[3] as List<Checklist>;
    final attachments = results[4] as List<Attachment>;
    final cardLabels = results[5] as List<LabelDef>;
    final recentComments = results[6] as List<Comment>;
    final recentActivities = results[7] as List<CardActivity>;
    final totalComments = results[8] as int;
    final totalActivities = results[9] as int;

    // 6. For each checklist, get its items (optimized with Future.wait)
    final checklistsWithItems = await Future.wait(
      checklists.map((checklist) async {
        final items = await ChecklistItem.db.find(
          session,
          where: (i) => i.checklistId.equals(checklist.id!) & i.deletedAt.equals(null),
          orderBy: (i) => i.rank,
        );
        return ChecklistWithItems(
          checklist: checklist,
          items: items,
        );
      }),
    );

    // 7. Calculate canEdit permission
    final canEdit = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    // 8. Build and return CardDetail
    return CardDetail(
      card: card,
      currentList: currentList,
      board: board,
      workspace: workspace,
      boardLists: boardLists,
      boardLabels: boardLabels,
      members: members,
      checklists: checklistsWithItems,
      attachments: attachments,
      cardLabels: cardLabels,
      recentComments: recentComments,
      totalComments: totalComments,
      recentActivities: recentActivities,
      totalActivities: totalActivities,
      canEdit: canEdit,
    );
  }

  /// Gets complete card details by UUID
  /// Requires: board.read permission
  Future<CardDetail?> getCardDetailByUuid(
    Session session,
    String uuid,
  ) async {
    final card = await Card.db.findFirstRow(
      session,
      where: (c) => c.uuid.equals(UuidValue.fromString(uuid)),
    );

    if (card == null || card.deletedAt != null) {
      return null;
    }

    return getCardDetail(session, card.id!);
  }

  /// Helper method to get labels attached to a card
  Future<List<LabelDef>> _getCardLabels(Session session, int cardId) async {
    // Get card_label join records
    final cardLabelLinks = await CardLabel.db.find(
      session,
      where: (cl) => cl.cardId.equals(cardId),
    );

    if (cardLabelLinks.isEmpty) {
      return [];
    }

    // Get the actual label definitions
    final labelIds = cardLabelLinks.map((cl) => cl.labelDefId).toList();
    final labels = await LabelDef.db.find(
      session,
      where: (l) => l.id.inSet(labelIds.toSet()) & l.deletedAt.equals(null),
    );

    return labels;
  }
}
