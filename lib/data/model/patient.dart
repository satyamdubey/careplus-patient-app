import 'dart:convert';

PatientData patientDataFromJson(String str) => PatientData.fromJson(json.decode(str));
String patientToJson(Patient data) => json.encode(data.toJson());

class PatientData {
  PatientData({
    this.status,
    this.message,
    this.patient,
  });

  dynamic status;
  dynamic message;
  dynamic patient;

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
    status: json["status"],
    message: json["message"],
    patient:  Patient.fromJson(json["patient"]),
  );
}

class Patient {
  Patient({
    this.id,
    this.location,
    this.fullName,
    this.photo,
    this.age,
    this.phone,
    this.gender,
    this.address,
    this.notificationToken,
  });

  dynamic id;
  dynamic location;
  dynamic fullName;
  dynamic photo;
  dynamic age;
  dynamic phone;
  dynamic gender;
  dynamic address;
  dynamic notificationToken;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    location: Location.fromJson(json["location"]),
    id: json["_id"],
    fullName: json["fullName"],
    photo: json["photo"],
    age: json["age"],
    phone: json["phone"],
    gender: json["gender"],
    address: json["address"],
    notificationToken: json["notificationsToken"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "gender": gender,
    "address": address,
    "age": age,
  };
}

class Location {
  Location({
    this.coordinates,
  });

  dynamic coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    coordinates: List<String>.from(json["coordinates"].map((x) => '$x')),
  );
}
