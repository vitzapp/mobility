import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobility/src/dto.dart';
import 'package:mobility/src/net.dart';
import 'package:mobility/src/provider/params.dart';

// Default request endpoints
const String defaultDepartureMonitorEndpoint = 'XSLT_DM_REQUEST';
const String defaultTripEndpoint = 'XSLT_TRIP_REQUEST2';
const String defaultStopfinderEndpoint = 'XML_STOPFINDER_REQUEST';
const String defaultCoordEndpoint = 'XML_COORD_REQUEST';

/// Data provider for systems using EFA (Eleketronische Fahrplanauskunft) software.
class EfaProvider {
  final String baseUrl;

  EfaProvider(this.baseUrl);

  /// Get a trip information between two stops.
  /// 
  /// [origin] and [originCity] specify the city and stop name
  /// where the trip starts. [dest] specifies the destination and if [destCity]
  /// is not provided it defaults to [originCity].
  /// 
  /// [time] and [deparr] can be used to specified when the trip shoul start
  /// or end. For that [deparr] can have two values: `dep` for departure and
  /// `arr` for arrival.
  Future<TripResponse> queryTrip(String origin, String dest, String originCity,
      [String? destCity, DateTime? time, String deparr = 'dep']) async {
    destCity ??= originCity;
    time ??= DateTime.now();

    QueryParameters params = {
      'execInst': 'normal',
      'command': '',
      'ptOptionsActive': '-1',
      'itOptionsAcitve': '',
      'itDateDay': time.day,
      'itDateMonth': time.month,
      'itDateYear': time.year,
      'place_origin': originCity,
      'placeState_origin': 'empty',
      'type_origin': 'stop',
      'name_origin': origin,
      'nameState_origin': 'empty',
      'place_destination': destCity,
      'placeState_destination': 'empty',
      'type_destination': 'stop',
      'name_destination': dest,
      'nameState_destination': 'empty',
      'itdTripDateTimeDepArr': deparr,
      'itdTimeHour': time.hour,
      'itdTimeMinute': time.minute,
    };

    // FIXME: probably not the correct location names
    appendTripRequestParams(params, Location(type: LocationType.station, name: origin), Location(type: LocationType.station, name: dest));

    var uri = buildRequestUri(baseUrl, defaultTripEndpoint, params);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.body.codeUnits));

      return Future.value(
        TripResponse(
          origin: json['origin']['points']['point']['name'],
          destination: json['destination']['points']['point']['name'],
          trips: List.of((json['trips'] as List).map((singleTrip) => 
            Trip(
              depature: singleTrip['legs'].first['points'].first['dateTime']['time'],
              arrival: singleTrip['legs'].last['points'].last['dateTime']['time'], 
              duration: singleTrip['duration'], 
              interchange: int.parse(singleTrip['interchange']),
              nodes: List.of((singleTrip['legs'] as List).map((leg) => 
                Leg(
                  mode: leg['mode']['product'], 
                  line: leg['mode']['number'], 
                  direction: leg['mode']['destination'],
                  departure: Location(
                    type: LocationType.station,
                    name: leg['points'].first['nameWO'],
                  ),
                  depatureTime: leg['points'].first['dateTime']['time'],
                  arrival: Location(
                    type: LocationType.station,
                    name: leg['points'][1]['nameWO']
                  ),
                  arrivalTime: leg['points'][1]['dateTime']['time'],
                ),
              )),
            ),
          )),
        ),
      );
    }

    // fallback for errors
    return Future.value(
      TripResponse(
        origin: '$originCity, $origin', 
        destination: '$destCity, $dest',
        trips: [],
      )
    );
  }
}
