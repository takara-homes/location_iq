import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/services/timezone/timezone_service.dart';

import 'timezone_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('TimezoneService', () {
    late MockClient mockClient;
    late TimezoneService service;

    setUp(() {
      mockClient = MockClient();
      service = TimezoneService(
        apiKey: 'test-api-key',
        baseUrl: 'https://us1.locationiq.com',
        httpClient: mockClient,
      );
    });

    group('getTimezone', () {
      test(
        'should return timezone information when API call is successful',
        () async {
          // Arrange
          const responseBody = '''{
          "timezone": "America/New_York",
          "utc_offset": -18000,
          "is_dst": true,
          "dst_offset": 3600,
          "abbreviation": "EDT",
          "display_name": "Eastern Daylight Time",
          "timestamp": 1622131200,
          "local_time": "2021-05-27T12:00:00-04:00"
        }''';

          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          final result = await service.getTimezone(
            latitude: 40.7589,
            longitude: -73.9851,
          );

          // Assert
          expect(result, isA<TimezoneResult>());
          expect(result.timezone, 'America/New_York');
          expect(result.utcOffset, -18000);
          expect(result.isDst, true);
          expect(result.dstOffset, 3600);
          expect(result.abbreviation, 'EDT');
          expect(result.displayName, 'Eastern Daylight Time');
        },
      );

      test('should validate latitude range', () async {
        // Act & Assert
        expect(
          () => service.getTimezone(latitude: -91, longitude: 0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Latitude must be between -90 and 90',
            ),
          ),
        );

        expect(
          () => service.getTimezone(latitude: 91, longitude: 0),
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
          () => service.getTimezone(latitude: 0, longitude: -181),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Longitude must be between -180 and 180',
            ),
          ),
        );

        expect(
          () => service.getTimezone(latitude: 0, longitude: 181),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Longitude must be between -180 and 180',
            ),
          ),
        );
      });

      test('should include timestamp in request when provided', () async {
        // Arrange
        const responseBody =
            '{"timezone": "UTC", "utc_offset": 0, "is_dst": false}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        const timestamp = 1622131200;

        // Act
        await service.getTimezone(
          latitude: 40.7589,
          longitude: -73.9851,
          timestamp: timestamp,
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.queryParameters['timestamp'], timestamp.toString());
      });

      test('should handle API error responses', () async {
        // Arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('{"error": "Invalid API key"}', 401),
        );

        // Act & Assert
        expect(
          () => service.getTimezone(latitude: 40.7589, longitude: -73.9851),
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
          () => service.getTimezone(latitude: 40.7589, longitude: -73.9851),
          throwsA(isA<LocationIQException>()),
        );
      });
    });

    group('getCurrentTimezone', () {
      test('should call getTimezone without timestamp', () async {
        // Arrange
        const responseBody =
            '{"timezone": "UTC", "utc_offset": 0, "is_dst": false}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        await service.getCurrentTimezone(
          latitude: 40.7589,
          longitude: -73.9851,
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.queryParameters.containsKey('timestamp'), false);
      });
    });

    group('getTimezoneForDate', () {
      test('should call getTimezone with timestamp from DateTime', () async {
        // Arrange
        const responseBody =
            '{"timezone": "UTC", "utc_offset": 0, "is_dst": false}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        final dateTime = DateTime(2021, 5, 27, 12, 0, 0);
        final expectedTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

        // Act
        await service.getTimezoneForDate(
          latitude: 40.7589,
          longitude: -73.9851,
          dateTime: dateTime,
        );

        // Assert
        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;
        expect(uri.queryParameters['timestamp'], expectedTimestamp.toString());
      });
    });
  });
}
