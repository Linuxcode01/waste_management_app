import 'package:flutter/material.dart';

Future<void> language({
  required BuildContext context,
  required Function(String) onLanguageSelected,
}) {
  final languages = ["English", "Hindi"];

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                onLanguageSelected(lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

