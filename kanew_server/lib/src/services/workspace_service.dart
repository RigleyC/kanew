import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/slug_generator.dart';
import 'permission_service.dart';

/// Service for creating default workspace when a new user signs up organically
class WorkspaceService {
  /// Creates a default workspace for new organic signups
  /// Called from onAfterAccountCreated hook in EmailIdpConfig
  ///
  /// Note: In Serverpod 3.x, authUserId is the user's UUID from auth_user table.
  static Future<Workspace> createDefaultWorkspace(
    Session session, {
    required UuidValue authUserId,
    required String email,
  }) async {
    // User always creates default workspace on signup
    // Invite flow is separate - user accepts invitation AFTER having an account
    // See plan.md line 184: email is optional in invites

    // Get the user's email username as workspace title base
    final emailUsername = email.split('@').first;
    final title = '$emailUsername Workspace';

    final slug = await SlugGenerator.generateUniqueSlug(
      session,
      title,
      checkSlugExists: (s) => Workspace.db
          .findFirstRow(
            session,
            where: (t) => t.slug.equals(s) & t.deletedAt.equals(null),
          )
          .then((w) => w != null),
    );

    final workspace = Workspace(
      title: title,
      slug: slug,
      ownerId: authUserId,
      createdAt: DateTime.now(),
    );

    final created = await Workspace.db.insertRow(session, workspace);

    // Add owner as member with role 'owner'
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
      '[WorkspaceService] Created default workspace "${created.title}" (${created.slug}) for user $authUserId',
    );

    return created;
  }
}
