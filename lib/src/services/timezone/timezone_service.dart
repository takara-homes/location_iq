import 'dart:convert';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/timezone/timezone_result.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

/// Service for getting timezone information using LocationIQ Timezone API
class TimezoneService extends BaseLocationIQService {
  TimezoneService({
    required super.apiKey,
    required super.baseUrl,
    super.httpClient,
    super.timeout,
  });

  /// Get timezone information for a coordinate
  ///
  /// [latitude] - Latitude coordinate (required)
  /// [longitude] - Longitude coordinate (required)
  /// [timestamp] - Unix timestamp for which to get timezone info (optional, defaults to current time)
  /// [format] - Response format (default: 'json')
  Future<TimezoneResult> getTimezone({
    required double latitude,
    required double longitude,
    int? timestamp,
    String format = 'json',
  }) async {
    // Validate coordinates
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180');
    }

    try {
      final queryParams = {
        'key': apiKey,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        if (timestamp != null) 'timestamp': timestamp.toString(),
        'format': format,
      };

      final uri = buildUri('/v1/timezone', queryParams);
      final response = await makeRequest(uri);

      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic>) {
        return TimezoneResult.fromJson(jsonData);
      } else {
        throw UnexpectedException(
          'Unexpected response format for timezone request',
          statusCode: 200,
        );
      }
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to get timezone information: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get current timezone information for a coordinate
  Future<TimezoneResult> getCurrentTimezone({
    required double latitude,
    required double longitude,
  }) async {
    return getTimezone(latitude: latitude, longitude: longitude);
  }

  /// Get timezone information for a specific date/time
  Future<TimezoneResult> getTimezoneForDate({
    required double latitude,
    required double longitude,
    required DateTime dateTime,
  }) async {
    final timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    return getTimezone(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    );
  }
}
