import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to get all members of a workspace
class GetMembersUseCase {
  final MemberRepository _repository;
  
  GetMembersUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, List<MemberWithUser>>> call(UuidValue workspaceId) async {
    return await _repository.getMembers(workspaceId);
  }
}
