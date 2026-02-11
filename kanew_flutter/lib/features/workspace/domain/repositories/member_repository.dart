import 'package:dartz/dartz.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/error/failures.dart';

abstract class MemberRepository {
  Future<Either<Failure, List<MemberWithUser>>> getMembers(UuidValue workspaceId);

  Future<Either<Failure, void>> removeMember(UuidValue memberId);

  Future<Either<Failure, WorkspaceMember>> updateMemberRole(
    UuidValue memberId,
    MemberRole role,
  );

  Future<Either<Failure, List<PermissionInfo>>> getMemberPermissions(
    UuidValue memberId,
  );

  Future<Either<Failure, void>> updateMemberPermissions(
    UuidValue memberId,
    List<UuidValue> permissionIds,
  );

  Future<Either<Failure, void>> transferOwnership(
    UuidValue workspaceId,
    UuidValue newOwnerId,
  );

  Future<Either<Failure, WorkspaceInvite>> createInvite(
    UuidValue workspaceId,
    List<UuidValue> permissionIds, {
    String? email,
  });

  Future<Either<Failure, List<WorkspaceInvite>>> getInvites(UuidValue workspaceId);

  Future<Either<Failure, void>> revokeInvite(UuidValue inviteId);

  Future<Either<Failure, InviteDetails?>> getInviteByCode(String code);

  Future<Either<Failure, AcceptInviteResult>> acceptInvite(String code);

  Future<Either<Failure, List<Permission>>> getAllPermissions();
}
