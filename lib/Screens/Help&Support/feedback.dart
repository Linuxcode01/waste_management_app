import 'package:flutter/material.dart';

class feedback extends StatelessWidget {
  const feedback({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // Global scaling logic
    final scale = (w / 400).clamp(0.8, 1.25);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback",
          style: TextStyle(fontSize: 20 * scale),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18 * scale, vertical: 20 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Intro Text
            Text(
              "We value your feedback! Please share your thoughts below:",
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 20 * scale),

            /// Feedback Input Box
            TextFormField(
              maxLines: 6,
              style: TextStyle(fontSize: 15 * scale),
              decoration: InputDecoration(
                labelText: "Your Feedback",
                labelStyle: TextStyle(fontSize: 15 * scale),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                contentPadding: EdgeInsets.all(15 * scale),
              ),
            ),

            SizedBox(height: 35 * scale),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
