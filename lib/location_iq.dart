library location_iq;

import 'package:location_iq/src/config/api_config.dart';
import 'package:location_iq/src/services/autocomplete/autocomplete.dart';
import 'package:location_iq/src/services/forward_geocoding/freeform_forward_geocoding.dart';

import 'package:location_iq/src/services/forward_geocoding/postal_code_forward_geocoding.dart';
import 'package:location_iq/src/services/forward_geocoding/structured_forward_geocoding.dart';
import 'package:location_iq/src/services/reverse_geocoding/reverse_geocoding.dart';

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

  LocationIQClient({required this.apiKey, this.baseUrl = ApiConfig.baseUrl});

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

  /// Disposes all cached services and their resources
  void dispose() {
    _forwardFreeform?.dispose();
    _forwardStructured?.dispose();
    _forwardPostalcode?.dispose();
    _autocomplete?.dispose();
    _reverse?.dispose();
  }
}
