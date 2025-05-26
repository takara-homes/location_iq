import 'package:http/http.dart' show Client;
import 'package:location_iq/src/core/base/base_service.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class FreeFormForwardGeocodingService extends BaseLocationIQService {
  FreeFormForwardGeocodingService({
    required String apiKey,
    required String baseUrl,
    Client? httpClient,
    Duration? timeout,
  }) : super(
         apiKey: apiKey,
         baseUrl: baseUrl,
         httpClient: httpClient,
         timeout: timeout,
       );

  Future<List<ForwardGeocodingResult>> search({
    required String query,
    int? limit,
    String? viewBox,
    bool? bounded,
    int? addressDetails,
    bool? normalizecity,
    bool? extratags,
    bool? namedetails,
    bool? dedupe,
    String? email,
    Map<String, dynamic>? additionalOptions,
  }) async {
    // Parameter validation
    validateStringParameter(query, 'query', maxLength: 300);
    validateNumericParameter(limit, 'limit', min: 1, max: 50);
    validateNumericParameter(addressDetails, 'addressDetails', min: 0, max: 1);

    // Validate viewbox format if provided
    if (viewBox != null && viewBox.isNotEmpty) {
      final parts = viewBox.split(',');
      if (parts.length != 4) {
        throw ArgumentError(
          'Viewbox must contain exactly 4 comma-separated values',
        );
      }
      for (final part in parts) {
        if (double.tryParse(part) == null) {
          throw ArgumentError('Viewbox coordinates must be valid numbers');
        }
      }
    }

    final parameters = <String, dynamic>{
      'key': apiKey,
      'q': query.trim(),
      'format': 'json',
      if (limit != null) 'limit': limit,
      if (viewBox != null) 'viewbox': viewBox,
      if (bounded != null) 'bounded': bounded ? '1' : '0',
      if (addressDetails != null) 'addressdetails': addressDetails,
      if (normalizecity != null) 'normalizecity': normalizecity ? '1' : '0',
      if (extratags != null) 'extratags': extratags ? '1' : '0',
      if (namedetails != null) 'namedetails': namedetails ? '1' : '0',
      if (dedupe != null) 'dedupe': dedupe ? '1' : '0',
      if (email != null) 'email': email,
      ...?additionalOptions,
    };

    try {
      final uri = buildUri('/search', parameters);
      final response = await makeRequest(uri);

      return parseListResponse<ForwardGeocodingResult>(
        response.body,
        (json) => ForwardGeocodingResult.fromJson(json),
      );
    } catch (e) {
      if (e is LocationIQException) {
        rethrow;
      }
      throw UnexpectedException(
        'Failed to perform forward geocoding: ${e.toString()}',
      );
    }
  }
}
