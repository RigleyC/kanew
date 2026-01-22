import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

/// Repository for card operations
///
/// Returns `Either<Failure, T>` for all operations that can fail,
/// following the pattern defined in AGENTS.md.
class CardRepository {
  final Client _client;

  CardRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all cards for a list
  Future<Either<Failure, List<Card>>> getCards(int listId) async {
    developer.log(
      'CardRepository.getCards($listId)',
      name: 'card_repository',
    );
    try {
      final cards = await _client.card.getCards(listId);
      developer.log(
        'CardRepository.getCards success: ${cards.length} cards',
        name: 'card_repository',
      );
      return Right(cards);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCards error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar cards',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets all cards for a board
  Future<Either<Failure, List<Card>>> getCardsByBoard(int boardId) async {
    developer.log(
      'CardRepository.getCardsByBoard($boardId)',
      name: 'card_repository',
    );
    try {
      final cards = await _client.card.getCardsByBoard(boardId);
      developer.log(
        'CardRepository.getCardsByBoard success: ${cards.length} cards',
        name: 'card_repository',
      );
      return Right(cards);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCardsByBoard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar cards do board',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets a single card by ID
  Future<Either<Failure, Card?>> getCard(int cardId) async {
    developer.log(
      'CardRepository.getCard($cardId)',
      name: 'card_repository',
    );
    try {
      final card = await _client.card.getCard(cardId);
      developer.log(
        'CardRepository.getCard success: ${card?.title}',
        name: 'card_repository',
      );
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao carregar card', originalError: e, stackTrace: s),
      );
    }
  }

  /// Creates a new card in a list
  Future<Either<Failure, Card>> createCard(
    int listId,
    String title, {
    String? description,
    CardPriority priority = CardPriority.none,
    DateTime? dueDate,
  }) async {
    developer.log(
      'CardRepository.createCard($listId, $title)',
      name: 'card_repository',
    );
    try {
      final card = await _client.card.createCard(
        listId,
        title,
        description: description,
        priority: priority,
        dueDate: dueDate,
      );
      developer.log(
        'CardRepository.createCard success: ${card.title}',
        name: 'card_repository',
      );
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.createCard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao criar card', originalError: e, stackTrace: s),
      );
    }
  }

  /// Updates a card's details
  Future<Either<Failure, Card>> updateCard(
    int cardId, {
    String? title,
    String? description,
    CardPriority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
    developer.log(
      'CardRepository.updateCard($cardId)',
      name: 'card_repository',
    );
    try {
      final card = await _client.card.updateCard(
        cardId,
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        isCompleted: isCompleted,
      );
      developer.log(
        'CardRepository.updateCard success: ${card.title}',
        name: 'card_repository',
      );
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.updateCard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao atualizar card',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Moves a card to a different list and/or reorders
  Future<Either<Failure, Card>> moveCard(
    int cardId,
    int targetListId, {
    String? afterRank,
    String? beforeRank,
    CardPriority? newPriority,
  }) async {
    developer.log(
      'CardRepository.moveCard($cardId -> $targetListId)',
      name: 'card_repository',
    );
    try {
      final card = await _client.card.moveCard(
        cardId,
        targetListId,
        afterRank: afterRank,
        beforeRank: beforeRank,
        newPriority: newPriority,
      );
      developer.log(
        'CardRepository.moveCard success: ${card.title} to list $targetListId',
        name: 'card_repository',
      );
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.moveCard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao mover card', originalError: e, stackTrace: s),
      );
    }
  }

  /// Soft deletes a card
  Future<Either<Failure, Unit>> deleteCard(int cardId) async {
    developer.log(
      'CardRepository.deleteCard($cardId)',
      name: 'card_repository',
    );
    try {
      await _client.card.deleteCard(cardId);
      developer.log(
        'CardRepository.deleteCard success',
        name: 'card_repository',
      );
      return const Right(unit);
    } catch (e, s) {
      developer.log(
        'CardRepository.deleteCard error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure('Erro ao excluir card', originalError: e, stackTrace: s),
      );
    }
  }

  /// Toggles card completion status
  Future<Either<Failure, Card>> toggleComplete(int cardId) async {
    developer.log(
      'CardRepository.toggleComplete($cardId)',
      name: 'card_repository',
    );
    try {
      final card = await _client.card.toggleComplete(cardId);
      developer.log(
        'CardRepository.toggleComplete success: ${card.isCompleted}',
        name: 'card_repository',
      );
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.toggleComplete error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao alterar status do card',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets complete card details (aggregate)
  Future<Either<Failure, CardDetail?>> getCardDetail(int cardId) async {
    developer.log(
      'CardRepository.getCardDetail($cardId)',
      name: 'card_repository',
    );
    try {
      final detail = await _client.card.getCardDetail(cardId);
      developer.log(
        'CardRepository.getCardDetail success: ${detail?.card.title}',
        name: 'card_repository',
      );
      return Right(detail);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCardDetail error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar detalhes do card',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets complete card details by UUID
  Future<Either<Failure, CardDetail?>> getCardDetailByUuid(String uuid) async {
    developer.log(
      'CardRepository.getCardDetailByUuid($uuid)',
      name: 'card_repository',
    );
    try {
      final detail = await _client.card.getCardDetailByUuid(uuid);
      developer.log(
        'CardRepository.getCardDetailByUuid success: ${detail?.card.title}',
        name: 'card_repository',
      );
      return Right(detail);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCardDetailByUuid error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar detalhes do card por UUID',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }
}
