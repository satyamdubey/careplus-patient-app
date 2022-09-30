import 'dart:convert';

String signupToJson(Signup data) => json.encode(data.toJson());

class Signup {
  Signup({
    required this.fullName,
    required this.age,
    required this.gender,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.authToken,
    required this.notificationsToken,
  });

  String fullName;
  String gender;
  String address;
  int age;
  double latitude;
  double longitude;
  String authToken;
  String notificationsToken;


  Map<String, dynamic> toJson() => {
    "authToken": authToken,
    "notificationsToken": notificationsToken,
    "latitude": latitude,
    "longitude": longitude,
    "fullName": fullName,
    "age": age,
    "gender": gender,
    "address": address,
  };
}


