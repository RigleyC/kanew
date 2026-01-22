import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

/// Repository for card list operations
///
/// Returns `Either<Failure, T>` for all operations that can fail,
/// following the pattern defined in AGENTS.md.
class ListRepository {
  final Client _client;

  ListRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all lists for a board
  Future<Either<Failure, List<CardList>>> getLists(int boardId) async {
    developer.log(
      'ListRepository.getLists($boardId)',
      name: 'list_repository',
    );
    try {
      final lists = await _client.cardList.getLists(boardId);
      developer.log(
        'ListRepository.getLists success: ${lists.length} lists',
        name: 'list_repository',
      );
      return Right(lists);
    } catch (e, s) {
      developer.log(
        'ListRepository.getLists error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar listas',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Creates a new list in a board
  Future<Either<Failure, CardList>> createList(
    int boardId,
    String title,
  ) async {
    developer.log(
      'ListRepository.createList($boardId, $title)',
      name: 'list_repository',
    );
    try {
      final list = await _client.cardList.createList(boardId, title);
      developer.log(
        'ListRepository.createList success: ${list.title}',
        name: 'list_repository',
      );
      return Right(list);
    } catch (e, s) {
      developer.log(
        'ListRepository.createList error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao criar lista', originalError: e, stackTrace: s),
      );
    }
  }

  /// Updates a list's title
  Future<Either<Failure, CardList>> updateList(int listId, String title) async {
    developer.log(
      'ListRepository.updateList($listId, $title)',
      name: 'list_repository',
    );
    try {
      final list = await _client.cardList.updateList(listId, title);
      developer.log(
        'ListRepository.updateList success: ${list.title}',
        name: 'list_repository',
      );
      return Right(list);
    } catch (e, s) {
      developer.log(
        'ListRepository.updateList error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao atualizar lista',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Reorders lists within a board
  Future<Either<Failure, List<CardList>>> reorderLists(
    int boardId,
    List<int> orderedListIds,
  ) async {
    developer.log(
      'ListRepository.reorderLists($boardId, $orderedListIds)',
      name: 'list_repository',
    );
    try {
      final lists = await _client.cardList.reorderLists(
        boardId,
        orderedListIds,
      );
      developer.log(
        'ListRepository.reorderLists success: ${lists.length} lists',
        name: 'list_repository',
      );
      return Right(lists);
    } catch (e, s) {
      developer.log(
        'ListRepository.reorderLists error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao reordenar listas',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Soft deletes a list
  Future<Either<Failure, Unit>> deleteList(int listId) async {
    developer.log(
      'ListRepository.deleteList($listId)',
      name: 'list_repository',
    );
    try {
      await _client.cardList.deleteList(listId);
      developer.log(
        'ListRepository.deleteList success',
        name: 'list_repository',
      );
      return const Right(unit);
    } catch (e, s) {
      developer.log(
        'ListRepository.deleteList error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao excluir lista', originalError: e, stackTrace: s),
      );
    }
  }

  /// Archives a list
  Future<Either<Failure, CardList>> archiveList(int listId) async {
    developer.log(
      'ListRepository.archiveList($listId)',
      name: 'list_repository',
    );
    try {
      final list = await _client.cardList.archiveList(listId);
      developer.log(
        'ListRepository.archiveList success',
        name: 'list_repository',
      );
      return Right(list);
    } catch (e, s) {
      developer.log(
        'ListRepository.archiveList error: $e',
        name: 'list_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao arquivar lista',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }
}
