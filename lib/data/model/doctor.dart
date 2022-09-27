import 'dart:convert';


TopDoctorsData topDoctorsFromJson(String str) => TopDoctorsData.fromJson(json.decode(str));
DepartmentDoctorsData departmentDoctorsFromJson(String str) => DepartmentDoctorsData.fromJson(json.decode(str));
DoctorData doctorFromJson(String str) => DoctorData.fromJson(json.decode(str));


class TopDoctorsData {
  TopDoctorsData({
    required this.status,
    required this.message,
    required this.topDoctors,
  });

  String status;
  String message;
  List<Doctor> topDoctors;

  factory TopDoctorsData.fromJson(Map<String, dynamic> json) => TopDoctorsData(
    status: json["status"],
    message: json["message"],
    topDoctors: List<Doctor>.from(json["doctors"].map((x) => Doctor.fromJson(x))),
  );
}

class DepartmentDoctorsData {
  DepartmentDoctorsData({
    required this.status,
    required this.message,
    required this.departmentDoctors,
  });

  String status;
  String message;
  List<Doctor> departmentDoctors;

  factory DepartmentDoctorsData.fromJson(Map<String, dynamic> json) => DepartmentDoctorsData(
    status: json["status"],
    message: json["message"],
    departmentDoctors: List<Doctor>.from(json["doctors"].map((x) => Doctor.fromJson(x))),
  );
}

class DoctorData{
  DoctorData({
    required this.status,
    required this.message,
    required this.doctor,
  });

  String status;
  String message;
  Doctor doctor;

  factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
    status: json["status"],
    message: json["message"],
    doctor: Doctor.fromJson(json["doctor"]),
  );
}

class Doctor {
  Doctor({
    required this.id,
    required this.fullName,
    required this.about,
    required this.patient,
    required this.block,
    required this.photo,
    required this.approved,
    required this.email,
    required this.phone,
    required this.specialist,
    required this.department,
    required this.experience,
    required this.sex,
    required this.averageRating,
    required this.reviewsCount,
    required this.ratings,
    required this.availableClinics,
  });

  String id;
  String fullName;
  String about;
  int patient;
  bool block;
  String photo;
  bool approved;
  String email;
  String phone;
  String specialist;
  String department;
  String experience;
  String sex;
  num averageRating;
  num reviewsCount;
  List<String> ratings;
  List<AvailableClinic> availableClinics;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["_id"],
    fullName: json["fullName"]??'',
    about: json["about"]??'',
    patient: json["patient"]??0,
    block: json["block"]??false,
    photo: json["photo"],
    approved: json["approved"]??false,
    email: json["email"]??'',
    phone: json["phone"]??'',
    specialist: json["specialist"]??'',
    department: json["department"]??'',
    experience: json["experience"]??'',
    sex: json["sex"]??'',
    averageRating: json["averageRating"]??0,
    reviewsCount: json["reviewsCount"]??0,
    ratings: List<String>.from(json["rating"].map((x) => x)),
    availableClinics: List<AvailableClinic>.from(json["clinic"].map((x) => AvailableClinic.fromJson(x))),
  );
}

class AvailableClinic {
  AvailableClinic({
    required this.clinicDetail,
  });

  dynamic clinicDetail;

  factory AvailableClinic.fromJson(Map<String, dynamic> json) => AvailableClinic(
    clinicDetail: json["clinic"] is String ? json["clinic"] : ClinicDetail.fromJson(json ["clinic"]),
  );
}


class ClinicDetail {
  ClinicDetail({
    required this.id,
    required this.name,
    required this.fee,
    required this.address,
    required this.profilePhoto,
    required this.averageRating,
    required this.reviewsCount,
  });

  String id;
  String name;
  int fee;
  String address;
  String profilePhoto;
  num averageRating;
  num reviewsCount;


  factory ClinicDetail.fromJson(Map<String, dynamic> json) => ClinicDetail(
    id: json["_id"],
    name: json["name"]??'',
    fee: json["fee"],
    address: json["address"]??'',
    profilePhoto: json["profilePhoto"],
    averageRating: json["averageRating"]??0,
    reviewsCount: json["reviewsCount"]??0,
  );
}
