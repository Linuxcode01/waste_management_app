import 'package:flutter/material.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.jpg"),
                  height: 50,
                  width: 50,
                ),
                Text(
                  "civicunity",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "pickup",
                        groupValue: selected,
                        onChanged: (v) => setState(() => selected = v!),
                      ),
                      Text("Pickup",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Radio<String>(
                        value: "earn",
                        groupValue: selected,
                        onChanged: (v) => setState(() => selected = v!),
                      ),
                      Text("Earn",
                          style: TextStyle(fontSize: 20, color: Colors.white))
                    ],
                  ),
                ),
                SizedBox(width: double.infinity, height: 2),
                Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 50,
                      color: Colors.blueGrey,
                      width: double.infinity,
                      child: Center(
                        child: Text("Get started",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
