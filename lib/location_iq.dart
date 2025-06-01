library location_iq;

import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/services/autocomplete/autocomplete.dart';
import 'package:location_iq/src/services/balance/balance_service.dart';
import 'package:location_iq/src/services/forward_geocoding/freeform_forward_geocoding.dart';
import 'package:location_iq/src/services/forward_geocoding/postal_code_forward_geocoding.dart';
import 'package:location_iq/src/services/forward_geocoding/structured_forward_geocoding.dart';
import 'package:location_iq/src/services/nearby/nearby_poi_service.dart';
import 'package:location_iq/src/services/reverse_geocoding/reverse_geocoding.dart';
import 'package:location_iq/src/services/routing/directions_service.dart';
import 'package:location_iq/src/services/timezone/timezone_service.dart';

export 'src/models/models.dart';

/// Main client class for interacting with LocationIQ API
class LocationIQClient {
  final String apiKey;
  final String baseUrl;

  // Cached service instances
  FreeFormForwardGeocodingService? _forwardFreeform;
  StructuredGeocodingService? _forwardStructured;
  PostalCodeService? _forwardPostalcode;
  AutocompleteService? _autocomplete;
  ReverseGeocodingService? _reverse;
  NearbyPOIService? _nearbyPOI;
  TimezoneService? _timezone;
  DirectionsService? _directions;
  BalanceService? _balance;

  LocationIQClient({required this.apiKey, this.baseUrl = ApiConfig.baseUrl}) {
    _validateApiKey(apiKey);
  }

  /// Validates the API key format
  void _validateApiKey(String apiKey) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty');
    }
    if (apiKey.trim() != apiKey) {
      throw ArgumentError(
        'API key cannot contain leading or trailing whitespace',
      );
    }
    // Basic format validation - LocationIQ keys are typically alphanumeric with periods
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(apiKey)) {
      throw ArgumentError('API key contains invalid characters');
    }
  }

  /// Free-form forward geocoding service
  FreeFormForwardGeocodingService get forwardFreeform {
    return _forwardFreeform ??= FreeFormForwardGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  }

  /// Structured geocoding service
  StructuredGeocodingService get forwardStructured {
    return _forwardStructured ??= StructuredGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  }

  /// Postal code search service
  PostalCodeService get forwardPostalcode {
    return _forwardPostalcode ??= PostalCodeService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  }

  /// Autocomplete suggestion service
  AutocompleteService get autocomplete {
    return _autocomplete ??= AutocompleteService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  }

  /// Reverse geocoding service
  ReverseGeocodingService get reverse {
    return _reverse ??= ReverseGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  }

  /// Nearby points of interest service
  NearbyPOIService get nearbyPOI {
    return _nearbyPOI ??= NearbyPOIService(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Timezone information service
  TimezoneService get timezone {
    return _timezone ??= TimezoneService(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Directions and routing service
  DirectionsService get directions {
    return _directions ??= DirectionsService(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Account balance and usage service
  BalanceService get balance {
    return _balance ??= BalanceService(apiKey: apiKey, baseUrl: baseUrl);
  }

  /// Disposes all cached services and their resources
  void dispose() {
    _forwardFreeform?.dispose();
    _forwardStructured?.dispose();
    _forwardPostalcode?.dispose();
    _autocomplete?.dispose();
    _reverse?.dispose();
    _nearbyPOI?.dispose();
    _timezone?.dispose();
    _directions?.dispose();
    _balance?.dispose();
  }
}
