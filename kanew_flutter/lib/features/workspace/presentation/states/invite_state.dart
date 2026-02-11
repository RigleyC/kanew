import 'package:kanew_client/kanew_client.dart';

/// State for Invite acceptance flow
sealed class InviteState {
  const InviteState();
}

class InviteInitial extends InviteState {
  const InviteInitial();
}

class InviteValidating extends InviteState {
  const InviteValidating();
}

class InviteValidated extends InviteState {
  final InviteDetails details;
  const InviteValidated(this.details);
}

class InviteAccepting extends InviteState {
  const InviteAccepting();
}

class InviteAccepted extends InviteState {
  final AcceptInviteResult result;
  const InviteAccepted(this.result);
}

class InviteError extends InviteState {
  final String message;
  const InviteError(this.message);
}
