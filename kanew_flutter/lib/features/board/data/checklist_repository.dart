import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

/// Repository for checklist operations
class ChecklistRepository {
  final Client _client;

  ChecklistRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all checklists for a card
  Future<Either<Failure, List<Checklist>>> getChecklists(UuidValue cardId) async {
    developer.log(
      'ChecklistRepository.getChecklists($cardId)',
      name: 'checklist_repository',
    );
    try {
      final checklists = await _client.checklist.getChecklists(cardId);
      developer.log(
        'ChecklistRepository.getChecklists success: ${checklists.length} checklists',
        name: 'checklist_repository',
      );
      return Right(checklists);
    } catch (e, s) {
      developer.log(
        'ChecklistRepository.getChecklists error: $e',
        name: 'checklist_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar checklists',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Gets items for a checklist
  Future<Either<Failure, List<ChecklistItem>>> getItems(UuidValue checklistId) async {
    developer.log(
      'ChecklistRepository.getItems($checklistId)',
      name: 'checklist_repository',
    );
    try {
      final items = await _client.checklist.getItems(checklistId);
      return Right(items);
    } catch (e, s) {
      developer.log(
        'ChecklistRepository.getItems error: $e',
        name: 'checklist_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao carregar itens da checklist',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Creates a new checklist
  Future<Either<Failure, Checklist>> createChecklist(
    UuidValue cardId,
    String title,
  ) async {
    developer.log(
      'ChecklistRepository.createChecklist($cardId, $title)',
      name: 'checklist_repository',
    );
    try {
      final checklist = await _client.checklist.createChecklist(cardId, title);
      return Right(checklist);
    } catch (e, s) {
      developer.log(
        'ChecklistRepository.createChecklist error: $e',
        name: 'checklist_repository',
        error: e,
        stackTrace: s,
      );
      return Left(
        ServerFailure(
          'Erro ao criar checklist',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Updates a checklist
  Future<Either<Failure, Checklist>> updateChecklist(
    UuidValue checklistId,
    String title,
  ) async {
    try {
      final checklist = await _client.checklist.updateChecklist(
        checklistId,
        title,
      );
      return Right(checklist);
    } catch (e, s) {
      return Left(
        ServerFailure(
          'Erro ao atualizar checklist',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Deletes a checklist
  Future<Either<Failure, Unit>> deleteChecklist(UuidValue checklistId) async {
    try {
      await _client.checklist.deleteChecklist(checklistId);
      return const Right(unit);
    } catch (e, s) {
      return Left(
        ServerFailure(
          'Erro ao excluir checklist',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Creates a new item in a checklist
  Future<Either<Failure, ChecklistItem>> addItem(
    UuidValue checklistId,
    String title,
  ) async {
    try {
      final item = await _client.checklist.addItem(checklistId, title);
      return Right(item);
    } catch (e, s) {
      return Left(
        ServerFailure(
          'Erro ao adicionar item',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Updates a checklist item
  Future<Either<Failure, ChecklistItem>> updateItem(
    UuidValue itemId, {
    String? title,
    bool? isChecked,
  }) async {
    try {
      final item = await _client.checklist.updateItem(
        itemId,
        title: title,
        isChecked: isChecked,
      );
      return Right(item);
    } catch (e, s) {
      return Left(
        ServerFailure(
          'Erro ao atualizar item',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }

  /// Deletes a checklist item
  Future<Either<Failure, Unit>> deleteItem(UuidValue itemId) async {
    try {
      await _client.checklist.deleteItem(itemId);
      return const Right(unit);
    } catch (e, s) {
      return Left(
        ServerFailure(
          'Erro ao excluir item',
          originalError: e,
          stackTrace: s,
        ),
      );
    }
  }
}
