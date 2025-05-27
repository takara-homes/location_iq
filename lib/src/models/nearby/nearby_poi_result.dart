import 'package:location_iq/src/models/address/address.dart';

/// Represents a nearby point of interest result from LocationIQ Nearby API
class NearbyPOIResult {
  /// Unique identifier for the POI
  final String? placeId;

  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// Display name of the POI
  final String displayName;

  /// Structured address information
  final LocationIQAddress? address;

  /// Category/type of the POI (e.g., restaurant, school, hospital)
  final String? category;

  /// Type of the POI (more specific than category)
  final String? type;

  /// Distance from the search point in meters
  final double? distance;

  /// Importance/relevance score
  final double? importance;

  /// Icon URL for the POI type
  final String? icon;

  /// Additional tags/attributes
  final Map<String, dynamic>? extratags;

  const NearbyPOIResult({
    this.placeId,
    required this.latitude,
    required this.longitude,
    required this.displayName,
    this.address,
    this.category,
    this.type,
    this.distance,
    this.importance,
    this.icon,
    this.extratags,
  });

  /// Creates a NearbyPOIResult from JSON
  factory NearbyPOIResult.fromJson(Map<String, dynamic> json) {
    return NearbyPOIResult(
      placeId: json['place_id']?.toString(),
      latitude: _parseDouble(json['lat']),
      longitude: _parseDouble(json['lon']),
      displayName: json['display_name']?.toString() ?? '',
      address: json['address'] != null
          ? LocationIQAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      category: json['category']?.toString(),
      type: json['type']?.toString(),
      distance: _parseDouble(json['distance']),
      importance: _parseDouble(json['importance']),
      icon: json['icon']?.toString(),
      extratags: json['extratags'] as Map<String, dynamic>?,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      if (placeId != null) 'place_id': placeId,
      'lat': latitude,
      'lon': longitude,
      'display_name': displayName,
      if (address != null) 'address': address!.toJson(),
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (distance != null) 'distance': distance,
      if (importance != null) 'importance': importance,
      if (icon != null) 'icon': icon,
      if (extratags != null) 'extratags': extratags,
    };
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  @override
  String toString() {
    return 'NearbyPOIResult(displayName: $displayName, category: $category, distance: ${distance?.toStringAsFixed(0)}m)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearbyPOIResult &&
        other.placeId == placeId &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return Object.hash(placeId, latitude, longitude, displayName);
  }
}
