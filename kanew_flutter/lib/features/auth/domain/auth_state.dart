import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Sealed class representing all possible auth states.
///
/// Using sealed class for exhaustive switch statements and type safety.
/// All auth-related UI should react to these states.
sealed class AuthState {
  const AuthState();
}

// ============================================================
// BASIC STATES
// ============================================================

/// Initial state - no operation in progress.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - operation in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Success state - user is authenticated.
class AuthAuthenticated extends AuthState {
  final String userId;
  final String? authToken;

  const AuthAuthenticated({
    required this.userId,
    this.authToken,
  });
}

// ============================================================
// REGISTRATION FLOW STATES
// ============================================================

/// State after verification code was sent during signup.
class AuthNeedsVerification extends AuthState {
  final String email;
  final UuidValue accountRequestId;

  const AuthNeedsVerification({
    required this.email,
    required this.accountRequestId,
  });
}

/// State after code was verified, ready to set password.
class AuthCodeVerified extends AuthState {
  final String email;
  final String registrationToken;

  const AuthCodeVerified({
    required this.email,
    required this.registrationToken,
  });
}

// ============================================================
// PASSWORD RESET FLOW STATES
// ============================================================

/// State for password reset flow - after code sent.
class AuthPasswordResetCodeSent extends AuthState {
  final String email;
  final UuidValue requestId;

  const AuthPasswordResetCodeSent({
    required this.email,
    required this.requestId,
  });
}

/// State for password reset - after code verified.
class AuthPasswordResetVerified extends AuthState {
  final String email;
  final String token;

  const AuthPasswordResetVerified({
    required this.email,
    required this.token,
  });
}

// ============================================================
// ERROR STATES
// ============================================================

/// Base error state - operation failed.
sealed class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Account not found during login.
class AuthAccountNotFoundError extends AuthError {
  final String email;
  const AuthAccountNotFoundError(this.email)
      : super('Conta não encontrada para este email');
}

/// Account already exists during signup.
class AuthAccountExistsError extends AuthError {
  final String email;
  const AuthAccountExistsError(this.email)
      : super('Este email já está cadastrado');
}

/// Invalid credentials during login.
class AuthInvalidCredentialsError extends AuthError {
  const AuthInvalidCredentialsError() : super('Email ou senha incorretos');
}

/// Email not verified - needs to complete verification.
class AuthEmailNotVerifiedError extends AuthError {
  final String email;
  final UuidValue? accountRequestId;

  const AuthEmailNotVerifiedError({
    required this.email,
    this.accountRequestId,
  }) : super('Email não verificado');
}

/// Invalid verification code.
class AuthInvalidCodeError extends AuthError {
  const AuthInvalidCodeError() : super('Código inválido');
}

/// Verification code expired.
class AuthCodeExpiredError extends AuthError {
  const AuthCodeExpiredError() : super('Código expirado');
}

/// Session registration failed.
class AuthSessionError extends AuthError {
  const AuthSessionError()
      : super('Falha ao registrar sessão. Tente novamente.');
}

/// Network/connection error.
class AuthNetworkError extends AuthError {
  const AuthNetworkError([String? details])
      : super(details ?? 'Erro de conexão');
}

/// Generic/unknown error.
class AuthGenericError extends AuthError {
  const AuthGenericError(super.message);
}
