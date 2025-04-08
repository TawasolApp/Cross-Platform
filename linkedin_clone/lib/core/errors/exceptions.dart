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

class TokenException implements Exception {
  final String message;
  TokenException(this.message);
  @override
  String toString() => "TokenException: $message";
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => "NotFoundException: $message";
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => "UnauthorizedException: $message";
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}
