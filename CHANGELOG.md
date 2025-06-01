# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2025-06-01

### Fixed
- **API Key Validation** - Updated regex pattern to support LocationIQ API keys containing periods
  - Fixed validation to allow `pk.` prefix in API keys
  - Updated regular expression from `^[a-zA-Z0-9_-]+$` to `^[a-zA-Z0-9._-]+$`

### Improved
- **Package Description** - Shortened description to meet pub.dev requirements (60-180 characters)
  - Optimized package description for better discoverability on pub.dev

## [1.1.1] - 2025-05-27

### Added
- **API Key Documentation** - Comprehensive guide on obtaining LocationIQ API keys
  - Step-by-step registration instructions at https://locationiq.com/
  - Information about free tier limits (60,000 requests/month, 2 requests/second)
  - Security best practices for API key management
  - Examples of secure API key storage using environment variables
- **Enhanced README Documentation** - Complete feature overview with real-world examples
  - Detailed usage examples for all 7 LocationIQ API services
  - Platform support information (Flutter mobile/web/desktop, Dart CLI/server)
  - Migration guide from v1.0.x to v1.1.x
  - Comprehensive error handling documentation with exception types table
  - Project structure visualization and architecture overview
  - Development setup and contributing guidelines

### Improved
- **Documentation Quality** - Enhanced README with professional presentation
  - Clear section organization with emojis for better readability
  - Complete API reference with parameter explanations
  - Popular POI categories reference guide
  - Links to LocationIQ registration, dashboard, and pricing

## [1.1.0] - 2025-05-27

### Added
- **Nearby Points of Interest API** - Find restaurants, schools, hospitals, and other POIs
  - `NearbyPOIService` with specialized methods for different POI types
  - Support for radius-based search with customizable limits
  - Detailed POI information including distance, category, and address
- **Directions API** - Comprehensive route planning
  - Support for driving, walking, and cycling profiles
  - Turn-by-turn directions with detailed maneuvers
  - Route optimization and waypoint support
  - Distance and duration calculations
- **Timezone API** - Timezone information services
  - Current and historical timezone data for any coordinate
  - DST (Daylight Saving Time) support and calculations
  - UTC offset information and formatting helpers
- **Balance API** - Account monitoring and usage tracking
  - Real-time account balance checking
  - Usage percentage calculations
  - Sufficient balance validation methods
- **Enhanced Documentation**
  - Comprehensive usage examples for all new services
  - Updated README with complete feature overview
  - Improved error handling documentation
- **Robust Testing**
  - 89 comprehensive unit tests
  - Full mock coverage for all new services
  - Type-safe test data and validation

### Improved
- **API Key Validation** - Enhanced validation in LocationIQClient constructor
- **Error Handling** - More specific exception types and better error messages
- **Type Safety** - Fixed coordinate type casting issues across all services
- **Parameter Validation** - Consistent validation across all service methods

### Fixed
- Type casting issues in existing geocoding and autocomplete services
- Missing required fields in model classes
- Parameter validation edge cases
- Test data consistency issues

## [1.0.0] - 2025-05-26

### Added
- Initial stable release
- Complete LocationIQ API implementation:
  - Free-form forward geocoding
  - Structured forward geocoding
  - Postal code forward geocoding
  - Reverse geocoding
  - Address autocomplete
- Type-safe API with null safety
- Comprehensive error handling system
- Custom HTTP client support
- Configurable timeouts
- Extensive documentation
- Unit tests

### Changed
- Refactored service architecture for better maintainability
- Improved error handling with specific exception types
- Enhanced request parameter handling

## [0.2.0] - 2024-10-20

### Added
- Basic implementations of all services
- Error handling system
- Initial documentation

### Changed
- Restructured project layout
- Improved service interfaces

## [0.1.0] - 2024-10-15

### Added
- Project initialization
- Basic project structure
- Initial service implementations
- Core HTTP client wrapper