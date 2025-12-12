import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_management_app/getData.dart';
import '../../Location/Location.dart';
import '../../socket_service.dart';
import 'driver_home_page.dart';
import 'driver_profil.dart';


class driver_dash extends StatefulWidget {
  driver_dash({super.key});

  @override
  State<driver_dash> createState() => _driver_dashState();
}

class _driver_dashState extends State<driver_dash> {
  int _selectedIndex = 0;
  bool isOnline = false;
  late final String drId;

  // final socketService = SocketService();

  double? driverLat;
  double? driverLng;

  Future<void> initDriver() async {
    final location = Location();     // create object
    Position? pos = await location.getLocation();   // call your method

    if (pos == null) {
      print("Permission denied or location failed");
      return;
    }

    driverLat = pos.latitude;
    driverLng = pos.longitude;
  }

  loadDriver() async{
    final driverId = await getData.getId();
    if(driverId != null ){
      drId = driverId;
    }
    print("driver id : $driverId");
  }

  // Future<void> loadSocket() async{
  //   socketService.initSocket();
  //   socketService.socket.connect();
  //
  //   socketService.socket.emit("driver_connect", {
  //     "driverId":drId,
  //     "lat":driverLat,
  //     "lng": driverLng
  //   });
  // }


  @override
  void initState() {
    // TODO: implement initState
    // loadSocket();
    // loadDriver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DriverHomePage(),
      // Container(),
      DriverProfile(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.camera_alt_outlined),
          //   label: "Camera",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
