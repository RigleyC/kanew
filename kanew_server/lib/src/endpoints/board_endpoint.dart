import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../utils/slug_generator.dart';

/// Endpoint for managing boards within a workspace
class BoardEndpoint extends Endpoint {
  /// Require user to be logged in for all methods in this endpoint
  @override
  bool get requireLogin => true;

  /// Gets all boards for a workspace by ID
  /// Requires: board.read permission
  Future<List<Board>> getBoards(
    Session session,
    int workspaceId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Verify user has permission to read boards in this workspace
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read boards');
    }

    final boards = await Board.db.find(
      session,
      where: (b) =>
          b.workspaceId.equals(workspaceId) & b.deletedAt.equals(null),
      orderBy: (b) => b.createdAt,
      orderDescending: true,
    );

    return boards;
  }

  /// Gets all boards for a workspace by workspace slug
  /// Requires: board.read permission
  Future<List<Board>> getBoardsByWorkspaceSlug(
    Session session,
    String workspaceSlug,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Resolve workspace by slug
    final workspace = await Workspace.db.findFirstRow(
      session,
      where: (w) => w.slug.equals(workspaceSlug) & w.deletedAt.equals(null),
    );

    if (workspace == null) {
      throw Exception('Workspace not found');
    }

    // Verify permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspace.id!,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read boards');
    }

    return await Board.db.find(
      session,
      where: (b) =>
          b.workspaceId.equals(workspace.id!) & b.deletedAt.equals(null),
      orderBy: (b) => b.createdAt,
      orderDescending: true,
    );
  }

  /// Gets a single board by slug within a workspace (by workspace ID)
  /// Requires: board.read permission
  Future<Board?> getBoard(
    Session session,
    int workspaceId,
    String slug,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Verify user has permission to read boards
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspaceId,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this board');
    }

    final board = await Board.db.findFirstRow(
      session,
      where: (b) =>
          b.workspaceId.equals(workspaceId) &
          b.slug.equals(slug) &
          b.deletedAt.equals(null),
    );

    return board;
  }

  /// Gets a single board by workspace slug and board slug
  /// Requires: board.read permission
  Future<Board?> getBoardBySlug(
    Session session,
    String workspaceSlug,
    String boardSlug,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Resolve workspace by slug
    final workspace = await Workspace.db.findFirstRow(
      session,
      where: (w) => w.slug.equals(workspaceSlug) & w.deletedAt.equals(null),
    );

    if (workspace == null) {
      throw Exception('Workspace not found');
    }

    // Verify permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspace.id!,
      permissionSlug: 'board.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this board');
    }

    return await Board.db.findFirstRow(
      session,
      where: (b) =>
          b.workspaceId.equals(workspace.id!) &
          b.slug.equals(boardSlug) &
          b.deletedAt.equals(null),
    );
  }

  /// Creates a new board in a workspace (by workspace ID)
  /// Requires: board.create permission
  Future<Board> createBoard(
    Session session,
    int workspaceId,
    String title,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Verify user has permission to create boards
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspaceId,
      permissionSlug: 'board.create',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to create boards');
    }

    // Verify workspace exists and is not deleted
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null || workspace.deletedAt != null) {
      throw Exception('Workspace not found');
    }

    // Generate unique slug within the workspace
    final slug = await SlugGenerator.generateUniqueSlug(
      session,
      title,
      checkSlugExists: (s) => Board.db
          .findFirstRow(
            session,
            where: (b) =>
                b.workspaceId.equals(workspaceId) &
                b.slug.equals(s) &
                b.deletedAt.equals(null),
          )
          .then((b) => b != null),
    );

    final board = Board(
      uuid: const Uuid().v4obj(),
      workspaceId: workspaceId,
      title: title,
      slug: slug,
      visibility: BoardVisibility.workspace,
      isTemplate: false,
      createdAt: DateTime.now(),
      createdBy: userId,
    );

    final created = await Board.db.insertRow(session, board);

    session.log(
      '[BoardEndpoint] Created board "${created.title}" (${created.slug}) in workspace $workspaceId by user $userId',
    );

    return created;
  }

  /// Creates a new board in a workspace by workspace slug
  /// Requires: board.create permission
  Future<Board> createBoardByWorkspaceSlug(
    Session session,
    String workspaceSlug,
    String title,
  ) async {
    // Resolve workspace by slug
    final workspace = await Workspace.db.findFirstRow(
      session,
      where: (w) => w.slug.equals(workspaceSlug) & w.deletedAt.equals(null),
    );

    if (workspace == null) {
      throw Exception('Workspace not found');
    }

    // Delegate to existing method
    return createBoard(session, workspace.id!, title);
  }

  /// Updates a board's title and/or slug
  /// Requires: board.update permission
  Future<Board> updateBoard(
    Session session,
    int boardId,
    String title,
    String? slug,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final board = await Board.db.findById(session, boardId);

    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Verify user has permission to update boards
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update this board');
    }

    String finalSlug = board.slug;
    if (slug != null && slug.isNotEmpty && slug != board.slug) {
      finalSlug = await SlugGenerator.generateUniqueSlug(
        session,
        slug,
        checkSlugExists: (s) => Board.db
            .findFirstRow(
              session,
              where: (b) =>
                  b.workspaceId.equals(board.workspaceId) &
                  b.slug.equals(s) &
                  ~b.id.equals(boardId) &
                  b.deletedAt.equals(null),
            )
            .then((b) => b != null),
      );
    }

    final updated = board.copyWith(
      title: title,
      slug: finalSlug,
    );

    final result = await Board.db.updateRow(session, updated);

    session.log(
      '[BoardEndpoint] Updated board "${result.title}" (${result.slug})',
    );

    return result;
  }

  /// Soft deletes a board
  /// Requires: board.delete permission
  Future<void> deleteBoard(
    Session session,
    int boardId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final board = await Board.db.findById(session, boardId);

    if (board == null || board.deletedAt != null) {
      throw Exception('Board not found');
    }

    // Verify user has permission to delete boards
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: board.workspaceId,
      permissionSlug: 'board.delete',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to delete this board');
    }

    final updated = board.copyWith(
      deletedAt: DateTime.now(),
      deletedBy: userId,
    );

    await Board.db.updateRow(session, updated);

    session.log(
      '[BoardEndpoint] Soft deleted board "${board.title}" by user $userId',
    );
  }
}
