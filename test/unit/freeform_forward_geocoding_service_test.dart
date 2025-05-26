import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/src/services/forward_geocoding/freeform_forward_geocoding.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

import 'freeform_forward_geocoding_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('FreeFormForwardGeocodingService', () {
    late FreeFormForwardGeocodingService service;
    late MockClient mockClient;
    const String testApiKey = 'test_api_key_12345';
    const String testBaseUrl = 'https://us1.locationiq.com/v1';

    setUp(() {
      mockClient = MockClient();
      service = FreeFormForwardGeocodingService(
        apiKey: testApiKey,
        baseUrl: testBaseUrl,
        httpClient: mockClient,
      );
    });

    group('search method', () {
      test('should successfully return forward geocoding results', () async {
        const query = 'Empire State Building, New York';
        const responseBody = '''[
          {
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
            "boundingbox": ["40.7484", "40.7485", "-73.9858", "-73.9856"]
          }
        ]''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        final results = await service.search(query: query);

        expect(results, hasLength(1));
        expect(results.first.displayName, contains('Empire State Building'));
        expect(results.first.lat, equals('40.7484'));
        expect(results.first.lon, equals('-73.9857'));

        verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
      });

      test('should validate query parameter is not empty', () async {
        expect(() => service.search(query: ''), throwsA(isA<ArgumentError>()));

        expect(
          () => service.search(query: '   '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'should validate query length does not exceed 300 characters',
        () async {
          final longQuery = 'a' * 301;

          expect(
            () => service.search(query: longQuery),
            throwsA(isA<ArgumentError>()),
          );
        },
      );

      test('should validate limit parameter range', () async {
        expect(
          () => service.search(query: 'test', limit: 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(query: 'test', limit: 51),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate addressDetails parameter range', () async {
        expect(
          () => service.search(query: 'test', addressDetails: -1),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(query: 'test', addressDetails: 2),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate viewbox format', () async {
        expect(
          () => service.search(query: 'test', viewBox: 'invalid'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.search(query: 'test', viewBox: '1,2,3'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should include all optional parameters in request', () async {
        const responseBody = '[]';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.search(
          query: 'test query',
          limit: 10,
          viewBox: '-74.1,40.7,-73.9,40.8',
          bounded: true,
          addressDetails: 1,
          normalizecity: true,
          extratags: true,
          namedetails: true,
          dedupe: true,
          email: 'test@example.com',
          additionalOptions: {'custom': 'value'},
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['q'], equals('test query'));
        expect(uri.queryParameters['limit'], equals('10'));
        expect(uri.queryParameters['viewbox'], equals('-74.1,40.7,-73.9,40.8'));
        expect(uri.queryParameters['bounded'], equals('1'));
        expect(uri.queryParameters['addressdetails'], equals('1'));
        expect(uri.queryParameters['normalizecity'], equals('1'));
        expect(uri.queryParameters['extratags'], equals('1'));
        expect(uri.queryParameters['namedetails'], equals('1'));
        expect(uri.queryParameters['dedupe'], equals('1'));
        expect(uri.queryParameters['email'], equals('test@example.com'));
        expect(uri.queryParameters['custom'], equals('value'));
      });

      test('should handle API error responses correctly', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Bad Request', 400));

        expect(
          () => service.search(query: 'test'),
          throwsA(isA<BadRequestException>()),
        );
      });

      test('should handle network errors', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        expect(
          () => service.search(query: 'test'),
          throwsA(isA<UnexpectedException>()),
        );
      });

      test('should filter out null parameters', () async {
        const responseBody = '[]';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.search(
          query: 'test',
          limit: null,
          viewBox: null,
          bounded: null,
          addressDetails: null,
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['q'], equals('test'));
        expect(uri.queryParameters.containsKey('limit'), isFalse);
        expect(uri.queryParameters.containsKey('viewbox'), isFalse);
        expect(uri.queryParameters.containsKey('bounded'), isFalse);
        expect(uri.queryParameters.containsKey('addressdetails'), isFalse);
      });
    });
  });
}
