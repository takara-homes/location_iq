import 'package:location_iq/src/core/base/base_service.dart';

import 'package:test/test.dart';

class TestService extends BaseLocationIQService {
  TestService({required super.apiKey, required super.baseUrl});
}

void main() {
  group('BaseLocationIQService', () {
    late TestService service;

    setUp(() {
      service = TestService(
        apiKey: 'test_api_key',
        baseUrl: 'https://test.com/v1',
      );
    });

    group('API Key Validation', () {
      test('should reject empty API key', () {
        expect(
          () => TestService(apiKey: '', baseUrl: 'https://test.com'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject API key with whitespace', () {
        expect(
          () => TestService(apiKey: ' test_key ', baseUrl: 'https://test.com'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject API key with invalid characters', () {
        expect(
          () => TestService(apiKey: 'test@key!', baseUrl: 'https://test.com'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Parameter Validation', () {
      test('validateNumericParameter should accept valid values', () {
        expect(
          () => service.validateNumericParameter(5, 'test', min: 1, max: 10),
          returnsNormally,
        );
      });

      test('validateNumericParameter should reject values below minimum', () {
        expect(
          () => service.validateNumericParameter(0, 'test', min: 1, max: 10),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validateNumericParameter should reject values above maximum', () {
        expect(
          () => service.validateNumericParameter(15, 'test', min: 1, max: 10),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('validateStringParameter should accept valid strings', () {
        expect(
          () => service.validateStringParameter('test', 'param', maxLength: 10),
          returnsNormally,
        );
      });

      test('validateStringParameter should reject empty strings', () {
        expect(
          () => service.validateStringParameter('', 'param'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'validateStringParameter should reject strings exceeding max length',
        () {
          expect(
            () => service.validateStringParameter(
              'toolongstring',
              'param',
              maxLength: 5,
            ),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    });

    group('Coordinate Validation', () {
      test('should accept valid coordinates', () {
        expect(
          () => service.validateCoordinate('51.5074', '-0.1278'),
          returnsNormally,
        );
      });

      test('should reject invalid latitude format', () {
        expect(
          () => service.validateCoordinate('invalid', '-0.1278'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject latitude out of range', () {
        expect(
          () => service.validateCoordinate('91', '-0.1278'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject longitude out of range', () {
        expect(
          () => service.validateCoordinate('51.5074', '181'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('URI Building', () {
      test('should build URI with filtered parameters', () {
        final uri = service.buildUri('/test', {
          'param1': 'value1',
          'param2': null,
          'param3': 42,
        });

        expect(uri.path, equals('/v1/test'));
        expect(uri.queryParameters['param1'], equals('value1'));
        expect(uri.queryParameters.containsKey('param2'), isFalse);
        expect(uri.queryParameters['param3'], equals('42'));
      });
    });
  });
}
