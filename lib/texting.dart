import 'package:flutter/material.dart';

class Texting extends StatelessWidget {
  const Texting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text("New Waste Report"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (data['images'] != null && data['images'].isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "data['images'][i]",
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Text("📍 Address: ''}"),
            Text("🚮 Type: ''}"),
            Text("⚖ Weight: ''}"),
            Text("📝 Notes: ''}"),
            Text("🕒 Time: ''}"),
            Text("Distance "),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Accept Job"),
            onPressed: () {
              // TODO: Accept/report logic

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
