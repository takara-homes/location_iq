import 'package:location_iq/location_iq.dart';
import 'package:location_iq/src/core/error/exceptions.dart';

void main() async {
  final client = LocationIQClient(apiKey: 'your_api_key_here');

  try {
    // Free-form Forward Geocoding Example
    print('\n--- Free-form Forward Geocoding ---');
    final locations = await client.forwardFreeform.search(
      query: 'Buckingham Palace, London',
      limit: 1,
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

    // Nearby POI Example
    print('\n--- Nearby Points of Interest ---');
    final nearbyRestaurants = await client.nearbyPOI.findNearbyRestaurants(
      latitude: 51.5074,
      longitude: -0.1278,
      radius: 1000,
      limit: 5,
    );

    for (final restaurant in nearbyRestaurants) {
      print('Restaurant: ${restaurant.displayName}');
      if (restaurant.distance != null) {
        print('  Distance: ${restaurant.distance!.toStringAsFixed(0)}m');
      }
    }

    // Timezone Example
    print('\n--- Timezone Information ---');
    final timezone = await client.timezone.getCurrentTimezone(
      latitude: 51.5074,
      longitude: -0.1278,
    );

    print('Timezone: ${timezone.timezone}');
    print('UTC Offset: ${timezone.utcOffsetFormatted}');
    print('Is DST: ${timezone.isDst}');

    // Directions Example
    print('\n--- Driving Directions ---');
    final directions = await client.directions.getSimpleRoute(
      startLatitude: 51.5074,
      startLongitude: -0.1278,
      endLatitude: 51.5033,
      endLongitude: -0.1195,
    );

    if (directions.primaryRoute != null) {
      final route = directions.primaryRoute!;
      print('Distance: ${route.formattedDistance}');
      print('Duration: ${route.formattedDuration}');

      // Print turn-by-turn directions
      for (final leg in route.legs) {
        for (final step in leg.steps) {
          final instruction = step.maneuver?.instruction ?? 'Continue';
          print('  ${instruction} (${step.distance.toStringAsFixed(0)}m)');
        }
      }
    }

    // Balance Check Example
    print('\n--- Account Balance ---');
    final balance = await client.balance.getBalance();
    print('Status: ${balance.status}');
    print(
      'Remaining Requests: ${balance.remainingRequests}/${balance.totalRequests}',
    );
    print('Usage: ${balance.usagePercentage.toStringAsFixed(1)}%');

    if (balance.balance != null) {
      print('Account Balance: ${balance.formattedBalance}');
    }

    // Check if account has sufficient balance
    final hasSufficientBalance = await client.balance.hasSufficientBalance(
      minimumRequests: 100,
    );
    print('Has sufficient balance (>100 requests): $hasSufficientBalance');
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
