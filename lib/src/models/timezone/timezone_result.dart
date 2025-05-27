/// Represents timezone information from LocationIQ Timezone API
class TimezoneResult {
  /// IANA timezone identifier (e.g., "America/New_York")
  final String timezone;

  /// UTC offset in seconds
  final int utcOffset;

  /// Whether daylight saving time is active
  final bool isDst;

  /// Daylight saving time offset in seconds (if applicable)
  final int? dstOffset;

  /// UTC offset formatted as string (e.g., "-05:00")
  final String utcOffsetFormatted;

  /// Timezone abbreviation (e.g., "EST", "PDT")
  final String? abbreviation;

  /// Display name of the timezone
  final String? displayName;

  /// Unix timestamp used for the query
  final int? timestamp;

  /// Local time at the queried location
  final DateTime? localTime;

  const TimezoneResult({
    required this.timezone,
    required this.utcOffset,
    required this.isDst,
    this.dstOffset,
    required this.utcOffsetFormatted,
    this.abbreviation,
    this.displayName,
    this.timestamp,
    this.localTime,
  });

  /// Creates a TimezoneResult from JSON
  factory TimezoneResult.fromJson(Map<String, dynamic> json) {
    final utcOffset = _parseInt(json['utc_offset']) ?? 0;
    final timestamp = _parseInt(json['timestamp']);

    return TimezoneResult(
      timezone: json['timezone']?.toString() ?? '',
      utcOffset: utcOffset,
      isDst: _parseBool(json['is_dst']),
      dstOffset: _parseInt(json['dst_offset']),
      utcOffsetFormatted: _formatUtcOffset(utcOffset),
      abbreviation: json['abbreviation']?.toString(),
      displayName: json['display_name']?.toString(),
      timestamp: timestamp,
      localTime: _parseLocalTime(json['local_time']),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'timezone': timezone,
      'utc_offset': utcOffset,
      'is_dst': isDst,
      if (dstOffset != null) 'dst_offset': dstOffset,
      'utc_offset_formatted': utcOffsetFormatted,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (displayName != null) 'display_name': displayName,
      if (timestamp != null) 'timestamp': timestamp,
      if (localTime != null) 'local_time': localTime!.toIso8601String(),
    };
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

  /// Helper method to safely parse boolean values
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value != 0;
    return false;
  }

  /// Helper method to parse local time
  static DateTime? _parseLocalTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Helper method to format UTC offset as string
  static String _formatUtcOffset(int offsetSeconds) {
    final hours = offsetSeconds ~/ 3600;
    final minutes = (offsetSeconds.abs() % 3600) ~/ 60;
    final sign = offsetSeconds >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Get the current local time considering the timezone offset
  DateTime getCurrentLocalTime() {
    final now = DateTime.now().toUtc();
    return now.add(Duration(seconds: utcOffset));
  }

  /// Check if the timezone observes daylight saving time
  bool observesDst() {
    return dstOffset != null && dstOffset! != 0;
  }

  @override
  String toString() {
    return 'TimezoneResult(timezone: $timezone, utcOffset: $utcOffsetFormatted, isDst: $isDst)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimezoneResult &&
        other.timezone == timezone &&
        other.utcOffset == utcOffset &&
        other.isDst == isDst;
  }

  @override
  int get hashCode {
    return Object.hash(timezone, utcOffset, isDst);
  }
}
