import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:waste_management_app/Location/Location.dart';

import '../../socket_service.dart';
import 'Driver_dash_page.dart';

class LocationEmitter {
  final socketService = SocketService();
  Timer? timer;

  void startSendingLocation(String driverId) {

    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        final locationService = Location();
        Position? pos = await locationService.getLocation();

        final data = {
          "driverId": driverId,
          "lat": pos?.latitude,
          "lng": pos?.longitude,
        };

        // socketService.emit("driver_location", data, " driver update location");

        // socketService.sendLocation(data);
        print("Location sent: $data");
      } catch (e) {
        print("Error fetching location: $e");
      }
    });
  }

  void stopSending() {
    timer?.cancel();
  }
}
