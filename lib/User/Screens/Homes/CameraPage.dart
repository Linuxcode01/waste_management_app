import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/User_services.dart';
import '../../../socket_service.dart';

class CameraPage{
  final ImagePicker _picker = ImagePicker();
  final socketService = SocketService();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _note = TextEditingController();
  String? selectedWasteType = "dry waste";
  Position? pos;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("user_data");

    if (data == null) return null;

    final jsonData = jsonDecode(data);
    return jsonData["token"];
  }

  // ============================
  // 🔥 FETCH USER LOCATION
  // ============================
  Future<void> _fetchLocation(
    BuildContext context,
    void Function(void Function()) setState,
  ) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      //_currentPosition = await Geolocator.getCurrentPosition();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location permission denied")));
        return;
      }

      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos!.latitude,
        pos!.longitude,
      );

      final place = placemarks.first;
      final formatted =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";

      setState(() => _address.text = formatted);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fetch location")));
    }
  }


  Future<void> show(BuildContext context) async {
    List<File> images = [];



    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    submitReport() async {
      var res = await UserServices().sendReport(
        images: images,
        latitude: pos!.latitude,
        longitude: pos!.longitude,
        type: selectedWasteType ?? "dry waste",
        token: token,
        address: _address.text,
        weight: _weight.text,
        notes: _note.text,
      );

      if (res['success'] == true) {

        // 🔥 Send realtime update to driver
        socketService.socket.emit("new_report", {
          "postId" : res['report']['_id'],
          "images": images.map((e) => e.path.split('/').last).toList(),
          "lat": pos!.latitude,
          "lng": pos!.longitude,
          "address": _address.text,
          "type": selectedWasteType,
          "weight": _weight.text,
          "notes": _note.text,
          "createdAt": DateTime.now().toIso8601String(),
        });


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Report submitted"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Report submitted"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          // 🔥 Auto fetch location once when dialog opens
          if (_address.text.isEmpty) {
            Future.delayed(
              Duration.zero,
              () => _fetchLocation(context, setState),
            );
          }

          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Report Waste",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),

                    // ============================
                    // IMAGE PREVIEW
                    // ============================
                    Container(
                      height: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: images.isEmpty
                          ? const Center(
                              child: Text(
                                "No photos captured",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (_, index) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    images[index],
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (images.length >= 3) return;

                          final picked = await _picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 70,
                          );

                          if (picked != null) {
                            setState(() => images.add(File(picked.path)));
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Capture Photo"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ============================
                    // 🔥 UPDATED ADDRESS FIELD
                    // ============================
                    TextField(
                      controller: _address,
                      decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () => _fetchLocation(context, setState),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedWasteType,
                      decoration: InputDecoration(
                        labelText: "Waste Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "dry waste",
                          child: Text("Dry Waste"),
                        ),
                        DropdownMenuItem(
                          value: "bio waste",
                          child: Text("Bio Waste"),
                        ),
                        DropdownMenuItem(
                          value: "solid waste",
                          child: Text("Solid Waste"),
                        ),
                        DropdownMenuItem(value: "all", child: Text("All")),
                      ],
                      onChanged: (v) {
                        setState(() => selectedWasteType = v);
                      },
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _weight,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Weight (kg)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _note,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: images.isEmpty || images.length < 3
                    ? null
                    : () {
                        submitReport();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Upload"),
              ),
            ],
          );
        },
      ),
    );
  }
}
