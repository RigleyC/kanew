import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

class CommentRepository {
  final Client _client;

  CommentRepository({Client? client}) : _client = client ?? getIt<Client>();

  Future<Either<Failure, List<Comment>>> getComments(int cardId) async {
    try {
      final comments = await _client.comment.getComments(cardId);
      return Right(comments);
    } catch (e, s) {
      developer.log('Error fetching comments', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to fetch comments', originalError: e));
    }
  }

  Future<Either<Failure, Comment>> createComment(
    int cardId,
    String content,
  ) async {
    try {
      final comment = await _client.comment.createComment(cardId, content);
      return Right(comment);
    } catch (e, s) {
      developer.log('Error creating comment', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to create comment', originalError: e));
    }
  }

  Future<Either<Failure, Unit>> deleteComment(int commentId) async {
    try {
      await _client.comment.deleteComment(commentId);
      return const Right(unit);
    } catch (e, s) {
      developer.log('Error deleting comment', error: e, stackTrace: s);
      return Left(ServerFailure('Failed to delete comment', originalError: e));
    }
  }
}
