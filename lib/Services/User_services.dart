import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Usermodel.dart';

class UserServices {
  String baseUrl = "https://waste-managment-y3tn.onrender.com";
  // String baseUrl = "http://localhost:5000";
  getData(String email, String pass, BuildContext context) async {
    // List<User> user = [];
    try {
      var res = await http.post(
        Uri.parse('$baseUrl/api/v1/user/login'),
        body: jsonEncode({'email': email, 'password': pass}),
        headers: {"Content-Type": "application/json"},
      );

      var rawdata = res.body;
      var data = jsonDecode(rawdata);
      print("response $data");

      if (res.statusCode == 200) {
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error : ${data['message']}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error : ${e.toString()}")));
    }
  }

  createUser(User user) async {
    try {
      var res = await http.post(
        Uri.parse('$baseUrl/api/v1/user/signup'),
        body: jsonEncode(user.toJson()),
        headers: {"Content-Type": "application/json"},
      );

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
        Uri.parse('$baseUrl/api/v1/user/forgot-password'),
        body: jsonEncode({'email': email}),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        var rawdata = res.body;
        var data = jsonDecode(rawdata);

        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" User not found"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  resendOtp(String email, BuildContext context) async {
    try {
      print("email from resendOtp $email");
      var res = await http.post(
        Uri.parse('$baseUrl/api/v1/user/resend-otp'),
        body: jsonEncode({'email': email}),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        var rawdata = res.body;
        var data = jsonDecode(rawdata);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opt send"), backgroundColor: Colors.green),
        );

        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error while sending opt"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  verifyOtp(String email, String otp, BuildContext context) async {
    // Dummy implementation for OTP verification
    try {
      var res = await http.post(
        Uri.parse('$baseUrl/api/v1/user/verify/otp'),
        body: jsonEncode({'otp': otp, 'email': email}),
        headers: {"Content-Type": "application/json"},
      );

      var rawData = res.body;
      var data = jsonDecode(rawData);
      if (data['success'] == true) {
        print("verify Otp: $data");
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  resetPassword(String email, String newPassword, BuildContext context) async {
    try {
      var res = await http.post(
        Uri.parse('$baseUrl/api/v1/user/reset-password'),
        body: jsonEncode({'email': email, 'password': newPassword}),
        headers: {"Content-Type": "application/json"},
      );

      var rawdata = res.body;
      var data = jsonDecode(rawdata);

      if (res.statusCode == 200) {
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error : ${data['message']}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<ReportModel>> fetchReports(String token) async{
    try{

      var res = await http.post(
        Uri.parse("$baseUrl/api/v1/user"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if(res.statusCode == 200){
        var rawData = res.body;
        var data = jsonDecode(rawData);

        final List report = data["reports"];

        return report.map((e) => ReportModel.fromJson(e)).toList();

      }else{
        throw Exception("Failed to load report");
      }

    }catch(e){
      throw Exception(e.toString());
    }


  }

  // sendReport({
  //   required List<File> images,
  //   required double latitude,
  //   required double longitude,
  //   required String type,
  //   required String token,
  //   String? address,
  //   String? weight,
  //   String? notes,
  // }) async {
  //
  //   print("$latitude  $longitude");
  //
  //   final uri = Uri.parse("$baseUrl/api/v1/report/make-report");
  //
  //   var request = http.MultipartRequest("POST", uri);
  //
  //   // 🔥 Add Bearer token
  //   request.headers["Authorization"] = token;
  //
  //   // 🔥 Add normal fields
  //   request.fields["latitude"] = latitude.toString();
  //   request.fields["longitude"] = longitude.toString();
  //   request.fields["type"] = type;
  //
  //   if (address != null && address.isNotEmpty) {
  //     request.fields["address"] = address;
  //   }
  //   if (weight != null && weight.isNotEmpty) {
  //     request.fields["weight"] = weight;
  //   }
  //   if (notes != null && notes.isNotEmpty) {
  //     request.fields["notes"] = notes;
  //   }
  //
  //   // 🔥 Attach images
  //   for (var img in images) {
  //     request.files.add(await http.MultipartFile.fromPath("files", img.path));
  //   }
  //
  //   // Send to server
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uploaded Successfully")));
  //     print("Upload successfully");
  //   } else {
  //     //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: ${response.statusCode}")));
  //
  //     print("Upload Failed: ${response.statusCode}");
  //   }
  // }

  Future<Map<String, dynamic>> sendReport({
    required List<File> images,
    required double latitude,
    required double longitude,
    required String type,
    required String token,
    String? address,
    String? weight,
    String? notes,
  }) async {
    final uri = Uri.parse("$baseUrl/api/v1/report/make-report");

    var request = http.MultipartRequest("POST", uri);

    // 🔥 Correct token
    request.headers["Authorization"] = "Bearer $token";

    // 🔥 Normal fields
    request.fields["latitude"] = latitude.toString();
    request.fields["longitude"] = longitude.toString();
    request.fields["type"] = type;

    if (address?.isNotEmpty == true) request.fields["address"] = address!;
    if (weight?.isNotEmpty == true) request.fields["weight"] = weight!;
    if (notes?.isNotEmpty == true) request.fields["notes"] = notes!;

    // 🔥 Attach images (if backend expects images[] then change here)
    for (var img in images) {
      request.files.add(await http.MultipartFile.fromPath("files", img.path));
    }

    // Send
    var response = await request.send();
    var body = await response.stream.bytesToString();
    print("STATUS: ${response.statusCode}");
    print("BODY: $body");

    try {
      return jsonDecode(body);
    } catch (e) {
      return {
        "success": false,
        "message": "Invalid server response",
        "raw": body,
      };
    }
  }

  // putUser() {}
  //
  // deleteUser() {}
}
