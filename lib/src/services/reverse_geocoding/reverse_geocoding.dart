// lib/src/services/reverse_geocoding/i_reverse_geocoding_service.dart

// lib/src/services/reverse_geocoding/reverse_geocoding_service.dart
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';
import 'package:location_iq/src/models/geocoding/reverse_result.dart';

class ReverseGeocodingService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  ReverseGeocodingService({
    required this.apiKey,
    required this.baseUrl,
    Client? httpClient,
  }) : _httpClient = LocationIQHttpClient(
          client: httpClient,
          timeout: const Duration(seconds: 30),
        );

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
    try {
      final uri = _buildUri(
        lat: lat,
        lon: lon,
        format: format,
        language: language,
        normalizeCity: normalizeCity,
        addressDetails: addressDetails,
        nameDetails: nameDetails,
        extraTags: extraTags,
        statecode: statecode,
        showAlternativeNames: showAlternativeNames,
        callback: callback,
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
  }) {
    final queryParams = {
      'key': apiKey,
      'lat': lat,
      'lon': lon,
      'format': format ?? ApiConfig.defaultFormat,
      if (language != null) 'accept-language': language,
      if (normalizeCity != null) 'normalizecity': normalizeCity,
      if (addressDetails != null) 'addressdetails': addressDetails.toString(),
      if (nameDetails != null) 'namedetails': nameDetails.toString(),
      if (extraTags != null) 'extratags': extraTags.toString(),
      if (statecode != null) 'statecode': statecode.toString(),
      if (showAlternativeNames != null)
        'show_alternative_names': showAlternativeNames,
      if (callback != null) 'callback': callback,
    };

    return Uri.parse('$baseUrl/reverse').replace(
      queryParameters: queryParams,
    );
  }

  LocationIQReverseResult _parseResponse(String responseBody) {
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return LocationIQReverseResult.fromJson(json);
  }
}
