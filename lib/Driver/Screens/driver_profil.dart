import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Help&Support/feedback.dart';
import '../../Help&Support/help_and_support.dart';
import '../../User/Screens/Account Setting/language.dart';
import '../../User/Screens/Account Setting/language_provider.dart';
import '../../utils/Constants.dart';
import '../../utils/CustomContainer.dart';
import '../../validation/login.dart';
import '../Accounts/Account Setting/driverNotification.dart';
import '../Accounts/Account Setting/driverProfileDetails.dart';


class DriverProfile extends StatefulWidget {
  // final Map<String, dynamic> apiData;

  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("user_data");
    if (data == null) return null;

    return jsonDecode(data);
  }

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    user = await getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final scale = (w / 400).clamp(0.8, 1.3);
    final isTablet = w > 600;

    // final user = apiData['user'] ?? {};
    // print("user from profile page ${user}");
    // print("user name from profile page ${user?['user']['name']}");
    //
    final userData = user?['user'] ?? {};


    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              // radius: 25 * scale,

              child: Image(image: NetworkImage("https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg")),
            ),
            SizedBox(width: 12 * scale),
            Text(
              (userData != null) ? userData['name'] : "loading...",
              style: TextStyle(
                fontSize: 20 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? constraints.maxWidth * 0.1 : 15 * scale,
                vertical: 15 * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SHORTCUT ROW 1
                  SizedBox(
                    height: 110 * scale,
                    child: Row(
                      children: [
                        Expanded(
                          child: customContainer.container(
                            icon: Icon(Icons.request_page_outlined,
                                size: 28 * scale),
                            text: "Pickup requested",
                            context: context,
                          ),
                        ),
                        SizedBox(width: 10 * scale),
                        Expanded(
                          child: customContainer.container(
                            icon: Icon(Icons.paypal_rounded, size: 28 * scale),
                            text: "Refer & Earn",
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1 * scale),

                  // SHORTCUT ROW 2
                  SizedBox(
                    height: 60 * scale,
                    child: Row(
                      children: [
                        Expanded(
                          child: customContainer.container(
                            icon: Icon(Icons.wallet, size: 28 * scale),
                            text: "Payment Methods",
                            context: context,
                          ),
                        ),
                        SizedBox(width: 10 * scale),
                        Expanded(
                          child: customContainer.container(
                            icon: Icon(Icons.location_on_outlined,
                                size: 28 * scale),
                            text: "Address",
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30 * scale),

                  // ACCOUNT SETTINGS TITLE
                  Text(
                    "ACCOUNT SETTINGS",
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18 * scale),

                  // TILES
                  customTile(
                    icon: Icons.person_2_outlined,
                    text: "Profile details",
                    scale: scale,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => DriverProfileDetails()));
                    },
                    context: context,
                  ),

                  customTile(
                    icon: Icons.language_outlined,
                    text: "Language",
                    scale: scale,
                    onTap: () {
                      language(
                        context: context,
                        onLanguageSelected: (lang) {
                          final provider = Provider.of<LanguageProvider>(
                              context,
                              listen: false);
                          if (lang == "English") provider.setLocale('en');
                          if (lang == "Hindi") provider.setLocale('hi');
                        },
                      );
                    },
                    context: context,
                  ),

                  customTile(
                    icon: Icons.notifications_none_outlined,
                    text: "Notifications",
                    scale: scale,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => driverNotification()));
                    },
                    context: context,
                  ),

                  SizedBox(height: 25 * scale),

                  // HELP & SUPPORT
                  Text(
                    "HELP & SUPPORT",
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18 * scale),

                  customTile(
                    icon: Icons.feedback_outlined,
                    text: "Give Feedback",
                    scale: scale,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => feedback()));
                    },
                    context: context,
                  ),

                  customTile(
                    icon: Icons.help_outline,
                    text: "Help & Support",
                    scale: scale,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HelpSupportPage()));
                    },
                    context: context,
                  ),

                  SizedBox(height: 25 * scale),

                  // MORE
                  Text(
                    "MORE",
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18 * scale),

                  customTile(
                    icon: Icons.policy_outlined,
                    text: "Privacy Policy",
                    scale: scale,
                    onTap: () {},
                    context: context,
                  ),

                  customTile(
                    icon: Icons.article_outlined,
                    text: "Terms & Conditions",
                    scale: scale,
                    onTap: () {},
                    context: context,
                  ),

                  customTile(
                    icon: Icons.content_copy,
                    text: "Content Policy",
                    scale: scale,
                    onTap: () {},
                    context: context,
                  ),

                  customTile(
                    icon: Icons.logout,
                    text: "Logout",
                    scale: scale,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      // Logout action
                      Constants.prefs?.setBool("loggedIn", false);
                      Constants.prefs?.setString("user_data", "");

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    context: context,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // CUSTOM TILE USING YOUR LONG CONTAINER
  Widget customTile({
    required IconData icon,
    required String text,
    required double scale,
    required BuildContext context,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: customContainer.longContainer(
        icon: Icon(icon, size: 26 * scale, color: iconColor),
        text: text,
        context: context,
        color: textColor,
      ),
    );
  }
}
