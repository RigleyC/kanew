class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Unauthorized'});

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException({this.message = 'Forbidden'});

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException({this.message = 'Not found'});

  @override
  String toString() => message;
}

class BadRequestException implements Exception {
  final String message;
  const BadRequestException({this.message = 'Bad request'});

  @override
  String toString() => message;
}
