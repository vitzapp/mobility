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

  void queryTrip() async {
    QueryParameters params = {
      'sessionID': '0',
      'requestID': '0',
      'language': 'de',
      'execInst': 'normal',
      'command': '',
      'ptOptionsActive': '-1',
      'itOptionsAcitve': '',

      'outputFormat': 'JSON',
      'coordOutputFormat': coordFormat,
      'coordOutputFormatTail': coordFormatTail
    };

    var uri = buildRequestUri(baseUrl, defaultTripEndpoint, params);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      // var json = jsonDecode(utf8.decode(response.body.codeUnits));
      // TODO: handle response
    }
  }
}
