import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

void main() async {
  final client = LocationIQClient(
    apiKey: 'your_api_key_here',
  );

  try {
    // Free-form Forward Geocoding Example
    print('\n--- Free-form Forward Geocoding ---');
    final locations = await client.forwardFreeform.search(
      query: 'Buckingham Palace, London',
      limit: 1,
      acceptLanguage: 'en',
    );

    if (locations.isNotEmpty) {
      final location = locations.first;
      print('Location: ${location.displayName}');
      print('Coordinates: ${location.lat}, ${location.lon}');
    }

    // Structured Forward Geocoding Example
    print('\n--- Structured Forward Geocoding ---');
    final structuredResults = await client.forwardStructured.search(
      street: 'Baker Street 221B',
      city: 'London',
      country: 'United Kingdom',
      addressdetails: 1,
    );

    if (structuredResults.isNotEmpty) {
      final result = structuredResults.first;
      print('Address: ${result.displayName}');
    }

    // Postal Code Search Example
    print('\n--- Postal Code Search ---');
    final postalResults = await client.forwardPostalcode.search(
      postalcode: 'SW1A 1AA',
      countrycodes: 'gb',
    );

    if (postalResults.isNotEmpty) {
      final result = postalResults.first;
      print('Location: ${result.displayName}');
    }

    // Reverse Geocoding Example
    print('\n--- Reverse Geocoding ---');
    final address = await client.reverse.reverseGeocode(
      lat: '51.5074',
      lon: '-0.1278',
      language: 'en',
    );

    print('Address: ${address.displayName}');

    // Autocomplete Example
    print('\n--- Autocomplete ---');
    final suggestions = await client.autocomplete.suggest(
      query: 'Bucking',
      countryCode: 'gb',
      limit: 5,
    );

    for (final suggestion in suggestions) {
      print('Suggestion: ${suggestion.displayName}');
    }
  } on AuthenticationException catch (e) {
    print('Authentication Error: ${e.message}');
  } on RateLimitException catch (e) {
    print('Rate Limit Error: ${e.message}');
  } on NetworkException catch (e) {
    print('Network Error: ${e.message}');
  } on LocationIQException catch (e) {
    print('LocationIQ Error: ${e.message}');
  }
}
