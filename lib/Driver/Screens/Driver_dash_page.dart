import 'dart:convert';

import 'package:flutter/material.dart';
import 'driver_home_page.dart';
import 'driver_profil.dart';

class driver_dash extends StatefulWidget {
  driver_dash({super.key});


  @override
  State<driver_dash> createState() => _driver_dashState();
}

class _driver_dashState extends State<driver_dash> {
  int _selectedIndex = 0;


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

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // if (index == 1) {
          //   // Camera button clicked
          //   driver_camera().show(context); // << THIS IS THE CORRECT PLACE
          //   return; // Prevent switching screen
          // }

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
