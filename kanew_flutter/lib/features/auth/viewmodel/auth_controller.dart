import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../data/auth_repository.dart';
import '../domain/auth_exception.dart';
import '../domain/auth_state.dart';

export '../domain/auth_state.dart';


class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  final FlutterAuthSessionManager _authManager;

  AuthState _state = const AuthInitial();
  String? _currentEmail;
  late final VoidCallback _authListener;

  AuthController({
    required AuthRepository repository,
    required FlutterAuthSessionManager authManager,
  }) : _repository = repository,
       _authManager = authManager {
    _authListener = _onAuthInfoChanged;
    _authManager.authInfoListenable.addListener(_authListener);
  }


  AuthState get state => _state;

  String? get currentEmail => _currentEmail;

  bool get isLoading => _state is AuthLoading;

  String? get errorMessage =>
      _state is AuthError ? (_state as AuthError).message : null;

  bool get isAuthenticated => _authManager.isAuthenticated;

  void _onAuthInfoChanged() {
    // Keep UI listening to AuthController in sync with session changes that
    // may happen outside of this controller (e.g. token refresh or sign-out).
    if (!_authManager.isAuthenticated && _state is AuthAuthenticated) {
      reset();
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authManager.authInfoListenable.removeListener(_authListener);
    super.dispose();
  }


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

  void clearError() {
    if (_state is AuthError) {
      _setState(const AuthInitial());
    }
  }

  void reset() {
    _currentEmail = null;
    _setState(const AuthInitial());
  }


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


  Future<void> startRegistration({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    try {
      final accountRequestId = await _repository.startRegistration(
        email: _currentEmail!,
      );

      _setState(
        AuthNeedsVerification(
          email: _currentEmail!,
          accountRequestId: accountRequestId,
        ),
      );
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

      _setState(
        AuthCodeVerified(
          email: _currentEmail ?? '',
          registrationToken: registrationToken,
        ),
      );
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

  Future<void> resendVerificationCode({required String email}) async {
    _setState(const AuthLoading());

    try {
      final accountRequestId = await _repository.startRegistration(
        email: email.trim().toLowerCase(),
      );

      _setState(
        AuthNeedsVerification(
          email: email,
          accountRequestId: accountRequestId,
        ),
      );
      _logStateChange('Resend verification code');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Resend verification code', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao reenviar código: $e'));
      _logStateChange('Resend verification code', e);
    }
  }


  Future<void> startPasswordReset({required String email}) async {
    _currentEmail = email.trim().toLowerCase();
    _setState(const AuthLoading());

    try {
      final requestId = await _repository.startPasswordReset(
        email: _currentEmail!,
      );

      _setState(
        AuthPasswordResetCodeSent(
          email: _currentEmail!,
          requestId: requestId,
        ),
      );
      _logStateChange('Start password reset');
    } on AuthNetworkException catch (e) {
      _setState(AuthNetworkError(e.message));
      _logStateChange('Start password reset', e);
    } catch (e) {
      _setState(AuthGenericError('Erro ao enviar código: $e'));
      _logStateChange('Start password reset', e);
    }
  }

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

      _setState(
        AuthPasswordResetVerified(
          email: _currentEmail ?? '',
          token: token,
        ),
      );
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
