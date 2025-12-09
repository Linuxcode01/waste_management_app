import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_management_app/Driver/Screens/getData.dart';
import '../../socket_service.dart';
import 'driver_home_page.dart';
import 'driver_profil.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check GPS
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("GPS is off");
    }

    // Permission check
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permanently denied");
    }

    // Fetch real-time location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class driver_dash extends StatefulWidget {
  driver_dash({super.key});

  @override
  State<driver_dash> createState() => _driver_dashState();
}

class _driver_dashState extends State<driver_dash> {
  int _selectedIndex = 0;

  final socketService = SocketService();
  late final String drId;

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final rawdata = prefs.getString("user_data");
    if (rawdata == null) return null;

    final data = jsonDecode(rawdata);
    var id =  data['user']['_id'];
    return id;
  }

  Future<void> loadDriver() async {
    // 1. Load driverId
    drId = await getData.getDriverId();

    // // 2. After drId is loaded → initialize socket + location
    // await initDriver();
  }



  @override
  @override
  void initState() {
    // TODO: implement initState
    // loadDriver();
    // initDriver();
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
      // appBar: AppBar(
      //   title: Text("Waste Management"),
      //   elevation: 0,
      // ),
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
