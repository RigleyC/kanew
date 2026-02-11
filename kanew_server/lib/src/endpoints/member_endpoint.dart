import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../services/user_service.dart';

/// Endpoint for managing workspace members
class MemberEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Gets all members of a workspace with UserInfo details
  Future<List<MemberWithUser>> getMembers(
    Session session,
    UuidValue workspaceId,
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

    session.log('[MemberEndpoint.getMembers] Found ${members.length} members in workspace $workspaceId');

    // Get UserInfo for each member using UserService
    final result = <MemberWithUser>[];

    for (final member in members) {
      session.log('[MemberEndpoint.getMembers] Processing member ${member.id} with authUserId ${member.authUserId}');
      final userInfo = await UserService.getUserInfo(session, member.authUserId);

      session.log('[MemberEndpoint.getMembers] UserInfo for ${member.authUserId}: $userInfo');

      result.add(
        MemberWithUser(
          member: member,
          userName: userInfo['displayName']!,
          userEmail: userInfo['email']!,
          userImageUrl: null,
        ),
      );
    }

    session.log('[MemberEndpoint.getMembers] Returning ${result.length} members');
    return result;
  }

  /// Removes a member from workspace (soft delete)
  Future<void> removeMember(Session session, UuidValue memberId) async {
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

    // Delete all permissions before soft delete
    await MemberPermission.db.deleteWhere(
      session,
      where: (mp) => mp.workspaceMemberId.equals(memberId),
    );

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
    UuidValue memberId,
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

    // Reset overrides when changing role
    await MemberPermission.db.deleteWhere(
      session,
      where: (mp) => mp.workspaceMemberId.equals(memberId),
    );

    final updated = member.copyWith(role: newRole);
    final result = await WorkspaceMember.db.updateRow(session, updated);

    session.log(
      '[MemberEndpoint] Updated member ${member.id} role to ${newRole.name}',
    );

    return result;
  }

  /// Gets all permissions for a member with granted status and metadata.
  Future<List<PermissionInfo>> getMemberPermissions(
    Session session,
    UuidValue memberId,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

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

    return PermissionService.getEffectivePermissions(session, memberId);
  }

  /// Updates member permissions.
  ///
  /// The client sends the final set of granted permission ids. The server
  /// calculates role defaults ± overrides and persists only the overrides.
  Future<void> updateMemberPermissions(
    Session session,
    UuidValue memberId,
    List<UuidValue> grantedPermissionIds,
  ) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null || member.deletedAt != null) {
      throw Exception('Member not found');
    }

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

    if (member.role == MemberRole.owner) {
      throw Exception('Cannot change owner permissions');
    }

    await PermissionService.applyPermissionOverrides(
      session,
      workspaceMemberId: memberId,
      role: member.role,
      grantedPermissionIds: grantedPermissionIds,
    );

    session.log(
      '[MemberEndpoint] Updated permissions for member $memberId: granted=${grantedPermissionIds.length}',
    );
  }

  /// Transfers workspace ownership to another member
  Future<void> transferOwnership(
    Session session,
    UuidValue workspaceId,
    UuidValue newOwnerId,
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

    // Update current owner to admin and clear their explicit permissions
    // (admin has permissions by default)
    final downgraded = currentOwnerMember.copyWith(role: MemberRole.admin);
    await WorkspaceMember.db.updateRow(session, downgraded);

    // Delete all permissions from the old owner (now admin)
    await MemberPermission.db.deleteWhere(
      session,
      where: (mp) => mp.workspaceMemberId.equals(currentOwnerMember.id!),
    );

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
