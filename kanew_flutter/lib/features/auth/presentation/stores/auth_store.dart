import 'package:flutter/foundation.dart';

import '../states/auth_state.dart';

class AuthStore extends ValueNotifier<AuthState> {
  AuthStore() : super(const AuthInitial());
}
