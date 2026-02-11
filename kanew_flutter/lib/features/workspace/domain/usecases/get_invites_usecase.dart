import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to get all pending invites of a workspace
class GetInvitesUseCase {
  final MemberRepository _repository;
  
  GetInvitesUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, List<WorkspaceInvite>>> call(UuidValue workspaceId) async {
    return await _repository.getInvites(workspaceId);
  }
}
