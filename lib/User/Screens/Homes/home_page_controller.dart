import 'package:flutter/material.dart';
import '../../../Location/Location.dart';
import '../../../Services/User_services.dart';
import '../../../getData.dart';
import '../../../User/UserSocket.dart';
import '../../../models/Usermodel.dart';

class HomePageController {
  // LOCATION
  Future<String> fetchLocation() async {
    final locationService = Location();
    final locName = await locationService.loadLocation();

    return locName.isEmpty ? "Location unavailable" : locName;
  }

  // FETCH REPORTS
  Future<List<ReportModel>> loadReports() async {
    final token = await getData.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token is NULL or EMPTY");
    }

    return UserServices().fetchReports(token);
  }

  // SOCKET SETUP
  Future<void> setupSocket() async {
    final socket = UserSocket().socket;
    final userId = await getData.getId();

    socket.emit("user_connect", {"userId": userId, "id": socket.id});
  }

  // STATUS LABEL
  String getStatusLabel(String status) {
    switch (status) {
      case "new":
        return "New";
      case "accepted":
        return "Accepted by driver";
      case "rejected":
        return "Rejected";
      case "submitted":
        return "Submitted";
      default:
        return status;
    }
  }

  // STATUS COLOR
  Color getStatusColor(String status) {
    switch (status) {
      case "new":
        return Colors.orangeAccent;
      case "accepted":
        return Colors.blueAccent;
      case "rejected":
        return Colors.red;
      case "submitted":
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }
}
