import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/Constants.dart';
import '../../utils/CustomContainer.dart';
import '../Account Setting/language.dart';
import '../Account Setting/language_provider.dart';
import '../Account Setting/notification.dart';
import '../Account Setting/profileDetails.dart';
import '../Help&Support/feedback.dart';
import '../Help&Support/help_and_support.dart';
import '../validation/login.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> apiData;

  const ProfilePage({super.key, required this.apiData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final scale = (w / 400).clamp(0.8, 1.3);
    final isTablet = w > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25 * scale,
              child: Image(image: AssetImage("assets/images/logo.jpg")),
            ),
            SizedBox(width: 12 * scale),
            Text(
              apiData['user']['name']?? "demo User",
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
                vertical: 20 * scale,
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
                    height: 110 * scale,
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
                          MaterialPageRoute(builder: (_) => ProfileDetails()));
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
                          MaterialPageRoute(builder: (_) => notification()));
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
