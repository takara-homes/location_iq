import 'dart:convert';

import 'package:http/http.dart';
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';
import 'package:location_iq/src/core/http/request_builder.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class FreeFormForwardGeocodingService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  FreeFormForwardGeocodingService({
    required this.apiKey,
    required this.baseUrl,
    Client? httpClient,
  }) : _httpClient = LocationIQHttpClient(
          client: httpClient,
          timeout: const Duration(seconds: 30),
        );

  Future<List<ForwardGeocodingResult>> search({
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
  }) async {
    try {
      final uri = RequestBuilder.buildSearchUri(
        baseUrl,
        apiKey,
        query: query,
        format: format,
        addressdetails: addressdetails,
        limit: limit,
        acceptLanguage: acceptLanguage,
        countrycodes: countrycodes,
        viewbox: viewbox,
        bounded: bounded,
        dedupe: dedupe,
        normalizeaddress: normalizeaddress,
        normalizecity: normalizecity,
        jsonCallback: jsonCallback,
      );

      final response = await _httpClient.get(
        uri,
        headers: ApiConfig.defaultHeaders,
      );

      if (HttpStatus.isSuccessful(response.statusCode)) {
        return _parseResponse(response.body);
      }

      ErrorHandler.handleErrorResponse(response);

      // This line will never be reached due to error handling
      throw UnexpectedException('Unexpected error occurred');
    } on FormatException catch (e) {
      throw UnexpectedException('Invalid response format: ${e.toString()}');
    }
  }

  /// Parses the response body into a list of ForwardGeocodingResult objects
  List<ForwardGeocodingResult> _parseResponse(String responseBody) {
    final List<dynamic> jsonList = json.decode(responseBody);
    return jsonList
        .map((json) => ForwardGeocodingResult.fromJson(json))
        .toList();
  }
}
