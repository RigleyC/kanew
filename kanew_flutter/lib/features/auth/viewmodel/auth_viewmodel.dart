import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/di/injection.dart';
import '../data/auth_repository.dart';

/// Sealed class representing all possible auth states
sealed class AuthState {
  const AuthState();
}

/// Initial state - no operation in progress
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - operation in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Error state - operation failed
class AuthError extends AuthState {
  final String message;
  final AuthStatus? status;

  const AuthError({required this.message, this.status});
}

/// Success state after login
class AuthLoginSuccess extends AuthState {
  final String authToken;
  final String userId;

  const AuthLoginSuccess({required this.authToken, required this.userId});
}

/// State indicating user needs to sign up (account not found)
class AuthAccountNotFound extends AuthState {
  final String email;

  const AuthAccountNotFound({required this.email});
}

/// State indicating email is not verified
class AuthEmailNotVerified extends AuthState {
  final String? accountRequestId;
  final String email;

  const AuthEmailNotVerified({
    this.accountRequestId,
    required this.email,
  });
}

/// State indicating verification code was sent
class AuthVerificationCodeSent extends AuthState {
  final String accountRequestId;
  final String email;

  const AuthVerificationCodeSent({
    required this.accountRequestId,
    required this.email,
  });
}

/// State indicating code was verified, ready for finish signup
class AuthCodeVerified extends AuthState {
  final String registrationToken;
  final String email;

  const AuthCodeVerified({
    required this.registrationToken,
    required this.email,
  });
}

/// State indicating registration is complete
class AuthRegistrationComplete extends AuthState {
  final String authToken;
  final String userId;

  const AuthRegistrationComplete({
    required this.authToken,
    required this.userId,
  });
}

/// ViewModel for custom authentication flows.
///
/// Uses the new AuthEndpoint that returns clear AuthResult with status.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final FlutterAuthSessionManager _authManager;

  AuthState _state = const AuthInitial();
  String? _currentEmail;

  AuthViewModel({
    required AuthRepository repository,
    required FlutterAuthSessionManager authManager,
  }) : _repository = repository,
       _authManager = authManager;

  /// Current auth state
  AuthState get state => _state;

  /// Current email being processed
  String? get currentEmail => _currentEmail;

  /// Whether loading is in progress
  bool get isLoading => _state is AuthLoading;

  /// Error message if in error state
  String? get errorMessage =>
      _state is AuthError ? (_state as AuthError).message : null;

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
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
  /// Returns the appropriate state based on backend response:
  /// - [AuthLoginSuccess] if login successful
  /// - [AuthAccountNotFound] if no account exists (should redirect to signup)
  /// - [AuthEmailNotVerified] if email not verified (should redirect to verification)
  /// - [AuthError] if credentials are invalid
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _currentEmail = email;
    _setState(const AuthLoading());

    try {
      // First check with our custom endpoint for clear status
      final result = await _repository.login(
        email: email,
        password: password,
      );

      switch (result.status) {
        case AuthStatus.success:
          debugPrint('[AuthViewModel] Login result: Success for $email');
          // Backend confirmed credentials are valid
          // Now we call the emailIdp.login on client to register the session
          final client = getIt<Client>();
          try {
            // This will authenticate and register the session in FlutterAuthSessionManager
            await client.emailIdp.login(
              email: email,
              password: password,
            );

            // Check if email is verified
            if (result.emailVerified == false) {
              _setState(
                AuthEmailNotVerified(
                  accountRequestId: result.accountRequestId,
                  email: email,
                ),
              );
            } else {
              // Wait for session to be registered securely
              // Increased retries to ensure persistence is complete
              int retries = 0;
              while (!_authManager.isAuthenticated && retries < 10) {
                debugPrint(
                  '[AuthViewModel] Waiting for session (retry $retries)',
                );
                await Future.delayed(const Duration(milliseconds: 100));
                retries++;
              }

              if (_authManager.isAuthenticated) {
                debugPrint('[AuthViewModel] Session registered successfully');
                _setState(
                  AuthLoginSuccess(
                    authToken: result.authToken ?? '',
                    userId: result.userId ?? '',
                  ),
                );
              } else {
                throw Exception(
                  'Falha ao registrar sessão localmente após retries',
                );
              }
            }
          } catch (e) {
            // Session registration failed, but credentials were valid
            debugPrint('[AuthViewModel] Session registration failed: $e');
            _setState(
              AuthError(
                message: 'Erro ao registrar sessão: $e',
                status: result.status,
              ),
            );
          }
          break;

        case AuthStatus.accountNotFound:
          _setState(AuthAccountNotFound(email: email));
          break;

        case AuthStatus.emailNotVerified:
          _setState(
            AuthEmailNotVerified(
              accountRequestId: result.accountRequestId!,
              email: email,
            ),
          );
          break;

        case AuthStatus.invalidCredentials:
          _setState(
            AuthError(
              message: result.message ?? 'Email ou senha incorretos',
              status: result.status,
            ),
          );
          break;

        default:
          _setState(
            AuthError(
              message: result.message ?? 'Erro no login',
              status: result.status,
            ),
          );
          break;
      }
    } catch (e) {
      _setState(AuthError(message: 'Erro de conexão: $e'));
    }
  }

  // ============================================================
  // SIGNUP
  // ============================================================

  /// Starts the signup process.
  ///
  /// Returns:
  /// - [AuthVerificationCodeSent] if new signup (code sent)
  /// - [AuthEmailNotVerified] if account exists but not verified (code resent)
  /// - [AuthError] if account already exists
  Future<void> startSignup({required String email}) async {
    _currentEmail = email;
    _setState(const AuthLoading());

    try {
      final result = await _repository.startSignup(email: email);

      switch (result.status) {
        case AuthStatus.verificationCodeSent:
          _setState(
            AuthVerificationCodeSent(
              accountRequestId: result.accountRequestId!,
              email: email,
            ),
          );
          break;

        case AuthStatus.emailNotVerified:
          _setState(
            AuthEmailNotVerified(
              accountRequestId: result.accountRequestId!,
              email: email,
            ),
          );
          break;

        case AuthStatus.accountAlreadyExists:
          _setState(
            AuthError(
              message: result.message ?? 'Este email já está cadastrado',
              status: result.status,
            ),
          );
          break;

        default:
          _setState(
            AuthError(
              message: result.message ?? 'Erro ao iniciar cadastro',
              status: result.status,
            ),
          );
          break;
      }
    } catch (e) {
      _setState(AuthError(message: 'Erro de conexão: $e'));
    }
  }

  // ============================================================
  // VERIFICATION
  // ============================================================

  /// Verifies the registration code.
  ///
  /// Returns:
  /// - [AuthCodeVerified] if code is valid (ready for finish signup)
  /// - [AuthError] if code is invalid or expired
  Future<void> verifyCode({
    required String accountRequestId,
    required String code,
  }) async {
    _setState(const AuthLoading());

    try {
      final result = await _repository.verifyCode(
        accountRequestId: accountRequestId,
        code: code,
      );

      switch (result.status) {
        case AuthStatus.success:
          _setState(
            AuthCodeVerified(
              registrationToken: result.registrationToken!,
              email: _currentEmail ?? '',
            ),
          );
          break;

        case AuthStatus.verificationCodeInvalid:
          _setState(
            AuthError(
              message: result.message ?? 'Código inválido',
              status: result.status,
            ),
          );
          break;

        case AuthStatus.verificationCodeExpired:
          _setState(
            AuthError(
              message: result.message ?? 'Código expirado',
              status: result.status,
            ),
          );
          break;

        default:
          _setState(
            AuthError(
              message: result.message ?? 'Erro na verificação',
              status: result.status,
            ),
          );
          break;
      }
    } catch (e) {
      _setState(AuthError(message: 'Erro de conexão: $e'));
    }
  }

  // ============================================================
  // FINISH SIGNUP
  // ============================================================

  /// Finishes the signup process with name and password.
  ///
  /// Returns:
  /// - [AuthRegistrationComplete] if successful (user is logged in)
  /// - [AuthError] on failure
  Future<void> finishSignup({
    required String registrationToken,
    required String name,
    required String password,
  }) async {
    _setState(const AuthLoading());

    try {
      final result = await _repository.finishSignup(
        registrationToken: registrationToken,
        name: name,
        password: password,
      );

      switch (result.status) {
        case AuthStatus.registrationComplete:
          _setState(
            AuthRegistrationComplete(
              authToken: result.authToken!,
              userId: result.userId!,
            ),
          );
          break;

        default:
          _setState(
            AuthError(
              message: result.message ?? 'Erro ao finalizar cadastro',
              status: result.status,
            ),
          );
          break;
      }
    } catch (e) {
      _setState(AuthError(message: 'Erro de conexão: $e'));
    }
  }

  // ============================================================
  // RESEND CODE
  // ============================================================

  /// Resends the verification code.
  ///
  /// Returns:
  /// - [AuthVerificationCodeSent] with new accountRequestId
  /// - [AuthError] on failure
  Future<void> resendCode({required String email}) async {
    _setState(const AuthLoading());

    try {
      final result = await _repository.resendCode(email: email);

      switch (result.status) {
        case AuthStatus.verificationCodeSent:
          _setState(
            AuthVerificationCodeSent(
              accountRequestId: result.accountRequestId!,
              email: email,
            ),
          );
          break;

        default:
          _setState(
            AuthError(
              message: result.message ?? 'Erro ao reenviar código',
              status: result.status,
            ),
          );
          break;
      }
    } catch (e) {
      _setState(AuthError(message: 'Erro de conexão: $e'));
    }
  }

  // ============================================================
  // PASSWORD RESET (using emailIdp directly)
  // ============================================================

  /// Starts password reset flow - sends code to email.
  /// Note: This uses the emailIdp endpoint directly since our
  /// custom auth endpoint doesn't handle password reset.
  Future<String> startPasswordReset({required String email}) async {
    _setState(const AuthLoading());

    try {
      final client = getIt<Client>();
      final requestId = await client.emailIdp.startPasswordReset(email: email);

      _currentEmail = email;
      _setState(const AuthInitial());
      return requestId.toString();
    } catch (e) {
      _setState(AuthError(message: 'Erro ao enviar código: $e'));
      rethrow;
    }
  }

  /// Verifies password reset code.
  Future<String> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  }) async {
    _setState(const AuthLoading());

    try {
      final client = getIt<Client>();
      final token = await client.emailIdp.verifyPasswordResetCode(
        passwordResetRequestId: UuidValue.fromString(passwordResetRequestId),
        verificationCode: verificationCode,
      );

      _setState(const AuthInitial());
      return token;
    } catch (e) {
      _setState(AuthError(message: 'Código inválido ou expirado'));
      rethrow;
    }
  }

  /// Finishes password reset with new password.
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    _setState(const AuthLoading());

    try {
      final client = getIt<Client>();
      await client.emailIdp.finishPasswordReset(
        finishPasswordResetToken: finishPasswordResetToken,
        newPassword: newPassword,
      );

      _setState(const AuthInitial());
    } catch (e) {
      _setState(AuthError(message: 'Erro ao redefinir senha: $e'));
      rethrow;
    }
  }

  // ============================================================
  // SESSION MANAGEMENT
  // ============================================================

  /// Checks if user is currently authenticated
  bool get isAuthenticated => _authManager.isAuthenticated;

  /// Logs out the current user
  Future<void> logout() async {
    await _authManager.signOutDevice();
    reset();
  }
}
