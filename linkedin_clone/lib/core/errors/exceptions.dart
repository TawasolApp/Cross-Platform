// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Network error"]);
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = "Validation failed"]);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
