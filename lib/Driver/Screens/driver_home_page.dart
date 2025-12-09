import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import 'package:waste_management_app/utils/Constants.dart';
import '../../socket_service.dart';
import 'LocationEmitter.dart';
import 'driver_request_details_page.dart';
import 'driver_request_list_page.dart';
import 'driver_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'getData.dart';
import '../../socket_service.dart';

/// If you already have these in separate files, remove the local copies below
/// and import them instead.


class DriverStatusBadge extends StatelessWidget {
  final bool online;

  DriverStatusBadge({required this.online,super.key});


  late double driverLat;
  late double driverLng;

  Future<void> initDriver() async {


    // final driverId = await getUserData(); // <-- actual String value
    // if (driverId == null) return;

    final pos = await Geolocator.getCurrentPosition();
    driverLat = pos.latitude;
    driverLng = pos.longitude;
  }

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

  DriverHomePage({ super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}



class _DriverHomePageState extends State<DriverHomePage> {
  final service = DriverService();
  bool streaming = false;
  bool isOnline = false;
  bool live = false;

  late final String drId;




  Future<void> toggleOnline() async {
    drId = await getData.getDriverId();
    print("Driver id  from getData : $drId");

    if(isOnline){
      isOnline = !isOnline;
      // LocationEmitter().stopSending();
      socketService.emit("driver_disconnect", {
        "driverId": drId,
      });

      print("Driver is now OFFLINE");
    }else{
      isOnline = !isOnline;
      // LocationEmitter().startSendingLocation(drId);
      socketService.emit("driver_connect", {
        "driverId": drId,
        // "lat": pos.latitude,
        // "lng": pos.longitude,
        // "id": socketService.socket.id,
      });

      print("Driver is now ONLINE");
    }

    // setState(() {
    //   drId = drId;
    // });
  }
  void toggleLive() => live = !live;

  double? driverLat;
  double? driverLng;


  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    setupSocket();
  }

  Future<void> setupSocket() async {
    socketService.initSocket();
    socketService.connect();
  }


  // @override
  // void initState() {
  //   super.initState();
  // }

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
                DriverStatusBadge(online: isOnline,),
              ],
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Go Online'),
              subtitle: const Text('Enable to start receiving jobs'),
              value: isOnline,
              onChanged: (v) {
                setState(() {
                  toggleOnline();
                });
              },
            ),

            const SizedBox(height: 25),

            // view my location on map
            const SizedBox(height: 10),

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
                leading: const Icon(Icons.gps_fixed, color: Colors.green),
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
                      backgroundColor: Color(0XFF00A884),
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

  void _showReportPopup(dynamic data) {
    double wstLat = data['lat'];
    double wsLng = data['lng'];
    double distance = calculateDistance(driverLat!, driverLng!, wstLat, wsLng);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Waste Report"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data['images'] != null && data['images'].isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data['images'].length,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data['images'][i],
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              Text("📍 Address: ${data['address'] ?? ''}"),
              Text("🚮 Type: ${data['type'] ?? ''}"),
              Text("⚖ Weight: ${data['weight'] ?? ''}"),
              Text("📝 Notes: ${data['notes'] ?? ''}"),
              Text("🕒 Time: ${data['createdAt'] ?? ''}"),
              Text("Distance $distance"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Accept Job"),
              onPressed: () {
                // TODO: Accept/report logic
                acceptRequest(data['postId']);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> acceptRequest(String postId) async {
    await http.post(
      Uri.parse("https://yourapi.com/accept"),
      body: {"driverId": "10", "postId": postId},
    );
  }

  // Future<void> cancelRequest(String postId) async {
  //   await http.post(
  //     Uri.parse("https://yourapi.com/cancel"),
  //     body: {"driverId": "10", "requestId": postId},
  //   );
  // }
}
