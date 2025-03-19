abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = "Server Failure"]) : super(message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure([String message = "Not Found Failure"]) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure([String message = "Unknown Failure"]) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = "Network Failure"]) : super(message);
}
