import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/permission_service.dart';
import '../services/auth_helper.dart';
import '../utils/slug_generator.dart';

/// Endpoint for managing workspaces
class WorkspaceEndpoint extends Endpoint {
  /// Require user to be logged in for all methods in this endpoint
  @override
  bool get requireLogin => true;

  /// Gets all workspaces for authenticated user
  Future<List<Workspace>> getWorkspaces(Session session) async {
    // Removed await as getAuthenticatedUserId is synchronous
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final members = await WorkspaceMember.db.find(
      session,
      where: (wm) =>
          wm.userInfoId.equals(numericUserId) & wm.deletedAt.equals(null),
    );

    final workspaceIds = members.map((m) => m.workspaceId).toSet().toList();

    if (workspaceIds.isEmpty) {
      return [];
    }

    final workspaces = await Workspace.db.find(
      session,
      where: (w) => w.id.inSet(workspaceIds.toSet()) & w.deletedAt.equals(null),
      orderBy: (w) => w.createdAt,
      orderDescending: true,
    );

    return workspaces;
  }

  /// Gets a single workspace by slug
  /// Verifies that user has permission to read workspace
  Future<Workspace?> getWorkspace(
    Session session,
    String slug,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final workspace = await Workspace.db.findFirstRow(
      session,
      where: (w) => w.slug.equals(slug) & w.deletedAt.equals(null),
    );

    if (workspace == null) {
      return null;
    }

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: workspace.id!,
      permissionSlug: 'workspace.read',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to read this workspace');
    }

    return workspace;
  }

  /// Creates a new workspace
  Future<Workspace> createWorkspace(
    Session session,
    String title,
    String? slug,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    String finalSlug;
    if (slug != null && slug.isNotEmpty) {
      finalSlug = await SlugGenerator.generateUniqueSlug(
        session,
        slug,
        checkSlugExists: (s) => Workspace.db
            .findFirstRow(
              session,
              where: (w) => w.slug.equals(s) & w.deletedAt.equals(null),
            )
            .then((w) => w != null),
      );
    } else {
      finalSlug = await SlugGenerator.generateUniqueSlug(
        session,
        title,
        checkSlugExists: (s) => Workspace.db
            .findFirstRow(
              session,
              where: (w) => w.slug.equals(s) & w.deletedAt.equals(null),
            )
            .then((w) => w != null),
      );
    }

    final workspace = Workspace(
      uuid: const Uuid().v4obj(),
      title: title,
      slug: finalSlug,
      ownerId: numericUserId,
      createdAt: DateTime.now(),
    );

    final created = await Workspace.db.insertRow(session, workspace);

    final member = WorkspaceMember(
      userInfoId: numericUserId,
      workspaceId: created.id!,
      role: MemberRole.owner, // Owner recebe todas as permissões
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    );

    final createdMember = await WorkspaceMember.db.insertRow(session, member);

    await PermissionService.grantAllPermissions(
      session,
      workspaceMemberId: createdMember.id!,
    );

    session.log(
      '[WorkspaceEndpoint] Created workspace "${created.title}" (${created.slug}) for user $numericUserId',
    );

    return created;
  }

  /// Updates workspace settings
  Future<Workspace> updateWorkspace(
    Session session,
    int workspaceId,
    String title,
    String? slug,
  ) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final hasPermission = await PermissionService.hasPermission(
      session,
      userId: numericUserId,
      workspaceId: workspaceId,
      permissionSlug: 'workspace.update',
    );

    if (!hasPermission) {
      throw Exception('User does not have permission to update workspace');
    }

    final workspace = await Workspace.db.findById(session, workspaceId);

    if (workspace == null || workspace.deletedAt != null) {
      throw Exception('Workspace not found');
    }

    String finalSlug = workspace.slug;
    if (slug != null && slug.isNotEmpty && slug != workspace.slug) {
      finalSlug = await SlugGenerator.generateUniqueSlug(
        session,
        slug,
        checkSlugExists: (s) => Workspace.db
            .findFirstRow(
              session,
              where: (w) =>
                  w.slug.equals(s) &
                  ~w.id.equals(workspaceId) &
                  w.deletedAt.equals(null),
            )
            .then((w) => w != null),
      );
    }

    final updated = workspace.copyWith(
      title: title,
      slug: finalSlug,
    );

    final result = await Workspace.db.updateRow(session, updated);

    session.log(
      '[WorkspaceEndpoint] Updated workspace "${result.title}" (${result.slug})',
    );

    return result;
  }

  /// Soft deletes a workspace
  Future<void> deleteWorkspace(Session session, int workspaceId) async {
    final numericUserId = AuthHelper.getAuthenticatedUserId(session);

    final workspace = await Workspace.db.findById(session, workspaceId);

    if (workspace == null || workspace.deletedAt != null) {
      throw Exception('Workspace not found');
    }

    if (workspace.ownerId != numericUserId) {
      throw Exception('Only workspace owner can delete workspace');
    }

    final updated = workspace.copyWith(
      deletedAt: DateTime.now(),
      deletedBy: numericUserId,
    );

    await Workspace.db.updateRow(session, updated);

    session.log(
      '[WorkspaceEndpoint] Soft deleted workspace "${workspace.title}"',
    );
  }
}
