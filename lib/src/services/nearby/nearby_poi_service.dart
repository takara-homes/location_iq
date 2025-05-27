import 'dart:convert';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/nearby/nearby_poi_result.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

/// Service for finding nearby points of interest using LocationIQ Nearby API
class NearbyPOIService extends BaseLocationIQService {
  NearbyPOIService({
    required super.apiKey,
    required super.baseUrl,
    super.httpClient,
    super.timeout,
  });

  /// Find nearby points of interest
  ///
  /// [latitude] - Latitude coordinate (required)
  /// [longitude] - Longitude coordinate (required)
  /// [radius] - Search radius in meters (default: 1000, max: 50000)
  /// [tag] - Category of POI to search for (e.g., restaurant, school, hospital)
  /// [limit] - Maximum number of results (default: 10, max: 50)
  /// [format] - Response format (default: 'json')
  Future<List<NearbyPOIResult>> findNearby({
    required double latitude,
    required double longitude,
    int radius = 1000,
    String? tag,
    int limit = 10,
    String format = 'json',
  }) async {
    // Validate coordinates
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180');
    }

    // Validate radius
    if (radius <= 0 || radius > 50000) {
      throw ArgumentError('Radius must be between 1 and 50000 meters');
    }

    // Validate limit
    if (limit <= 0 || limit > 50) {
      throw ArgumentError('Limit must be between 1 and 50');
    }

    try {
      final queryParams = {
        'key': apiKey,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'radius': radius.toString(),
        if (tag != null) 'tag': tag,
        'limit': limit.toString(),
        'format': format,
      };

      final uri = buildUri('/v1/nearby', queryParams);
      final response = await makeRequest(uri);

      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        return jsonData
            .map(
              (json) => NearbyPOIResult.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw UnexpectedException(
          'Unexpected response format for nearby POI search',
          statusCode: 200,
        );
      }
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to find nearby POIs: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Find nearby restaurants
  Future<List<NearbyPOIResult>> findNearbyRestaurants({
    required double latitude,
    required double longitude,
    int radius = 1000,
    int limit = 10,
  }) async {
    return findNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      tag: 'restaurant',
      limit: limit,
    );
  }

  /// Find nearby schools
  Future<List<NearbyPOIResult>> findNearbySchools({
    required double latitude,
    required double longitude,
    int radius = 2000,
    int limit = 10,
  }) async {
    return findNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      tag: 'school',
      limit: limit,
    );
  }

  /// Find nearby hospitals
  Future<List<NearbyPOIResult>> findNearbyHospitals({
    required double latitude,
    required double longitude,
    int radius = 5000,
    int limit = 10,
  }) async {
    return findNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      tag: 'hospital',
      limit: limit,
    );
  }

  /// Find nearby gas stations
  Future<List<NearbyPOIResult>> findNearbyGasStations({
    required double latitude,
    required double longitude,
    int radius = 2000,
    int limit = 10,
  }) async {
    return findNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      tag: 'fuel',
      limit: limit,
    );
  }

  /// Find nearby ATMs
  Future<List<NearbyPOIResult>> findNearbyATMs({
    required double latitude,
    required double longitude,
    int radius = 1000,
    int limit = 10,
  }) async {
    return findNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      tag: 'atm',
      limit: limit,
    );
  }
}
