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
