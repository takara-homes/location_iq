import 'dart:convert';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/balance/balance_result.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

/// Service for checking account balance and API usage using LocationIQ Balance API
class BalanceService extends BaseLocationIQService {
  BalanceService({
    required super.apiKey,
    required super.baseUrl,
    super.httpClient,
    super.timeout,
  });

  /// Get account balance and usage information
  ///
  /// [format] - Response format (default: 'json')
  Future<BalanceResult> getBalance({String format = 'json'}) async {
    try {
      final queryParams = {
        'key': apiKey,
        'format': format,
      };

      final uri = buildUri('/v1/balance', queryParams);
      final response = await makeRequest(uri);

      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic>) {
        return BalanceResult.fromJson(jsonData);
      } else {
        throw UnexpectedException(
          'Unexpected response format for balance request',
          statusCode: 200,
        );
      }
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to get balance information: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Check if account has sufficient balance for operations
  Future<bool> hasSufficientBalance({int minimumRequests = 100}) async {
    try {
      final balance = await getBalance();
      return balance.remainingRequests >= minimumRequests;
    } catch (e) {
      // If we can't check balance, assume insufficient
      return false;
    }
  }

  /// Get usage percentage (used requests / total requests)
  Future<double> getUsagePercentage() async {
    final balance = await getBalance();
    if (balance.totalRequests <= 0) return 0.0;

    final usedRequests = balance.totalRequests - balance.remainingRequests;
    return (usedRequests / balance.totalRequests) * 100;
  }
}
