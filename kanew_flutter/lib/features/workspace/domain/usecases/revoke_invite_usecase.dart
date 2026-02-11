import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to revoke an invite
class RevokeInviteUseCase {
  final MemberRepository _repository;
  
  RevokeInviteUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, void>> call(UuidValue inviteId) async {
    return await _repository.revokeInvite(inviteId);
  }
}
