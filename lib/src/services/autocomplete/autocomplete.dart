import 'package:http/http.dart' show Client;
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/models/geocoding/autocomplete_result.dart';

class AutocompleteService extends BaseLocationIQService {
  AutocompleteService({
    required String apiKey,
    required String baseUrl,
    Client? httpClient,
  }) : super(apiKey: apiKey, baseUrl: baseUrl, httpClient: httpClient);

  Future<List<LocationIQAutocompleteResult>> suggest({
    required String query,
    String? countryCode,
    int? limit,
    String? viewBox,
    bool? bounded,
    String? tag,
    String? language,
    String? dedupe,
    int? addressDetails,
    Map<String, dynamic>? additionalOptions,
  }) async {
    // Validate query parameter
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      throw ArgumentError('query cannot be empty');
    }
    validateStringParameter(trimmedQuery, 'query', maxLength: 200);

    // Validate numeric parameters
    validateNumericParameter(limit, 'limit', min: 1, max: 50);
    validateNumericParameter(addressDetails, 'addressDetails', min: 0, max: 1);

    final parameters = <String, dynamic>{
      'key': apiKey,
      'q': trimmedQuery,
      'format': 'json',
      if (countryCode != null) 'countrycodes': countryCode,
      if (limit != null) 'limit': limit,
      if (viewBox != null) 'viewbox': viewBox,
      if (bounded != null) 'bounded': bounded ? '1' : '0',
      if (tag != null) 'tag': tag,
      if (language != null) 'accept-language': language,
      if (dedupe != null) 'dedupe': dedupe,
      if (addressDetails != null) 'addressdetails': addressDetails,
      ...?additionalOptions,
    };

    try {
      final uri = buildUri('/autocomplete', parameters);
      final response = await makeRequest(uri);

      return parseListResponse<LocationIQAutocompleteResult>(
        response.body,
        (json) => LocationIQAutocompleteResult.fromJson(json),
      );
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to perform autocomplete: ${e.toString()}',
      );
    }
  }
}
