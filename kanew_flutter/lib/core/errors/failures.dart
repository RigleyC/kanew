abstract class Failure {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Não autorizado',
    super.error,
    super.stackTrace,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Não encontrado',
    super.error,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Erro inesperado',
    super.error,
    super.stackTrace,
  });
}
