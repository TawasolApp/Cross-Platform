class Failure {
  final String message;

  Failure([this.message = 'An unexpected error occured']);

  @override
  String toString() => 'Failure: $message';
}

// Add specific failure types that are used in profile_provider.dart
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error occurred']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Network error occurred']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache error occurred']);
}

class ValidationFailure extends Failure {
  ValidationFailure([super.message = 'Validation error occurred']);
}