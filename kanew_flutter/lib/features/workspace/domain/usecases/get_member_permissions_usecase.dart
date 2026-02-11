import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to get member permissions
class GetMemberPermissionsUseCase {
  final MemberRepository _repository;
  
  GetMemberPermissionsUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, List<PermissionInfo>>> call(UuidValue memberId) async {
    return await _repository.getMemberPermissions(memberId);
  }
}
