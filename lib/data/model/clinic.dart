import 'dart:convert';

import 'doctor.dart';

NearByClinicsData nearByClinicsFromJson(String str) => NearByClinicsData.fromJson(json.decode(str));
TopClinicsData topClinicsFromJson(String str) => TopClinicsData.fromJson(json.decode(str));
FavouriteClinicsData favouriteClinicsFromJson(String str) => FavouriteClinicsData.fromJson(json.decode(str));
ClinicData clinicFromJson(String str) => ClinicData.fromJson(json.decode(str));


class NearByClinicsData {
  NearByClinicsData({
     this.status,
     this.message,
     required this.clinics,
  });

  dynamic status;
  dynamic message;
  List<Clinic> clinics;

  factory NearByClinicsData.fromJson(Map<String, dynamic> json) => NearByClinicsData(
    status: json["status"],
    message: json["message"],
    clinics: List<Clinic>.from(json["clinics"].map((x) => Clinic.fromJson2(x))),
  );
}

class TopClinicsData {
  TopClinicsData({
     this.status,
     this.message,
     required this.clinics,
  });

  dynamic status;
  dynamic message;
  List<Clinic> clinics;

  factory TopClinicsData.fromJson(Map<String, dynamic> json) => TopClinicsData(
    status: json["status"],
    message: json["message"],
    clinics: List<Clinic>.from(json["clinics"].map((x) => Clinic.fromJson2(x))),
  );
}

class FavouriteClinicsData {
  FavouriteClinicsData({
     this.status,
     this.message,
     required this.clinics,
  });

  dynamic status;
  dynamic message;
  List<Clinic> clinics;

  factory FavouriteClinicsData.fromJson(Map<String, dynamic> json) => FavouriteClinicsData(
    status: json["status"],
    message: json["message"],
    clinics: List<Clinic>.from(json["clinics"].map((x) => Clinic.fromJson2(x))),
  );
}

class ClinicData{
  ClinicData({
     this.status,
     this.message,
     required this.clinic,
  });

  dynamic status;
  dynamic message;
  Clinic clinic;

  factory ClinicData.fromJson(Map<String, dynamic> json) => ClinicData(
    status: json["status"],
    message: json["message"],
    clinic: Clinic.fromJson1(json["clinic"]),
  );
}

class Clinic {
  Clinic({
     required this.id,
     required this.name,
     required this.profilePhoto,
     required this.about,
     required this.fee,
     required this.clinicTiming,
     required this.diagnostic,
     required this.block,
     required this.approved,
     required this.email,
     required this.emailVerified,
     required this.phoneNumber,
     required this.address,
     required this.distance,
     required this.averageRating,
     required this.reviewsCount,
     required this.doctors,
     required this.diagnosticServices,
     required this.ratings
  });

  String id;
  String name;
  String about;
  num fee;
  ClinicTiming clinicTiming;
  String profilePhoto;
  bool diagnostic;
  bool block;
  bool approved;
  String email;
  bool emailVerified;
  String phoneNumber;
  String address;
  num distance;
  num averageRating;
  num reviewsCount;
  List<dynamic> doctors;
  List<dynamic> diagnosticServices;
  List<dynamic> ratings;



  factory Clinic.fromJson1(Map<String, dynamic> json) => Clinic(
    id: json["_id"],
    name: json["name"]??'',
    profilePhoto: json["profilePhoto"],
    about: json["about"]??'',
    fee: json["fee"]??0,
    clinicTiming: ClinicTiming.fromJson(json["trimming"]),
    diagnostic: json["diagnostic"]??false,
    block: json["block"]??false,
    approved: json["approved"]??false,
    email: json["email"]??'',
    emailVerified: json["emailVerified"]??false,
    phoneNumber: json["phoneNumber"]??'',
    address: json["address"]??'',
    distance: json["distance"]??0,
    averageRating: json["averageRating"]??0,
    reviewsCount: json["reviewsCount"]??0,
    doctors: List<Doctor>.from(json["doctor"].map((x) => Doctor.fromJson(x))),
    diagnosticServices: List<dynamic>.from(json["diagnosticService"].map((x) => x)),
    ratings: List<dynamic>.from(json["rating"].map((x) => x)),
  );

  factory Clinic.fromJson2(Map<String, dynamic> json) => Clinic(
    id: json["_id"],
    name: json["name"]??'',
    profilePhoto: json["profilePhoto"],
    about: json["about"]??'',
    fee: json["fee"]??0,
    clinicTiming: ClinicTiming.fromJson(json["trimming"]),
    diagnostic: json["diagnostic"]??false,
    block: json["block"]??false,
    approved: json["approved"]??false,
    email: json["email"]??'',
    emailVerified: json["emailVerified"]??false,
    phoneNumber: json["phoneNumber"]??'',
    address: json["address"]??'',
    distance: json["distance"]??0,
    averageRating: json["averageRating"]??0,
    reviewsCount: json["reviewsCount"]??0,
    doctors: List<String>.from(json["doctor"].map((x) => x)),
    diagnosticServices: List<dynamic>.from(json["diagnosticService"].map((x) => x)),
    ratings: List<dynamic>.from(json["rating"].map((x) => x)),
  );
}

class ClinicTiming {
  ClinicTiming({
     required this.sun,
     required this.mon,
     required this.tue,
     required this.wed,
     required this.thr,
     required this.fri,
     required this.sat,
  });

  WeekDay sun;
  WeekDay mon;
  WeekDay tue;
  WeekDay wed;
  WeekDay thr;
  WeekDay fri;
  WeekDay sat;

  factory ClinicTiming.fromJson(Map<String, dynamic> json) => ClinicTiming(
    sun: WeekDay.fromJson(json["sun"]),
    mon: WeekDay.fromJson(json["mon"]),
    tue: WeekDay.fromJson(json["tue"]),
    wed: WeekDay.fromJson(json["wed"]),
    thr: WeekDay.fromJson(json["thr"]),
    fri: WeekDay.fromJson(json["fri"]),
    sat: WeekDay.fromJson(json["sat"]),
  );
}

class WeekDay {
  WeekDay({
   required this.morningTime,
   required this.eveningTime,
   required this.close,
  });

  Shift morningTime;
  Shift eveningTime;
  bool close;

  factory WeekDay.fromJson(Map<String, dynamic> json) => WeekDay(
    morningTime: Shift.fromJson(json["morningTime"]),
    eveningTime: Shift.fromJson(json["eveningTime"]),
    close: json["close"],
  );

}

class Shift {
  Shift({
     required this.from,
     required this.till,
     required this.close,
  });

  int from;
  int till;
  bool close;

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    from: json["from"],
    till: json["till"],
    close: json["close"],
  );
}
