import 'package:flutter/material.dart';

class customContainer {
  static container({
    required Icon? icon,
    required String text,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / 400; // Pixel 7 base

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 70 * scale.clamp(0.8, 1.2),
      padding: EdgeInsets.all(12 * scale),
      child: Row(
        children: [
          icon ?? Icon(Icons.help_outline, size: 26 * scale),
          SizedBox(width: 8 * scale),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static longContainer({
    required Icon? icon,
    required String text,
    required BuildContext context,
    Color? color,
  }) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / 400;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.4,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 18 * scale.clamp(0.8, 1.3),
        horizontal: 10 * scale,
      ),
      child: Row(
        children: [
          icon ??
              Icon(
                Icons.help_outline,
                size: 26 * scale,
                color: color,
              ),

          SizedBox(width: 10 * scale),

          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black,
              ),
            ),
          ),

          Icon(Icons.arrow_right_sharp, size: 26 * scale),
        ],
      ),
    );
  }

}
