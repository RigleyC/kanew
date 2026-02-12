import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '_auth_usecase_utils.dart';

class StartPasswordResetUseCase {
  final AuthRepository _repository;

  StartPasswordResetUseCase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, UuidValue>> call({required String email}) {
    if (email.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Email e obrigatorio')));
    }

    return runAuthOperation(() => _repository.startPasswordReset(email: email));
  }
}
