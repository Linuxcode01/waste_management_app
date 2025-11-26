import 'package:flutter/material.dart';

import '../../Services/User_services.dart';
import 'OtpPage.dart';

class Forgot extends StatelessWidget {
  const Forgot({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Future<void> forgotPassword(String email, BuildContext context) async {


      if(email.trim().isEmpty){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please enter your email")));
        return;
      }
      var data = UserServices().forgetPassword(email.trim(), context);
      print(data);
      if(data['success'] != true){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${data['message']}")));
        return;
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP sent to $email")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(email: email),
          ),
        );
      }

    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset forgot password",
                  style: TextStyle(
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.03),

                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Enter your Email",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                SizedBox(
                  width: double.infinity,
                  height: height * 0.07,
                  child: TextButton(
                    onPressed: () {
                      forgotPassword(email.text, context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Send OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
