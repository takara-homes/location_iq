// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forward_geocoding_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForwardGeocodingResult _$ForwardGeocodingResultFromJson(
  Map<String, dynamic> json,
) => ForwardGeocodingResult(
  placeId: json['place_id'] as String,
  licence: json['licence'] as String,
  osmType: json['osm_type'] as String?,
  osmId: json['osm_id'] as String?,
  boundingbox: _toDoubleList(json['boundingbox'] as List),
  lat: double.parse(json['lat'] as String),
  lon: double.parse(json['lon'] as String),
  displayName: json['display_name'] as String,
  type: json['type'] as String?,
  className: json['class_name'] as String?,
  importance: (json['importance'] as num).toDouble(),
  address: json['address'] == null
      ? null
      : LocationIQAddress.fromJson(json['address'] as Map<String, dynamic>),
  nameDetails: json['name_details'] as Map<String, dynamic>?,
  extraTags: json['extra_tags'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ForwardGeocodingResultToJson(
  ForwardGeocodingResult instance,
) => <String, dynamic>{
  'place_id': instance.placeId,
  'licence': instance.licence,
  'osm_type': instance.osmType,
  'osm_id': instance.osmId,
  'boundingbox': instance.boundingbox,
  'lat': instance.lat,
  'lon': instance.lon,
  'display_name': instance.displayName,
  'type': instance.type,
  'class_name': instance.className,
  'importance': instance.importance,
  'address': instance.address,
  'name_details': instance.nameDetails,
  'extra_tags': instance.extraTags,
};
