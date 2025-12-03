import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CameraPage.dart';
import 'HomePageContent.dart';
import 'ProfilePage.dart';

class Home extends StatefulWidget {
   Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePageContent(),
      Container(),
      ProfilePage(),
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
          if (index == 1) {
            // Camera button clicked
            CameraPage().show(context); // << THIS IS THE CORRECT PLACE
            return; // Prevent switching screen
          }

          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: "Camera",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
