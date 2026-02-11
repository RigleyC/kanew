import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to update member permissions
class UpdateMemberPermissionsUseCase {
  final MemberRepository _repository;
  
  UpdateMemberPermissionsUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, void>> call({
    required UuidValue memberId,
    required List<UuidValue> permissionIds,
  }) async {
    if (permissionIds.isEmpty) {
      return const Left(ValidationFailure('Selecione pelo menos uma permissão'));
    }
    return await _repository.updateMemberPermissions(memberId, permissionIds);
  }
}
