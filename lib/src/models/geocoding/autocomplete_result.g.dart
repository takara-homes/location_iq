// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationIQAutocompleteResult _$LocationIQAutocompleteResultFromJson(
        Map<String, dynamic> json) =>
    LocationIQAutocompleteResult(
      placeId: json['place_id'] as String,
      osmId: json['osm_id'] as String,
      osmType: json['osm_type'] as String,
      licence: json['licence'] as String,
      lat: double.parse(json['lat'] as String),
      lon: double.parse(json['lon'] as String),
      boundingbox: _toDoubleList(json['boundingbox'] as List),
      className: json['class'] as String,
      type: json['type'] as String,
      displayName: json['display_name'] as String,
      displayPlace: json['display_place'] as String,
      displayAddress: json['display_address'] as String,
      address: json['address'] == null
          ? null
          : LocationIQAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationIQAutocompleteResultToJson(
        LocationIQAutocompleteResult instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'osm_id': instance.osmId,
      'osm_type': instance.osmType,
      'licence': instance.licence,
      'lat': instance.lat,
      'lon': instance.lon,
      'boundingbox': instance.boundingbox,
      'class': instance.className,
      'type': instance.type,
      'display_name': instance.displayName,
      'display_place': instance.displayPlace,
      'display_address': instance.displayAddress,
      'address': instance.address,
    };
