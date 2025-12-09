class User {

  String? name;
  String? email;
  String? password;
  String? referredBy;


  User(
      {
      required this.name,
      required this.email,
      required this.password,
      required this.referredBy});


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
  final String address;
  final double lat;
  final double lng;
  final String type;
  final String weight;
  final String createdAt;
  final List<String> photos;

  ReportModel({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.type,
    required this.weight,
    required this.createdAt,
    required this.photos,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["_id"],
      address: json["location"]["address"],
      lat: json["location"]["lat"],
      lng: json["location"]["lng"],
      type: json["type"]["reportedType"],
      weight: json["weight"]["reportedWeight"],
      createdAt: json["timestamps"]["createdAt"],
      photos: (json["photos"] as List)
          .map((p) => p["url"].toString())
          .toList(),
    );
  }
}

