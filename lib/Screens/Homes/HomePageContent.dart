import 'package:flutter/material.dart';
import '../../Location/Location.dart';

class HomePageContent extends StatefulWidget {
  final Map<String, dynamic> apiData;

  const HomePageContent({super.key, required this.apiData});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String? userLocation;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  void fetchLocation() async {
    final locationService = Location();
    final locName = await locationService.loadLocation();

    setState(() {
      userLocation = locName.isEmpty ? "Location unavailable" : locName;
    });
  }

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final user = widget.apiData['user'] ?? {};
    final String name = user['name'] ?? "User";
    print(name);
    final String requestStatus = widget.apiData['request_status'] ?? "No active request";



    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Greeting Section
              Text(
                userLocation!,
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.02),

              // Garbage Request Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Garbage Pickup Status",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      requestStatus,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.04,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        // open tracking page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Track Request"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.03),

              // Quick Actions
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    icon: Icons.add_circle,
                    label: "Request Pickup",
                    color: Colors.orange,
                    width: width,
                    height: height,
                    onTap: () {},
                  ),
                  _actionButton(
                    icon: Icons.schedule,
                    label: "Schedule",
                    color: Colors.blue,
                    width: width,
                    height: height,
                    onTap: () {},
                  ),
                  _actionButton(
                    icon: Icons.history,
                    label: "History",
                    color: Colors.purple,
                    width: width,
                    height: height,
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: height * 0.03),

              // Recent Updates
              Text(
                "Recent Updates",
                style: TextStyle(
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.015),

              _updateCard(
                title: "Pickup completed",
                date: "Today • 10:20 AM",
                width: width,
              ),
              SizedBox(height: height * 0.012),
              _updateCard(
                title: "Your request is accepted",
                date: "Yesterday • 8:45 PM",
                width: width,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Action Button Widget
  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width * 0.26,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: width * 0.09),
            SizedBox(height: height * 0.01),
            Text(
              label,
              style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent Updates Card
  Widget _updateCard({
    required String title,
    required String date,
    required double width,
  }) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: width * 0.08),
          SizedBox(width: width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
