import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'permission_service.dart';
import '../utils/slug_generator.dart';

/// Service for handling post-registration logic
class UserRegistrationService {
  /// Called after a user finishes registration.
  /// Creates a default workspace and user preferences.
  static Future<void> onUserRegistered(
    Session session, {
    required int userId,
    String? userName,
  }) async {
    session.log(
      '[UserRegistrationService] Setting up new user: $userId',
    );

    // 1. Create default workspace
    final workspace = await _createDefaultWorkspace(
      session,
      userId: userId,
      userName: userName,
    );

    // 2. Create UserPreference
    final preference = UserPreference(
      userInfoId: userId,
      lastWorkspaceId: workspace.id,
      theme: 'system',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await UserPreference.db.insertRow(session, preference);

    session.log(
      '[UserRegistrationService] Created UserPreference for user $userId',
    );
  }

  /// Creates the default workspace for a new user
  static Future<Workspace> _createDefaultWorkspace(
    Session session, {
    required int userId,
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
    final workspace = Workspace(
      uuid: const Uuid().v4obj(),
      title: workspaceTitle,
      slug: slug,
      ownerId: userId,
      createdAt: DateTime.now(),
    );

    final created = await Workspace.db.insertRow(session, workspace);

    session.log(
      '[UserRegistrationService] Created workspace "${created.title}" (${created.slug}) for user $userId',
    );

    // Create WorkspaceMember for owner
    final member = WorkspaceMember(
      userInfoId: userId,
      workspaceId: created.id!,
      role: MemberRole.owner, // Owner role (conforme plan.md)
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
      '[UserRegistrationService] Granted all permissions to user $userId',
    );

    return created;
  }
}
