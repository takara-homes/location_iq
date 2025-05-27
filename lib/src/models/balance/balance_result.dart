/// Represents balance and usage information from LocationIQ Balance API
class BalanceResult {
  /// Current account status
  final String status;

  /// Current balance in account currency
  final double? balance;

  /// Account currency code
  final String? currency;

  /// Number of requests remaining in current billing period
  final int remainingRequests;

  /// Total number of requests allowed in current billing period
  final int totalRequests;

  /// Reset date for the billing period
  final DateTime? resetDate;

  /// Daily request limit
  final int? dailyLimit;

  /// Requests used today
  final int? dailyUsage;

  /// Account type/plan
  final String? accountType;

  const BalanceResult({
    required this.status,
    this.balance,
    this.currency,
    required this.remainingRequests,
    required this.totalRequests,
    this.resetDate,
    this.dailyLimit,
    this.dailyUsage,
    this.accountType,
  });

  /// Creates a BalanceResult from JSON
  factory BalanceResult.fromJson(Map<String, dynamic> json) {
    return BalanceResult(
      status: json['status']?.toString() ?? 'unknown',
      balance: _parseDouble(json['balance']),
      currency: json['currency']?.toString(),
      remainingRequests: _parseInt(json['remaining']) ?? 0,
      totalRequests: _parseInt(json['total']) ?? 0,
      resetDate: _parseDate(json['reset_date']),
      dailyLimit: _parseInt(json['daily_limit']),
      dailyUsage: _parseInt(json['daily_usage']),
      accountType: json['account_type']?.toString(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      'remaining': remainingRequests,
      'total': totalRequests,
      if (resetDate != null) 'reset_date': resetDate!.toIso8601String(),
      if (dailyLimit != null) 'daily_limit': dailyLimit,
      if (dailyUsage != null) 'daily_usage': dailyUsage,
      if (accountType != null) 'account_type': accountType,
    };
  }

  /// Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Helper method to safely parse integer values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Helper method to parse date values
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      // Assume Unix timestamp
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return null;
  }

  /// Check if account is active
  bool get isActive => status.toLowerCase() == 'active';

  /// Get usage percentage (0-100)
  double get usagePercentage {
    if (totalRequests <= 0) return 0.0;
    final usedRequests = totalRequests - remainingRequests;
    return (usedRequests / totalRequests) * 100;
  }

  /// Check if close to limit (>90% usage)
  bool get isCloseToLimit => usagePercentage > 90.0;

  /// Get requests used in current period
  int get requestsUsed => totalRequests - remainingRequests;

  /// Get daily usage percentage
  double? get dailyUsagePercentage {
    if (dailyLimit == null || dailyUsage == null || dailyLimit! <= 0) {
      return null;
    }
    return (dailyUsage! / dailyLimit!) * 100;
  }

  /// Check if daily limit is close to being reached
  bool get isDailyLimitClose {
    final percentage = dailyUsagePercentage;
    return percentage != null && percentage > 90.0;
  }

  /// Get formatted balance string
  String get formattedBalance {
    if (balance == null || currency == null) {
      return 'N/A';
    }
    return '${balance!.toStringAsFixed(2)} $currency';
  }

  /// Get days until reset (approximate)
  int? get daysUntilReset {
    if (resetDate == null) return null;
    final now = DateTime.now();
    final difference = resetDate!.difference(now);
    return difference.inDays;
  }

  @override
  String toString() {
    return 'BalanceResult(status: $status, remaining: $remainingRequests/$totalRequests, usage: ${usagePercentage.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BalanceResult &&
        other.status == status &&
        other.remainingRequests == remainingRequests &&
        other.totalRequests == totalRequests;
  }

  @override
  int get hashCode {
    return Object.hash(status, remainingRequests, totalRequests);
  }
}
