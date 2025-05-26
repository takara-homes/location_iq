class HttpStatus {
  static const int ok = 200;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;

  /// Checks if the status code indicates a successful response
  static bool isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }
}
