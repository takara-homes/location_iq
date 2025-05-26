import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/src/services/reverse_geocoding/reverse_geocoding.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

import 'reverse_geocoding_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ReverseGeocodingService', () {
    late ReverseGeocodingService service;
    late MockClient mockClient;
    const String testApiKey = 'test_api_key_12345';
    const String testBaseUrl = 'https://us1.locationiq.com/v1';

    setUp(() {
      mockClient = MockClient();
      service = ReverseGeocodingService(
        apiKey: testApiKey,
        baseUrl: testBaseUrl,
        httpClient: mockClient,
      );
    });

    group('search method', () {
      test('should successfully return reverse geocoding result', () async {
        const lat = '40.7484';
        const lon = '-73.9857';
        const responseBody = '''{
          "place_id": "12345",
          "licence": "test",
          "osm_type": "way",
          "osm_id": "67890",
          "lat": "40.7484",
          "lon": "-73.9857",
          "class": "tourism",
          "type": "attraction",
          "place_rank": 30,
          "importance": 0.8,
          "addresstype": "tourism",
          "name": "Empire State Building",
          "display_name": "Empire State Building, 350, 5th Avenue, Manhattan, New York, NY, 10118, USA",
          "address": {
            "house_number": "350",
            "road": "5th Avenue",
            "suburb": "Manhattan",
            "city": "New York",
            "state": "NY",
            "postcode": "10118",
            "country": "USA"
          }
        }''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        final result = await service.search(lat: lat, lon: lon);

        expect(result.displayName, contains('Empire State Building'));
        expect(result.lat, equals('40.7484'));
        expect(result.lon, equals('-73.9857'));
        expect(result.address, isNotNull);

        verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
      });

      test('should validate latitude parameter', () async {
        expect(
          () => service.search(lat: '', lon: '0'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: 'invalid', lon: '0'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '91', lon: '0'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '-91', lon: '0'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate longitude parameter', () async {
        expect(
          () => service.search(lat: '0', lon: ''),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '0', lon: 'invalid'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '0', lon: '181'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '0', lon: '-181'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate zoom parameter range', () async {
        expect(
          () => service.search(lat: '0', lon: '0', zoom: -1),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '0', lon: '0', zoom: 19),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate addressDetails parameter range', () async {
        expect(
          () => service.search(lat: '0', lon: '0', addressDetails: -1),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(lat: '0', lon: '0', addressDetails: 2),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should include all optional parameters in request', () async {
        const responseBody = '{}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.search(
          lat: '40.7484',
          lon: '-73.9857',
          zoom: 10,
          addressDetails: 1,
          extratags: true,
          namedetails: true,
          acceptLanguage: 'en',
          additionalOptions: {'custom': 'value'},
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['lat'], equals('40.7484'));
        expect(uri.queryParameters['lon'], equals('-73.9857'));
        expect(uri.queryParameters['zoom'], equals('10'));
        expect(uri.queryParameters['addressdetails'], equals('1'));
        expect(uri.queryParameters['extratags'], equals('1'));
        expect(uri.queryParameters['namedetails'], equals('1'));
        expect(uri.queryParameters['accept-language'], equals('en'));
        expect(uri.queryParameters['custom'], equals('value'));
      });

      test('should handle API error responses correctly', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
          () => service.search(lat: '0', lon: '0'),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('should handle network errors', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        expect(
          () => service.search(lat: '0', lon: '0'),
          throwsA(isA<UnexpectedException>()),
        );
      });

      test('should filter out null parameters', () async {
        const responseBody = '{}';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.search(
          lat: '40.7484',
          lon: '-73.9857',
          zoom: null,
          addressDetails: null,
          extratags: null,
          namedetails: null,
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['lat'], equals('40.7484'));
        expect(uri.queryParameters['lon'], equals('-73.9857'));
        expect(uri.queryParameters.containsKey('zoom'), isFalse);
        expect(uri.queryParameters.containsKey('addressdetails'), isFalse);
        expect(uri.queryParameters.containsKey('extratags'), isFalse);
        expect(uri.queryParameters.containsKey('namedetails'), isFalse);
      });
    });
  });
}
