import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to create a workspace invite
class CreateInviteUseCase {
  final MemberRepository _repository;
  
  CreateInviteUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, WorkspaceInvite>> call({
    required UuidValue workspaceId,
    required List<UuidValue> permissionIds,
    String? email,
  }) async {
    if (permissionIds.isEmpty) {
      return const Left(ValidationFailure('Selecione pelo menos uma permissão'));
    }
    return await _repository.createInvite(workspaceId, permissionIds, email: email);
  }
}
