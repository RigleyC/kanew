/// Domain exceptions for authentication operations.
///
/// These exceptions are thrown by [AuthRepository] to provide
/// typed error handling in the ViewModel layer.
sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Thrown when no account exists for the given email.
class AuthAccountNotFoundException extends AuthException {
  final String email;
  const AuthAccountNotFoundException(this.email)
    : super('Conta não encontrada');
}

/// Thrown when email/password combination is invalid.
class AuthInvalidCredentialsException extends AuthException {
  const AuthInvalidCredentialsException() : super('Email ou senha incorretos');
}

/// Thrown when the verification code is invalid.
class AuthCodeInvalidException extends AuthException {
  const AuthCodeInvalidException() : super('Código inválido');
}

/// Thrown when the verification code has expired.
class AuthCodeExpiredException extends AuthException {
  const AuthCodeExpiredException() : super('Código expirado');
}

/// Thrown when there's a network or connection error.
class AuthNetworkException extends AuthException {
  AuthNetworkException([String? details]) : super(details ?? 'Erro de conexão');
}

/// Thrown when account already exists.
class AuthAccountExistsException extends AuthException {
  const AuthAccountExistsException() : super('Este email já está cadastrado');
}
