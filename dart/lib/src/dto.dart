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
