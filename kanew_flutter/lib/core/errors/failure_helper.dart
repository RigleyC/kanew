import 'package:dartz/dartz.dart';

import 'failures.dart';

/// Helper para converter exceções em Failures
Failure exceptionToFailure(Object error, StackTrace stackTrace) {
  // Verifica se é um erro de servidor (status code em error.toString())
  final errorString = error.toString();

  if (errorString.contains('401') || errorString.contains('403')) {
    return UnauthorizedFailure(
      error: error,
      stackTrace: stackTrace,
    );
  }

  if (errorString.contains('404')) {
    return NotFoundFailure(
      error: error,
      stackTrace: stackTrace,
    );
  }

  if (errorString.contains('SocketException') ||
      errorString.contains('Failed host lookup') ||
      errorString.contains('Connection')) {
    return NetworkFailure(
      message: 'Erro de conexão com o servidor',
      error: error,
      stackTrace: stackTrace,
    );
  }

  if (error is Exception) {
    return ServerFailure(
      message: error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  return UnexpectedFailure(
    error: error,
    stackTrace: stackTrace,
  );
}

/// Wrapper para executar operações e retornar Either\u003cFailure, T>
Future<Either<Failure, T>> executeOperation<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return Right(result);
  } catch (error, stackTrace) {
    return Left(exceptionToFailure(error, stackTrace));
  }
}
