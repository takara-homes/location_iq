import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/models/geocoding/reverse_result.dart';

class ReverseGeocodingService extends BaseLocationIQService {
  ReverseGeocodingService({
    required super.apiKey,
    required super.baseUrl,
    Client? httpClient,
    Duration? timeout,
  }) : super(httpClient: httpClient, timeout: timeout);

  Future<LocationIQReverseResult> reverseGeocode({
    required String lat,
    required String lon,
    String? format,
    String? language,
    String? normalizeCity,
    int? addressDetails,
    int? nameDetails,
    int? extraTags,
    int? statecode,
    String? showAlternativeNames,
    String? callback,
  }) async {
    // Parameter validation
    validateCoordinate(lat, lon);
    validateStringParameter(language, 'language', maxLength: 10);
    validateStringParameter(normalizeCity, 'normalizeCity', maxLength: 10);
    validateNumericParameter(addressDetails, 'addressDetails', min: 0, max: 1);
    validateNumericParameter(nameDetails, 'nameDetails', min: 0, max: 1);
    validateNumericParameter(extraTags, 'extraTags', min: 0, max: 1);
    validateNumericParameter(statecode, 'statecode', min: 0, max: 1);

    final queryParams = {
      'key': apiKey,
      'lat': lat,
      'lon': lon,
      'format': format ?? ApiConfig.defaultFormat,
      'accept-language': language ?? ApiConfig.defaultLanguage,
      'normalizecity': normalizeCity,
      'addressdetails': addressDetails ?? ApiConfig.defaultAddressDetails,
      'namedetails': nameDetails,
      'extratags': extraTags,
      'statecode': statecode,
      'show_alternative_names': showAlternativeNames,
      'callback': callback,
    };

    final uri = buildUri('/reverse', queryParams);
    final response = await makeRequest(uri);
    return parseObjectResponse(response.body, LocationIQReverseResult.fromJson);
  }

  /// Convenience method that provides the same interface as other services
  Future<LocationIQReverseResult> search({
    required String lat,
    required String lon,
    int? zoom,
    int? addressDetails,
    bool? extratags,
    bool? namedetails,
    String? acceptLanguage,
    Map<String, dynamic>? additionalOptions,
  }) async {
    // Validate coordinates
    validateCoordinate(lat, lon);
    validateNumericParameter(zoom, 'zoom', min: 0, max: 18);
    validateNumericParameter(addressDetails, 'addressDetails', min: 0, max: 1);

    final parameters = <String, dynamic>{
      'key': apiKey,
      'lat': lat,
      'lon': lon,
      'format': 'json',
      if (zoom != null) 'zoom': zoom,
      if (addressDetails != null) 'addressdetails': addressDetails,
      if (extratags != null) 'extratags': extratags ? '1' : '0',
      if (namedetails != null) 'namedetails': namedetails ? '1' : '0',
      if (acceptLanguage != null) 'accept-language': acceptLanguage,
      ...?additionalOptions,
    };

    try {
      final uri = buildUri('/reverse', parameters);
      final response = await makeRequest(uri);

      return parseObjectResponse<LocationIQReverseResult>(
        response.body,
        (json) => LocationIQReverseResult.fromJson(json),
      );
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to perform reverse geocoding: ${e.toString()}',
      );
    }
  }
}
