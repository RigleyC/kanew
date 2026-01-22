import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../data/auth_repository.dart';
import '../domain/auth_exception.dart';
import '../domain/auth_state.dart';

export '../domain/auth_state.dart';

/// Controller for authentication flows.
///
/// Follows SOLID principles:
/// - Single Responsibility: Only manages auth state and delegates to repository
/// - Open/Closed: States can be extended via sealed class hierarchy
/// - Liskov Substitution: Uses abstract AuthRepository
/// - Interface Segregation: Repository has focused methods
/// - Dependency Inversion: Depends on abstractions (AuthRepository)
class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  final FlutterAuthSessionManager _authManager;

  AuthState _state = const AuthInitial();
  String? _currentEmail;

  AuthController({
    required AuthRepository repository,
    required FlutterAuthSessionManager authManager,
  })  : _repository = repository,
        _authManager = authManager;

  // ============================================================
  // GETTERS
  // ============================================================

  /// Current auth state
  AuthState get state => _state;

  /// Current email being processed
  String? get currentEmail => _currentEmail;

  /// Whether loading is in progress
  bool get isLoading => _state is AuthLoading;

  /// Error message if in error state
  String? get errorMessage => _state is AuthError ? (_state as AuthError).message : null;

  /// Checks if user is currently authenticated
  bool get isAuthenticated => _authManager.isAuthenticated;

  // ============================================================
  // STATE MANAGEMENT
  // ============================================================

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _logStateChange(String operation, [Object? error]) {
    if (error != null) {
      developer.log(
        '$operation failed',
        name: 'auth_controller',
        level: 1000,
        error: error,
      );
    } else {
      developer.log(
        '$operation - new state: ${_state.runtimeType}',
        name: 'auth_controller',
      );
    }
  }

  /// Clears the current error state
  void clearError() {
    if (_state is AuthError) {
      _setState(const AuthInitial());
    }
  }

  /// Resets the state to initial
  void reset() {
    _currentEmail = null;
    _setState(const AuthInitial());
  }

  // ============================================================
  // LOGIN
  // ============================================================

  /// Attempts to log in with email and password.
  ///
  /// Possible resulting states:
  /// - [AuthAuthenticated] if login successful
  /// - [AuthAccountNotFoundError] if no account exists
  /// - [AuthInvalidCredentialsError] if credentials are wrong
  /// - [AuthNetworkError] on connection errors
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    try {
      final authSuccess = await _repository.login(
        email: _currentEmail!,
        password: password,
      );

      // Explicitly register the session with the auth manager
      await _authManager.updateSignedInUser(authSuccess);

      if (_authManager.isAuthenticated) {
        _setState(AuthAuthenticated(userId: authSuccess.authUserId.toString()));
        _logStateChange('Login');
      } else {
        _setState(const AuthSessionError());
        _logStateChange('Login', 'Session not registered');
      }
    } on AuthInvalidCredentialsException {
      _setState(const AuthInvalidCredentialsError());
      _logStateChange('Login', 'Invalid credentials');
    } on AuthAccountNotFoundException catch (e) {
      _setState(AuthAccountNotFoundError(e.email));
      _logStateChange('Login', 'Account not found');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Login', e);
    } catch (e) {
      _setState(AuthGenericError('Erro no login: $e'));
      _logStateChange('Login', e);
    }
  }

  // ============================================================
  // REGISTRATION
  // ============================================================

  /// Starts the registration process by sending verification code.
  ///
  /// Possible resulting states:
  /// - [AuthNeedsVerification] if code was sent
  /// - [AuthAccountExistsError] if account already exists
  /// - [AuthNetworkError] on connection errors
  Future<void> startRegistration({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    try {
      final accountRequestId = await _repository.startRegistration(
        email: _currentEmail!,
      );

      _setState(AuthNeedsVerification(
        email: _currentEmail!,
        accountRequestId: accountRequestId,
      ));
      _logStateChange('Start registration');
    } on AuthAccountExistsException {
      _setState(AuthAccountExistsError(_currentEmail!));
      _logStateChange('Start registration', 'Account exists');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Start registration', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao iniciar cadastro: $e'));
      _logStateChange('Start registration', e);
    }
  }

  /// Verifies the registration code.
  ///
  /// Possible resulting states:
  /// - [AuthCodeVerified] if code is valid
  /// - [AuthInvalidCodeError] if code is wrong
  /// - [AuthCodeExpiredError] if code has expired
  Future<void> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String code,
  }) async {
    _setState(const AuthLoading());

    try {
      final registrationToken = await _repository.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        code: code.trim(),
      );

      _setState(AuthCodeVerified(
        email: _currentEmail ?? '',
        registrationToken: registrationToken,
      ));
      _logStateChange('Verify registration code');
    } on AuthCodeInvalidException {
      _setState(const AuthInvalidCodeError());
      _logStateChange('Verify registration code', 'Invalid code');
    } on AuthCodeExpiredException {
      _setState(const AuthCodeExpiredError());
      _logStateChange('Verify registration code', 'Code expired');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Verify registration code', e);
    } catch (e) {
      _setState(AuthGenericError('Erro na verificação: $e'));
      _logStateChange('Verify registration code', e);
    }
  }

  /// Finishes registration with password.
  ///
  /// Possible resulting states:
  /// - [AuthAuthenticated] if registration successful
  /// - [AuthNetworkError] on connection errors
  Future<void> finishRegistration({
    required String registrationToken,
    required String password,
  }) async {
    _setState(const AuthLoading());

    try {
      final authSuccess = await _repository.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );

      // Explicitly register the session with the auth manager
      await _authManager.updateSignedInUser(authSuccess);

      if (_authManager.isAuthenticated) {
        _setState(AuthAuthenticated(userId: authSuccess.authUserId.toString()));
        _logStateChange('Finish registration');
      } else {
        _setState(const AuthSessionError());
        _logStateChange('Finish registration', 'Session not registered');
      }
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Finish registration', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao finalizar cadastro: $e'));
      _logStateChange('Finish registration', e);
    }
  }

  /// Resends verification code.
  ///
  /// Possible resulting states:
  /// - [AuthNeedsVerification] with new accountRequestId
  /// - [AuthNetworkError] on connection errors
  Future<void> resendVerificationCode({required String email}) async {
    _setState(const AuthLoading());

    try {
      final accountRequestId = await _repository.startRegistration(
        email: email.trim().toLowerCase(),
      );

      _setState(AuthNeedsVerification(
        email: email,
        accountRequestId: accountRequestId,
      ));
      _logStateChange('Resend verification code');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Resend verification code', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao reenviar código: $e'));
      _logStateChange('Resend verification code', e);
    }
  }

  // ============================================================
  // PASSWORD RESET
  // ============================================================

  /// Starts password reset flow.
  ///
  /// Possible resulting states:
  /// - [AuthPasswordResetCodeSent] if code was sent
  /// - [AuthNetworkError] on connection errors
  Future<void> startPasswordReset({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    try {
      final requestId = await _repository.startPasswordReset(
        email: _currentEmail!,
      );

      _setState(AuthPasswordResetCodeSent(
        email: _currentEmail!,
        requestId: requestId,
      ));
      _logStateChange('Start password reset');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Start password reset', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao enviar código: $e'));
      _logStateChange('Start password reset', e);
    }
  }

  /// Verifies password reset code.
  ///
  /// Possible resulting states:
  /// - [AuthPasswordResetVerified] with token for password change
  /// - [AuthInvalidCodeError] if code is wrong
  /// - [AuthCodeExpiredError] if code has expired
  Future<void> verifyPasswordResetCode({
    required UuidValue requestId,
    required String code,
  }) async {
    _setState(const AuthLoading());

    try {
      final token = await _repository.verifyPasswordResetCode(
        requestId: requestId,
        code: code.trim(),
      );

      _setState(AuthPasswordResetVerified(
        email: _currentEmail ?? '',
        token: token,
      ));
      _logStateChange('Verify password reset code');
    } on AuthCodeInvalidException {
      _setState(const AuthInvalidCodeError());
      _logStateChange('Verify password reset code', 'Invalid code');
    } on AuthCodeExpiredException {
      _setState(const AuthCodeExpiredError());
      _logStateChange('Verify password reset code', 'Code expired');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Verify password reset code', e);
    } catch (e) {
      _setState(AuthGenericError('Código inválido ou expirado'));
      _logStateChange('Verify password reset code', e);
    }
  }

  /// Finishes password reset with new password.
  ///
  /// Possible resulting states:
  /// - [AuthInitial] if password was changed (user needs to login)
  /// - [AuthNetworkError] on connection errors
  Future<void> finishPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    _setState(const AuthLoading());

    try {
      await _repository.finishPasswordReset(
        token: token,
        newPassword: newPassword,
      );

      _setState(const AuthInitial());
      _logStateChange('Finish password reset');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Finish password reset', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao redefinir senha: $e'));
      _logStateChange('Finish password reset', e);
    }
  }

  // ============================================================
  // SESSION MANAGEMENT
  // ============================================================

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _authManager.signOutDevice();
    } catch (e) {
      developer.log(
        'Logout error',
        name: 'auth_controller',
        level: 900,
        error: e,
      );
    }
    reset();
  }
}
