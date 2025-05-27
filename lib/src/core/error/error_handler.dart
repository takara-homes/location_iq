import 'package:http/http.dart' as http;
import 'package:location_iq/src/core/http/http_status.dart';
import 'exceptions.dart';

/// Centralized error handling for LocationIQ API responses
class ErrorHandler {
  /// Throws appropriate exception based on the HTTP response
  static void handleErrorResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    switch (statusCode) {
      case HttpStatus.badRequest:
        throw BadRequestException('Bad Request: $body');
      case HttpStatus.unauthorized:
        throw AuthenticationException('Invalid API Key: $body');
      case HttpStatus.forbidden:
        throw AuthorizationException(
          'Request made from unauthorized domain: $body',
        );
      case HttpStatus.notFound:
        throw NotFoundException('No location found: $body');
      case HttpStatus.tooManyRequests:
        throw RateLimitException('Rate limit exceeded: $body');
      case HttpStatus.internalServerError:
        throw ServerException('Internal Server Error: $body');
      default:
        throw UnexpectedException(
          'Unexpected error',
          statusCode: statusCode,
          response: body,
        );
    }
  }

  /// Handles network-related errors
  static void handleNetworkError(dynamic error) {
    throw NetworkException('Network error: ${error.toString()}');
  }
}
