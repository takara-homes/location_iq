import 'package:location_iq/src/config/api_config.dart';

class RequestBuilder {
  static Uri buildSearchUri(
    String baseUrl,
    String apiKey, {
    required String query,
    String? format,
    int? addressdetails,
    int? limit,
    String? acceptLanguage,
    String? countrycodes,
    String? viewbox,
    int? bounded,
    int? dedupe,
    int? normalizeaddress,
    int? normalizecity,
    String? jsonCallback,
  }) {
    final queryParams = {
      'key': apiKey,
      'q': query,
      'format': format ?? ApiConfig.defaultFormat,
      'addressdetails': (addressdetails ?? ApiConfig.defaultAddressDetails)
          .toString(),
      'limit': (limit ?? ApiConfig.defaultLimit).toString(),
      'accept-language': acceptLanguage ?? ApiConfig.defaultLanguage,
      if (countrycodes != null) 'countrycodes': countrycodes,
      if (viewbox != null) 'viewbox': viewbox,
      if (bounded != null) 'bounded': bounded.toString(),
      if (dedupe != null) 'dedupe': dedupe.toString(),
      if (normalizeaddress != null)
        'normalizeaddress': normalizeaddress.toString(),
      if (normalizecity != null) 'normalizecity': normalizecity.toString(),
      if (jsonCallback != null) 'json_callback': jsonCallback,
    };

    return Uri.parse('$baseUrl/search').replace(queryParameters: queryParams);
  }
}
