import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final scale = (w / 400).clamp(0.8, 1.25);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help & Support",
          style: TextStyle(fontSize: 20 * scale),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(16 * scale),
        children: [
          /// QUICK HELP
          Text(
            "Quick Help",
            style: TextStyle(
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10 * scale),

          _faqItem(
            question: "How to schedule a waste pickup?",
            answer: "Go to the Pickup section → select date → confirm.",
            scale: scale,
          ),

          _faqItem(
            question: "Pickup is delayed. What should I do?",
            answer: "Wait 15–20 minutes. If still not picked, raise a complaint.",
            scale: scale,
          ),

          _faqItem(
            question: "How to separate waste?",
            answer: "Dry waste → Blue bin. Wet waste → Green bin.",
            scale: scale,
          ),

          SizedBox(height: 25 * scale),

          /// CONTACT
          Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10 * scale),

          _contactOption(
            icon: Icons.call,
            label: "Call Support",
            scale: scale,
            onTap: () {},
          ),
          _contactOption(
            icon: Icons.email,
            label: "Email Support",
            scale: scale,
            onTap: () {},
          ),
          _contactOption(
            icon: Icons.chat,
            label: "Chat on WhatsApp",
            scale: scale,
            onTap: () {},
          ),

          SizedBox(height: 25 * scale),

          /// REPORT ISSUE
          Text(
            "Report an Issue",
            style: TextStyle(
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10 * scale),

          SizedBox(
            height: 48 * scale,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportIssuePage()),
                );
              },
              child: Text(
                "Report a Problem",
                style: TextStyle(fontSize: 16 * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CONTACT OPTION
  Widget _contactOption({
    required IconData icon,
    required String label,
    required double scale,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28 * scale),
      title: Text(
        label,
        style: TextStyle(fontSize: 16 * scale),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14 * scale),
      onTap: onTap,
    );
  }

  /// FAQ ITEM
  Widget _faqItem({
    required String question,
    required String answer,
    required double scale,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 8 * scale),
      childrenPadding: EdgeInsets.all(12 * scale),
      title: Text(
        question,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Text(
          answer,
          style: TextStyle(fontSize: 14 * scale),
        ),
      ],
    );
  }
}


// ---------------- REPORT ISSUE PAGE ----------------

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  String? selectedCategory;
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final scale = (w / 400).clamp(0.8, 1.25);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Issue",
          style: TextStyle(fontSize: 20 * scale),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CATEGORY
            DropdownButtonFormField(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                labelText: "Issue Category",
                labelStyle: TextStyle(fontSize: 15 * scale),
              ),
              items: const [
                DropdownMenuItem(value: "pickup", child: Text("Pickup not done")),
                DropdownMenuItem(value: "delay", child: Text("Pickup delay")),
                DropdownMenuItem(value: "billing", child: Text("Payment issue")),
                DropdownMenuItem(value: "other", child: Text("Other")),
              ],
              onChanged: (value) => setState(() => selectedCategory = value),
            ),

            SizedBox(height: 18 * scale),

            /// DESCRIPTION
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Describe your issue",
                labelStyle: TextStyle(fontSize: 15 * scale),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                contentPadding: EdgeInsets.all(15 * scale),
              ),
            ),

            SizedBox(height: 25 * scale),

            /// SUBMIT BUTTON
            SizedBox(
              height: 48 * scale,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitComplaint,
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitComplaint() {
    if (selectedCategory == null || descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    // API call will go here later

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Issue submitted")),
    );
  }
}
