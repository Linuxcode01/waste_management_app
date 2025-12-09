import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class getData{

  static Future<dynamic> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();

    final rawData = prefs.getString("user_data");
    if (rawData == null) return null;

    final data = jsonDecode(rawData);
    var id =  data['user']['_id'];
    return id;
  }



}