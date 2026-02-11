import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'permission_service.dart';
import '../utils/slug_generator.dart';

/// Service for handling post-registration logic
/// 
/// DEPRECATED: Use WorkspaceService.createDefaultWorkspace instead
/// This file is kept for backward compatibility but should not be used for new code.
class UserRegistrationService {
  /// Called after a user finishes registration.
  /// Creates a default workspace and user preferences.
  /// 
  /// DEPRECATED: Use WorkspaceService.createDefaultWorkspace instead
  @Deprecated('Use WorkspaceService.createDefaultWorkspace instead')
  static Future<void> onUserRegistered(
    Session session, {
    required UuidValue authUserId,
    String? userName,
  }) async {
    session.log(
      '[UserRegistrationService] Setting up new user: $authUserId',
    );

    // 1. Create default workspace
    await _createDefaultWorkspace(
      session,
      authUserId: authUserId,
      userName: userName,
    );

    session.log(
      '[UserRegistrationService] Setup completed for user $authUserId',
    );
  }

  /// Creates the default workspace for a new user
  static Future<Workspace> _createDefaultWorkspace(
    Session session, {
    required UuidValue authUserId,
    String? userName,
  }) async {
    // Generate workspace title using userName if available
    final workspaceTitle = userName != null && userName.isNotEmpty
        ? "$userName's Workspace"
        : 'My Workspace';

    // Generate unique slug
    final slug = await SlugGenerator.generateUniqueSlug(
      session,
      workspaceTitle,
      checkSlugExists: (s) => Workspace.db
          .findFirstRow(
            session,
            where: (w) => w.slug.equals(s) & w.deletedAt.equals(null),
          )
          .then((w) => w != null),
    );

    // Create workspace
    final workspace = Workspace(      title: workspaceTitle,
      slug: slug,
      ownerId: authUserId,
      createdAt: DateTime.now(),
    );

    final created = await Workspace.db.insertRow(session, workspace);

    session.log(
      '[UserRegistrationService] Created workspace "${created.title}" (${created.slug}) for user $authUserId',
    );

    // Create WorkspaceMember for owner
    final member = WorkspaceMember(
      authUserId: authUserId,
      workspaceId: created.id!,
      role: MemberRole.owner,
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    );

    final createdMember = await WorkspaceMember.db.insertRow(session, member);

    // Grant all permissions to owner
    await PermissionService.grantAllPermissions(
      session,
      workspaceMemberId: createdMember.id!,
    );

    session.log(
      '[UserRegistrationService] Granted all permissions to user $authUserId',
    );

    return created;
  }
}
