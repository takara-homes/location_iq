import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';

/// Base class for all LocationIQ services providing common functionality
abstract class BaseLocationIQService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  BaseLocationIQService({
    required this.apiKey,
    required this.baseUrl,
    http.Client? httpClient,
    Duration? timeout,
  }) : _httpClient = LocationIQHttpClient(
         client: httpClient,
         timeout: timeout ?? Duration(milliseconds: ApiConfig.defaultTimeout),
       ) {
    _validateApiKey(apiKey);
  }

  /// Validates the API key format
  void _validateApiKey(String apiKey) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }
    if (apiKey.trim() != apiKey) {
      throw ArgumentError(
        'API key cannot contain leading or trailing whitespace',
      );
    }
    // Basic format validation - LocationIQ keys are typically alphanumeric
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(apiKey)) {
      throw ArgumentError('API key contains invalid characters');
    }
  }

  /// Validates numeric parameters
  void validateNumericParameter(
    int? value,
    String paramName, {
    int? min,
    int? max,
  }) {
    if (value == null) return;

    if (min != null && value < min) {
      throw ArgumentError('$paramName must be at least $min, got $value');
    }
    if (max != null && value > max) {
      throw ArgumentError('$paramName must be at most $max, got $value');
    }
  }

  /// Validates string parameters
  void validateStringParameter(
    String? value,
    String paramName, {
    int? maxLength,
  }) {
    if (value == null) return;

    if (value.isEmpty) {
      throw ArgumentError('$paramName cannot be empty');
    }
    if (maxLength != null && value.length > maxLength) {
      throw ArgumentError(
        '$paramName exceeds maximum length of $maxLength characters',
      );
    }
  }

  /// Validates coordinate values
  void validateCoordinate(String? lat, String? lon) {
    if (lat != null) {
      final latValue = double.tryParse(lat);
      if (latValue == null) {
        throw ArgumentError('Invalid latitude format: $lat');
      }
      if (latValue < -90 || latValue > 90) {
        throw ArgumentError(
          'Latitude must be between -90 and 90 degrees, got $latValue',
        );
      }
    }

    if (lon != null) {
      final lonValue = double.tryParse(lon);
      if (lonValue == null) {
        throw ArgumentError('Invalid longitude format: $lon');
      }
      if (lonValue < -180 || lonValue > 180) {
        throw ArgumentError(
          'Longitude must be between -180 and 180 degrees, got $lonValue',
        );
      }
    }
  }

  /// Makes an HTTP GET request with error handling
  Future<http.Response> makeRequest(Uri uri) async {
    try {
      final response = await _httpClient.get(
        uri,
        headers: ApiConfig.defaultHeaders,
      );

      if (HttpStatus.isSuccessful(response.statusCode)) {
        return response;
      }

      ErrorHandler.handleErrorResponse(response);
      throw UnexpectedException('Unexpected error occurred');
    } on NetworkException catch (e) {
      throw UnexpectedException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw UnexpectedException('Invalid response format: ${e.toString()}');
    }
  }

  /// Parses JSON response into a list
  List<T> parseListResponse<T>(
    String responseBody,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<dynamic> jsonList = json.decode(responseBody);
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Parses JSON response into a single object
  T parseObjectResponse<T>(
    String responseBody,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final Map<String, dynamic> json =
        jsonDecode(responseBody) as Map<String, dynamic>;
    return fromJson(json);
  }

  /// Builds a URI with query parameters, filtering out null values
  Uri buildUri(String endpoint, Map<String, dynamic> queryParams) {
    final filteredParams = <String, String>{};

    queryParams.forEach((key, value) {
      if (value != null) {
        filteredParams[key] = value.toString();
      }
    });

    return Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: filteredParams);
  }

  /// Disposes of resources
  void dispose() {
    _httpClient.dispose();
  }
}
