import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '_auth_usecase_utils.dart';

class VerifyRegistrationCodeUseCase {
  final AuthRepository _repository;

  VerifyRegistrationCodeUseCase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, String>> call({
    required UuidValue accountRequestId,
    required String code,
  }) {
    if (code.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Codigo e obrigatorio')));
    }

    return runAuthOperation(
      () => _repository.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        code: code,
      ),
    );
  }
}
