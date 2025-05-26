import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/core/error/error_handler.dart';
import 'package:location_iq/src/core/error/exceptions.dart';
import 'package:location_iq/src/core/http/http_client.dart';
import 'package:location_iq/src/core/http/http_status.dart';
import 'package:location_iq/src/models/geocoding/forward_geocoding_result.dart';

class PostalCodeService {
  final String apiKey;
  final String baseUrl;
  final LocationIQHttpClient _httpClient;

  PostalCodeService({
    required this.apiKey,
    required this.baseUrl,
    Client? httpClient,
  }) : _httpClient = LocationIQHttpClient(
          client: httpClient,
          timeout: const Duration(seconds: 30),
        );

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
    try {
      final uri = _buildUri(
        postalcode: postalcode,
        countrycodes: countrycodes,
        format: format,
        addressdetails: addressdetails,
        statecode: statecode,
        viewbox: viewbox,
        bounded: bounded,
        limit: limit,
        acceptLanguage: acceptLanguage,
        normalizeaddress: normalizeaddress,
        normalizecity: normalizecity,
        postaladdress: postaladdress,
        matchquality: matchquality,
        source: source,
        normalizeimportance: normalizeimportance,
        dedupe: dedupe,
        namedetails: namedetails,
        extratags: extratags,
        polygonOptions: polygonOptions,
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
      throw UnexpectedException('Unexpected error occurred');
    } on FormatException catch (e) {
      throw UnexpectedException('Invalid response format: ${e.toString()}');
    }
  }

  Uri _buildUri({
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
  }) {
    final queryParams = {
      'key': apiKey,
      'postalcode': postalcode,
      if (countrycodes != null) 'countrycodes': countrycodes,
      'format': format ?? ApiConfig.defaultFormat,
      if (addressdetails != null) 'addressdetails': addressdetails.toString(),
      if (statecode != null) 'statecode': statecode.toString(),
      if (viewbox != null) 'viewbox': viewbox,
      if (bounded != null) 'bounded': bounded.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (acceptLanguage != null) 'accept-language': acceptLanguage,
      if (normalizeaddress != null)
        'normalizeaddress': normalizeaddress.toString(),
      if (normalizecity != null) 'normalizecity': normalizecity.toString(),
      if (postaladdress != null) 'postaladdress': postaladdress.toString(),
      if (matchquality != null) 'matchquality': matchquality.toString(),
      if (source != null) 'source': source,
      if (normalizeimportance != null)
        'normalizeimportance': normalizeimportance.toString(),
      if (dedupe != null) 'dedupe': dedupe.toString(),
      if (namedetails != null) 'namedetails': namedetails.toString(),
      if (extratags != null) 'extratags': extratags.toString(),
      if (polygonOptions != null)
        ...polygonOptions.map(
          (key, value) => MapEntry('polygon_$key', value.toString()),
        ),
      if (jsonCallback != null) 'json_callback': jsonCallback,
    };

    return Uri.parse('$baseUrl/search/postalcode').replace(
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
