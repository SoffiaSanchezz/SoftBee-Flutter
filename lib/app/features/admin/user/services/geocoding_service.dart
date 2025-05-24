import 'package:geocoding/geocoding.dart';

Future<bool> isValidAddress(String direccion) async {
  try {
    List<Location> locations = await locationFromAddress(direccion);
    return locations.isNotEmpty;
  } catch (e) {
    return false;
  }
}
