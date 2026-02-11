import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to accept an invite
class AcceptInviteUseCase {
  final MemberRepository _repository;
  
  AcceptInviteUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, AcceptInviteResult>> call(String code) async {
    if (code.isEmpty) {
      return const Left(ValidationFailure('Código do convite é obrigatório'));
    }
    return await _repository.acceptInvite(code);
  }
}
