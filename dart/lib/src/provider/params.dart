import 'package:mobility/src/dto.dart';
import 'package:mobility/src/net.dart';

const String coordFormat = 'WGS84[DD.ddddd]';
const int coordFormatTail = 7;

const String language = 'de';

void appendLocationParams(
    QueryParameters params, Location location, String suffix) {
  if (location.type == LocationType.station) {
    params['type_$suffix'] = 'stop';
    params['name_$suffix'] = location.name;
  }
}

void appendCommonRequestParams(QueryParameters params, String outputFormat) {
  params.addAll({
    'outputFormat': outputFormat,
    'language': language,
    'stateles': '1',
    'coordOutputFormat': coordFormat,
    'coordOutputFormatTail': '$coordFormatTail'
  });
}

void appendTripRequestParams(
    QueryParameters params, Location from, Location to) {
  appendCommonRequestParams(params, 'JSON');

  params['sessionID'] = '0';
  params['requestID'] = '0';

  appendLocationParams(params, from, 'origin');
  appendLocationParams(params, to, 'destination');
}
