import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/auth_exception.dart';

Failure authExceptionToFailure(Object error, [StackTrace? stackTrace]) {
  if (error is AuthNetworkException) {
    return NetworkFailure(error.message, error, stackTrace);
  }
  if (error is AuthInvalidCredentialsException ||
      error is AuthAccountNotFoundException ||
      error is AuthAccountExistsException ||
      error is AuthCodeInvalidException ||
      error is AuthCodeExpiredException) {
    return AuthFailure(error.toString(), error, stackTrace);
  }
  return UnknownFailure(error.toString(), error, stackTrace);
}

Future<Either<Failure, T>> runAuthOperation<T>(Future<T> Function() run) async {
  try {
    final result = await run();
    return Right(result);
  } catch (error, stackTrace) {
    return Left(authExceptionToFailure(error, stackTrace));
  }
}
