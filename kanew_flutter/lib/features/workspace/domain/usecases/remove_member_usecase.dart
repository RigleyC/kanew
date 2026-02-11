import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to remove a member from workspace
class RemoveMemberUseCase {
  final MemberRepository _repository;
  
  RemoveMemberUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, void>> call(UuidValue memberId) async {
    return await _repository.removeMember(memberId);
  }
}
