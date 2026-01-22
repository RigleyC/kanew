import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

class ActivityRepository {
  final Client _client;

  ActivityRepository({Client? client}) : _client = client ?? getIt<Client>();

  Future<Either<Failure, List<CardActivity>>> getLog(int cardId) async {
    try {
      final logs = await _client.activity.getLog(cardId);
      return Right(logs);
    } catch (e, s) {
      developer.log('Error fetching activity log', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to fetch activity log', originalError: e));
    }
  }
}
