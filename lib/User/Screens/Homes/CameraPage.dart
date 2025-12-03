import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class CameraPage {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _address = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _note = TextEditingController();
  String? selectedWasteType = "dry waste";

  // ============================
  // 🔥 FETCH USER LOCATION
  // ============================
  Future<void> _fetchLocation(
      BuildContext context, void Function(void Function()) setState) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      //_currentPosition = await Geolocator.getCurrentPosition();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      final place = placemarks.first;
      final formatted =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";

      setState(() => _address.text = formatted);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch location")),
      );
    }
  }

  void show(BuildContext context) {
    List<File> images = [];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          // 🔥 Auto fetch location once when dialog opens
          if (_address.text.isEmpty) {
            Future.delayed(Duration.zero,
                    () => _fetchLocation(context, setState));
          }

          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                            value: "dry waste", child: Text("Dry Waste")),
                        DropdownMenuItem(
                            value: "bio waste", child: Text("Bio Waste")),
                        DropdownMenuItem(
                            value: "solid waste", child: Text("Solid Waste")),
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
                onPressed: images.length < 3
                    ? null
                    : () async {
                  // UserServices().sendReport(
                  //   images: images,
                  //   latitude: permission!.latitude,
                  //   longitude: permission!.longitude,
                  //   type: selectedWasteType ?? "dry waste",
                  //   token: _userToken!,
                  //   address: _address.text,
                  //   weight: _weight.text,
                  //   notes: _note.text,
                  // );
                  Navigator.pop(context);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
