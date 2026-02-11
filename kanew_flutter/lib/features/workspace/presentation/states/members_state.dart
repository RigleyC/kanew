import 'package:kanew_client/kanew_client.dart';

/// State for Members management
sealed class MembersState {
  const MembersState();
}

class MembersInitial extends MembersState {
  const MembersInitial();
}

class MembersLoading extends MembersState {
  const MembersLoading();
}

class MembersLoaded extends MembersState {
  final List<MemberWithUser> members;
  final List<WorkspaceInvite> invites;
  final List<Permission> allPermissions;
  
  const MembersLoaded({
    required this.members,
    required this.invites,
    required this.allPermissions,
  });
}

class MembersError extends MembersState {
  final String message;
  const MembersError(this.message);
}
