import 'package:dartz/dartz.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/error/failures.dart';

class LogoutUseCase {
  final FlutterAuthSessionManager _authManager;

  LogoutUseCase({required FlutterAuthSessionManager authManager}) : _authManager = authManager;

  Future<Either<Failure, void>> call() async {
    try {
      await _authManager.signOutDevice();
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(AuthFailure('Falha ao encerrar sessao', error, stackTrace));
    }
  }
}
