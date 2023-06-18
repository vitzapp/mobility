import 'package:http/http.dart' as http;
import 'package:mobility/src/net.dart';

// Default request endpoints
const String defaultDepartureMonitorEndpoint = 'XSLT_DM_REQUEST';
const String defaultTripEndpoint = 'XSLT_TRIP_REQUEST2';
const String defaultStopfinderEndpoint = 'XML_STOPFINDER_REQUEST';
const String defaultCoordEndpoint = 'XML_COORD_REQUEST';

const String coordFormat = 'WGS84[DD.ddddd]';
const int coordFormatTail = 7;

/// Data provider for systems using EFA (Eleketronische Fahrplanauskunft) software.
class EfaProvider {
  final String baseUrl;

  EfaProvider(this.baseUrl);

  void queryTrip(String origin, String dest, String originCity,
      [String? destCity, DateTime? time, String deparr = 'dep']) async {
    destCity ??= originCity;
    time ??= DateTime.now();
      
    QueryParameters params = {
      'sessionID': '0',
      'requestID': '0',
      'language': 'de',
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
      'outputFormat': 'JSON',
      'coordOutputFormat': coordFormat,
      'coordOutputFormatTail': coordFormatTail
    };

    var uri = buildRequestUri(baseUrl, defaultTripEndpoint, params);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      print(response.body);
      // var json = jsonDecode(utf8.decode(response.body.codeUnits));
      // TODO: handle response
    }
  }
}
