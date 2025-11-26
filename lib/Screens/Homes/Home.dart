import 'package:flutter/material.dart';

import 'CameraPage.dart';
import 'HomePageContent.dart';
import 'ProfilePage.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> apiData;
  const Home({super.key, required this.apiData});



  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {



    final List<Widget> pages = [
      HomePageContent(apiData: widget.apiData),
      CameraPage(),
      ProfilePage(apiData: widget.apiData),
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
