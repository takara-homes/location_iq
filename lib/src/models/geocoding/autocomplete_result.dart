import 'package:json_annotation/json_annotation.dart';
import '../address/address.dart';

part 'autocomplete_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LocationIQAutocompleteResult {
  final String placeId;
  final String osmId;
  final String osmType;
  final String licence;
  @JsonKey(fromJson: double.parse)
  final double lat;
  @JsonKey(fromJson: double.parse)
  final double lon;
  @JsonKey(fromJson: _toDoubleList)
  final List<double> boundingbox;
  @JsonKey(name: 'class')
  final String className;
  final String type;
  final String displayName;
  final String displayPlace;
  final String displayAddress;
  final LocationIQAddress? address;

  LocationIQAutocompleteResult({
    required this.placeId,
    required this.osmId,
    required this.osmType,
    required this.licence,
    required this.lat,
    required this.lon,
    required this.boundingbox,
    required this.className,
    required this.type,
    required this.displayName,
    required this.displayPlace,
    required this.displayAddress,
    this.address,
  });

  factory LocationIQAutocompleteResult.fromJson(Map<String, dynamic> json) =>
      _$LocationIQAutocompleteResultFromJson(json);

  Map<String, dynamic> toJson() => _$LocationIQAutocompleteResultToJson(this);
}

List<double> _toDoubleList(List<dynamic> list) {
  return list.map((e) => double.parse(e as String)).toList();
}
