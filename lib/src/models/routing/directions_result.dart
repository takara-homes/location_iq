/// Represents a directions result from LocationIQ Directions API
class DirectionsResult {
  /// List of routes (usually one, more if alternatives requested)
  final List<Route> routes;

  /// List of waypoints used in the route calculation
  final List<Waypoint> waypoints;

  /// Status code of the routing request
  final String? code;

  /// Error message if routing failed
  final String? message;

  const DirectionsResult({
    required this.routes,
    required this.waypoints,
    this.code,
    this.message,
  });

  /// Creates a DirectionsResult from JSON
  factory DirectionsResult.fromJson(Map<String, dynamic> json) {
    return DirectionsResult(
      routes: (json['routes'] as List<dynamic>? ?? [])
          .map((route) => Route.fromJson(route as Map<String, dynamic>))
          .toList(),
      waypoints: (json['waypoints'] as List<dynamic>? ?? [])
          .map(
            (waypoint) => Waypoint.fromJson(waypoint as Map<String, dynamic>),
          )
          .toList(),
      code: json['code']?.toString(),
      message: json['message']?.toString(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'routes': routes.map((route) => route.toJson()).toList(),
      'waypoints': waypoints.map((waypoint) => waypoint.toJson()).toList(),
      if (code != null) 'code': code,
      if (message != null) 'message': message,
    };
  }

  /// Get the primary (fastest/shortest) route
  Route? get primaryRoute => routes.isNotEmpty ? routes.first : null;

  /// Check if the routing was successful
  bool get isSuccess => code == 'Ok' || (code == null && routes.isNotEmpty);

  @override
  String toString() {
    return 'DirectionsResult(routes: ${routes.length}, code: $code)';
  }
}

/// Represents a single route in the directions result
class Route {
  /// Total distance in meters
  final double distance;

  /// Total duration in seconds
  final double duration;

  /// Route geometry (coordinates)
  final Map<String, dynamic>? geometry;

  /// List of route legs (segments between waypoints)
  final List<RouteLeg> legs;

  /// Route weight (used for optimization)
  final double? weight;

  /// Route weight name
  final String? weightName;

  const Route({
    required this.distance,
    required this.duration,
    this.geometry,
    required this.legs,
    this.weight,
    this.weightName,
  });

  /// Creates a Route from JSON
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      distance: _parseDouble(json['distance']),
      duration: _parseDouble(json['duration']),
      geometry: json['geometry'] as Map<String, dynamic>?,
      legs: (json['legs'] as List<dynamic>? ?? [])
          .map((leg) => RouteLeg.fromJson(leg as Map<String, dynamic>))
          .toList(),
      weight: _parseDouble(json['weight']),
      weightName: json['weight_name']?.toString(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      if (geometry != null) 'geometry': geometry,
      'legs': legs.map((leg) => leg.toJson()).toList(),
      if (weight != null) 'weight': weight,
      if (weightName != null) 'weight_name': weightName,
    };
  }

  /// Get formatted duration as string (e.g., "1h 30m")
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get formatted distance as string (e.g., "15.2 km")
  String get formattedDistance {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    } else {
      return '${distance.toStringAsFixed(0)} m';
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

/// Represents a leg (segment) of a route
class RouteLeg {
  /// Distance of this leg in meters
  final double distance;

  /// Duration of this leg in seconds
  final double duration;

  /// List of steps in this leg
  final List<RouteStep> steps;

  /// Summary of this leg
  final String? summary;

  /// Weight of this leg
  final double? weight;

  const RouteLeg({
    required this.distance,
    required this.duration,
    required this.steps,
    this.summary,
    this.weight,
  });

  /// Creates a RouteLeg from JSON
  factory RouteLeg.fromJson(Map<String, dynamic> json) {
    return RouteLeg(
      distance: Route._parseDouble(json['distance']),
      duration: Route._parseDouble(json['duration']),
      steps: (json['steps'] as List<dynamic>? ?? [])
          .map((step) => RouteStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      summary: json['summary']?.toString(),
      weight: Route._parseDouble(json['weight']),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      'steps': steps.map((step) => step.toJson()).toList(),
      if (summary != null) 'summary': summary,
      if (weight != null) 'weight': weight,
    };
  }
}

/// Represents a single step in a route leg
class RouteStep {
  /// Distance of this step in meters
  final double distance;

  /// Duration of this step in seconds
  final double duration;

  /// Step geometry
  final Map<String, dynamic>? geometry;

  /// Maneuver instruction
  final RouteManeuver? maneuver;

  /// Step mode (driving, walking, etc.)
  final String? mode;

  /// Driving side
  final String? drivingSide;

  /// Name of the road/street
  final String? name;

  /// Reference identifier
  final String? ref;

  /// Pronunciation guide
  final String? pronunciation;

  /// Destinations
  final String? destinations;

  /// Weight of this step
  final double? weight;

  const RouteStep({
    required this.distance,
    required this.duration,
    this.geometry,
    this.maneuver,
    this.mode,
    this.drivingSide,
    this.name,
    this.ref,
    this.pronunciation,
    this.destinations,
    this.weight,
  });

  /// Creates a RouteStep from JSON
  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      distance: Route._parseDouble(json['distance']),
      duration: Route._parseDouble(json['duration']),
      geometry: json['geometry'] as Map<String, dynamic>?,
      maneuver: json['maneuver'] != null
          ? RouteManeuver.fromJson(json['maneuver'] as Map<String, dynamic>)
          : null,
      mode: json['mode']?.toString(),
      drivingSide: json['driving_side']?.toString(),
      name: json['name']?.toString(),
      ref: json['ref']?.toString(),
      pronunciation: json['pronunciation']?.toString(),
      destinations: json['destinations']?.toString(),
      weight: Route._parseDouble(json['weight']),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      if (geometry != null) 'geometry': geometry,
      if (maneuver != null) 'maneuver': maneuver!.toJson(),
      if (mode != null) 'mode': mode,
      if (drivingSide != null) 'driving_side': drivingSide,
      if (name != null) 'name': name,
      if (ref != null) 'ref': ref,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (destinations != null) 'destinations': destinations,
      if (weight != null) 'weight': weight,
    };
  }
}

/// Represents a maneuver instruction in a route step
class RouteManeuver {
  /// Location of the maneuver [longitude, latitude]
  final List<double> location;

  /// Bearing before the maneuver in degrees
  final int? bearingBefore;

  /// Bearing after the maneuver in degrees
  final int? bearingAfter;

  /// Type of maneuver (turn, merge, etc.)
  final String type;

  /// Modifier for the maneuver (left, right, straight, etc.)
  final String? modifier;

  /// Exit number (for roundabouts)
  final int? exit;

  /// Instruction text
  final String? instruction;

  const RouteManeuver({
    required this.location,
    this.bearingBefore,
    this.bearingAfter,
    required this.type,
    this.modifier,
    this.exit,
    this.instruction,
  });

  /// Creates a RouteManeuver from JSON
  factory RouteManeuver.fromJson(Map<String, dynamic> json) {
    return RouteManeuver(
      location: (json['location'] as List<dynamic>? ?? [])
          .map((coord) => Route._parseDouble(coord))
          .toList(),
      bearingBefore: json['bearing_before'] as int?,
      bearingAfter: json['bearing_after'] as int?,
      type: json['type']?.toString() ?? '',
      modifier: json['modifier']?.toString(),
      exit: json['exit'] as int?,
      instruction: json['instruction']?.toString(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      if (bearingBefore != null) 'bearing_before': bearingBefore,
      if (bearingAfter != null) 'bearing_after': bearingAfter,
      'type': type,
      if (modifier != null) 'modifier': modifier,
      if (exit != null) 'exit': exit,
      if (instruction != null) 'instruction': instruction,
    };
  }
}

/// Represents a waypoint in the directions result
class Waypoint {
  /// Hint for the waypoint
  final String? hint;

  /// Distance to the nearest road in meters
  final double? distance;

  /// Name of the waypoint
  final String? name;

  /// Location of the waypoint [longitude, latitude]
  final List<double> location;

  const Waypoint({this.hint, this.distance, this.name, required this.location});

  /// Creates a Waypoint from JSON
  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      hint: json['hint']?.toString(),
      distance: Route._parseDouble(json['distance']),
      name: json['name']?.toString(),
      location: (json['location'] as List<dynamic>? ?? [])
          .map((coord) => Route._parseDouble(coord))
          .toList(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      if (hint != null) 'hint': hint,
      if (distance != null) 'distance': distance,
      if (name != null) 'name': name,
      'location': location,
    };
  }
}
