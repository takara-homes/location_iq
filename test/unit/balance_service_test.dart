import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/services/balance/balance_service.dart';

import 'balance_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('BalanceService', () {
    late MockClient mockClient;
    late BalanceService service;

    setUp(() {
      mockClient = MockClient();
      service = BalanceService(
        apiKey: 'test-api-key',
        baseUrl: 'https://us1.locationiq.com',
        httpClient: mockClient,
      );
    });

    group('getBalance', () {
      test(
        'should return balance information when API call is successful',
        () async {
          // Arrange
          const responseBody = '''{
          "status": "active",
          "balance": 25.50,
          "currency": "USD",
          "remaining": 8500,
          "total": 10000,
          "reset_date": "2025-06-01T00:00:00Z",
          "daily_limit": 1000,
          "daily_usage": 250,
          "account_type": "premium"
        }''';

          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          final result = await service.getBalance();

          // Assert
          expect(result, isA<BalanceResult>());
          expect(result.status, 'active');
          expect(result.balance, 25.50);
          expect(result.currency, 'USD');
          expect(result.remainingRequests, 8500);
          expect(result.totalRequests, 10000);
          expect(result.dailyLimit, 1000);
          expect(result.dailyUsage, 250);
          expect(result.accountType, 'premium');
          expect(result.isActive, true);
          expect(result.usagePercentage, 15.0); // (10000-8500)/10000 * 100
        },
      );

      test('should handle minimal response format', () async {
        // Arrange
        const responseBody = '''{
          "status": "active",
          "remaining": 500,
          "total": 1000
        }''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        final result = await service.getBalance();

        // Assert
        expect(result.status, 'active');
        expect(result.remainingRequests, 500);
        expect(result.totalRequests, 1000);
        expect(result.balance, null);
        expect(result.currency, null);
        expect(result.usagePercentage, 50.0);
      });

      test('should handle API error responses', () async {
        // Arrange
        when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('{"error": "Invalid API key"}', 401),
        );

        // Act & Assert
        expect(() => service.getBalance(), throwsA(isA<LocationIQException>()));
      });

      test('should handle network errors', () async {
        // Arrange
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => service.getBalance(), throwsA(isA<LocationIQException>()));
      });
    });

    group('hasSufficientBalance', () {
      test(
        'should return true when remaining requests exceed minimum',
        () async {
          // Arrange
          const responseBody = '''{
          "status": "active",
          "remaining": 500,
          "total": 1000
        }''';

          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          final result = await service.hasSufficientBalance(
            minimumRequests: 100,
          );

          // Assert
          expect(result, true);
        },
      );

      test(
        'should return false when remaining requests are below minimum',
        () async {
          // Arrange
          const responseBody = '''{
          "status": "active",
          "remaining": 50,
          "total": 1000
        }''';

          when(
            mockClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response(responseBody, 200));

          // Act
          final result = await service.hasSufficientBalance(
            minimumRequests: 100,
          );

          // Assert
          expect(result, false);
        },
      );

      test('should return false when API call fails', () async {
        // Arrange
        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await service.hasSufficientBalance();

        // Assert
        expect(result, false);
      });
    });

    group('getUsagePercentage', () {
      test('should calculate usage percentage correctly', () async {
        // Arrange
        const responseBody = '''{
          "status": "active",
          "remaining": 300,
          "total": 1000
        }''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        final result = await service.getUsagePercentage();

        // Assert
        expect(result, 70.0); // (1000-300)/1000 * 100
      });

      test('should return 0 when total requests is 0', () async {
        // Arrange
        const responseBody = '''{
          "status": "active",
          "remaining": 0,
          "total": 0
        }''';

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(responseBody, 200));

        // Act
        final result = await service.getUsagePercentage();

        // Assert
        expect(result, 0.0);
      });
    });
  });
}
