// lib/src/services/forward_geocoding/structured/structured_geocoding_service.dart
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class StructuredGeocodingService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  StructuredGeocodingService({
    required this.apiKey,
    required this.baseUrl,
    Client? httpClient,
  }) : _httpClient = LocationIQHttpClient(
          client: httpClient,
          timeout: const Duration(seconds: 30),
        );

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
    try {
      final uri = _buildUri(
        street: street,
        city: city,
        county: county,
        state: state,
        country: country,
        postalcode: postalcode,
        format: format,
        addressdetails: addressdetails,
        statecode: statecode,
        viewbox: viewbox,
        bounded: bounded,
        limit: limit,
        acceptLanguage: acceptLanguage,
        countrycodes: countrycodes,
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
  }) {
    final queryParams = {
      'key': apiKey,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (county != null) 'county': county,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (postalcode != null) 'postalcode': postalcode,
      'format': format ?? ApiConfig.defaultFormat,
      if (addressdetails != null) 'addressdetails': addressdetails.toString(),
      if (statecode != null) 'statecode': statecode.toString(),
      if (viewbox != null) 'viewbox': viewbox,
      if (bounded != null) 'bounded': bounded.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (acceptLanguage != null) 'accept-language': acceptLanguage,
      if (countrycodes != null) 'countrycodes': countrycodes,
    };

    // Add any additional options if provided
    if (additionalOptions != null) {
      additionalOptions.forEach((key, value) {
        if (value != null) {
          queryParams[key] = value.toString();
        }
      });
    }

    return Uri.parse('$baseUrl/search/structured').replace(
      queryParameters: queryParams,
    );
  }

  List<ForwardGeocodingResult> _parseResponse(String responseBody) {
    final List<dynamic> jsonList = json.decode(responseBody);
    return jsonList
        .map((json) => ForwardGeocodingResult.fromJson(json))
        .toList();
  }
}
