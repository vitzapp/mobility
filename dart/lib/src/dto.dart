// Data transfer objects

/// GCS Point
class Point {
  double latitude;
  double longitude;

  Point({
    required this.latitude,
    required this.longitude,
  });
}

enum LocationType {
  /// Location represents a station or stop.
  station,

  /// Location represents a point of interest.
  poi,

  /// Location represents a postal address.
  address,

  /// Location represents a plain coordinate, e.g. acquired by GPS.
  coordinate,
}

class Location {
  LocationType type;
  String? name;
  Point? coordinate;

  Location({
    required this.type,
    this.name,
    this.coordinate,
  }) {
    // TODO: Remove assert and replace with the proper error message.
    if (type == LocationType.coordinate) {
      assert(coordinate != null);
    } else {
      assert(name != null);
    }
  }
}

class Leg {
  /// The type of the vehicle (e.g. bus, tram, ...)
  String mode;

  /// Line number
  String line;

  /// Final destination
  String direction;

  Location departure;
  String depatureTime;

  Location arrival;
  String arrivalTime;

  Leg({
    required this.mode,
    required this.line,
    required this.direction,
    required this.departure,
    required this.depatureTime,
    required this.arrival,
    required this.arrivalTime,
  });
}

class Trip {
  String depature;
  String arrival;
  String duration;
  int interchange;
  List<Leg> nodes;

  Trip({
    required this.depature,
    required this.arrival,
    required this.duration,
    required this.interchange,
    required this.nodes,
  });
}

class TripResponse {
  String origin;
  String destination;
  List<Trip> trips;

  TripResponse({
    required this.origin,
    required this.destination,
    required this.trips,
  });
}
