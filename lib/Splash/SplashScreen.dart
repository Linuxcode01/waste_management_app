import 'dart:async';
import 'package:flutter/material.dart';

import '../OnBoarding/OnBoardingScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
      super.initState();
      Timer(Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Onboardingscreen()));
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image(image: AssetImage("assets/images/login.jpeg")),
              ),
              SizedBox(height: 20,),
              Text("Welcome to Civic Unity", style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
