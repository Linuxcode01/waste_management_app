import 'package:flutter/material.dart';
import '../../utils/Constants.dart';
import '../../Services/User_services.dart';
import '../User/Screens/Homes/Home.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> verify() async {
    final otp = controllers.map((e) => e.text).join();

    print("OTP entered: $otp");

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter full OTP")));
      return;
    }

    try {
      // print("email from verify opt $widget.email");
      var response = await UserServices().verifyOtp(
        widget.email.trim(),
        otp,
        context,
      );

      print("Otp page $response");

      var data = response;

      if (data['success'] == true) {

        Constants().saveUserData(response);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> resend() async {
    try {
      // print("email from resent otp $widget.email");

      var response = await UserServices().resendOtp(widget.email.trim(), context);
      print(response.toString());
      if (response['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Otp send successfully"),backgroundColor: Colors.green,));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed send Otp"),backgroundColor: Colors.red,));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.22,
          left: 22,
          right: 22,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter the OTP sent to", style: TextStyle(fontSize: 22)),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 25),

            // OTP Input Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 48,
                  height: 55,
                  child: TextField(
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Submit Button
            GestureDetector(
              onTap: verify,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Didn't get OTP?",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        "  Resend in 120s",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: resend,

                    child: Text(
                      "Resend",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
