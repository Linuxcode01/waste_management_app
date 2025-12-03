import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // Same scaling logic used across your entire app
    final scale = (w / 400).clamp(0.8, 1.25);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile Details',
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18 * scale),
        child: Column(
          children: [
            SizedBox(height: 40 * scale),

            /// White card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10 * scale,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // handle profile pic change
                    },
                    child: CircleAvatar(
                      radius: 55 * scale,
                      backgroundColor: Colors.green,
                      backgroundImage: AssetImage(
                        'assets/profile_placeholder.png',
                      ),
                    ),
                  ),

                  SizedBox(height: 20 * scale),

                  _buildInput("First Name", scale),
                  _buildInput("Last Name", scale),
                  _buildInput("Phone Number", scale, keyboard: TextInputType.phone),
                  _buildInput("Gender", scale),
                  _buildInput("Date of Birth", scale, keyboard: TextInputType.datetime),

                  SizedBox(height: 25 * scale),

                  /// SAVE BUTTON
                  GestureDetector(
                    onTap: () {
                      // save action
                    },
                    child: Container(
                      height: 50 * scale,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40 * scale),

            GestureDetector(
              onTap: () {
                // delete action
              },
              child: Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * scale,
                ),
              ),
            ),

            SizedBox(height: 40 * scale),
          ],
        ),
      ),
    );
  }

  /// ---------- INPUT FIELD BUILDER ----------
  Widget _buildInput(
      String label,
      double scale, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15 * scale),
      child: TextFormField(
        keyboardType: keyboard,
        style: TextStyle(fontSize: 16 * scale),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16 * scale),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12 * scale,
            horizontal: 12 * scale,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8 * scale),
          ),
        ),
      ),
    );
  }
}
