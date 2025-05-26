import 'package:json_annotation/json_annotation.dart';
import 'package:location_iq/src/models/address/address.dart';

part 'forward_geocoding_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ForwardGeocodingResult {
  final String placeId;
  final String licence;
  final String? osmType;
  final String? osmId;
  @JsonKey(fromJson: _toDoubleList)
  final List<double> boundingbox;
  @JsonKey(fromJson: double.parse)
  final double lat;
  @JsonKey(fromJson: double.parse)
  final double lon;
  final String displayName;
  final String? type;
  final String? className;
  final double importance;
  final LocationIQAddress? address;
  final Map<String, dynamic>? nameDetails;
  final Map<String, dynamic>? extraTags;

  const ForwardGeocodingResult({
    required this.placeId,
    required this.licence,
    this.osmType,
    this.osmId,
    required this.boundingbox,
    required this.lat,
    required this.lon,
    required this.displayName,
    this.type,
    this.className,
    required this.importance,
    this.address,
    this.nameDetails,
    this.extraTags,
  });

  factory ForwardGeocodingResult.fromJson(Map<String, dynamic> json) =>
      _$ForwardGeocodingResultFromJson(json);

  Map<String, dynamic> toJson() => _$ForwardGeocodingResultToJson(this);

  @override
  String toString() =>
      'ForwardGeocodingResult(displayName: $displayName, lat: $lat, lon: $lon)';
}

List<double> _toDoubleList(List<dynamic> list) {
  return list.map((e) => double.parse(e as String)).toList();
}
