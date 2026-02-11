import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to transfer workspace ownership
class TransferOwnershipUseCase {
  final MemberRepository _repository;
  
  TransferOwnershipUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, void>> call({
    required UuidValue workspaceId,
    required UuidValue newOwnerId,
  }) async {
    return await _repository.transferOwnership(workspaceId, newOwnerId);
  }
}
