import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

class LabelRepository {
  final Client _client;

  LabelRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Get all labels for a board
  Future<Either<Failure, List<LabelDef>>> getLabels(int boardId) async {
    try {
      final labels = await _client.label.getLabels(boardId);
      return Right(labels);
    } catch (e, s) {
      developer.log('Error fetching labels', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to fetch labels', originalError: e));
    }
  }

  /// Create a new label definition
  Future<Either<Failure, LabelDef>> createLabel(
    int boardId,
    String name,
    String colorHex,
  ) async {
    try {
      final label = await _client.label.createLabel(boardId, name, colorHex);
      return Right(label);
    } catch (e, s) {
      developer.log('Error creating label', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to create label', originalError: e));
    }
  }

  /// Attach a label to a card
  Future<Either<Failure, Unit>> attachLabel(int cardId, int labelId) async {
    try {
      await _client.label.attachLabel(cardId, labelId);
      return const Right(unit);
    } catch (e, s) {
      developer.log('Error attaching label', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to attach label', originalError: e));
    }
  }

  /// Detach a label from a card
  Future<Either<Failure, Unit>> detachLabel(int cardId, int labelId) async {
    try {
      await _client.label.detachLabel(cardId, labelId);
      return const Right(unit);
    } catch (e, s) {
      developer.log('Error detaching label', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to detach label', originalError: e));
    }
  }

  /// Get labels attached to a card
  Future<Either<Failure, List<LabelDef>>> getCardLabels(int cardId) async {
    try {
      final labels = await _client.label.getCardLabels(cardId);
      return Right(labels);
    } catch (e, s) {
      developer.log('Error fetching card labels', error: e, stackTrace: s);
      return Left(
        ServerFailure('Failed to fetch card labels', originalError: e),
      );
    }
  }
}
