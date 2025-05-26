# LocationIQ API Client for Dart

A type-safe, feature-rich Dart client for the LocationIQ API. This package provides easy access to LocationIQ's geocoding, reverse geocoding, and autocomplete services with robust error handling and flexible configuration options.

[![pub package](https://img.shields.io/pub/v/location_iq.svg)](https://pub.dev/packages/location_iq)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Features

- 📍 Complete LocationIQ API coverage:
  - Forward Geocoding (Free-form, Structured, and Postal Code)
  - Reverse Geocoding
  - Address Autocomplete
- 🛡️ Type-safe API with null safety
- 🎯 Comprehensive error handling
- ⚡ Configurable timeout and HTTP client
- 📚 Extensive documentation
- 🧪 Test coverage

## Installation

```yaml
dependencies:
  location_iq: ^1.0.0
```

## Quick Start

```dart
import 'package:location_iq/location_iq.dart';

void main() async {
  final client = LocationIQClient(
    apiKey: 'your_api_key_here',
  );

  try {
    // Free-form forward geocoding
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
  }
}
```

## Usage Examples

### Forward Geocoding

#### Free-form Search
```dart
final locations = await client.forwardFreeform.search(
  query: 'Big Ben, London',
  limit: 5,
  acceptLanguage: 'en',
  addressdetails: 1,
);
```

#### Structured Search
```dart
final results = await client.forwardStructured.search(
  street: '221B Baker Street',
  city: 'London',
  country: 'United Kingdom',
  addressdetails: 1,
);
```

#### Postal Code Search
```dart
final locations = await client.forwardPostalcode.search(
  postalcode: 'SW1A 1AA',
  countrycodes: 'gb',
);
```

### Reverse Geocoding
```dart
final address = await client.reverse.reverseGeocode(
  lat: '51.5074',
  lon: '-0.1278',
  language: 'en',
);
```

### Autocomplete
```dart
final suggestions = await client.autocomplete.autocomplete(
  query: 'Bucking',
  countryCode: 'gb',
  limit: 5,
);
```

## Configuration

### Custom HTTP Client

```dart
import 'package:http/http.dart' as http;

final customClient = http.Client();
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  httpClient: customClient,
);
```

### Custom Timeout

```dart
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  timeout: Duration(seconds: 60),
);
```

### Custom Base URL

```dart
final locationIQ = LocationIQClient(
  apiKey: 'your_api_key_here',
  baseUrl: 'https://eu1.locationiq.com/v1',
);
```

## Error Handling

The library provides specific exceptions for different error scenarios:

```dart
try {
  final results = await client.forwardFreeform.search(query: 'London');
} on AuthenticationException catch (e) {
  print('API key is invalid: ${e.message}');
} on RateLimitException catch (e) {
  print('Rate limit exceeded: ${e.message}');
} on NetworkException catch (e) {
  print('Network error occurred: ${e.message}');
} on LocationIQException catch (e) {
  print('General error: ${e.message}');
}
```

Available exception types:
- `AuthenticationException` - Invalid API key
- `AuthorizationException` - Unauthorized domain
- `RateLimitException` - Rate limit exceeded
- `NetworkException` - Network-related errors
- `BadRequestException` - Invalid request parameters
- `NotFoundException` - No results found
- `ServerException` - Server-side errors
- `UnexpectedException` - Unexpected errors

## Project Structure

```
lib/
├── src/
│   ├── config/
│   │   └── api_config.dart
│   ├── core/
│   │   ├── error/
│   │   │   ├── error_handler.dart
│   │   │   └── exceptions.dart
│   │   └── http/
│   │       ├── http_client.dart
│   │       └── http_status.dart
│   ├── models/
│   │   ├── forward_geocoding_result.dart
│   │   ├── location_iq_autocomplete_result.dart
│   │   └── location_iq_reverse_result.dart
│   └── services/
│       ├── autocomplete/
│       ├── forward_geocoding/
│       └── reverse_geocoding/
└── location_iq.dart
```

## Testing

```bash
# Run all tests
dart test

# Run tests with coverage
dart test --coverage
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and migration guides.

## Support

If you find this package helpful, please consider giving it a star ⭐️ on GitHub.

For bugs, feature requests, and questions:
- Open an issue on [GitHub](https://github.com/yourusername/location_iq/issues)
- Read our [contribution guidelines](CONTRIBUTING.md)