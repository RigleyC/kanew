import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../services/activity_service.dart';

class CommentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets all comments for a card
  Future<List<Comment>> getComments(
    Session session,
    UuidValue cardId,
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

    return await Comment.db.find(
      session,
      where: (c) => c.cardId.equals(cardId) & c.deletedAt.equals(null),
      orderBy: (c) => c.createdAt,
      orderDescending: true,
    );
  }

  /// Creates a comment
  Future<Comment> createComment(
    Session session,
    UuidValue cardId,
    String content,
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
      throw Exception('User does not have permission to comment on this card');
    }

    final comment = Comment(
      cardId: cardId,
      authorId: numericUserId,
      content: content,
      createdAt: DateTime.now(),
    );

    final created = await Comment.db.insertRow(session, comment);

    // Log activity
    await ActivityService.log(
      session,
      cardId: cardId,
      actorId: numericUserId,
      type: ActivityType.comment,
      details: 'adicionou um comentário',
    );

    return created;
  }

  /// Deletes a comment (soft delete)
  Future<void> deleteComment(
    Session session,
    UuidValue commentId,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final comment = await Comment.db.findById(session, commentId);
    if (comment == null || comment.deletedAt != null) {
      throw Exception('Comment not found');
    }

    // Only author or admin can delete?
    // For now, let's say only author or someone with board.update
    // But we need to check board permissions anyway.

    final card = await Card.db.findById(session, comment.cardId);
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
      throw Exception('User does not have permission to delete comments');
    }

    // Additional check: users can only delete their own comments unless they are admins?
    // Let's keep it simple: if you can update the board, you can moderate comments.
    // But ideally: author can delete, OR workspace admin.
    // The permission check above covers "member with write access".

    final updated = comment.copyWith(
      deletedAt: DateTime.now(),
    );

    await Comment.db.updateRow(session, updated);
  }
}
