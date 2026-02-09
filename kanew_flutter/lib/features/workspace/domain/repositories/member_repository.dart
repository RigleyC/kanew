import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';

abstract class MemberRepository {
  Future<Either<Failure, List<MemberWithUser>>> getMembers(int workspaceId);

  Future<Either<Failure, void>> removeMember(int memberId);

  Future<Either<Failure, WorkspaceMember>> updateMemberRole(
    int memberId,
    MemberRole role,
  );

  Future<Either<Failure, List<PermissionInfo>>> getMemberPermissions(
    int memberId,
  );

  Future<Either<Failure, void>> updateMemberPermissions(
    int memberId,
    List<int> permissionIds,
  );

  Future<Either<Failure, void>> transferOwnership(
    int workspaceId,
    int newOwnerId,
  );

  Future<Either<Failure, WorkspaceInvite>> createInvite(
    int workspaceId,
    List<int> permissionIds, {
    String? email,
  });

  Future<Either<Failure, List<WorkspaceInvite>>> getInvites(int workspaceId);

  Future<Either<Failure, void>> revokeInvite(int inviteId);

  Future<Either<Failure, InviteDetails?>> getInviteByCode(String code);

  Future<Either<Failure, AcceptInviteResult>> acceptInvite(String code);

  Future<Either<Failure, List<Permission>>> getAllPermissions();
}
