import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class PostalCodeService extends BaseLocationIQService {
  PostalCodeService({
    required super.apiKey,
    required super.baseUrl,
    Client? httpClient,
    Duration? timeout,
  }) : super(httpClient: httpClient, timeout: timeout);

  Future<List<ForwardGeocodingResult>> search({
    required String postalcode,
    String? countrycodes,
    String? format,
    int? addressdetails,
    int? statecode,
    String? viewbox,
    int? bounded,
    int? limit,
    String? acceptLanguage,
    int? normalizeaddress,
    int? normalizecity,
    int? postaladdress,
    int? matchquality,
    String? source,
    int? normalizeimportance,
    int? dedupe,
    int? namedetails,
    int? extratags,
    Map<String, int>? polygonOptions,
    String? jsonCallback,
  }) async {
    // Parameter validation
    validateStringParameter(postalcode, 'postalcode', maxLength: 20);
    validateStringParameter(countrycodes, 'countrycodes', maxLength: 10);
    validateNumericParameter(addressdetails, 'addressdetails', min: 0, max: 1);
    validateNumericParameter(statecode, 'statecode', min: 0, max: 1);
    validateNumericParameter(bounded, 'bounded', min: 0, max: 1);
    validateNumericParameter(limit, 'limit', min: 1, max: 50);
    validateNumericParameter(
      normalizeaddress,
      'normalizeaddress',
      min: 0,
      max: 1,
    );
    validateNumericParameter(normalizecity, 'normalizecity', min: 0, max: 1);
    validateNumericParameter(postaladdress, 'postaladdress', min: 0, max: 1);
    validateNumericParameter(matchquality, 'matchquality', min: 0, max: 1);
    validateNumericParameter(
      normalizeimportance,
      'normalizeimportance',
      min: 0,
      max: 1,
    );
    validateNumericParameter(dedupe, 'dedupe', min: 0, max: 1);
    validateNumericParameter(namedetails, 'namedetails', min: 0, max: 1);
    validateNumericParameter(extratags, 'extratags', min: 0, max: 1);

    final queryParams = <String, dynamic>{
      'key': apiKey,
      'postalcode': postalcode,
      'countrycodes': countrycodes,
      'format': format ?? ApiConfig.defaultFormat,
      'addressdetails': addressdetails ?? ApiConfig.defaultAddressDetails,
      'statecode': statecode,
      'viewbox': viewbox,
      'bounded': bounded,
      'limit': limit ?? ApiConfig.defaultLimit,
      'accept-language': acceptLanguage ?? ApiConfig.defaultLanguage,
      'normalizeaddress': normalizeaddress,
      'normalizecity': normalizecity,
      'postaladdress': postaladdress,
      'matchquality': matchquality,
      'source': source,
      'normalizeimportance': normalizeimportance,
      'dedupe': dedupe,
      'namedetails': namedetails,
      'extratags': extratags,
      'json_callback': jsonCallback,
    };

    // Add polygon options if provided
    if (polygonOptions != null) {
      polygonOptions.forEach((key, value) {
        queryParams['polygon_$key'] = value;
      });
    }

    final uri = buildUri('/search/postalcode', queryParams);
    final response = await makeRequest(uri);
    return parseListResponse(response.body, ForwardGeocodingResult.fromJson);
  }
}
