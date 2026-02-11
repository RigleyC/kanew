import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to update a member's role
class UpdateMemberRoleUseCase {
  final MemberRepository _repository;
  
  UpdateMemberRoleUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, WorkspaceMember>> call({
    required UuidValue memberId,
    required MemberRole role,
  }) async {
    return await _repository.updateMemberRole(memberId, role);
  }
}
