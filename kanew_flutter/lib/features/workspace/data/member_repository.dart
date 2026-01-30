import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/failures.dart';

/// Repository for workspace member operations
class MemberRepository {
  final Client _client;

  MemberRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all members of a workspace
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

  /// Removes a member from workspace
  Future<Either<Failure, void>> removeMember(int memberId) async {
    try {
      await _client.member.removeMember(memberId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Updates member role
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

  /// Gets member permissions with granted status
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

  /// Updates member permissions
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

  /// Transfers workspace ownership
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

  // ============ INVITE METHODS ============

  /// Creates a new workspace invite
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

  /// Gets all pending invites for workspace
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

  /// Revokes an invite
  Future<Either<Failure, void>> revokeInvite(int inviteId) async {
    try {
      await _client.invite.revokeInvite(inviteId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Gets invite by code (public, no auth required)
  Future<Either<Failure, WorkspaceInvite?>> getInviteByCode(
    String code,
  ) async {
    try {
      final invite = await _client.invite.getInviteByCode(code);
      return Right(invite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Accepts an invite and joins workspace
  Future<Either<Failure, WorkspaceMember>> acceptInvite(String code) async {
    try {
      final member = await _client.invite.acceptInvite(code);
      return Right(member);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Gets all available permissions in the system
  Future<Either<Failure, List<Permission>>> getAllPermissions() async {
    try {
      final permissions = await _client.member.getAllPermissions();
      return Right(permissions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
