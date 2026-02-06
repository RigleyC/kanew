import 'package:flutter_test/flutter_test.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/features/workspace/presentation/controllers/members_page_controller.dart';
import 'package:kanew_flutter/features/workspace/domain/repositories/member_repository.dart';
import 'package:kanew_flutter/features/workspace/data/workspace_repository.dart';
import 'package:kanew_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('MembersPageController', () {
    test('should initialize with correct default state', () {
      // Arrange
      final mockMemberRepository = _MockMemberRepository();
      final mockWorkspaceRepository = _MockWorkspaceRepository();
      final controller = MembersPageController(
        repository: mockMemberRepository,
        workspaceRepository: mockWorkspaceRepository,
      );

      // Assert
      expect(controller.isLoading, false);
      expect(controller.error, null);
      expect(controller.members, isEmpty);
      expect(controller.invites, isEmpty);
      expect(controller.allPermissions, isEmpty);
      expect(controller.workspaceId, null);
      expect(controller.initError, null);
      expect(controller.isInitialized, false);

      // Cleanup
      controller.dispose();
    });

    test('should clear error when clearError is called', () {
      // Arrange
      final mockMemberRepository = _MockMemberRepository();
      final mockWorkspaceRepository = _MockWorkspaceRepository();
      final controller = MembersPageController(
        repository: mockMemberRepository,
        workspaceRepository: mockWorkspaceRepository,
      );

      // Act
      controller.clearError();

      // Assert
      expect(controller.error, null);

      // Cleanup
      controller.dispose();
    });
  });
}

class _MockMemberRepository implements MemberRepository {
  @override
  Future<Either<Failure, List<MemberWithUser>>> getMembers(int workspaceId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> removeMember(int memberId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkspaceMember>> updateMemberRole(int memberId, MemberRole role) async {
    return Right(WorkspaceMember(
      id: memberId,
      authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      workspaceId: 1,
      role: role,
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    ));
  }

  @override
  Future<Either<Failure, List<PermissionInfo>>> getMemberPermissions(int memberId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> updateMemberPermissions(int memberId, List<int> permissionIds) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> transferOwnership(int workspaceId, int newOwnerId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkspaceInvite>> createInvite(int workspaceId, List<int> permissionIds, {String? email}) async {
    return Right(WorkspaceInvite(
      id: 1,
      workspaceId: workspaceId,
      code: 'test123',
      createdBy: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      createdAt: DateTime.now(),
      initialPermissions: permissionIds,
      email: email,
    ));
  }

  @override
  Future<Either<Failure, List<WorkspaceInvite>>> getInvites(int workspaceId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> revokeInvite(int inviteId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, InviteDetails?>> getInviteByCode(String code) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, AcceptInviteResult>> acceptInvite(String code) async {
    return Right(AcceptInviteResult(
      member: WorkspaceMember(
        id: 1,
        authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        workspaceId: 1,
        role: MemberRole.member,
        status: MemberStatus.active,
        joinedAt: DateTime.now(),
      ),
      workspaceSlug: 'test-workspace',
    ));
  }

  @override
  Future<Either<Failure, List<Permission>>> getAllPermissions() async {
    return const Right([]);
  }
}

class _MockWorkspaceRepository implements WorkspaceRepository {
  @override
  Future<List<Workspace>> getWorkspaces() async {
    return [];
  }

  @override
  Future<Workspace?> getBySlug(String slug) async {
    return null;
  }

  @override
  Future<Workspace> createWorkspace(String title, {String? slug}) async {
    throw UnimplementedError();
  }

  @override
  Future<Workspace> updateWorkspace(int workspaceId, String title, {String? slug}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWorkspace(int workspaceId) async {
    throw UnimplementedError();
  }
}
