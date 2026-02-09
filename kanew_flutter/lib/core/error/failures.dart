/// Modelo centralizado de falhas para uso com `Either<Failure, T>`
///
/// Seguindo as diretrizes do AGENTS.md, todas as operações que podem
/// falhar devem retornar `Future<Either<Failure, T>>`.
sealed class Failure {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.originalError, this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Falha de rede (conexão, timeout, etc)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.originalError, super.stackTrace]);
}

/// Falha do servidor (erro 500, resposta inválida, etc)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(
    String message, {
    this.statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError, stackTrace);
}

/// Falha de validação (dados inválidos, campos obrigatórios, etc)
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(
    String message, {
    this.fieldErrors,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError, stackTrace);
}

/// Falha de autenticação (não autenticado, token expirado, etc)
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.originalError, super.stackTrace]);
}

/// Falha de permissão (acesso negado)
class PermissionFailure extends Failure {
  const PermissionFailure(
    super.message, [
    super.originalError,
    super.stackTrace,
  ]);
}

/// Falha de recurso não encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, [super.originalError, super.stackTrace]);
}

/// Falha desconhecida (fallback)
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.originalError, super.stackTrace]);
}

/// Extension para facilitar a criação de Failure a partir de Exception
extension FailureFromException on Exception {
  Failure toFailure([StackTrace? stackTrace]) {
    final message = toString().replaceFirst('Exception: ', '');
    return UnknownFailure(message, this, stackTrace);
  }
}
