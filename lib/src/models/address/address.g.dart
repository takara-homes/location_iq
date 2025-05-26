// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationIQAddress _$LocationIQAddressFromJson(Map<String, dynamic> json) =>
    LocationIQAddress(
      houseNumber: json['house_number'] as String?,
      road: json['road'] as String?,
      neighbourhood: json['neighbourhood'] as String?,
      suburb: json['suburb'] as String?,
      city: json['city'] as String?,
      county: json['county'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      postcode: json['postcode'] as String?,
    );

Map<String, dynamic> _$LocationIQAddressToJson(LocationIQAddress instance) =>
    <String, dynamic>{
      'house_number': instance.houseNumber,
      'road': instance.road,
      'neighbourhood': instance.neighbourhood,
      'suburb': instance.suburb,
      'city': instance.city,
      'county': instance.county,
      'state': instance.state,
      'country': instance.country,
      'country_code': instance.countryCode,
      'postcode': instance.postcode,
    };
