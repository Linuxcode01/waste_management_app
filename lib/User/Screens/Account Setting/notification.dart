import 'package:flutter/material.dart';

class notification extends StatelessWidget {
  const notification({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    // MAIN SCALE FACTOR (same logic as other pages)
    final scale = (w / 400).clamp(0.8, 1.3);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Settings",
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 18 * scale),

              _buildSwitchTile(
                title: 'Push Notifications',
                value: true,
                scale: scale,
                onChange: (v) {},
              ),

              _buildSwitchTile(
                title: 'Email Notifications',
                value: false,
                scale: scale,
                onChange: (v) {},
              ),

              _buildSwitchTile(
                title: 'SMS Notifications',
                value: true,
                scale: scale,
                onChange: (v) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CUSTOM RESPONSIVE SWITCH TILE
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required double scale,
    required Function(bool) onChange,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18 * scale,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: onChange,
      contentPadding: EdgeInsets.symmetric(vertical: 6 * scale),
    );
  }
}
