import '../generated/protocol.dart';

class RoleDefaults {
  static const Map<MemberRole, List<String>> permissions = {
    MemberRole.admin: [
      'workspace.read',
      'workspace.invite', 
      'workspace.update',
      'board.read',
      'board.create',
      'board.update',
      'board.delete',
      'card.read',
      'card.create',
      'card.update',
      'card.delete',
    ],
    MemberRole.member: [
      'board.read',
      'card.read',
      'card.create',
      'card.update',
    ],
    MemberRole.guest: [
      'board.read',
      'card.read',
    ],
    // Owner should have all permissions but handled separately
    MemberRole.owner: [],
  };
}
