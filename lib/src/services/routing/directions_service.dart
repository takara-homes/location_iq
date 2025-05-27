import 'dart:convert';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/routing/directions_result.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

/// Service for route planning using LocationIQ Directions API
class DirectionsService extends BaseLocationIQService {
  DirectionsService({
    required super.apiKey,
    required super.baseUrl,
    super.httpClient,
    super.timeout,
  });

  /// Get driving directions between coordinates
  ///
  /// [coordinates] - List of coordinate pairs [longitude, latitude] for waypoints
  /// [alternatives] - Whether to return alternative routes (default: false)
  /// [steps] - Whether to return step-by-step directions (default: true)
  /// [geometries] - Geometry format: 'geojson', 'polyline', or 'polyline6' (default: 'geojson')
  /// [overview] - Overview geometry: 'full', 'simplified', or 'false' (default: 'full')
  /// [continueStrait] - Whether to force route to continue straight at waypoints (default: false)
  /// [annotations] - Additional data to include: 'duration', 'distance', 'speed' (default: false)
  Future<DirectionsResult> getDrivingDirections({
    required List<List<double>> coordinates,
    bool alternatives = false,
    bool steps = true,
    String geometries = 'geojson',
    String overview = 'full',
    bool continueStrait = false,
    bool annotations = false,
  }) async {
    return _getDirections(
      profile: 'driving',
      coordinates: coordinates,
      alternatives: alternatives,
      steps: steps,
      geometries: geometries,
      overview: overview,
      continueStrait: continueStrait,
      annotations: annotations,
    );
  }

  /// Get walking directions between coordinates
  Future<DirectionsResult> getWalkingDirections({
    required List<List<double>> coordinates,
    bool alternatives = false,
    bool steps = true,
    String geometries = 'geojson',
    String overview = 'full',
    bool continueStrait = false,
    bool annotations = false,
  }) async {
    return _getDirections(
      profile: 'foot',
      coordinates: coordinates,
      alternatives: alternatives,
      steps: steps,
      geometries: geometries,
      overview: overview,
      continueStrait: continueStrait,
      annotations: annotations,
    );
  }

  /// Get cycling directions between coordinates
  Future<DirectionsResult> getCyclingDirections({
    required List<List<double>> coordinates,
    bool alternatives = false,
    bool steps = true,
    String geometries = 'geojson',
    String overview = 'full',
    bool continueStrait = false,
    bool annotations = false,
  }) async {
    return _getDirections(
      profile: 'cycling',
      coordinates: coordinates,
      alternatives: alternatives,
      steps: steps,
      geometries: geometries,
      overview: overview,
      continueStrait: continueStrait,
      annotations: annotations,
    );
  }

  /// Internal method to get directions for any profile
  Future<DirectionsResult> _getDirections({
    required String profile,
    required List<List<double>> coordinates,
    bool alternatives = false,
    bool steps = true,
    String geometries = 'geojson',
    String overview = 'full',
    bool continueStrait = false,
    bool annotations = false,
  }) async {
    // Validate coordinates
    if (coordinates.isEmpty) {
      throw ArgumentError('At least one coordinate pair is required');
    }

    if (coordinates.length < 2) {
      throw ArgumentError(
        'At least two coordinate pairs are required for routing',
      );
    }

    for (int i = 0; i < coordinates.length; i++) {
      final coord = coordinates[i];
      if (coord.length != 2) {
        throw ArgumentError(
          'Coordinate at index $i must have exactly 2 values [longitude, latitude]',
        );
      }

      final longitude = coord[0];
      final latitude = coord[1];

      if (latitude < -90 || latitude > 90) {
        throw ArgumentError('Latitude at index $i must be between -90 and 90');
      }
      if (longitude < -180 || longitude > 180) {
        throw ArgumentError(
          'Longitude at index $i must be between -180 and 180',
        );
      }
    }

    // Format coordinates as semicolon-separated string
    final coordinatesString = coordinates
        .map((coord) => '${coord[0]},${coord[1]}')
        .join(';');

    try {
      final queryParams = {
        'key': apiKey,
        'alternatives': alternatives.toString(),
        'steps': steps.toString(),
        'geometries': geometries,
        'overview': overview,
        'continue_straight': continueStrait.toString(),
        'annotations': annotations.toString(),
      };

      final uri = buildUri('/v1/directions/$profile/$coordinatesString', queryParams);
      final response = await makeRequest(uri);

      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic>) {
        return DirectionsResult.fromJson(jsonData);
      } else {
        throw UnexpectedException(
          'Unexpected response format for directions request',
          statusCode: 200,
        );
      }
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to get directions: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get simple point-to-point driving directions
  Future<DirectionsResult> getSimpleRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    return getDrivingDirections(
      coordinates: [
        [startLongitude, startLatitude],
        [endLongitude, endLatitude],
      ],
    );
  }
}
