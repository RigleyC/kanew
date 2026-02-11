import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/workspace_repository.dart';
import '../../domain/usecases/get_members_usecase.dart';
import '../../domain/usecases/remove_member_usecase.dart';
import '../../domain/usecases/update_member_role_usecase.dart';
import '../../domain/usecases/get_member_permissions_usecase.dart';
import '../../domain/usecases/update_member_permissions_usecase.dart';
import '../../domain/usecases/transfer_ownership_usecase.dart';
import '../../domain/usecases/create_invite_usecase.dart';
import '../../domain/usecases/get_invites_usecase.dart';
import '../../domain/usecases/revoke_invite_usecase.dart';
import '../../domain/usecases/get_all_permissions_usecase.dart';
import '../states/members_state.dart';
import '../stores/members_store.dart';

/// Controller for Members management following AGENTS.md pattern
class MembersController extends ChangeNotifier {
  final GetMembersUseCase _getMembersUseCase;
  final RemoveMemberUseCase _removeMemberUseCase;
  final UpdateMemberRoleUseCase _updateMemberRoleUseCase;
  final GetMemberPermissionsUseCase _getMemberPermissionsUseCase;
  final UpdateMemberPermissionsUseCase _updateMemberPermissionsUseCase;
  final TransferOwnershipUseCase _transferOwnershipUseCase;
  final CreateInviteUseCase _createInviteUseCase;
  final GetInvitesUseCase _getInvitesUseCase;
  final RevokeInviteUseCase _revokeInviteUseCase;
  final GetAllPermissionsUseCase _getAllPermissionsUseCase;
  final WorkspaceRepository _workspaceRepository;
  final MembersStore _store;

  UuidValue? _workspaceId;
  String? _initError;

  MembersController({
    required GetMembersUseCase getMembersUseCase,
    required RemoveMemberUseCase removeMemberUseCase,
    required UpdateMemberRoleUseCase updateMemberRoleUseCase,
    required GetMemberPermissionsUseCase getMemberPermissionsUseCase,
    required UpdateMemberPermissionsUseCase updateMemberPermissionsUseCase,
    required TransferOwnershipUseCase transferOwnershipUseCase,
    required CreateInviteUseCase createInviteUseCase,
    required GetInvitesUseCase getInvitesUseCase,
    required RevokeInviteUseCase revokeInviteUseCase,
    required GetAllPermissionsUseCase getAllPermissionsUseCase,
    required WorkspaceRepository workspaceRepository,
    required MembersStore store,
  })  : _getMembersUseCase = getMembersUseCase,
        _removeMemberUseCase = removeMemberUseCase,
        _updateMemberRoleUseCase = updateMemberRoleUseCase,
        _getMemberPermissionsUseCase = getMemberPermissionsUseCase,
        _updateMemberPermissionsUseCase = updateMemberPermissionsUseCase,
        _transferOwnershipUseCase = transferOwnershipUseCase,
        _createInviteUseCase = createInviteUseCase,
        _getInvitesUseCase = getInvitesUseCase,
        _revokeInviteUseCase = revokeInviteUseCase,
        _getAllPermissionsUseCase = getAllPermissionsUseCase,
        _workspaceRepository = workspaceRepository,
        _store = store;

  MembersStore get store => _store;
  MembersState get state => _store.value;
  UuidValue? get workspaceId => _workspaceId;
  String? get initError => _initError;
  bool get isInitialized => _workspaceId != null && _initError == null;

  /// Initializes the controller by loading workspace and member data
  Future<bool> init(String workspaceSlug) async {
    _initError = null;
    _store.value = const MembersLoading();

    try {
      final existing = _workspaceRepository
          .getWorkspaces()
          .then((list) => list.where((w) => w.slug == workspaceSlug).firstOrNull);

      Workspace? workspace = await existing;
      workspace ??= await _workspaceRepository.getBySlug(workspaceSlug);

      if (workspace == null) {
        _initError = 'Workspace não encontrado';
        _store.value = MembersError(_initError!);
        return false;
      }

      _workspaceId = workspace.id;
      await loadData(workspace.id!);
      return true;
    } catch (e) {
      _initError = 'Erro ao carregar workspace: $e';
      _store.value = MembersError(_initError!);
      return false;
    }
  }

  /// Loads members and invites for a workspace
  Future<void> loadData(UuidValue workspaceId) async {
    _store.value = const MembersLoading();

    List<Permission> allPermissions = [];
    List<MemberWithUser> members = [];
    List<WorkspaceInvite> invites = [];
    String? errorMessage;

    // Load all permissions
    final permissionsResult = await _getAllPermissionsUseCase();
    permissionsResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => allPermissions = data,
    );

    // Load members
    final membersResult = await _getMembersUseCase(workspaceId);
    membersResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => members = data,
    );

    // Load invites
    final invitesResult = await _getInvitesUseCase(workspaceId);
    invitesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => invites = data,
    );

    if (errorMessage != null) {
      _store.value = MembersError(errorMessage!);
    } else {
      _store.value = MembersLoaded(
        members: members,
        invites: invites,
        allPermissions: allPermissions,
      );
    }
  }

  /// Removes a member
  Future<bool> removeMember(UuidValue memberId) async {
    final result = await _removeMemberUseCase(memberId);

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return false;
      },
      (_) {
        if (_store.value is MembersLoaded) {
          final current = _store.value as MembersLoaded;
          final updatedMembers = current.members
              .where((m) => m.member.id != memberId)
              .toList();
          _store.value = MembersLoaded(
            members: updatedMembers,
            invites: current.invites,
            allPermissions: current.allPermissions,
          );
        }
        return true;
      },
    );
  }

  /// Updates member role
  Future<bool> updateMemberRole(UuidValue memberId, MemberRole newRole) async {
    final result = await _updateMemberRoleUseCase(
      memberId: memberId,
      role: newRole,
    );

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return false;
      },
      (updated) {
        if (_store.value is MembersLoaded) {
          final current = _store.value as MembersLoaded;
          final updatedMembers = current.members.map((m) {
            if (m.member.id == memberId) {
              return m.copyWith(member: updated);
            }
            return m;
          }).toList();
          _store.value = MembersLoaded(
            members: updatedMembers,
            invites: current.invites,
            allPermissions: current.allPermissions,
          );
        }
        return true;
      },
    );
  }

  /// Gets permissions for a member
  Future<List<PermissionInfo>?> getMemberPermissions(UuidValue memberId) async {
    final result = await _getMemberPermissionsUseCase(memberId);

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return null;
      },
      (permissions) => permissions,
    );
  }

  /// Updates member permissions
  Future<bool> updateMemberPermissions(
    UuidValue memberId,
    List<UuidValue> permissionIds,
  ) async {
    final result = await _updateMemberPermissionsUseCase(
      memberId: memberId,
      permissionIds: permissionIds,
    );

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return false;
      },
      (_) => true,
    );
  }

  /// Transfers ownership
  Future<bool> transferOwnership(UuidValue workspaceId, UuidValue newOwnerId) async {
    final result = await _transferOwnershipUseCase(
      workspaceId: workspaceId,
      newOwnerId: newOwnerId,
    );

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return false;
      },
      (_) {
        loadData(workspaceId);
        return true;
      },
    );
  }

  /// Creates an invite
  Future<WorkspaceInvite?> createInvite(
    UuidValue workspaceId,
    List<UuidValue> permissionIds, {
    String? email,
  }) async {
    final result = await _createInviteUseCase(
      workspaceId: workspaceId,
      permissionIds: permissionIds,
      email: email,
    );

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return null;
      },
      (invite) {
        if (_store.value is MembersLoaded) {
          final current = _store.value as MembersLoaded;
          final updatedInvites = [invite, ...current.invites];
          _store.value = MembersLoaded(
            members: current.members,
            invites: updatedInvites,
            allPermissions: current.allPermissions,
          );
        }
        return invite;
      },
    );
  }

  /// Revokes an invite
  Future<bool> revokeInvite(UuidValue inviteId) async {
    final result = await _revokeInviteUseCase(inviteId);

    return result.fold(
      (failure) {
        _store.value = MembersError(failure.message);
        return false;
      },
      (_) {
        if (_store.value is MembersLoaded) {
          final current = _store.value as MembersLoaded;
          final updatedInvites = current.invites
              .where((inv) => inv.id != inviteId)
              .toList();
          _store.value = MembersLoaded(
            members: current.members,
            invites: updatedInvites,
            allPermissions: current.allPermissions,
          );
        }
        return true;
      },
    );
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }
}
