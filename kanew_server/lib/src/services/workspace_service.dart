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
  /// We need to map the UUID to a numeric ID for ownerId.
  static Future<Workspace> createDefaultWorkspace(
    Session session, {
    required UuidValue authUserId,
    required String email,
  }) async {
    // Check if user was invited (has pending invite with their email)
    // Note: email is now optional, so we check if it exists and matches
    final invite = await WorkspaceInvite.db.findFirstRow(
      session,
      where: (t) =>
          t.email.equals(email) &
          t.acceptedAt.equals(null) &
          t.revokedAt.equals(null),
    );

    if (invite != null) {
      // Invited user - don't create default workspace
      // They'll be added to the inviting workspace via invite flow
      session.log(
        '[WorkspaceService] User $email was invited, skipping default workspace',
      );
      throw Exception('User was invited, should join invited workspace');
    }

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

    // Generate a deterministic numeric ID from UUID
    // This converts the first 8 bytes of the UUID to a positive integer
    final uuidBytes = authUserId.toBytes();
    final numericUserId = _bytesToInt(uuidBytes);

    final workspace = Workspace(
      uuid: const Uuid().v4obj(),
      title: title,
      slug: slug,
      ownerId: numericUserId,
      createdAt: DateTime.now(),
    );

    final created = await Workspace.db.insertRow(session, workspace);

    // Add owner as member with role 'owner'
    final member = WorkspaceMember(
      userInfoId: numericUserId,
      workspaceId: created.id!,
      role: MemberRole.owner, // Owner role (conforme plan.md)
      status: MemberStatus.active,
      joinedAt: DateTime.now(),
    );

    final createdMember = await WorkspaceMember.db.insertRow(session, member);

    // Grant all permissions to owner (conforme plan.md)
    await PermissionService.grantAllPermissions(
      session,
      workspaceMemberId: createdMember.id!,
    );

    // Create UserPreference with lastWorkspaceId (conforme plan.md)
    final preference = UserPreference(
      userInfoId: numericUserId,
      lastWorkspaceId: created.id!,
      theme: null, // Default theme
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await UserPreference.db.insertRow(session, preference);

    session.log(
      '[WorkspaceService] Created default workspace "${created.title}" (${created.slug}) for user $numericUserId (UUID: $authUserId)',
    );
    session.log(
      '[WorkspaceService] Created UserPreference with lastWorkspaceId=${created.id} for user $numericUserId',
    );

    return created;
  }

  /// Converts bytes to a positive integer
  static int _bytesToInt(List<int> bytes) {
    var result = 0;
    for (var i = 0; i < bytes.length && i < 8; i++) {
      result = (result << 8) | (bytes[i] & 0xFF);
    }
    return result.abs();
  }
}
