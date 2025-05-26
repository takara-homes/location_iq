import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';
import 'package:location_iq/src/models/geocoding/autocomplete_result.dart';

class AutocompleteService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  AutocompleteService({
    required this.apiKey,
    required this.baseUrl,
    Client? httpClient,
  }) : _httpClient = LocationIQHttpClient(
          client: httpClient,
          timeout: const Duration(seconds: 30),
        );

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
    try {
      final uri = _buildUri(
        query: query,
        countryCode: countryCode,
        limit: limit,
        viewBox: viewBox,
        bounded: bounded,
        tag: tag,
        language: language,
        dedupe: dedupe,
        addressDetails: addressDetails,
        additionalOptions: additionalOptions,
      );

      final response = await _httpClient.get(
        uri,
        headers: ApiConfig.defaultHeaders,
      );

      if (HttpStatus.isSuccessful(response.statusCode)) {
        return _parseResponse(response.body);
      }

      ErrorHandler.handleErrorResponse(response);
      throw UnexpectedException('Unexpected error occurred');
    } on FormatException catch (e) {
      throw UnexpectedException('Invalid response format: ${e.toString()}');
    }
  }

  Uri _buildUri({
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
  }) {
    final queryParams = {
      'key': apiKey,
      'q': query,
      'format': ApiConfig.defaultFormat,
      if (countryCode != null) 'countrycodes': countryCode,
      if (limit != null) 'limit': limit.toString(),
      if (viewBox != null) 'viewbox': viewBox,
      if (bounded != null) 'bounded': bounded ? '1' : '0',
      if (tag != null) 'tag': tag,
      if (language != null) 'accept-language': language,
      if (dedupe != null) 'dedupe': dedupe,
      if (addressDetails != null) 'addressdetails': addressDetails.toString(),
    };

    // Add any additional options if provided
    if (additionalOptions != null) {
      additionalOptions.forEach((key, value) {
        if (value != null) {
          queryParams[key] = value.toString();
        }
      });
    }

    return Uri.parse('$baseUrl/autocomplete').replace(
      queryParameters: queryParams,
    );
  }

  List<LocationIQAutocompleteResult> _parseResponse(String responseBody) {
    final List<dynamic> jsonList = json.decode(responseBody) as List;
    return jsonList
        .map((json) =>
            LocationIQAutocompleteResult.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
