import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String? authToken;

  const AuthAuthenticated({
    required this.userId,
    this.authToken,
  });
}

class AuthNeedsVerification extends AuthState {
  final String email;
  final UuidValue accountRequestId;

  const AuthNeedsVerification({
    required this.email,
    required this.accountRequestId,
  });
}

class AuthCodeVerified extends AuthState {
  final String email;
  final String registrationToken;

  const AuthCodeVerified({
    required this.email,
    required this.registrationToken,
  });
}

class AuthPasswordResetCodeSent extends AuthState {
  final String email;
  final UuidValue requestId;

  const AuthPasswordResetCodeSent({
    required this.email,
    required this.requestId,
  });
}

class AuthPasswordResetVerified extends AuthState {
  final String email;
  final String token;

  const AuthPasswordResetVerified({
    required this.email,
    required this.token,
  });
}

sealed class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthAccountNotFoundError extends AuthError {
  final String email;
  const AuthAccountNotFoundError(this.email)
    : super('Conta nao encontrada para este email');
}

class AuthAccountExistsError extends AuthError {
  final String email;
  const AuthAccountExistsError(this.email)
    : super('Este email ja esta cadastrado');
}

class AuthInvalidCredentialsError extends AuthError {
  const AuthInvalidCredentialsError() : super('Email ou senha incorretos');
}

class AuthEmailNotVerifiedError extends AuthError {
  final String email;
  final UuidValue? accountRequestId;

  const AuthEmailNotVerifiedError({
    required this.email,
    this.accountRequestId,
  }) : super('Email nao verificado');
}

class AuthInvalidCodeError extends AuthError {
  const AuthInvalidCodeError() : super('Codigo invalido');
}

class AuthCodeExpiredError extends AuthError {
  const AuthCodeExpiredError() : super('Codigo expirado');
}

class AuthSessionError extends AuthError {
  const AuthSessionError()
    : super('Falha ao registrar sessao. Tente novamente.');
}

class AuthNetworkError extends AuthError {
  const AuthNetworkError([String? details])
    : super(details ?? 'Erro de conexao');
}

class AuthGenericError extends AuthError {
  const AuthGenericError(super.message);
}
