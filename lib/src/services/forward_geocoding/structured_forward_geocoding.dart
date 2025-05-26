import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class StructuredGeocodingService extends BaseLocationIQService {
  StructuredGeocodingService({
    required super.apiKey,
    required super.baseUrl,
    Client? httpClient,
    Duration? timeout,
  }) : super(httpClient: httpClient, timeout: timeout);

  Future<List<ForwardGeocodingResult>> search({
    String? street,
    String? city,
    String? county,
    String? state,
    String? country,
    String? postalcode,
    String? format,
    int? addressdetails,
    int? statecode,
    String? viewbox,
    int? bounded,
    int? limit,
    String? acceptLanguage,
    String? countrycodes,
    Map<String, dynamic>? additionalOptions,
  }) async {
    // Parameter validation
    validateStringParameter(street, 'street', maxLength: 100);
    validateStringParameter(city, 'city', maxLength: 100);
    validateStringParameter(county, 'county', maxLength: 100);
    validateStringParameter(state, 'state', maxLength: 100);
    validateStringParameter(country, 'country', maxLength: 100);
    validateStringParameter(postalcode, 'postalcode', maxLength: 20);
    validateNumericParameter(addressdetails, 'addressdetails', min: 0, max: 1);
    validateNumericParameter(statecode, 'statecode', min: 0, max: 1);
    validateNumericParameter(bounded, 'bounded', min: 0, max: 1);
    validateNumericParameter(limit, 'limit', min: 1, max: 50);

    final queryParams = {
      'key': apiKey,
      'street': street,
      'city': city,
      'county': county,
      'state': state,
      'country': country,
      'postalcode': postalcode,
      'format': format ?? ApiConfig.defaultFormat,
      'addressdetails': addressdetails ?? ApiConfig.defaultAddressDetails,
      'statecode': statecode,
      'viewbox': viewbox,
      'bounded': bounded,
      'limit': limit ?? ApiConfig.defaultLimit,
      'accept-language': acceptLanguage ?? ApiConfig.defaultLanguage,
      'countrycodes': countrycodes,
      ...?additionalOptions,
    };

    final uri = buildUri('/search/structured', queryParams);
    final response = await makeRequest(uri);
    return parseListResponse(response.body, ForwardGeocodingResult.fromJson);
  }
}
