import 'dart:async';

import '../../socket_service.dart';
import 'Driver_dash_page.dart';

class LocationEmitter {
  final locationService = LocationService();
  final socketService = SocketService();
  Timer? timer;

  void startSendingLocation(String driverId) {

    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        final pos = await locationService.getCurrentLocation();

        final data = {
          "driverId": driverId,
          "lat": pos.latitude,
          "lng": pos.longitude,
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
