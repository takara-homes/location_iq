library location_iq;

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

  LocationIQClient({
    required this.apiKey,
    this.baseUrl = 'https://us1.locationiq.com/v1',
  });

  /// Free-form forward geocoding service
  FreeFormForwardGeocodingService get forwardFreeform {
    final forwardGeocodingService = FreeFormForwardGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    return forwardGeocodingService;
  }

  /// Structured geocoding service
  StructuredGeocodingService get forwardStructured {
    final structuredGeocodingService = StructuredGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    return structuredGeocodingService;
  }

  /// Postal code search service
  PostalCodeService get forwardPostalcode {
    final postalCodeService = PostalCodeService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    return postalCodeService;
  }

  /// Autocomplete suggestion service
  AutocompleteService get autocomplete {
    final autocompleteService = AutocompleteService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    return autocompleteService;
  }

  /// Reverse geocoding service
  ReverseGeocodingService get reverse {
    final reverseGeocodingService = ReverseGeocodingService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    return reverseGeocodingService;
  }
}
