abstract class LocationIQException implements Exception {
  final String message;
  final int? statusCode;
  final String? response;

  const LocationIQException(this.message, {this.statusCode, this.response});

  @override
  String toString() {
    if (statusCode != null) {
      return '${runtimeType.toString()} ($statusCode): $message';
    }
    return '${runtimeType.toString()}: $message';
  }
}

/// Exception thrown when there's a network-related error
class NetworkException extends LocationIQException {
  NetworkException(super.message);
}

/// Exception thrown when the API request is malformed
class BadRequestException extends LocationIQException {
  BadRequestException(super.message) : super(statusCode: 400);
}

/// Exception thrown when the API key is invalid
class AuthenticationException extends LocationIQException {
  AuthenticationException(super.message) : super(statusCode: 401);
}

/// Exception thrown when the request is made from an unauthorized domain
class AuthorizationException extends LocationIQException {
  AuthorizationException(super.message) : super(statusCode: 403);
}

/// Exception thrown when no location is found
class NotFoundException extends LocationIQException {
  NotFoundException(super.message) : super(statusCode: 404);
}

/// Exception thrown when rate limit is exceeded
class RateLimitException extends LocationIQException {
  RateLimitException(super.message) : super(statusCode: 429);
}

/// Exception thrown when server encounters an error
class ServerException extends LocationIQException {
  ServerException(super.message) : super(statusCode: 500);
}

/// Exception thrown when an unexpected status code is received
class UnexpectedException extends LocationIQException {
  UnexpectedException(super.message, {super.statusCode, super.response});
}
