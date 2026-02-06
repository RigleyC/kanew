import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/member_repository.dart';

class MemberRepositoryImpl implements MemberRepository {
  final Client _client;

  MemberRepositoryImpl({Client? client}) : _client = client ?? getIt<Client>();

  @override
  Future<Either<Failure, List<MemberWithUser>>> getMembers(
    int workspaceId,
  ) async {
    try {
      final members = await _client.member.getMembers(workspaceId);
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMember(int memberId) async {
    try {
      await _client.member.removeMember(memberId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> updateMemberRole(
    int memberId,
    MemberRole role,
  ) async {
    try {
      final updated = await _client.member.updateMemberRole(memberId, role);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PermissionInfo>>> getMemberPermissions(
    int memberId,
  ) async {
    try {
      final permissions = await _client.member.getMemberPermissions(memberId);
      return Right(permissions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMemberPermissions(
    int memberId,
    List<int> permissionIds,
  ) async {
    try {
      await _client.member.updateMemberPermissions(memberId, permissionIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) async {
    try {
      await _client.member.transferOwnership(workspaceId, newOwnerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkspaceInvite>> createInvite(
    int workspaceId,
    List<int> permissionIds, {
    String? email,
  }) async {
    try {
      final invite = await _client.invite.createInvite(
        workspaceId,
        permissionIds,
        email: email,
      );
      return Right(invite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkspaceInvite>>> getInvites(
    int workspaceId,
  ) async {
    try {
      final invites = await _client.invite.getInvites(workspaceId);
      return Right(invites);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeInvite(int inviteId) async {
    try {
      await _client.invite.revokeInvite(inviteId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InviteDetails?>> getInviteByCode(String code) async {
    try {
      final details = await _client.invite.getInviteByCode(code);
      return Right(details);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcceptInviteResult>> acceptInvite(String code) async {
    try {
      final result = await _client.invite.acceptInvite(code);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getAllPermissions() async {
    try {
      final permissions = await _client.member.getAllPermissions();
      return Right(permissions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
