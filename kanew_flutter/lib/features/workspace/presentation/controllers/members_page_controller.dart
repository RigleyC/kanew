import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/workspace_repository.dart';
import '../../domain/repositories/member_repository.dart';

/// Controller for Members Page
class MembersPageController extends ChangeNotifier {
  final MemberRepository _repository;
  final WorkspaceRepository _workspaceRepository;

  UuidValue? _workspaceId;
  String? _initError;

  MembersPageController({
    required MemberRepository repository,
    required WorkspaceRepository workspaceRepository,
  })  : _repository = repository,
        _workspaceRepository = workspaceRepository;

  // State
  List<MemberWithUser> _members = [];
  List<WorkspaceInvite> _invites = [];
  List<Permission> _allPermissions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MemberWithUser> get members => _members;
  List<WorkspaceInvite> get invites => _invites;
  List<Permission> get allPermissions => _allPermissions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UuidValue? get workspaceId => _workspaceId;
  String? get initError => _initError;
  bool get isInitialized => _workspaceId != null && _initError == null;

  /// Initializes the controller by loading workspace and member data
  Future<bool> init(String workspaceSlug) async {
    _initError = null;
    notifyListeners();

    try {
      final existing = _workspaceRepository
          .getWorkspaces()
          .then((list) => list.where((w) => w.slug == workspaceSlug).firstOrNull);

      Workspace? workspace = await existing;

      workspace ??= await _workspaceRepository.getBySlug(workspaceSlug);

      if (workspace == null) {
        _initError = 'Workspace não encontrado';
        notifyListeners();
        return false;
      }

      _workspaceId = workspace.id;
      await loadData(workspace.id!);
      return true;
    } catch (e) {
      _initError = 'Erro ao carregar workspace: $e';
      notifyListeners();
      return false;
    }
  }

  /// Loads members and invites for a workspace
  Future<void> loadData(UuidValue workspaceId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Load all permissions (only once)
    if (_allPermissions.isEmpty) {
      final permissionsResult = await _repository.getAllPermissions();
      permissionsResult.fold(
        (failure) => _error = failure.message,
        (data) => _allPermissions = data,
      );
    }

    // Load members
    final membersResult = await _repository.getMembers(workspaceId);
    membersResult.fold(
      (failure) => _error = failure.message,
      (data) => _members = data,
    );

    // Load invites
    final invitesResult = await _repository.getInvites(workspaceId);
    invitesResult.fold(
      (failure) => _error = failure.message,
      (data) => _invites = data,
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Removes a member
  Future<bool> removeMember(UuidValue memberId) async {
    final result = await _repository.removeMember(memberId);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _members.removeWhere((m) => m.member.id == memberId);
        notifyListeners();
        return true;
      },
    );
  }

  /// Updates member role
  Future<bool> updateMemberRole(UuidValue memberId, MemberRole newRole) async {
    final result = await _repository.updateMemberRole(memberId, newRole);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (updated) {
        final index = _members.indexWhere((m) => m.member.id == memberId);
        if (index != -1) {
          _members[index] = _members[index].copyWith(
            member: updated,
          );
        }
        notifyListeners();
        return true;
      },
    );
  }

  /// Gets permissions for a member
  Future<List<PermissionInfo>?> getMemberPermissions(UuidValue memberId) async {
    final result = await _repository.getMemberPermissions(memberId);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
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
    final result = await _repository.updateMemberPermissions(
      memberId,
      permissionIds,
    );

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  /// Transfers ownership
  Future<bool> transferOwnership(UuidValue workspaceId, UuidValue newOwnerId) async {
    final result = await _repository.transferOwnership(
      workspaceId,
      newOwnerId,
    );

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
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
    final result = await _repository.createInvite(
      workspaceId,
      permissionIds,
      email: email,
    );

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return null;
      },
      (invite) {
        _invites.insert(0, invite);
        notifyListeners();
        return invite;
      },
    );
  }

  /// Revokes an invite
  Future<bool> revokeInvite(UuidValue inviteId) async {
    final result = await _repository.revokeInvite(inviteId);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _invites.removeWhere((inv) => inv.id == inviteId);
        notifyListeners();
        return true;
      },
    );
  }

  /// Clears error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
