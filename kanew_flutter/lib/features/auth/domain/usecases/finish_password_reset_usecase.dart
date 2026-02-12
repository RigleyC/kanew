import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '_auth_usecase_utils.dart';

class FinishPasswordResetUseCase {
  final AuthRepository _repository;

  FinishPasswordResetUseCase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, void>> call({
    required String token,
    required String newPassword,
  }) {
    if (token.isEmpty) {
      return Future.value(const Left(ValidationFailure('Token de redefinicao invalido')));
    }
    if (newPassword.length < 8) {
      return Future.value(const Left(ValidationFailure('Senha deve ter ao menos 8 caracteres')));
    }

    return runAuthOperation(
      () => _repository.finishPasswordReset(token: token, newPassword: newPassword),
    );
  }
}
