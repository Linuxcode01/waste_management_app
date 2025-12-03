import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Services {
  final base = 'https://waste-managment-y3tn.onrender.com/api/v1/driver';

  Future<dynamic> getPendingRequests() async {
    var res = await http.post(Uri.parse('$base/requests/pending/'));

    var rawData = res.body;
    var data = jsonDecode(rawData);

    if (res.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  // Future<dynamic> acceptRequest(String id) async {
  //   var res = await http.post(Uri.parse('$base/requests/$id/accept/'));
  //
  //   var rawData = res.body;
  //   var data = jsonDecode(rawData);
  //
  //   if (res.statusCode == 200) {
  //     return data;
  //   } else {
  //     throw Exception(data['message']);
  //   }
  // }

  Future<bool> uploadRequest({
    required String driverId,
    required String requestId,
    required String location,
    required List<File> images,
  }) async {
    final uri = Uri.parse("https://your-server.com/upload");

    var request = http.MultipartRequest("POST", uri);

    // Send text fields
    request.fields["driverId"] = driverId;
    request.fields["requestId"] = requestId;
    request.fields["location"] = location;

    // Send each image
    for (int i = 0; i < images.length; i++) {
      final img = images[i];

      request.files.add(
        await http.MultipartFile.fromPath(
          "images[]",
          img.path,
          contentType: http.MediaType("image", "jpeg"),
        ),
      );
    }

    final response = await request.send();
    return response.statusCode == 200;
  }


  // background_service for newly submitted request

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(),
    );

    service.startService();
  }

  void onStart(ServiceInstance service) async {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position pos = await Geolocator.getCurrentPosition();

      final response = await http.get(Uri.parse(
        "https://yourapi.com/getPendingRequest?driverId=10",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["newRequest"] == true) {
          service.invoke("showPopup", {
            "requestId": data["requestId"],
            "lat": data["lat"],
            "lng": data["lng"],
            "driverLat": pos.latitude,
            "driverLng": pos.longitude,
          });
        }
      }
    });
  }



}
