import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../auth/roles.dart';

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
    required UuidValue workspaceMemberId,
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
            isRemoved: false,
            grantedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Checks if a member has a specific permission.
  ///
  /// Effective permission set = role defaults ± per-member overrides.
  static Future<bool> hasPermission(
    Session session, {
    required UuidValue userId,
    required UuidValue workspaceId,
    required String permissionSlug,
    UuidValue? scopeBoardId,
  }) async {
    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.authUserId.equals(userId) &
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null),
    );

    if (member == null) {
      return false;
    }

    // Owner has all permissions
    if (member.role == MemberRole.owner) {
      return true;
    }

    final permission = await Permission.db.findFirstRow(
      session,
      where: (p) => p.slug.equals(permissionSlug),
    );

    if (permission == null) {
      return false;
    }

    final roleDefaults = RoleDefaults.permissions[member.role] ?? const [];
    final isDefault = roleDefaults.contains(permissionSlug);

    // Overrides are stored in MemberPermission; a row with isRemoved=true means
    // "explicitly denied" even if the permission is granted by role defaults.
    final memberPermission = await MemberPermission.db.findFirstRow(
      session,
      where: (t) {
        final base = t.workspaceMemberId.equals(member.id!) &
            t.permissionId.equals(permission.id!);

        if (scopeBoardId == null) {
          return base & t.scopeBoardId.equals(null);
        }

        return base &
            (t.scopeBoardId.equals(scopeBoardId) | t.scopeBoardId.equals(null));
      },
    );

    if (memberPermission != null) {
      return !memberPermission.isRemoved;
    }

    return isDefault;
  }

  /// Gets all permissions for a user in a workspace (workspace-level).
  static Future<List<String>> getUserPermissions(
    Session session, {
    required UuidValue userId,
    required UuidValue workspaceId,
  }) async {
    final member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.authUserId.equals(userId) &
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null),
    );

    if (member == null) {
      return [];
    }

    if (member.role == MemberRole.owner) {
      final all = await Permission.db.find(session);
      return all.map((p) => p.slug).toList();
    }

    final result = <String>{};

    final roleDefaults = RoleDefaults.permissions[member.role] ?? const [];
    result.addAll(roleDefaults);

    final overrides = await MemberPermission.db.find(
      session,
      where: (t) =>
          t.workspaceMemberId.equals(member.id!) & t.scopeBoardId.equals(null),
    );

    if (overrides.isEmpty) {
      return result.toList();
    }

    final permissions = await Permission.db.find(session);
    final idToSlug = <UuidValue, String>{
      for (final p in permissions) if (p.id != null) p.id!: p.slug,
    };

    for (final mp in overrides) {
      final slug = idToSlug[mp.permissionId];
      if (slug == null) continue;
      if (mp.isRemoved) {
        result.remove(slug);
      } else {
        result.add(slug);
      }
    }

    return result.toList();
  }

  /// Returns PermissionInfo for UI (granted + metadata).
  static Future<List<PermissionInfo>> getEffectivePermissions(
    Session session,
    UuidValue workspaceMemberId,
  ) async {
    final member = await WorkspaceMember.db.findById(session, workspaceMemberId);
    if (member == null) return [];

    final allPermissions = await Permission.db.find(session);

    if (member.role == MemberRole.owner) {
      return allPermissions
          .map(
            (p) => PermissionInfo(
              permission: p,
              granted: true,
              isDefault: true,
              isAdded: false,
              isRemoved: false,
            ),
          )
          .toList();
    }

    final roleDefaults = RoleDefaults.permissions[member.role] ?? const [];
    final defaultSlugs = roleDefaults.toSet();

    final overrides = await MemberPermission.db.find(
      session,
      where: (t) =>
          t.workspaceMemberId.equals(workspaceMemberId) &
          t.scopeBoardId.equals(null),
    );

    final overridesByPermissionId = <UuidValue, MemberPermission>{};
    for (final o in overrides) {
      overridesByPermissionId[o.permissionId] = o;
    }

    final result = <PermissionInfo>[];

    for (final perm in allPermissions) {
      final isDefault = defaultSlugs.contains(perm.slug);
      final override = perm.id == null ? null : overridesByPermissionId[perm.id!];

      final isRemoved = override?.isRemoved ?? false;
      final isAdded = override != null && !override.isRemoved;

      final granted = (isDefault && !isRemoved) || isAdded;

      result.add(
        PermissionInfo(
          permission: perm,
          granted: granted,
          isDefault: isDefault,
          isAdded: isAdded,
          isRemoved: isRemoved,
        ),
      );
    }

    return result;
  }

  /// Applies permission overrides for a workspace member based on the final granted set.
  ///
  /// This computes role defaults ± overrides and persists only the overrides:
  /// - Permissions in grantedIds but not in defaults are added (isRemoved=false)
  /// - Permissions in defaults but not in grantedIds are removed (isRemoved=true)
  static Future<void> applyPermissionOverrides(
    Session session, {
    required UuidValue workspaceMemberId,
    required MemberRole role,
    required List<UuidValue> grantedPermissionIds,
  }) async {
    if (role == MemberRole.owner) {
      return;
    }

    final roleDefaults = RoleDefaults.permissions[role] ?? const [];
    final defaultSlugs = roleDefaults.toSet();

    final allPermissions = await Permission.db.find(session);
    final slugToId = <String, UuidValue>{
      for (final p in allPermissions)
        if (p.id != null) p.slug: p.id!,
    };

    final defaultIds = <UuidValue>{};
    for (final slug in defaultSlugs) {
      final id = slugToId[slug];
      if (id != null) defaultIds.add(id);
    }

    final grantedSet = grantedPermissionIds.toSet();
    final removedIds = defaultIds.difference(grantedSet);
    final addedIds = grantedSet.difference(defaultIds);

    final existingOverrides = await MemberPermission.db.find(
      session,
      where: (mp) =>
          mp.workspaceMemberId.equals(workspaceMemberId) &
          mp.scopeBoardId.equals(null),
    );

    final existingByPermissionId = <UuidValue, MemberPermission>{};
    for (final mp in existingOverrides) {
      existingByPermissionId[mp.permissionId] = mp;
    }

    for (final mp in existingOverrides) {
      final permId = mp.permissionId;

      if (addedIds.contains(permId)) {
        if (mp.isRemoved) {
          await MemberPermission.db.updateRow(
            session,
            mp.copyWith(isRemoved: false, grantedAt: DateTime.now()),
          );
        }
        continue;
      }

      if (removedIds.contains(permId)) {
        if (!mp.isRemoved) {
          await MemberPermission.db.updateRow(
            session,
            mp.copyWith(isRemoved: true, grantedAt: DateTime.now()),
          );
        }
        continue;
      }

      await MemberPermission.db.deleteRow(session, mp);
    }

    for (final permId in addedIds) {
      if (existingByPermissionId.containsKey(permId)) continue;
      await MemberPermission.db.insertRow(
        session,
        MemberPermission(
          workspaceMemberId: workspaceMemberId,
          permissionId: permId,
          scopeBoardId: null,
          isRemoved: false,
          grantedAt: DateTime.now(),
        ),
      );
    }

    for (final permId in removedIds) {
      if (existingByPermissionId.containsKey(permId)) continue;
      await MemberPermission.db.insertRow(
        session,
        MemberPermission(
          workspaceMemberId: workspaceMemberId,
          permissionId: permId,
          scopeBoardId: null,
          isRemoved: true,
          grantedAt: DateTime.now(),
        ),
      );
    }
  }
}
