import 'package:json_annotation/json_annotation.dart';
import '../address/address.dart';

part 'reverse_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LocationIQReverseResult {
  final String placeId;
  final String licence;
  final String osmType;
  final String osmId;
  @JsonKey(fromJson: double.parse)
  final double lat;
  @JsonKey(fromJson: double.parse)
  final double lon;
  final String displayName;
  final LocationIQAddress address;
  @JsonKey(fromJson: _toDoubleList)
  final List<double> boundingbox;

  LocationIQReverseResult({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.address,
    required this.boundingbox,
  });

  factory LocationIQReverseResult.fromJson(Map<String, dynamic> json) =>
      _$LocationIQReverseResultFromJson(json);

  Map<String, dynamic> toJson() => _$LocationIQReverseResultToJson(this);
}

List<double> _toDoubleList(List<dynamic> list) {
  return list.map((e) => double.parse(e as String)).toList();
}
