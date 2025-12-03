import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'driver_request_details_page.dart';
import 'driver_request_list_page.dart';
import 'driver_service.dart';

/// If you already have these in separate files, remove the local copies below
/// and import them instead.
class DriverViewModel {
  bool isOnline = false;
  bool live = false;
  void toggleOnline() => isOnline = !isOnline;
  void toggleLive() => live = !live;
}

class DriverStatusBadge extends StatelessWidget {
  final bool online;
  const DriverStatusBadge({required this.online, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: online ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        online ? 'Online' : 'Offline',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

/// Complete, fixed DriverHomePage widget
class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final vm = DriverViewModel();
  final service = DriverService();
  bool streaming = false;

  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  StreamSubscription<Position>? _positionStream;

  // @override
  // void initState() {
  //   super.initState();
  //   _startLocationUpdates();
  // }
  //
  // void _startLocationUpdates() async {
  //   var permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) return;
  //
  //   _positionStream = Geolocator.getPositionStream().listen((pos) {
  //     setState(() {
  //       _currentLatLng = LatLng(pos.latitude, pos.longitude);
  //     });
  //
  //     // Push location to backend
  //     service.updateLocation(pos.latitude, pos.longitude);
  //
  //     // Move camera smoothly
  //     if (_mapController != null) {
  //       _mapController!.animateCamera(
  //         CameraUpdate.newLatLng(_currentLatLng!),
  //       );
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _positionStream?.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterBackgroundService().on("showPopup").listen((event) {
      if (event == null) return;

      showRequestPopup(
        event["requestId"],
        event["lat"],
        event["lng"],
        event["driverLat"],
        event["driverLng"],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // STATUS + SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status:', style: TextStyle(fontSize: 18)),
                DriverStatusBadge(online: vm.isOnline),
              ],
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Go Online'),
              subtitle: const Text('Enable to start receiving jobs'),
              value: vm.isOnline,
              onChanged: (v) {
                setState(() {
                  vm.toggleOnline();
                });
              },
            ),

            const SizedBox(height: 25),

            // view my location on map

            // const Text(
            //   "My Live Location",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 10),
            //
            // Container(
            //   height: 450,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.grey.shade400),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: _currentLatLng == null
            //         ? const Center(child: CircularProgressIndicator())
            //         : GoogleMap(
            //       initialCameraPosition: CameraPosition(
            //         target: _currentLatLng!,
            //         zoom: 16,
            //       ),
            //       onMapCreated: (c) => _mapController = c,
            //       markers: {
            //         Marker(
            //           markerId: const MarkerId("me"),
            //           position: _currentLatLng!,
            //           icon: BitmapDescriptor.defaultMarkerWithHue(
            //             BitmapDescriptor.hueAzure,
            //           ),
            //         ),
            //       },
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ElevatedButton(
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DriverRequestListPage(),
                //     ),
                //   ),
                //   child: const Text('View Pending Requests'),
                // ),
                ElevatedButton(
                  onPressed: () async {
                    if (!streaming) {
                      streaming = true;
                      Geolocator.getPositionStream().listen((pos) {
                        service.updateLocation(pos.latitude, pos.longitude);
                      });
                    }
                  },
                  //onPressed: () => Navigator.pushNamed(context, '/driver/live'),
                  child: const Text('Go Live'),
                ),
              ],
            ),

            SizedBox(height: 15),

            // TODAY'S REQUESTS PREVIEW (two example cards)
            const Text(
              'Today\'s Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(Icons.gps_fixed, color: Colors.orange),
                title: const Text('Request #123'),
                subtitle: const Text('Location: 26.123, 82.912'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverRequestDetailsPage(
                          req: {
                            "postId": "12345",
                            "images": [
                              "https://yourdomain.com/image1.jpg",
                              "https://yourdomain.com/image2.jpg",
                            ],
                            "lat": 26.788781,
                            "lng": 81.125871,
                            "username": "Chandan Kumar",
                            "avatar": "https://yourdomain.com/userdp.jpg",
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('View'),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(14),
            //   ),
            //   child: ListTile(
            //     leading: const Icon(Icons.gps_fixed, color: Colors.orange),
            //     title: const Text('Request #124'),
            //     subtitle: const Text('Location: 26.125, 82.900'),
            //     trailing: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => DriverRequestDetailsPage(),
            //           ),
            //         );
            //       },
            //       child: const Text('View'),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),

            // ACTION BUTTONS
            SizedBox(height: 20),
            // QUICK ACTIONS GRID
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _quickButton(Icons.list, 'Pending Requests', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverRequestListPage(),
                    ),
                  );
                }),
                // _quickButton(Icons.location_searching, 'Live Tracking', () {
                //   Navigator.pushNamed(context, '/driver/live');
                // }),
                _quickButton(Icons.history, 'Completed Tasks', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverRequestListPage(),
                    ),
                  );
                }),
                // _quickButton(Icons.route, 'Navigation Mode', () {
                //   // toggle navigation mode or open maps
                // }),
              ],
            ),

            const SizedBox(height: 30),

            // TOP CARD SUMMARY
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Today\'s Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Completed: 4', style: TextStyle(fontSize: 16)),
                        Text('Pending: 2', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 35),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  void showRequestPopup(
    String requestId,
    double userLat,
    double userLng,
    double driverLat,
    double driverLng,
  ) {
    final dist = calculateDistance(driverLat, driverLng, userLat, userLng);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("New Ride Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Request ID: $requestId"),
            Text("Location: $userLat, $userLng"),
            Text("Distance: ${dist.toStringAsFixed(2)} km"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              acceptRequest(requestId);
              Navigator.pop(context);
            },
            child: Text("ACCEPT"),
          ),
          TextButton(
            onPressed: () {
              cancelRequest(requestId);
              Navigator.pop(context);
            },
            child: Text("CANCEL"),
          ),
        ],
      ),
    );
  }

  Future<void> acceptRequest(String requestId) async {
    await http.post(
      Uri.parse("https://yourapi.com/accept"),
      body: {"driverId": "10", "requestId": requestId},
    );
  }

  Future<void> cancelRequest(String requestId) async {
    await http.post(
      Uri.parse("https://yourapi.com/cancel"),
      body: {"driverId": "10", "requestId": requestId},
    );
  }
}
