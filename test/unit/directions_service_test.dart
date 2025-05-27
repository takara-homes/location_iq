import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/services/routing/directions_service.dart';

import 'directions_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('DirectionsService', () {
    late MockClient mockClient;
    late DirectionsService service;

    setUp(() {
      mockClient = MockClient();
      service = DirectionsService(
        apiKey: 'test-api-key',
        baseUrl: 'https://us1.locationiq.com',
        httpClient: mockClient,
      );
    });

    group('getDrivingDirections', () {
      test('should return directions when API call is successful', () async {
        // Arrange
        const responseBody = '''{
          "code": "Ok",
          "routes": [{
            "distance": 15240.5,
            "duration": 1820.3,
            "geometry": {
              "type": "LineString",
              "coordinates": [[-73.9851, 40.7589], [-73.9753, 40.7614]]
            },
            "legs": [{
              "distance": 15240.5,
              "duration": 1820.3,
              "steps": [{
                "distance": 150.2,
                "duration": 25.5,
                "geometry": {
                  "type": "LineString",
                  "coordinates": [[-73.9851, 40.7589], [-73.9850, 40.7590]]
                },
                "maneuver": {
                  "location": [-73.9851, 40.7589],
                  "type": "depart",
                  "instruction": "Head north on Main Street"
                },
                "name": "Main Street"
              }]
            }]
          }],
          "waypoints": [{
            "location": [-73.9851, 40.7589],
            "name": "Start Point"
          }, {
            "location": [-73.9753, 40.7614],
            "name": "End Point"
          }]
        }''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        final result = await service.getDrivingDirections(
          coordinates: [
            [-73.9851, 40.7589],
            [-73.9753, 40.7614],
          ],
        );

        // Assert
        expect(result, isA<DirectionsResult>());
        expect(result.routes.length, 1);
        expect(result.waypoints.length, 2);
        expect(result.code, 'Ok');
        expect(result.isSuccess, true);

        final route = result.routes.first;
        expect(route.distance, 15240.5);
        expect(route.duration, 1820.3);
        expect(route.legs.length, 1);

        final leg = route.legs.first;
        expect(leg.steps.length, 1);

        final step = leg.steps.first;
        expect(step.maneuver?.type, 'depart');
        expect(step.name, 'Main Street');
      });

      test('should validate minimum coordinates requirement', () async {
        // Act & Assert
        expect(
          () => service.getDrivingDirections(coordinates: []),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'At least one coordinate pair is required',
            ),
          ),
        );

        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851, 40.7589],
            ],
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'At least two coordinate pairs are required for routing',
            ),
          ),
        );
      });

      test('should validate coordinate format', () async {
        // Act & Assert
        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851],
            ],
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('must have exactly 2 values'),
            ),
          ),
        );

        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851, 40.7589, 100],
            ],
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('must have exactly 2 values'),
            ),
          ),
        );
      });

      test('should validate coordinate values', () async {
        // Act & Assert
        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851, 91], // Invalid latitude > 90
              [-73.9753, 40.7614],
            ],
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Latitude at index 0 must be between -90 and 90'),
            ),
          ),
        );

        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [181, 40.7589], // Invalid longitude > 180
              [-73.9753, 40.7614],
            ],
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Longitude at index 0 must be between -180 and 180'),
            ),
          ),
        );
      });

      test('should handle API error responses', () async {
        // Arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('{"error": "Invalid API key"}', 401),
        );

        // Act & Assert
        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851, 40.7589],
              [-73.9753, 40.7614],
            ],
          ),
          throwsA(isA<LocationIQException>()),
        );
      });

      test('should handle network errors', () async {
        // Arrange
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => service.getDrivingDirections(
            coordinates: [
              [-73.9851, 40.7589],
              [-73.9753, 40.7614],
            ],
          ),
          throwsA(isA<LocationIQException>()),
        );
      });
    });

    group('getWalkingDirections', () {
      test('should use foot profile', () async {
        // Arrange
        const responseBody = '{"code": "Ok", "routes": [], "waypoints": []}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        await service.getWalkingDirections(
          coordinates: [
            [-73.9851, 40.7589],
            [-73.9753, 40.7614],
          ],
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.path, contains('/v1/directions/foot/'));
      });
    });

    group('getCyclingDirections', () {
      test('should use cycling profile', () async {
        // Arrange
        const responseBody = '{"code": "Ok", "routes": [], "waypoints": []}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        await service.getCyclingDirections(
          coordinates: [
            [-73.9851, 40.7589],
            [-73.9753, 40.7614],
          ],
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.path, contains('/v1/directions/cycling/'));
      });
    });

    group('getSimpleRoute', () {
      test('should convert lat/lon to coordinate pairs', () async {
        // Arrange
        const responseBody = '{"code": "Ok", "routes": [], "waypoints": []}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        await service.getSimpleRoute(
          startLatitude: 40.7589,
          startLongitude: -73.9851,
          endLatitude: 40.7614,
          endLongitude: -73.9753,
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.path, contains('-73.9851,40.7589;-73.9753,40.7614'));
      });
    });
  });
}
