import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../domain/auth_exception.dart';
import '../../domain/usecases/finish_password_reset_usecase.dart';
import '../../domain/usecases/finish_registration_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/start_password_reset_usecase.dart';
import '../../domain/usecases/start_registration_usecase.dart';
import '../../domain/usecases/verify_password_reset_code_usecase.dart';
import '../../domain/usecases/verify_registration_code_usecase.dart';
import '../states/auth_state.dart';
import '../stores/auth_store.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final StartRegistrationUseCase _startRegistrationUseCase;
  final VerifyRegistrationCodeUseCase _verifyRegistrationCodeUseCase;
  final FinishRegistrationUseCase _finishRegistrationUseCase;
  final StartPasswordResetUseCase _startPasswordResetUseCase;
  final VerifyPasswordResetCodeUseCase _verifyPasswordResetCodeUseCase;
  final FinishPasswordResetUseCase _finishPasswordResetUseCase;
  final LogoutUseCase _logoutUseCase;
  final FlutterAuthSessionManager _authManager;
  final AuthStore _store;

  String? _currentEmail;
  late final VoidCallback _authListener;

  AuthController({
    required LoginUseCase loginUseCase,
    required StartRegistrationUseCase startRegistrationUseCase,
    required VerifyRegistrationCodeUseCase verifyRegistrationCodeUseCase,
    required FinishRegistrationUseCase finishRegistrationUseCase,
    required StartPasswordResetUseCase startPasswordResetUseCase,
    required VerifyPasswordResetCodeUseCase verifyPasswordResetCodeUseCase,
    required FinishPasswordResetUseCase finishPasswordResetUseCase,
    required LogoutUseCase logoutUseCase,
    required FlutterAuthSessionManager authManager,
    required AuthStore store,
  })  : _loginUseCase = loginUseCase,
        _startRegistrationUseCase = startRegistrationUseCase,
        _verifyRegistrationCodeUseCase = verifyRegistrationCodeUseCase,
        _finishRegistrationUseCase = finishRegistrationUseCase,
        _startPasswordResetUseCase = startPasswordResetUseCase,
        _verifyPasswordResetCodeUseCase = verifyPasswordResetCodeUseCase,
        _finishPasswordResetUseCase = finishPasswordResetUseCase,
        _logoutUseCase = logoutUseCase,
        _authManager = authManager,
        _store = store {
    _authListener = _onAuthInfoChanged;
    _authManager.authInfoListenable.addListener(_authListener);
  }

  AuthStore get store => _store;
  AuthState get state => _store.value;
  String? get currentEmail => _currentEmail;
  String? get userEmail => _currentEmail;
  bool get isLoading => state is AuthLoading;
  bool get isAuthenticated => _authManager.isAuthenticated;
  String? get errorMessage =>
      state is AuthError ? (state as AuthError).message : null;

  void _setState(AuthState newState) {
    _store.value = newState;
    notifyListeners();
  }

  void _onAuthInfoChanged() {
    if (!_authManager.isAuthenticated && state is AuthAuthenticated) {
      reset();
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authManager.authInfoListenable.removeListener(_authListener);
    _store.dispose();
    super.dispose();
  }

  void clearError() {
    if (state is AuthError) {
      _setState(const AuthInitial());
    }
  }

  void reset() {
    _currentEmail = null;
    _setState(const AuthInitial());
  }

  Future<void> login({required String email, required String password}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    final result = await _loginUseCase(email: _currentEmail!, password: password);
    await result.fold((failure) async {
      final rawError = failure.originalError;
      if (rawError is AuthInvalidCredentialsException) {
        _setState(const AuthInvalidCredentialsError());
      } else if (rawError is AuthAccountNotFoundException) {
        _setState(AuthAccountNotFoundError(rawError.email));
      } else {
        _setState(AuthGenericError(failure.message));
      }
    }, (authSuccess) async {
      await _authManager.updateSignedInUser(authSuccess);
      if (_authManager.isAuthenticated) {
        _setState(AuthAuthenticated(userId: authSuccess.authUserId.toString()));
      } else {
        _setState(const AuthSessionError());
      }
    });
  }

  Future<void> startRegistration({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    final result = await _startRegistrationUseCase(email: _currentEmail!);
    result.fold((failure) {
      final rawError = failure.originalError;
      if (rawError is AuthAccountExistsException) {
        _setState(AuthAccountExistsError(_currentEmail!));
      } else {
        _setState(AuthGenericError(failure.message));
      }
    }, (accountRequestId) {
      _setState(
        AuthNeedsVerification(email: _currentEmail!, accountRequestId: accountRequestId),
      );
    });
  }

  Future<void> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String code,
  }) async {
    _setState(const AuthLoading());

    final result = await _verifyRegistrationCodeUseCase(
      accountRequestId: accountRequestId,
      code: code.trim(),
    );

    result.fold((failure) {
      final rawError = failure.originalError;
      if (rawError is AuthCodeInvalidException) {
        _setState(const AuthInvalidCodeError());
      } else if (rawError is AuthCodeExpiredException) {
        _setState(const AuthCodeExpiredError());
      } else {
        _setState(AuthGenericError(failure.message));
      }
    }, (registrationToken) {
      _setState(
        AuthCodeVerified(
          email: _currentEmail ?? '',
          registrationToken: registrationToken,
        ),
      );
    });
  }

  Future<void> finishRegistration({
    required String registrationToken,
    required String password,
  }) async {
    _setState(const AuthLoading());

    final result = await _finishRegistrationUseCase(
      registrationToken: registrationToken,
      password: password,
    );

    await result.fold((failure) async {
      _setState(AuthGenericError(failure.message));
    }, (authSuccess) async {
      await _authManager.updateSignedInUser(authSuccess);
      if (_authManager.isAuthenticated) {
        _setState(AuthAuthenticated(userId: authSuccess.authUserId.toString()));
      } else {
        _setState(const AuthSessionError());
      }
    });
  }

  Future<void> resendVerificationCode({required String email}) async {
    await startRegistration(email: email);
  }

  Future<void> startPasswordReset({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    final result = await _startPasswordResetUseCase(email: _currentEmail!);
    result.fold((failure) {
      _setState(AuthGenericError(failure.message));
    }, (requestId) {
      _setState(AuthPasswordResetCodeSent(email: _currentEmail!, requestId: requestId));
    });
  }

  Future<void> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  }) async {
    _setState(const AuthLoading());

    final result = await _verifyPasswordResetCodeUseCase(
      requestId: requestId,
      code: code.trim(),
    );

    result.fold((failure) {
      final rawError = failure.originalError;
      if (rawError is AuthCodeInvalidException) {
        _setState(const AuthInvalidCodeError());
      } else if (rawError is AuthCodeExpiredException) {
        _setState(const AuthCodeExpiredError());
      } else {
        _setState(AuthGenericError(failure.message));
      }
    }, (token) {
      _setState(AuthPasswordResetVerified(email: _currentEmail ?? '', token: token));
    });
  }

  Future<void> finishPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    _setState(const AuthLoading());

    final result = await _finishPasswordResetUseCase(
      token: token,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => _setState(AuthGenericError(failure.message)),
      (_) => _setState(const AuthInitial()),
    );
  }

  Future<void> logout() async {
    final result = await _logoutUseCase();
    result.fold((failure) {
      developer.log(
        'Logout error',
        name: 'auth_controller',
        level: 900,
        error: failure.originalError ?? failure.message,
      );
    }, (_) {});
    reset();
  }
}
