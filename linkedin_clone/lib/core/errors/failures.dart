class Failure {
  final String message;
  final int errorCode;
  Failure({required this.message, required this.errorCode});
}

class ServerFailure extends Failure {
  ServerFailure([
    String message = "A server error occurred",
    int errorCode = 500,
  ]) : super(message: message, errorCode: errorCode);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = "Network error", int errorCode = 0])
    : super(message: message, errorCode: errorCode);
}

class ValidationFailure extends Failure {
  ValidationFailure([String message = "Validation failed", int errorCode = 0])
    : super(message: message, errorCode: errorCode);
}

class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error occurred', int errorCode = 0])
    : super(message: message, errorCode: errorCode);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String message, {int errorCode = 401})
    : super(message: message, errorCode: errorCode);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String message) : super(message: message, errorCode: 404);
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message: message, errorCode: 0);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure([String message = 'Access forbidden', int errorCode = 403])
    : super(message: message, errorCode: errorCode);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([
    String message = 'Unexpected error occurred',
    int errorCode = 0,
  ]) : super(message: message, errorCode: errorCode);
}
