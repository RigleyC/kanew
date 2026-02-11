import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to get invite details by code
class GetInviteByCodeUseCase {
  final MemberRepository _repository;
  
  GetInviteByCodeUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, InviteDetails?>> call(String code) async {
    if (code.isEmpty) {
      return const Left(ValidationFailure('Código do convite é obrigatório'));
    }
    return await _repository.getInviteByCode(code);
  }
}
