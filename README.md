# LocationIQ API Client for Dart

A comprehensive, production-ready Dart client for the LocationIQ API. This package provides easy access to LocationIQ's complete suite of location services with type-safe models, comprehensive error handling, and extensive testing.

[![pub package](https://img.shields.io/pub/v/location_iq.svg)](https://pub.dev/packages/location_iq)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## 🚀 Features

### **Complete LocationIQ API Coverage**
- 🌍 **Forward Geocoding** - Convert addresses to coordinates (Free-form, Structured, and Postal Code)
- 📍 **Reverse Geocoding** - Convert coordinates to human-readable addresses
- ⚡ **Address Autocomplete** - Real-time search suggestions with partial queries
- 🏢 **Nearby Points of Interest** - Find restaurants, schools, hospitals, gas stations, etc.
- 🗺️ **Directions API** - Route planning with multiple transportation profiles
- 🕒 **Timezone API** - Get timezone information for any coordinate
- 💰 **Balance API** - Monitor account usage and remaining balance

### **Developer Experience**
- 🛡️ **Type-safe API** with null safety and comprehensive models
- 🎯 **Robust error handling** with specific exception types
- ⚡ **Configurable** timeout, HTTP client, and base URL
- 🧪 **89 unit tests** with 100% mock coverage
- 📚 **Extensive documentation** with real-world examples
- 🏗️ **Clean architecture** with service separation

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  location_iq: ^1.1.0
```

Then run:
```bash
dart pub get
```

## 🔑 Getting Your API Key

To use this package, you'll need a LocationIQ API key:

1. **Sign up** for a free account at [https://locationiq.com/](https://locationiq.com/)
2. **Verify your email** and complete the registration process
3. **Navigate to your dashboard** and find the "Access Tokens" section
4. **Copy your API key** - it will look something like `pk.12345abcdef...`

### Free Tier Limits
LocationIQ offers a generous free tier:
- **60,000 requests per month**
- **2 requests per second**
- Access to all API endpoints (geocoding, reverse geocoding, autocomplete, etc.)

### API Key Security
⚠️ **Important**: Keep your API key secure and never commit it to version control.

```dart
// ❌ Don't do this - hardcoded API key
final client = LocationIQClient(apiKey: 'pk.your_actual_key_here');

// ✅ Do this - use environment variables or secure storage
final apiKey = Platform.environment['LOCATIONIQ_API_KEY'] ?? 
               await SecureStorage.read('locationiq_api_key');
final client = LocationIQClient(apiKey: apiKey);
```

## 🚀 Quick Start

```dart
import 'package:location_iq/location_iq.dart';

void main() async {
  final client = LocationIQClient(
    apiKey: 'your_api_key_here',
  );

  try {
    // Search for a location
    final locations = await client.forwardFreeform.search(
      query: 'Buckingham Palace, London',
      limit: 5,
    );

    for (final location in locations) {
      print('Location: ${location.displayName}');
      print('Coordinates: ${location.lat}, ${location.lon}');
    }
  } on LocationIQException catch (e) {
    print('Error: ${e.message}');
  } finally {
    client.dispose(); // Clean up resources
  }
}
```

## 📖 Complete API Reference

### 🌍 Forward Geocoding

Convert addresses and place names to geographic coordinates.

#### Free-form Search
Search using natural language queries:

```dart
final locations = await client.forwardFreeform.search(
  query: 'Central Park, New York City',
  limit: 10,
  acceptLanguage: 'en',
  addressdetails: 1,
  dedupe: 1,
  extratags: 1,
  namedetails: 1,
  bounded: 1,
  viewbox: '-74.1,40.6,-73.8,40.9', // NYC bounding box
  countrycodes: 'us',
);

// Access detailed information
for (final location in locations) {
  print('Name: ${location.displayName}');
  print('Lat/Lon: ${location.lat}, ${location.lon}');
  print('Type: ${location.type}');
  print('Importance: ${location.importance}');
  if (location.address != null) {
    print('City: ${location.address!.city}');
    print('Country: ${location.address!.country}');
  }
}
```

#### Structured Search
Search using structured address components:

```dart
final results = await client.forwardStructured.search(
  street: '221B Baker Street',
  city: 'London',
  county: 'Greater London',
  state: 'England',
  country: 'United Kingdom',
  postalcode: 'NW1 6XE',
  addressdetails: 1,
  limit: 5,
);
```

#### Postal Code Search
Search specifically by postal codes:

```dart
final locations = await client.forwardPostalcode.search(
  postalcode: '10001',
  countrycodes: 'us',
  addressdetails: 1,
  limit: 10,
);
```

### 📍 Reverse Geocoding

Convert coordinates to human-readable addresses:

```dart
final address = await client.reverse.reverseGeocode(
  lat: '51.5074',
  lon: '-0.1278',
  language: 'en',
  addressdetails: 1,
  extratags: 1,
  namedetails: 1,
  zoom: 18,
);

print('Address: ${address.displayName}');
if (address.address != null) {
  print('Street: ${address.address!.road}');
  print('City: ${address.address!.city}');
  print('Postcode: ${address.address!.postcode}');
}
```

### ⚡ Address Autocomplete

Get real-time search suggestions as users type:

```dart
final suggestions = await client.autocomplete.suggest(
  query: 'Buckingham Pal',
  countryCode: 'gb',
  limit: 8,
  addressDetails: 1,
  tag: 'place:palace',
);

for (final suggestion in suggestions) {
  print('Suggestion: ${suggestion.displayName}');
  print('Place ID: ${suggestion.placeId}');
}
```

### 🏢 Nearby Points of Interest

Find nearby businesses, amenities, and landmarks:

```dart
// Find restaurants near a location
final restaurants = await client.nearbyPoi.findNearby(
  lat: 40.7589,
  lon: -73.9851, // Times Square
  tag: 'amenity:restaurant',
  radius: 1000, // 1km radius
  limit: 20,
);

// Find multiple types of amenities
final amenities = await client.nearbyPoi.findNearby(
  lat: 51.5074,
  lon: -0.1278, // London
  tag: 'amenity:hospital,amenity:school,amenity:bank',
  radius: 2000,
  limit: 50,
);

for (final poi in amenities) {
  print('Name: ${poi.displayName}');
  print('Type: ${poi.type}');
  print('Distance: ${poi.distance}m');
  print('Tags: ${poi.extratags}');
}
```

**Popular POI Categories:**
- `amenity:restaurant` - Restaurants
- `amenity:hospital` - Hospitals
- `amenity:school` - Schools
- `amenity:bank` - Banks
- `amenity:gas_station` - Gas stations
- `shop:supermarket` - Supermarkets
- `tourism:hotel` - Hotels
- `amenity:pharmacy` - Pharmacies

### 🗺️ Directions & Routing

Get detailed routing information between locations:

```dart
// Get driving directions
final route = await client.directions.getDirections(
  coordinates: [
    [-0.1278, 51.5074], // London
    [2.3522, 48.8566],  // Paris
  ],
  profile: 'driving',
  steps: true,
  geometries: 'geojson',
  overview: 'full',
  annotations: true,
);

print('Distance: ${route.distance}m');
print('Duration: ${route.duration}s');
print('Routes: ${route.routes.length}');

// Access detailed route steps
for (final routeInfo in route.routes) {
  print('Route distance: ${routeInfo.distance}m');
  print('Route duration: ${routeInfo.duration}s');
  
  if (routeInfo.legs != null) {
    for (final leg in routeInfo.legs!) {
      print('Leg: ${leg.distance}m, ${leg.duration}s');
      
      if (leg.steps != null) {
        for (final step in leg.steps!) {
          print('Step: ${step.instruction}');
          print('Distance: ${step.distance}m');
        }
      }
    }
  }
}
```

**Available Profiles:**
- `driving` - Car routing
- `walking` - Pedestrian routing
- `cycling` - Bicycle routing

### 🕒 Timezone Information

Get timezone data for any coordinate:

```dart
final timezone = await client.timezone.getTimezone(
  lat: 40.7589,
  lon: -73.9851, // New York
);

print('Timezone: ${timezone.timezone}');
print('UTC Offset: ${timezone.utcOffset}');
print('Local Time: ${timezone.localtime}');
print('DST Active: ${timezone.dst}');

// Additional timezone info
print('Country Code: ${timezone.countryCode}');
print('Country Name: ${timezone.countryName}');
print('Region: ${timezone.region}');
```

### 💰 Account Balance

Monitor your API usage and account balance:

```dart
final balance = await client.balance.getBalance();

print('Status: ${balance.status}');
print('Balance: ${balance.balance}');

if (balance.billing != null) {
  print('Plan: ${balance.billing!.name}');
  print('Requests Used: ${balance.billing!.requests}');
  if (balance.billing!.requestsRemaining != null) {
    print('Requests Remaining: ${balance.billing!.requestsRemaining}');
  }
}
```

## ⚙️ Configuration & Advanced Usage

### Custom HTTP Client

Use your own HTTP client for custom configurations:

```dart
import 'package:http/http.dart' as http;

final customClient = http.Client();
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  httpClient: customClient,
);

// Don't forget to dispose both clients
locationIQ.dispose();
customClient.close();
```

### Custom Timeout

Configure request timeouts:

```dart
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  timeout: Duration(seconds: 30), // Default is 15 seconds
);
```

### Custom Base URL

Use different LocationIQ endpoints or your own proxy:

```dart
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  baseUrl: 'https://eu1.locationiq.com/v1', // EU endpoint
  // baseUrl: 'https://us1.locationiq.com/v1', // US endpoint
);
```

### Service Access

Access individual services directly:

```dart
final client = LocationIQClient(apiKey: 'your_key');

// All services are lazy-loaded and cached
final geocoding = client.forwardFreeform;
final reverse = client.reverse;
final autocomplete = client.autocomplete;
final nearbyPoi = client.nearbyPoi;
final directions = client.directions;
final timezone = client.timezone;
final balance = client.balance;
```

## 🛡️ Error Handling

The library provides comprehensive error handling with specific exception types for different scenarios:

```dart
try {
  final results = await client.forwardFreeform.search(query: 'London');
} on AuthenticationException catch (e) {
  // Invalid API key
  print('Authentication failed: ${e.message}');
  print('Status code: ${e.statusCode}');
} on AuthorizationException catch (e) {
  // Domain not authorized for API key
  print('Authorization failed: ${e.message}');
} on RateLimitException catch (e) {
  // Rate limit exceeded
  print('Rate limit exceeded: ${e.message}');
  print('Try again later');
} on BadRequestException catch (e) {
  // Invalid request parameters
  print('Bad request: ${e.message}');
  print('Check your parameters');
} on NotFoundException catch (e) {
  // No results found
  print('No results found: ${e.message}');
} on ServerException catch (e) {
  // Server-side error (5xx)
  print('Server error: ${e.message}');
  print('Status code: ${e.statusCode}');
} on NetworkException catch (e) {
  // Network connectivity issues
  print('Network error: ${e.message}');
  print('Check your internet connection');
} on UnexpectedException catch (e) {
  // Unexpected errors
  print('Unexpected error: ${e.message}');
} on LocationIQException catch (e) {
  // Catch-all for any LocationIQ-related errors
  print('LocationIQ error: ${e.message}');
} catch (e) {
  // Non-LocationIQ errors
  print('General error: $e');
}
```

### Exception Types

| Exception | Description | Common Causes |
|-----------|-------------|---------------|
| `AuthenticationException` | Invalid API key | Wrong API key, expired key |
| `AuthorizationException` | Unauthorized domain | Domain not registered for API key |
| `RateLimitException` | Rate limit exceeded | Too many requests per minute/hour |
| `BadRequestException` | Invalid request | Missing required parameters, invalid format |
| `NotFoundException` | No results found | Location doesn't exist, typo in query |
| `ServerException` | Server-side error | LocationIQ service issues |
| `NetworkException` | Network issues | No internet, DNS resolution failure |
| `UnexpectedException` | Unexpected error | Parsing issues, unknown response format |

## 🏗️ Architecture & Models

### Client Architecture

The `LocationIQClient` provides a clean, service-oriented architecture:

```dart
LocationIQClient
├── forwardFreeform (FreeformForwardGeocodingService)
├── forwardStructured (StructuredForwardGeocodingService)  
├── forwardPostalcode (PostalCodeForwardGeocodingService)
├── reverse (ReverseGeocodingService)
├── autocomplete (AutocompleteService)
├── nearbyPoi (NearbyPoiService)
├── directions (DirectionsService)
├── timezone (TimezoneService)
└── balance (BalanceService)
```

### Data Models

All API responses are parsed into type-safe Dart models:

#### ForwardGeocodingResult
```dart
class ForwardGeocodingResult {
  final String placeId;
  final String licence;
  final String osmType;
  final String osmId;
  final List<String> boundingbox;
  final String lat;
  final String lon;
  final String displayName;
  final String type;
  final double importance;
  final Address? address;
  // ... additional fields
}
```

#### Address
```dart
class Address {
  final String? houseNumber;
  final String? road;
  final String? neighbourhood;
  final String? suburb;
  final String? city;
  final String? county;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;
  // ... additional fields
}
```

#### DirectionsResult
```dart
class DirectionsResult {
  final String code;
  final List<Route> routes;
  final List<Waypoint> waypoints;
  final double? distance;
  final double? duration;
}
```

#### NearbyPoiResult
```dart
class NearbyPoiResult {
  final String placeId;
  final String displayName;
  final String type;
  final double lat;
  final double lon;
  final double? distance;
  final Map<String, dynamic>? extratags;
  // ... additional fields
}
```

## 🧪 Testing

The package includes comprehensive testing with 89 unit tests covering all services:

```bash
# Run all tests
dart test

# Run tests with coverage
dart test --coverage

# Run specific test file
dart test test/unit/directions_service_test.dart

# Run tests in verbose mode
dart test --reporter=expanded
```

### Test Coverage

- ✅ **89 unit tests** covering all services
- ✅ **100% mock coverage** for HTTP requests
- ✅ **Error scenario testing** for all exception types
- ✅ **Parameter validation testing**
- ✅ **JSON parsing and model testing**

### Running Static Analysis

```bash
# Analyze code quality
dart analyze

# Check formatting
dart format --output=none --set-exit-if-changed .

# Generate code (if needed)
dart run build_runner build
```

## 📱 Platform Support

This package supports all platforms where Dart runs:

- ✅ **Flutter mobile** (iOS, Android)
- ✅ **Flutter web**
- ✅ **Flutter desktop** (Windows, macOS, Linux)
- ✅ **Dart CLI applications**
- ✅ **Dart server applications**

## 🔄 Migration Guide

### From v1.0.x to v1.1.0

Version 1.1.0 adds new services while maintaining backward compatibility:

```dart
// v1.0.x - Still works
final client = LocationIQClient(apiKey: 'key');
final results = await client.forwardFreeform.search(query: 'London');

// v1.1.0 - New features available
final pois = await client.nearbyPoi.findNearby(lat: 51.5, lon: -0.1, tag: 'amenity:restaurant');
final route = await client.directions.getDirections(coordinates: [[0,0], [1,1]]);
final timezone = await client.timezone.getTimezone(lat: 40.7, lon: -74.0);
final balance = await client.balance.getBalance();
```

**New in v1.1.0:**
- ➕ Nearby POI service
- ➕ Directions/routing service  
- ➕ Timezone service
- ➕ Balance monitoring service
- 🔧 Enhanced error handling
- 📚 Improved documentation

## 🏗️ Project Structure

```
lib/
├── location_iq.dart                 # Main export file
└── src/
    ├── config/
    │   └── api_config.dart          # API configuration
    ├── core/
    │   ├── base/
    │   │   └── base_service.dart    # Base service class
    │   ├── error/
    │   │   ├── error_handler.dart   # Error handling logic
    │   │   └── exceptions.dart      # Exception definitions
    │   └── http/
    │       ├── http_client.dart     # HTTP client wrapper
    │       ├── http_status.dart     # HTTP status codes
    │       └── request_builder.dart # Request building utilities
    ├── models/
    │   ├── models.dart              # Model exports
    │   ├── address/
    │   │   ├── address.dart         # Address model
    │   │   └── address.g.dart       # Generated JSON serialization
    │   ├── balance/
    │   │   └── balance_result.dart  # Balance API models
    │   ├── geocoding/
    │   │   ├── autocomplete_result.dart     # Autocomplete models
    │   │   ├── forward_geocoding_result.dart # Forward geocoding models
    │   │   └── reverse_result.dart          # Reverse geocoding models
    │   ├── nearby/
    │   │   └── nearby_poi_result.dart       # Nearby POI models
    │   ├── routing/
    │   │   └── directions_result.dart       # Directions API models
    │   └── timezone/
    │       └── timezone_result.dart         # Timezone API models
    └── services/
        ├── autocomplete/
        │   └── autocomplete.dart            # Autocomplete service
        ├── balance/
        │   └── balance_service.dart         # Balance service
        ├── forward_geocoding/
        │   ├── freeform_forward_geocoding.dart      # Free-form geocoding
        │   ├── postal_code_forward_geocoding.dart   # Postal code geocoding
        │   └── structured_forward_geocoding.dart    # Structured geocoding
        ├── nearby/
        │   └── nearby_poi_service.dart      # Nearby POI service
        ├── reverse_geocoding/
        │   └── reverse_geocoding.dart       # Reverse geocoding service
        ├── routing/
        │   └── directions_service.dart      # Directions service
        └── timezone/
            └── timezone_service.dart        # Timezone service
```

## 🤝 Contributing

Contributions are welcome! We appreciate bug reports, feature requests, and code contributions.

### Development Setup

1. **Fork the repository**
```bash
git clone https://github.com/your-username/location_iq.git
cd location_iq
```

2. **Install dependencies**
```bash
dart pub get
```

3. **Run tests**
```bash
dart test
```

4. **Run static analysis**
```bash
dart analyze
```

### Contributing Guidelines

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/amazing-feature`)
3. **Write tests** for your changes
4. **Ensure** all tests pass (`dart test`)
5. **Run** static analysis (`dart analyze`)
6. **Commit** your changes (`git commit -m 'Add amazing feature'`)
7. **Push** to the branch (`git push origin feature/amazing-feature`)
8. **Open** a Pull Request

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format code
- Add documentation for public APIs
- Write tests for new functionality

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and migration guides.

## 🆘 Support & Resources

- 📖 **Documentation**: [LocationIQ API Docs](https://docs.locationiq.com/)
- 🔑 **Get API Key**: [LocationIQ Registration](https://locationiq.com/register)
- 💰 **Pricing & Plans**: [LocationIQ Pricing](https://locationiq.com/pricing)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/takara-homes/location_iq/issues)
- 💡 **Feature Requests**: [GitHub Issues](https://github.com/takara-homes/location_iq/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/takara-homes/location_iq/discussions)

### Helpful Links

- [Get LocationIQ API Key](https://locationiq.com/register) - Sign up for free access
- [LocationIQ Dashboard](https://locationiq.com/dashboard) - Manage your API keys and usage
- [LocationIQ Pricing](https://locationiq.com/pricing) - Compare plans and features
- [LocationIQ API Documentation](https://docs.locationiq.com/) - Complete API reference
- [Dart Package Guidelines](https://dart.dev/guides/libraries/create-library-packages)

---

**If you find this package helpful, please consider:**
- ⭐ **Starring** the repository
- 🐛 **Reporting** issues you encounter
- 🚀 **Contributing** new features or improvements
- 📢 **Sharing** with other developers

Made with ❤️ for the Dart and Flutter community.