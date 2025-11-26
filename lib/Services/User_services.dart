import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Usermodel.dart';

class UserServices {
  // String baseUrl = "https://waste-managment-y3tn.onrender.com/";
String baseUrl = "http://10.50.189.27:3000/";
  getData(String email, String pass, BuildContext context) async {
    // List<User> user = [];
    try {
      var res = await http.post(
          Uri.parse(
              'https://waste-managment-y3tn.onrender.com/api/v1/user/login'),
          body: jsonEncode({'email': email, 'password': pass}),
          headers: {"Content-Type": "application/json"});

      var rawdata = res.body;
      var data = jsonDecode(rawdata);
      print("response $data");

      if (res.statusCode == 200) {
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error : ${data['message']}")));
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error : ${e.toString()}")));
    }
  }

  createUser(User user) async {
    try {
      var res = await http.post(Uri.parse('${baseUrl}api/v1/user/signup'),
          body: jsonEncode(user.toJson()),
          headers: {"Content-Type": "application/json"});

      var rawdata = res.body;
      print("rawdata $rawdata");
      var data = jsonDecode(rawdata);
      print("data $data");
      if (res.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  forgetPassword(String email, BuildContext context) async {
    try {
      var res = await http.post(
          Uri.parse('${baseUrl}api/v1/user/forgot-password'),
          body: jsonEncode({'email': email}),
          headers: {"Content-Type": "application/json"});

      var rawdata = res.body;
      var data = jsonDecode(rawdata);

      if (res.statusCode == 200) {
        return data;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(" User not found")));
        return;
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  verifyOtp(String email, String otp, BuildContext context) async {
    // Dummy implementation for OTP verification
   try{
     var res = await http.post(
         Uri.parse('${baseUrl}api/v1/user/verify/otp'),
         body: jsonEncode({'otp': otp, 'email': email}),
         headers: {"Content-Type": "application/json"});

     var rawData = res.body;
     var data = jsonDecode(rawData);
     if (data['success'] == true) {
       print("verify Otp: $data");
       return data;
     } else {
       ScaffoldMessenger.of(context)
           .showSnackBar(SnackBar(content: Text("Invalid OTP")));
     }

   }catch(e){
      print(e.toString());
      throw Exception(e.toString());
   }
  }

  // putUser() {}
  //
  // deleteUser() {}
}
