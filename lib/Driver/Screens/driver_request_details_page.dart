import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Location/Location.dart';
import '../Services/Services.dart';


class DriverRequestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> req;

  DriverRequestDetailsPage({super.key, required this.req});

  @override
  State<DriverRequestDetailsPage> createState() =>
      _DriverRequestDetailsPageState();
}

class _DriverRequestDetailsPageState extends State<DriverRequestDetailsPage> {
  late double driverLat;
  late double driverLng;

  void _openRequestDialog(BuildContext context) {
    final picker = ImagePicker();
    List<XFile> images = [];
    String locationText = "Fetching location...";

    showDialog(

      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            // load location on dialog open
            (() async {
              final pos = await Location().getLocation();
              if (pos != null) {
                setState(() {
                  locationText = "${pos.latitude}, ${pos.longitude}";
                });
              } else {
                setState(() {
                  locationText = "Location not available";
                });
              }
            })();

            Future<void> pickImage() async {
              if (images.length >= 3) return;

              final img = await picker.pickImage(source: ImageSource.camera);
              if (img != null) {
                setState(() => images.add(img));
              }
            }

            return AlertDialog(
              title: const Text("Submit Pickup Details"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ----------- CAMERA BUTTON -----------
                    ElevatedButton.icon(
                      onPressed: images.length < 3 ? pickImage : null,
                      icon: const Icon(Icons.camera_alt),
                      label: Text("Capture Photo (${images.length}/3)"),
                    ),

                    const SizedBox(height: 10),

                    // ----------- PREVIEW PHOTOS -----------
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: images
                          .map((img) => Image.file(
                        File(img.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ))
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    // ----------- LOCATION TEXTBOX -----------
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Live Location",
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: locationText),
                    ),

                  ],
                ),
              ),

              // ----------- ACTION BUTTONS -----------
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (images.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Add at least 1 photo")),
                      );
                      return;
                    }
                    final imgFiles = images.map((x) => File(x.path)).toList();

                    final success = await Services().uploadRequest(
                      driverId: "12",                // replace with real driver ID
                      requestId: widget.req['postId'].toString(),
                      location: locationText,        // live lat,lng
                      images: imgFiles,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Uploaded successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Upload Failed")),
                      );
                    }

                    Navigator.pop(context);

                    // TODO: handle your submit logic
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _loadDriverLocation();
  }

  Future<void> _loadDriverLocation() async {
    final pos = await Location().getLocation();
    if (pos != null) {
      setState(() {
        driverLat = pos.latitude;
        driverLng = pos.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.req['images'] as List<dynamic>;
    final username = widget.req['username'] ?? "User";
    final avatar =
        widget.req['avatar'] ??
        "https://ui-avatars.com/api/?name=${username.replaceAll(' ', '+')}";
    final userLat = widget.req['lat'];
    final userLng = widget.req['lng'];

    // Driver current location (you should replace with real-time GPS later)
    // final driverLat = 22.6655;
    // final driverLng = 66.4515;

    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text(
                "Request ID: ${widget.req['postId']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              // ------------------ IMAGES (HORIZONTAL) ------------------
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        images[index],
                        width: 250,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ------------------ USER INFO ROW ------------------
              Row(
                children: [
                  CircleAvatar(radius: 26, backgroundImage: NetworkImage(avatar)),
                  const SizedBox(width: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async {
                      // handle accept logic

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text(
                            'View Location',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.location_on, )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ------------------ ACCEPT BUTTON ------------------
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _openRequestDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------
  Future<void> _openMap(
    double driverLat,
    double driverLng,
    double userLat,
    double userLng,
  ) async {
    final url =
        "https://www.google.com/maps/dir/?api=1&origin=$driverLat,$driverLng&destination=$userLat,$userLng&travelmode=driving";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
