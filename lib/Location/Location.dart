import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class Location {
  Future<Position?> getLocation() async {
    // permission handling

    LocationPermission permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return null; // user said NO
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getPlaceNameFromCoords(double lat, double lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    final place = placeMarks.first;
    return "${place.locality}, ${place.administrativeArea}";
  }


  Future<Future<Position?>> getCoordinate() async{
    final pos = getLocation();
    return pos;
  }

  Future<String> loadLocation() async {
    final pos = await getLocation();
    if (pos == null) {
      // no permission or failure
      return "";
    }

    final name = await getPlaceNameFromCoords(pos.latitude, pos.longitude);
    return name;
  }
}
