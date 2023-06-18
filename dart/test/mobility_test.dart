import 'package:mobility/mobility.dart';

void main() async {
  var provider = EfaProvider(efaVvoUrl);

  TripResponse response = await provider.queryTrip('Zellescher Weg', 'Postplatz', 'Dresden');
  for (var trip in response.trips) {
    print(trip.arrival);
  }
}
