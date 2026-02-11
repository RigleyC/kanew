import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

/// UseCase to get all available permissions
class GetAllPermissionsUseCase {
  final MemberRepository _repository;
  
  GetAllPermissionsUseCase({required MemberRepository repository})
      : _repository = repository;
  
  Future<Either<Failure, List<Permission>>> call() async {
    return await _repository.getAllPermissions();
  }
}
