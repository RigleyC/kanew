import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';

/// Endpoint for managing workspace members
class MemberEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets all members of a workspace with UserInfo details
  Future<List<MemberWithUser>> getMembers(
    Session session,
    int workspaceId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspaceId,
      permissionSlug: 'workspace.read',
    );

    if (!hasPermission) {
      throw Exception(
        'User does not have permission to read workspace members',
      );
    }

    // Get all workspace members
    final members = await WorkspaceMember.db.find(
      session,
      where: (m) =>
          m.workspaceId.equals(workspaceId) & m.deletedAt.equals(null),
      orderBy: (m) => m.joinedAt,
    );

    // Get UserInfo for each member
    final result = <MemberWithUser>[];

    for (final member in members) {
      final userInfo = await Users.findUserByIdentifier(
        session,
        member.authUserId.toString(),
      );

      result.add(
        MemberWithUser(
          member: member,
          userName: userInfo?.userName ?? 'Usuario',
          userEmail: userInfo?.email ?? 'email@exemplo.com',
          userImageUrl: userInfo?.imageUrl,
        ),
      );
    }

    return result;
  }

  /// Removes a member from workspace (soft delete)
  Future<void> removeMember(Session session, int memberId) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: member.workspaceId,
      permissionSlug: 'workspace.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to remove members');
    }

    // Cannot remove owner
    if (member.role == MemberRole.owner) {
      throw Exception('Cannot remove workspace owner');
    }

    // Soft delete
    final updated = member.copyWith(
      deletedAt: DateTime.now(),
      deletedBy: userId,
    );

    await WorkspaceMember.db.updateRow(session, updated);

    session.log('[MemberEndpoint] Removed member ${member.id}');
  }

  /// Updates member role
  Future<WorkspaceMember> updateMemberRole(
    Session session,
    int memberId,
    MemberRole newRole,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: member.workspaceId,
      permissionSlug: 'workspace.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update member roles');
    }

    // Cannot change owner role
    if (member.role == MemberRole.owner) {
      throw Exception('Cannot change owner role');
    }

    final updated = member.copyWith(role: newRole);
    final result = await WorkspaceMember.db.updateRow(session, updated);

    session.log(
      '[MemberEndpoint] Updated member ${member.id} role to ${newRole.name}',
    );

    return result;
  }

  /// Gets all permissions for a member with granted status
  Future<List<PermissionInfo>> getMemberPermissions(
    Session session,
    int memberId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: member.workspaceId,
      permissionSlug: 'workspace.read',
    );

    if (!hasPermission) {
      throw Exception(
        'User does not have permission to read member permissions',
      );
    }

    // Get all permissions
    final allPermissions = await Permission.db.find(session);

    // Get member's granted permissions
    final memberPermissions = await MemberPermission.db.find(
      session,
      where: (mp) =>
          mp.workspaceMemberId.equals(memberId) & mp.scopeBoardId.equals(null),
    );

    final grantedPermissionIds = memberPermissions
        .map((mp) => mp.permissionId)
        .toSet();

    // Build result
    final result = allPermissions.map((permission) {
      return PermissionInfo(
        permission: permission,
        granted: grantedPermissionIds.contains(permission.id),
      );
    }).toList();

    return result;
  }

  /// Updates member permissions
  Future<void> updateMemberPermissions(
    Session session,
    int memberId,
    List<int> permissionIds,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: member.workspaceId,
      permissionSlug: 'workspace.update',
    );

    if (!hasPermission) {
      throw Exception(
        'User does not have permission to update member permissions',
      );
    }

    // Cannot change owner permissions
    if (member.role == MemberRole.owner) {
      throw Exception('Cannot change owner permissions');
    }

    // Delete all existing permissions (workspace-level only)
    final existing = await MemberPermission.db.find(
      session,
      where: (mp) =>
          mp.workspaceMemberId.equals(memberId) & mp.scopeBoardId.equals(null),
    );

    for (final perm in existing) {
      await MemberPermission.db.deleteRow(session, perm);
    }

    // Insert new permissions
    for (final permissionId in permissionIds) {
      await MemberPermission.db.insertRow(
        session,
        MemberPermission(
          workspaceMemberId: memberId,
          permissionId: permissionId,
        ),
      );
    }

    session.log(
      '[MemberEndpoint] Updated permissions for member $memberId: ${permissionIds.length} permissions',
    );
  }

  /// Transfers workspace ownership to another member
  Future<void> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final workspace = await Workspace.db.findById(session, workspaceId);

    if (workspace == null || workspace.deletedAt != null) {
      throw Exception('Workspace not found');
    }

    // Only current owner can transfer ownership
    if (workspace.ownerId != userId) {
      throw Exception('Only workspace owner can transfer ownership');
    }

    final newOwnerMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (m) =>
          m.id.equals(newOwnerId) &
          m.workspaceId.equals(workspaceId) &
          m.deletedAt.equals(null),
    );

    if (newOwnerMember == null) {
      throw Exception('New owner must be a workspace member');
    }

    final currentOwnerMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (m) =>
          m.authUserId.equals(userId) &
          m.workspaceId.equals(workspaceId) &
          m.deletedAt.equals(null),
    );

    if (currentOwnerMember == null) {
      throw Exception('Current owner member record not found');
    }

    // Update workspace ownerId
    final updatedWorkspace = workspace.copyWith(
      ownerId: newOwnerMember.authUserId,
    );
    await Workspace.db.updateRow(session, updatedWorkspace);

    // Update current owner to admin
    final downgraded = currentOwnerMember.copyWith(role: MemberRole.admin);
    await WorkspaceMember.db.updateRow(session, downgraded);

    // Update new owner role
    final upgraded = newOwnerMember.copyWith(role: MemberRole.owner);
    await WorkspaceMember.db.updateRow(session, upgraded);

    // Grant all permissions to new owner
    await PermissionService.grantAllPermissions(
      session,
      workspaceMemberId: newOwnerMember.id!,
    );

    session.log(
      '[MemberEndpoint] Transferred ownership of workspace $workspaceId from user $userId to user ${newOwnerMember.authUserId}',
    );
  }

  /// Gets all available permissions in the system
  Future<List<Permission>> getAllPermissions(Session session) async {
    // This endpoint requires authentication but no specific workspace permission
    // It's needed to populate the invite dialog with available permissions
    final permissions = await Permission.db.find(session);

    session.log('[MemberEndpoint] Retrieved ${permissions.length} permissions');
    return permissions;
  }
}
