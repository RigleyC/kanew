import 'dart:developer' as developer;

import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';

/// Repository for board operations
class BoardRepository {
  final Client _client;

  BoardRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all boards for a workspace by workspace slug
  Future<List<Board>> getBoardsByWorkspaceSlug(String workspaceSlug) async {
    developer.log(
      'BoardRepository.getBoardsByWorkspaceSlug($workspaceSlug)',
      name: 'board_repository',
    );
    try {
      final boards = await _client.board.getBoardsByWorkspaceSlug(
        workspaceSlug,
      );
      developer.log(
        'BoardRepository.getBoardsByWorkspaceSlug success: ${boards.length} boards',
        name: 'board_repository',
      );
      return boards;
    } catch (e, s) {
      developer.log(
        'BoardRepository.getBoardsByWorkspaceSlug error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Gets a single board by workspace slug and board slug
  Future<Board?> getBoardBySlug(String workspaceSlug, String boardSlug) async {
    developer.log(
      'BoardRepository.getBoardBySlug($workspaceSlug, $boardSlug)',
      name: 'board_repository',
    );
    try {
      return await _client.board.getBoardBySlug(workspaceSlug, boardSlug);
    } catch (e, s) {
      developer.log(
        'BoardRepository.getBoardBySlug error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Creates a new board by workspace slug
  Future<Board> createBoardByWorkspaceSlug(
    String workspaceSlug,
    String title,
  ) async {
    developer.log(
      'BoardRepository.createBoardByWorkspaceSlug($workspaceSlug, $title)',
      name: 'board_repository',
    );
    try {
      final board = await _client.board.createBoardByWorkspaceSlug(
        workspaceSlug,
        title,
      );
      developer.log(
        'BoardRepository.createBoardByWorkspaceSlug success: ${board.title} (${board.slug})',
        name: 'board_repository',
      );
      return board;
    } catch (e, s) {
      developer.log(
        'BoardRepository.createBoardByWorkspaceSlug error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  // ============================================================
  // DEPRECATED - Use slug-based methods instead
  // ============================================================

  @Deprecated('Use getBoardsByWorkspaceSlug instead')
  Future<List<Board>> getBoards(int workspaceId) async {
    developer.log(
      'BoardRepository.getBoards($workspaceId)',
      name: 'board_repository',
    );
    try {
      final boards = await _client.board.getBoards(workspaceId);
      developer.log(
        'BoardRepository.getBoards success: ${boards.length} boards',
        name: 'board_repository',
      );
      return boards;
    } catch (e, s) {
      developer.log(
        'BoardRepository.getBoards error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @Deprecated('Use getBoardBySlug instead')
  Future<Board?> getBySlug(int workspaceId, String slug) async {
    developer.log(
      'BoardRepository.getBySlug($workspaceId, $slug)',
      name: 'board_repository',
    );
    try {
      return await _client.board.getBoard(workspaceId, slug);
    } catch (e, s) {
      developer.log(
        'BoardRepository.getBySlug error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @Deprecated('Use createBoardByWorkspaceSlug instead')
  Future<Board> createBoard(int workspaceId, String title) async {
    developer.log(
      'BoardRepository.createBoard($workspaceId, $title)',
      name: 'board_repository',
    );
    try {
      final board = await _client.board.createBoard(workspaceId, title);
      developer.log(
        'BoardRepository.createBoard success: ${board.title} (${board.slug})',
        name: 'board_repository',
      );
      return board;
    } catch (e, s) {
      developer.log(
        'BoardRepository.createBoard error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Updates a board
  Future<Board> updateBoard(
    int boardId,
    String title, {
    String? slug,
  }) async {
    developer.log(
      'BoardRepository.updateBoard($boardId, $title)',
      name: 'board_repository',
    );
    try {
      return await _client.board.updateBoard(boardId, title, slug);
    } catch (e, s) {
      developer.log(
        'BoardRepository.updateBoard error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Deletes a board (soft delete)
  Future<void> deleteBoard(int boardId) async {
    developer.log(
      'BoardRepository.deleteBoard($boardId)',
      name: 'board_repository',
    );
    try {
      await _client.board.deleteBoard(boardId);
    } catch (e, s) {
      developer.log(
        'BoardRepository.deleteBoard error',
        name: 'board_repository',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
