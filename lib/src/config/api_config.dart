class ApiConfig {
  static const String baseUrl = 'https://us1.locationiq.com/v1';
  static const int defaultTimeout = 30000; // milliseconds
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
  };
  static const String defaultFormat = 'json';
  static const String defaultLanguage = 'en';
  static const int defaultLimit = 10;
  static const int defaultAddressDetails = 0;
  static const int defaultBounded = 0;
  static const int defaultDedupe = 1;
  static const int defaultNormalizeAddress = 0;
  static const int defaultNormalizeCity = 0;
}
