import 'package:dartz/dartz.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '_auth_usecase_utils.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, AuthSuccess>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Email e obrigatorio')));
    }
    if (password.isEmpty) {
      return Future.value(const Left(ValidationFailure('Senha e obrigatoria')));
    }

    return runAuthOperation(() => _repository.login(email: email, password: password));
  }
}
