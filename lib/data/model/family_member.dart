import 'dart:convert';

import 'package:careplus_patient/helper/storage_helper.dart';

FamilyMember familyMemberFromJson(String str) => FamilyMember.fromJson(json.decode(str));
FamilyMemberListData familyMemberListDataFromJson(String str) => FamilyMemberListData.fromJson(json.decode(str));
String addFamilyMemberToJson(FamilyMember data) => json.encode(data.addMemberToJson());
String removeFamilyMemberToJson(FamilyMember data) => json.encode(data.removeMemberToJson());


class FamilyMemberListData {
  FamilyMemberListData({
    this.status,
    this.message,
    required this.memberList,
  });

  dynamic status;
  dynamic message;
  List<FamilyMember> memberList;

  factory FamilyMemberListData.fromJson(Map<String, dynamic> json) => FamilyMemberListData(
    status: json["status"],
    message: json["message"],
    memberList: List<FamilyMember>.from(json["memberList"].map((x) => FamilyMember.fromJson(x))),
  );
}


class FamilyMember {
  FamilyMember({
    this.id,
    this.name,
    this.age,
    this.phone,
    this.gender,
    this.relationShip,
    this.patientId,
  });

  dynamic id;
  dynamic name;
  dynamic age;
  dynamic phone;
  dynamic gender;
  dynamic relationShip;
  dynamic patientId;


  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json["_id"],
    name: json["name"],
    age: json["age"],
    phone: json["phone"],
    gender: json["gender"],
    relationShip: json["relationShip"],
  );

  Map<String, dynamic> addMemberToJson() => {
    "name": name,
    "age": age,
    "phone": phone,
    "gender": gender,
    "relationShip": relationShip,
    "patientId": StorageHelper.getUserId(),
  };

  Map<String, dynamic> removeMemberToJson() => {
    "familyMemberId":id,
    "patientId": StorageHelper.getUserId(),
  };
}
