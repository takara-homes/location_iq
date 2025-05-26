import 'dart:async';

import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

class LocationIQHttpClient {
  final http.Client _client;
  final Duration timeout;

  LocationIQHttpClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) async {
    try {
      return await _client.get(uri, headers: headers).timeout(timeout);
    } on http.ClientException catch (e) {
      throw NetworkException('HTTP request failed: ${e.message}');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out: ${e.message}');
    } on Object catch (e) {
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}
