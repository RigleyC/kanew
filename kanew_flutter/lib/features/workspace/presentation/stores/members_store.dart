import 'package:flutter/material.dart';
import '../states/members_state.dart';

/// Store for Members state management
class MembersStore extends ValueNotifier<MembersState> {
  MembersStore() : super(const MembersInitial());
}
