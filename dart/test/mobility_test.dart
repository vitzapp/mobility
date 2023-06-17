import 'package:mobility/mobility.dart';

void main() {
  var provider = EfaProvider('https://efa.vvo-online.de/std3');

  provider.queryTrip();
}
