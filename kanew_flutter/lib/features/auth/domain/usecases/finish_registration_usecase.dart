import 'package:dartz/dartz.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '_auth_usecase_utils.dart';

class FinishRegistrationUseCase {
  final AuthRepository _repository;

  FinishRegistrationUseCase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, AuthSuccess>> call({
    required String registrationToken,
    required String password,
  }) {
    if (registrationToken.isEmpty) {
      return Future.value(const Left(ValidationFailure('Token de cadastro invalido')));
    }
    if (password.length < 8) {
      return Future.value(const Left(ValidationFailure('Senha deve ter ao menos 8 caracteres')));
    }

    return runAuthOperation(
      () => _repository.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      ),
    );
  }
}
