import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../errors/http_exceptions.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';

/// Endpoint for managing workspace invites
class InviteEndpoint extends Endpoint {
  /// Creates a new workspace invite
  /// Requires 'workspace.invite' permission
  Future<WorkspaceInvite> createInvite(
    Session session,
    UuidValue workspaceId,
    List<UuidValue> permissionIds, {
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
      throw ForbiddenException(message: 'User does not have permission to create invites');
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
      throw ForbiddenException(message: 'User does not have permission to read invites');
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
  Future<void> revokeInvite(Session session, UuidValue inviteId) async {
    final userId = AuthHelper.getAuthenticatedUserId(session);

    final invite = await WorkspaceInvite.db.findById(session, inviteId);

    if (invite == null) {
      throw NotFoundException(message: 'Invite not found');
    }

    // Check permission
    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: userId,
      workspaceId: invite.workspaceId,
      permissionSlug: 'workspace.invite',
    );

    if (!hasPermission) {
      throw ForbiddenException(message: 'User does not have permission to revoke invites');
    }

    if (invite.acceptedAt != null) {
      throw BadRequestException(message: 'Cannot revoke accepted invite');
    }

    if (invite.revokedAt != null) {
      throw BadRequestException(message: 'Invite already revoked');
    }

    final updated = invite.copyWith(revokedAt: DateTime.now());
    await WorkspaceInvite.db.updateRow(session, updated);

    session.log('[InviteEndpoint] Revoked invite ${invite.code}');
  }

  /// Gets invite by code (public - no auth required for validation)
  Future<InviteDetails?> getInviteByCode(
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

    // Fetch workspace details
    final workspace = await Workspace.db.findById(session, invite.workspaceId);
    if (workspace == null) {
      return null;
    }

    return InviteDetails(
      invite: invite,
      workspaceName: workspace.title,
      workspaceSlug: workspace.slug,
    );
  }

  /// Accepts an invite and joins workspace
  /// Requires authentication
  Future<AcceptInviteResult> acceptInvite(Session session, String code) async {
    if (!session.isUserSignedIn) {
      throw UnauthorizedException(message: 'User must be signed in to accept invite');
    }

    final userId = AuthHelper.getAuthenticatedUserId(session);

    final invite = await WorkspaceInvite.db.findFirstRow(
      session,
      where: (inv) => inv.code.equals(code),
    );

    if (invite == null) {
      throw NotFoundException(message: 'Invite not found');
    }

    if (invite.acceptedAt != null) {
      throw BadRequestException(message: 'Invite already accepted');
    }

    if (invite.revokedAt != null) {
      throw BadRequestException(message: 'Invite has been revoked');
    }

    // Check if already member
    final existingMember = await WorkspaceMember.db.findFirstRow(
      session,
      where: (m) =>
          m.authUserId.equals(userId) &
          m.workspaceId.equals(invite.workspaceId) &
          m.deletedAt.equals(null),
    );

    WorkspaceMember member;

    if (existingMember != null) {
      // Mark invite as accepted anyway
      final updated = invite.copyWith(acceptedAt: DateTime.now());
      await WorkspaceInvite.db.updateRow(session, updated);

      member = existingMember;
    } else {
      // Create new member with guest role
      final newMember = WorkspaceMember(
        authUserId: userId,
        workspaceId: invite.workspaceId,
        role: MemberRole.guest,
        status: MemberStatus.active,
        joinedAt: DateTime.now(),
      );

      member = await WorkspaceMember.db.insertRow(session, newMember);

      // Apply permission overrides based on invite's initial permissions
      await PermissionService.applyPermissionOverrides(
        session,
        workspaceMemberId: member.id!,
        role: MemberRole.guest,
        grantedPermissionIds: invite.initialPermissions,
      );

      // Mark invite as accepted
      final updated = invite.copyWith(acceptedAt: DateTime.now());
      await WorkspaceInvite.db.updateRow(session, updated);

      session.log(
        '[InviteEndpoint] User $userId accepted invite ${invite.code} and joined workspace ${invite.workspaceId}',
      );
    }

    // Fetch workspace slug
    final workspace = await Workspace.db.findById(session, invite.workspaceId);

    return AcceptInviteResult(
      member: member,
      workspaceSlug: workspace?.slug ?? '',
    );
  }
}

