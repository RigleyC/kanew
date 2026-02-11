import 'package:flutter_test/flutter_test.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/features/workspace/presentation/controllers/members_controller.dart';
import 'package:kanew_flutter/features/workspace/presentation/stores/members_store.dart';
import 'package:kanew_flutter/features/workspace/presentation/states/members_state.dart';
import 'package:kanew_flutter/features/workspace/domain/repositories/member_repository.dart';
import 'package:kanew_flutter/features/workspace/data/workspace_repository.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/get_members_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/remove_member_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/update_member_role_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/get_member_permissions_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/update_member_permissions_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/transfer_ownership_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/create_invite_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/get_invites_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/revoke_invite_usecase.dart';
import 'package:kanew_flutter/features/workspace/domain/usecases/get_all_permissions_usecase.dart';
import 'package:kanew_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('MembersController', () {
    late MembersController controller;
    late MembersStore store;
    late _MockMemberRepository mockMemberRepository;
    late _MockWorkspaceRepository mockWorkspaceRepository;

    setUp(() {
      mockMemberRepository = _MockMemberRepository();
      mockWorkspaceRepository = _MockWorkspaceRepository();
      store = MembersStore();
      
      controller = MembersController(
        getMembersUseCase: GetMembersUseCase(repository: mockMemberRepository),
        removeMemberUseCase: RemoveMemberUseCase(repository: mockMemberRepository),
        updateMemberRoleUseCase: UpdateMemberRoleUseCase(repository: mockMemberRepository),
        getMemberPermissionsUseCase: GetMemberPermissionsUseCase(repository: mockMemberRepository),
        updateMemberPermissionsUseCase: UpdateMemberPermissionsUseCase(repository: mockMemberRepository),
        transferOwnershipUseCase: TransferOwnershipUseCase(repository: mockMemberRepository),
        createInviteUseCase: CreateInviteUseCase(repository: mockMemberRepository),
        getInvitesUseCase: GetInvitesUseCase(repository: mockMemberRepository),
        revokeInviteUseCase: RevokeInviteUseCase(repository: mockMemberRepository),
        getAllPermissionsUseCase: GetAllPermissionsUseCase(repository: mockMemberRepository),
        workspaceRepository: mockWorkspaceRepository,
        store: store,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with correct default state', () {
      // Assert
      expect(controller.state, isA<MembersInitial>());
      expect(controller.workspaceId, null);
      expect(controller.initError, null);
      expect(controller.isInitialized, false);
    });

    test('should have store accessible', () {
      // Assert
      expect(controller.store, isA<MembersStore>());
    });
  });
}

class _MockMemberRepository implements MemberRepository {
  @override
  Future<Either<Failure, List<MemberWithUser>>> getMembers(UuidValue workspaceId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> removeMember(UuidValue memberId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkspaceMember>> updateMemberRole(UuidValue memberId, MemberRole role) async {
    return Right(WorkspaceMember(
      id: memberId,
      authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      workspaceId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      role: role,
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    ));
  }

  @override
  Future<Either<Failure, List<PermissionInfo>>> getMemberPermissions(UuidValue memberId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> updateMemberPermissions(
    UuidValue memberId,
    List<UuidValue> permissionIds,
  ) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> transferOwnership(UuidValue workspaceId, UuidValue newOwnerId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkspaceInvite>> createInvite(UuidValue workspaceId, List<UuidValue> permissionIds, {String? email}) async {
    return Right(WorkspaceInvite(
      id: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
      workspaceId: workspaceId,
      code: 'test123',
      createdBy: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      createdAt: DateTime.now(),
      initialPermissions: permissionIds,
      email: email,
    ));
  }

  @override
  Future<Either<Failure, List<WorkspaceInvite>>> getInvites(UuidValue workspaceId) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> revokeInvite(UuidValue inviteId) async {
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
        id: UuidValue.fromString('00000000-0000-0000-0000-000000000003'),
        authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        workspaceId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
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
    return Workspace(
      id: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
      title: title,
      slug: slug ?? 'test-workspace',
      ownerId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<Workspace> updateWorkspace(UuidValue workspaceId, String title, {String? slug}) async {
    return Workspace(
      id: workspaceId,
      title: title,
      slug: slug ?? 'test-workspace',
      ownerId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteWorkspace(UuidValue workspaceId) async {}
}
