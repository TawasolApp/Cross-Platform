class Failure {
 final String message;
 final int errorCode;
  Failure({required this.message, required this.errorCode});

}


class ServerFailure extends Failure {
  ServerFailure([String message = "A server error occurred", int errorCode = 500]) : super(message: message, errorCode: errorCode);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = "Network error", int errorCode = 0]) : super(message: message, errorCode: errorCode);
}

class ValidationFailure extends Failure {
  ValidationFailure([String message = "Validation failed", int errorCode = 0]) : super(message: message, errorCode: errorCode);
}
