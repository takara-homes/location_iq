import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

/// Mock HTTP client for testing
class MockHttpClient extends Mock implements http.Client {}

/// Mock response factory for creating test responses
class MockResponseFactory {
  static http.Response success(String body, {int statusCode = 200}) {
    return http.Response(body, statusCode);
  }

  static http.Response error(String body, int statusCode) {
    return http.Response(body, statusCode);
  }

  static http.Response autocompleteResponse() {
    return success('''[
      {
        "place_id": "12345",
        "licence": "test",
        "osm_type": "way",
        "osm_id": "67890",
        "lat": "40.7128",
        "lon": "-74.0060",
        "class": "place",
        "type": "city",
        "place_rank": 16,
        "importance": 0.9,
        "addresstype": "city",
        "name": "New York",
        "display_name": "New York, NY, USA",
        "boundingbox": ["40.4774", "40.9176", "-74.2591", "-73.7004"]
      }
    ]''');
  }

  static http.Response forwardGeocodingResponse() {
    return success('''[
      {
        "place_id": "12345",
        "licence": "test",
        "osm_type": "way",
        "osm_id": "67890",
        "lat": "40.7484",
        "lon": "-73.9857",
        "class": "tourism",
        "type": "attraction",
        "place_rank": 30,
        "importance": 0.8,
        "addresstype": "tourism",
        "name": "Empire State Building",
        "display_name": "Empire State Building, 350, 5th Avenue, Manhattan, New York, NY, 10118, USA",
        "boundingbox": ["40.7484", "40.7485", "-73.9858", "-73.9856"]
      }
    ]''');
  }

  static http.Response reverseGeocodingResponse() {
    return success('''{
      "place_id": "12345",
      "licence": "test",
      "osm_type": "way",
      "osm_id": "67890",
      "lat": "40.7484",
      "lon": "-73.9857",
      "class": "tourism",
      "type": "attraction",
      "place_rank": 30,
      "importance": 0.8,
      "addresstype": "tourism",
      "name": "Empire State Building",
      "display_name": "Empire State Building, 350, 5th Avenue, Manhattan, New York, NY, 10118, USA",
      "address": {
        "house_number": "350",
        "road": "5th Avenue",
        "suburb": "Manhattan",
        "city": "New York",
        "state": "NY",
        "postcode": "10118",
        "country": "USA"
      }
    }''');
  }

  static http.Response badRequestResponse() {
    return error('Bad Request: Invalid parameters', 400);
  }

  static http.Response unauthorizedResponse() {
    return error('Unauthorized: Invalid API key', 401);
  }

  static http.Response notFoundResponse() {
    return error('Not Found: No results found', 404);
  }

  static http.Response rateLimitResponse() {
    return error('Too Many Requests: Rate limit exceeded', 429);
  }

  static http.Response serverErrorResponse() {
    return error('Internal Server Error', 500);
  }
}
