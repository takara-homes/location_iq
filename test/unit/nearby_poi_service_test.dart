import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/services/nearby/nearby_poi_service.dart';

import 'nearby_poi_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('NearbyPOIService', () {
    late MockClient mockClient;
    late NearbyPOIService service;

    setUp(() {
      mockClient = MockClient();
      service = NearbyPOIService(
        apiKey: 'test-api-key',
        baseUrl: 'https://us1.locationiq.com',
        httpClient: mockClient,
      );
    });

    group('findNearby', () {
      test(
        'should return list of nearby POIs when API call is successful',
        () async {
          // Arrange
          const responseBody = '''[
          {
            "place_id": "12345",
            "lat": "40.7589",
            "lon": "-73.9851",
            "display_name": "Test Restaurant",
            "category": "restaurant",
            "type": "fast_food",
            "distance": 150.5,
            "importance": 0.8,
            "address": {
              "name": "Test Restaurant",
              "house_number": "123",
              "road": "Main Street",
              "city": "New York",
              "state": "NY",
              "postcode": "10001",
              "country": "USA"
            }
          }
        ]''';

          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          final result = await service.findNearby(
            latitude: 40.7589,
            longitude: -73.9851,
            radius: 1000,
            tag: 'restaurant',
          );

          // Assert
          expect(result, isA<List<NearbyPOIResult>>());
          expect(result.length, 1);
          expect(result.first.displayName, 'Test Restaurant');
          expect(result.first.category, 'restaurant');
          expect(result.first.latitude, 40.7589);
          expect(result.first.longitude, -73.9851);
          expect(result.first.distance, 150.5);
        },
      );

      test('should validate latitude range', () async {
        // Act & Assert
        expect(
          () => service.findNearby(latitude: -91, longitude: 0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Latitude must be between -90 and 90',
            ),
          ),
        );

        expect(
          () => service.findNearby(latitude: 91, longitude: 0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Latitude must be between -90 and 90',
            ),
          ),
        );
      });

      test('should validate longitude range', () async {
        // Act & Assert
        expect(
          () => service.findNearby(latitude: 0, longitude: -181),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Longitude must be between -180 and 180',
            ),
          ),
        );

        expect(
          () => service.findNearby(latitude: 0, longitude: 181),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Longitude must be between -180 and 180',
            ),
          ),
        );
      });

      test('should validate radius range', () async {
        // Act & Assert
        expect(
          () => service.findNearby(latitude: 0, longitude: 0, radius: 0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Radius must be between 1 and 50000 meters',
            ),
          ),
        );

        expect(
          () => service.findNearby(latitude: 0, longitude: 0, radius: 50001),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Radius must be between 1 and 50000 meters',
            ),
          ),
        );
      });

      test('should validate limit range', () async {
        // Act & Assert
        expect(
          () => service.findNearby(latitude: 0, longitude: 0, limit: 0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Limit must be between 1 and 50',
            ),
          ),
        );

        expect(
          () => service.findNearby(latitude: 0, longitude: 0, limit: 51),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Limit must be between 1 and 50',
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
          () => service.findNearby(latitude: 40.7589, longitude: -73.9851),
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
          () => service.findNearby(latitude: 40.7589, longitude: -73.9851),
          throwsA(isA<LocationIQException>()),
        );
      });
    });

    group('convenience methods', () {
      test(
        'findNearbyRestaurants should call findNearby with restaurant tag',
        () async {
          // Arrange
          const responseBody = '[]';
          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          await service.findNearbyRestaurants(
            latitude: 40.7589,
            longitude: -73.9851,
          );

          // Assert
          final captured = verify(
            mockClient.get(captureAny, headers: anyNamed('headers')),
          ).captured;
          final uri = captured.first as Uri;
          expect(uri.queryParameters['tag'], 'restaurant');
        },
      );

      test(
        'findNearbySchools should call findNearby with school tag',
        () async {
          // Arrange
          const responseBody = '[]';
          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          await service.findNearbySchools(
            latitude: 40.7589,
            longitude: -73.9851,
          );

          // Assert
          final captured = verify(
            mockClient.get(captureAny, headers: anyNamed('headers')),
          ).captured;
          final uri = captured.first as Uri;
          expect(uri.queryParameters['tag'], 'school');
        },
      );

      test(
        'findNearbyHospitals should call findNearby with hospital tag',
        () async {
          // Arrange
          const responseBody = '[]';
          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          await service.findNearbyHospitals(
            latitude: 40.7589,
            longitude: -73.9851,
          );

          // Assert
          final captured = verify(
            mockClient.get(captureAny, headers: anyNamed('headers')),
          ).captured;
          final uri = captured.first as Uri;
          expect(uri.queryParameters['tag'], 'hospital');
        },
      );
    });
  });
}
