import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Service for managing permissions in workspace
class PermissionService {
  /// Seeds all required permissions into database
  /// Called during initialization or migration
  static Future<void> seedPermissions(Session session) async {
    final permissions = [
      // Workspace permissions
      Permission(
        slug: 'workspace.read',
        description: 'Read workspace information',
      ),
      Permission(
        slug: 'workspace.invite',
        description: 'Invite users to workspace',
      ),
      Permission(
        slug: 'workspace.update',
        description: 'Update workspace settings',
      ),

      // Board permissions
      Permission(
        slug: 'board.read',
        description: 'Read boards in workspace',
      ),
      Permission(
        slug: 'board.create',
        description: 'Create new boards',
      ),
      Permission(
        slug: 'board.update',
        description: 'Update boards and lists',
      ),
      Permission(
        slug: 'board.delete',
        description: 'Delete boards',
      ),

      // Card permissions
      Permission(
        slug: 'card.read',
        description: 'Read cards',
      ),
      Permission(
        slug: 'card.create',
        description: 'Create new cards',
      ),
      Permission(
        slug: 'card.update',
        description: 'Update cards, move them, or change priority',
      ),
      Permission(
        slug: 'card.delete',
        description: 'Archive or delete cards',
      ),
    ];

    for (final permission in permissions) {
      final existing = await Permission.db.findFirstRow(
        session,
        where: (p) => p.slug.equals(permission.slug),
      );

      if (existing == null) {
        await Permission.db.insertRow(session, permission);
        session.log(
          '[PermissionService] Seeded permission: ${permission.slug}',
        );
      }
    }

    session.log(
      '[PermissionService] Permission seeding completed',
    );
  }

  /// Grants all permissions to a workspace member
  static Future<void> grantAllPermissions(
    Session session, {
    required int workspaceMemberId,
  }) async {
    final permissions = await Permission.db.find(session);

    for (final permission in permissions) {
      final existing = await MemberPermission.db.findFirstRow(
        session,
        where: (t) =>
            t.workspaceMemberId.equals(workspaceMemberId) &
            t.permissionId.equals(permission.id!) &
            t.scopeBoardId.equals(null),
      );

      if (existing == null) {
        await MemberPermission.db.insertRow(
          session,
          MemberPermission(
            workspaceMemberId: workspaceMemberId,
            permissionId: permission.id!,
          ),
        );
      }
    }
  }

  /// Checks if a member has a specific permission
  static Future<bool> hasPermission(
    Session session, {
    required int userId,
    required int workspaceId,
    required String permissionSlug,
    int? scopeBoardId,
  }) async {
    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.userInfoId.equals(userId) &
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null),
    );

    if (member == null) {
      return false;
    }

    final permission = await Permission.db.findFirstRow(
      session,
      where: (p) => p.slug.equals(permissionSlug),
    );

    if (permission == null) {
      return false;
    }

    final memberPermission = await MemberPermission.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceMemberId.equals(member.id!) &
          t.permissionId.equals(permission.id!) &
          (scopeBoardId != null
              ? t.scopeBoardId.equals(null)
              : (t.scopeBoardId.equals(scopeBoardId) |
                    t.scopeBoardId.equals(null))),
    );

    return memberPermission != null;
  }

  /// Gets all permissions for a user in a workspace
  static Future<List<String>> getUserPermissions(
    Session session, {
    required int userId,
    required int workspaceId,
  }) async {
    // First, find the workspace member
    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.userInfoId.equals(userId) &
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null),
    );

    if (member == null) {
      return [];
    }

    // Then, find all permissions for this member
    final memberPermissions = await MemberPermission.db.find(
      session,
      where: (t) => t.workspaceMemberId.equals(member.id!),
    );

    final permissionIds = memberPermissions.map((mp) => mp.permissionId).toSet();

    if (permissionIds.isEmpty) {
      return [];
    }

    final permissions = await Permission.db.find(
      session,
      where: (p) => p.id.inSet(permissionIds),
    );

    return permissions.map((p) => p.slug).toList();
  }
}
