import 'package:location_iq/location_iq.dart';
import 'package:test/test.dart';

void main() {
  group('LocationIQClient', () {
    late LocationIQClient client;

    setUp(() {
      client = LocationIQClient(apiKey: 'test_api_key');
    });

    tearDown(() {
      client.dispose();
    });

    test('should create client with default base URL', () {
      expect(client.baseUrl, equals('https://us1.locationiq.com/v1'));
      expect(client.apiKey, equals('test_api_key'));
    });

    test('should create client with custom base URL', () {
      final customClient = LocationIQClient(
        apiKey: 'test_key',
        baseUrl: 'https://custom.example.com/v1',
      );

      expect(customClient.baseUrl, equals('https://custom.example.com/v1'));
      customClient.dispose();
    });

    test('should cache service instances', () {
      final service1 = client.forwardFreeform;
      final service2 = client.forwardFreeform;

      expect(identical(service1, service2), isTrue);
    });

    test('should dispose all services when disposed', () {
      // Access services to create them
      client.forwardFreeform;
      client.reverse;
      client.autocomplete;

      // Should not throw
      expect(() => client.dispose(), returnsNormally);
    });

    group('API Key Validation', () {
      test('should reject empty API key', () {
        expect(
          () => LocationIQClient(apiKey: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject API key with whitespace', () {
        expect(
          () => LocationIQClient(apiKey: ' test_key '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should reject API key with invalid characters', () {
        expect(
          () => LocationIQClient(apiKey: 'test@key!'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should accept valid API key', () {
        expect(
          () => LocationIQClient(apiKey: 'valid_api_key_123'),
          returnsNormally,
        );
      });
    });
  });
}
