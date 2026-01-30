import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';

/// Endpoint for managing workspace invites
class InviteEndpoint extends Endpoint {
  /// Creates a new workspace invite
  /// Requires 'workspace.invite' permission
  Future<WorkspaceInvite> createInvite(
    Session session,
    int workspaceId,
    List<int> permissionIds, {
    String? email,
  }) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: workspaceId,
      permissionSlug: 'workspace.invite',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to create invites');
    }

    // Validate permissions exist
    for (final permId in permissionIds) {
      final perm = await Permission.db.findById(session, permId);
      if (perm == null) {
        throw Exception('Invalid permission ID: $permId');
      }
    }

    // Generate unique invite code
    final code = const Uuid().v4();

    final invite = WorkspaceInvite(
      email: email,
      code: code,
      workspaceId: workspaceId,
      createdBy: userId,
      initialPermissions: permissionIds,
      createdAt: DateTime.now(),
    );

    final created = await WorkspaceInvite.db.insertRow(session, invite);

    session.log(
      '[InviteEndpoint] Created invite ${created.code} for workspace $workspaceId',
    );

    return created;
  }

  /// Gets all pending invites for a workspace
  Future<List<WorkspaceInvite>> getInvites(
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
      throw Exception('User does not have permission to read invites');
    }

    final invites = await WorkspaceInvite.db.find(
      session,
      where: (inv) =>
          inv.workspaceId.equals(workspaceId) &
          inv.acceptedAt.equals(null) &
          inv.revokedAt.equals(null),
      orderBy: (inv) => inv.createdAt,
      orderDescending: true,
    );

    return invites;
  }

  /// Revokes an invite
  Future<void> revokeInvite(Session session, int inviteId) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final invite = await WorkspaceInvite.db.findById(session, inviteId);

    if (invite == null) {
      throw Exception('Invite not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: invite.workspaceId,
      permissionSlug: 'workspace.invite',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to revoke invites');
    }

    if (invite.acceptedAt != null) {
      throw Exception('Cannot revoke accepted invite');
    }

    if (invite.revokedAt != null) {
      throw Exception('Invite already revoked');
    }

    final updated = invite.copyWith(revokedAt: DateTime.now());
    await WorkspaceInvite.db.updateRow(session, updated);

    session.log('[InviteEndpoint] Revoked invite ${invite.code}');
  }

  /// Gets invite by code (public - no auth required for validation)
  Future<WorkspaceInvite?> getInviteByCode(
    Session session,
    String code,
  ) async {
    final invite = await WorkspaceInvite.db.findFirstRow(
      session,
      where: (inv) => inv.code.equals(code),
    );

    if (invite == null) {
      return null;
    }

    // Check if valid
    if (invite.acceptedAt != null || invite.revokedAt != null) {
      return null;
    }

    return invite;
  }

  /// Accepts an invite and joins workspace
  /// Requires authentication
  Future<WorkspaceMember> acceptInvite(Session session, String code) async {
    if (!session.isUserSignedIn) {
      throw Exception('User must be signed in to accept invite');
    }

    final userId = AuthHelper.getAuthenticatedUserId(session);

    final invite = await WorkspaceInvite.db.findFirstRow(
      session,
      where: (inv) => inv.code.equals(code),
    );

    if (invite == null) {
      throw Exception('Invite not found');
    }

    if (invite.acceptedAt != null) {
      throw Exception('Invite already accepted');
    }

    if (invite.revokedAt != null) {
      throw Exception('Invite has been revoked');
    }

    // Check if already member
    final existingMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (m) =>
          m.userInfoId.equals(userId) &
          m.workspaceId.equals(invite.workspaceId) &
          m.deletedAt.equals(null),
    );

    if (existingMember != null) {
      // Mark invite as accepted anyway
      final updated = invite.copyWith(acceptedAt: DateTime.now());
      await WorkspaceInvite.db.updateRow(session, updated);

      // Return existing member
      return existingMember;
    }

    // Create new member
    final member = WorkspaceMember(
      userInfoId: userId,
      workspaceId: invite.workspaceId,
      role: MemberRole.member,
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    );

    final createdMember = await WorkspaceMember.db.insertRow(session, member);

    // Grant permissions from invite
    for (final permissionId in invite.initialPermissions) {
      await MemberPermission.db.insertRow(
        session,
        MemberPermission(
          workspaceMemberId: createdMember.id!,
          permissionId: permissionId,
        ),
      );
    }

    // Mark invite as accepted
    final updated = invite.copyWith(acceptedAt: DateTime.now());
    await WorkspaceInvite.db.updateRow(session, updated);

    session.log(
      '[InviteEndpoint] User $userId accepted invite ${invite.code} and joined workspace ${invite.workspaceId}',
    );

    return createdMember;
  }
}
