import 'dart:convert';

class User {
  String? name;
  String? email;
  String? password;
  String? referredBy;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.referredBy,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    referredBy = json['referredBy'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['referredBy'] = referredBy;
    return data;
  }
}

class ReportModel {
  final String id;
  final LocationModel location;
  final TypeModel type;
  final WeightModel weight;
  final TimestampsModel timestamps;
  final List<PhotoModel> photos;
  final StatusModel status;


  ReportModel({
    required this.id,
    required this.location,
    required this.type,
    required this.weight,
    required this.timestamps,
    required this.photos,
    required this.status,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["_id"],
      location: LocationModel.fromJson(json["location"]),
      type: TypeModel.fromJson(json["type"]),
      weight: WeightModel.fromJson(json["weight"]),
      timestamps: TimestampsModel.fromJson(json["timestamps"]),
      photos: (json["photos"] as List)
          .map((p) => PhotoModel.fromJson(p))
          .toList(),
      status: StatusModel.fromJson(json["status"]),
    );
  }
}

class StatusModel {
  final String status;

  StatusModel({required this.status});

  factory StatusModel.fromJson(String status) {
    return StatusModel(status: status);
  }
}

class LocationModel {
  final String address;
  final double lat;
  final double lng;

  LocationModel({required this.address, required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json["address"],
      lat: (json["lat"] as num).toDouble(),
      lng: (json["lng"] as num).toDouble(),
    );
  }
}

class TypeModel {
  final String reportedType;

  TypeModel({required this.reportedType});

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(reportedType: json["reportedType"]);
  }
}

class WeightModel {
  final String reportedWeight;

  WeightModel({required this.reportedWeight});

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(reportedWeight: json["reportedWeight"].toString());
  }
}

class TimestampsModel {
  final String createdAt;

  TimestampsModel({required this.createdAt});

  factory TimestampsModel.fromJson(Map<String, dynamic> json) {
    return TimestampsModel(createdAt: json["createdAt"]);
  }
}

class PhotoModel {
  final String url;

  PhotoModel({required this.url});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(url: json["url"]);
  }
}
