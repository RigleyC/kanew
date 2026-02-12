import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

class CardRepository {
  final Client _client;

  CardRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all cards for a list
  Future<Either<Failure, List<Card>>> getCards(UuidValue listId) async {
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

  /// Gets all cards for a board with complete details
  Future<Either<Failure, List<CardDetail>>> getCardsByBoardDetail(
    UuidValue boardId,
  ) async {
    developer.log(
      'CardRepository.getCardsByBoardDetail($boardId)',
      name: 'card_repository',
    );
    try {
      final cardDetails = await _client.card.getCardsByBoardDetail(boardId);
      developer.log(
        'CardRepository.getCardsByBoardDetail success: ${cardDetails.length} cards',
        name: 'card_repository',
      );
      return Right(cardDetails);
    } catch (e, s) {
      developer.log(
        'CardRepository.getCardsByBoardDetail error: $e',
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

  /// Creates a new card and returns complete CardDetail
  /// Requires: board.update permission
  Future<Either<Failure, CardDetail>> createCardDetail(
    UuidValue listId,
    String title,
  ) async {
    developer.log(
      'CardRepository.createCardDetail($listId, $title)',
      name: 'card_repository',
    );
    try {
      final cardDetail = await _client.card.createCardDetail(
        listId,
        title,
        priority: CardPriority.none,
      );
      developer.log(
        'CardRepository.createCardDetail success',
        name: 'card_repository',
      );
      return Right(cardDetail);
    } catch (e, s) {
      developer.log(
        'CardRepository.createCardDetail error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao criar card',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets a single card by ID
  Future<Either<Failure, Card?>> getCard(UuidValue cardId) async {
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
    UuidValue listId,
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
    UuidValue cardId, {
    String? title,
    String? description,
    CardPriority? priority,
    DateTime? dueDate,
    bool? clearDueDate,
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
        clearDueDate: clearDueDate,
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

  Future<Either<Failure, Card>> updateAssignee(
    UuidValue cardId,
    UuidValue? assigneeMemberId,
  ) async {
    developer.log(
      'CardRepository.updateAssignee($cardId, $assigneeMemberId)',
      name: 'card_repository',
    );

    try {
      final card = await _client.card.updateAssignee(cardId, assigneeMemberId);
      return Right(card);
    } catch (e, s) {
      developer.log(
        'CardRepository.updateAssignee error: $e',
        name: 'card_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao atribuir membro ao card',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Moves a card to a different list and/or reorders
  Future<Either<Failure, Card>> moveCard(
    UuidValue cardId,
    UuidValue targetListId, {
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
  Future<Either<Failure, Unit>> deleteCard(UuidValue cardId) async {
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

  /// Gets complete card details (aggregate)
  Future<Either<Failure, CardDetail?>> getCardDetail(UuidValue cardId) async {
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
