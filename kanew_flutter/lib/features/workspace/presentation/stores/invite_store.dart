import 'package:flutter/material.dart';
import '../states/invite_state.dart';

/// Store for Invite state management
class InviteStore extends ValueNotifier<InviteState> {
  InviteStore() : super(const InviteInitial());
}
