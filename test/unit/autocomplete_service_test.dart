import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/src/services/autocomplete/autocomplete.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

import 'autocomplete_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('AutocompleteService', () {
    late AutocompleteService service;
    late MockClient mockClient;
    const String testApiKey = 'test_api_key_12345';
    const String testBaseUrl = 'https://us1.locationiq.com/v1';

    setUp(() {
      mockClient = MockClient();
      service = AutocompleteService(
        apiKey: testApiKey,
        baseUrl: testBaseUrl,
        httpClient: mockClient,
      );
    });

    group('Constructor validation', () {
      // API key validation has been removed - all API keys are now accepted
      test('should accept any API key format', () {
        expect(
          () => AutocompleteService(apiKey: '', baseUrl: testBaseUrl),
          returnsNormally,
        );
        expect(
          () => AutocompleteService(
            apiKey: ' invalid_key ',
            baseUrl: testBaseUrl,
          ),
          returnsNormally,
        );
        expect(
          () =>
              AutocompleteService(apiKey: 'invalid@key#', baseUrl: testBaseUrl),
          returnsNormally,
        );
      });
    });

    group('suggest method', () {
      test('should successfully return autocomplete results', () async {
        const query = 'New York';
        const responseBody = '''[
          {
            "place_id": "12345",
            "licence": "test",
            "osm_type": "way",
            "osm_id": "67890",
            "lat": "40.7128",
            "lon": "-74.0060",
            "class": "place",
            "type": "city",
            "place_rank": 16,
            "importance": 0.9,
            "addresstype": "city",
            "name": "New York",
            "display_name": "New York, NY, USA",
            "display_place": "New York",
            "display_address": "NY, USA",
            "boundingbox": ["40.4774", "40.9176", "-74.2591", "-73.7004"]
          }
        ]''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        final results = await service.suggest(query: query);

        expect(results, hasLength(1));
        expect(results.first.displayName, equals('New York, NY, USA'));
        expect(results.first.lat, equals(40.7128));
        expect(results.first.lon, equals(-74.0060));

        verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
      });

      test('should validate query parameter is not empty', () async {
        expect(() => service.suggest(query: ''), throwsA(isA<ArgumentError>()));

        expect(
          () => service.suggest(query: '   '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'should validate query length does not exceed 200 characters',
        () async {
          final longQuery = 'a' * 201;

          expect(
            () => service.suggest(query: longQuery),
            throwsA(isA<ArgumentError>()),
          );
        },
      );

      test('should validate limit parameter range', () async {
        expect(
          () => service.suggest(query: 'test', limit: 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.suggest(query: 'test', limit: 51),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should validate addressDetails parameter range', () async {
        expect(
          () => service.suggest(query: 'test', addressDetails: -1),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => service.suggest(query: 'test', addressDetails: 2),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle API error responses correctly', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(
          () => service.suggest(query: 'test'),
          throwsA(isA<AuthenticationException>()),
        );
      });

      test('should handle network errors', () async {
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        expect(
          () => service.suggest(query: 'test'),
          throwsA(isA<UnexpectedException>()),
        );
      });

      test('should include all optional parameters in request', () async {
        const responseBody = '[]';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.suggest(
          query: 'test',
          countryCode: 'US',
          limit: 10,
          viewBox: '-74.1,-40.9,-73.9,40.8',
          bounded: true,
          tag: 'place:city',
          language: 'en',
          dedupe: '1',
          addressDetails: 1,
          additionalOptions: {'custom': 'value'},
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['q'], equals('test'));
        expect(uri.queryParameters['countrycodes'], equals('US'));
        expect(uri.queryParameters['limit'], equals('10'));
        expect(
          uri.queryParameters['viewbox'],
          equals('-74.1,-40.9,-73.9,40.8'),
        );
        expect(uri.queryParameters['bounded'], equals('1'));
        expect(uri.queryParameters['tag'], equals('place:city'));
        expect(uri.queryParameters['accept-language'], equals('en'));
        expect(uri.queryParameters['dedupe'], equals('1'));
        expect(uri.queryParameters['addressdetails'], equals('1'));
        expect(uri.queryParameters['custom'], equals('value'));
      });

      test('should filter out null parameters', () async {
        const responseBody = '[]';
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        await service.suggest(
          query: 'test',
          countryCode: null,
          limit: null,
          viewBox: null,
          bounded: null,
        );

        final captured = verify(
          mockClient.get(captureAny, headers: anyNamed('headers')),
        ).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['q'], equals('test'));
        expect(uri.queryParameters.containsKey('countrycodes'), isFalse);
        expect(uri.queryParameters.containsKey('limit'), isFalse);
        expect(uri.queryParameters.containsKey('viewbox'), isFalse);
        expect(uri.queryParameters.containsKey('bounded'), isFalse);
      });
    });
  });
}
