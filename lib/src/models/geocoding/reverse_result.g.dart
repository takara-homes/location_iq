// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationIQReverseResult _$LocationIQReverseResultFromJson(
        Map<String, dynamic> json) =>
    LocationIQReverseResult(
      placeId: json['place_id'] as String,
      licence: json['licence'] as String,
      osmType: json['osm_type'] as String,
      osmId: json['osm_id'] as String,
      lat: double.parse(json['lat'] as String),
      lon: double.parse(json['lon'] as String),
      displayName: json['display_name'] as String,
      address:
          LocationIQAddress.fromJson(json['address'] as Map<String, dynamic>),
      boundingbox: _toDoubleList(json['boundingbox'] as List),
    );

Map<String, dynamic> _$LocationIQReverseResultToJson(
        LocationIQReverseResult instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'licence': instance.licence,
      'osm_type': instance.osmType,
      'osm_id': instance.osmId,
      'lat': instance.lat,
      'lon': instance.lon,
      'display_name': instance.displayName,
      'address': instance.address,
      'boundingbox': instance.boundingbox,
    };
