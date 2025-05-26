import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LocationIQAddress {
  final String? houseNumber;
  final String? road;
  final String? neighbourhood;
  final String? suburb;
  final String? city;
  final String? county;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? postcode;

  LocationIQAddress({
    this.houseNumber,
    this.road,
    this.neighbourhood,
    this.suburb,
    this.city,
    this.county,
    this.state,
    this.country,
    this.countryCode,
    this.postcode,
  });

  factory LocationIQAddress.fromJson(Map<String, dynamic> json) =>
      _$LocationIQAddressFromJson(json);

  Map<String, dynamic> toJson() => _$LocationIQAddressToJson(this);
}
