import 'dart:convert';

DepartmentData departmentsFromJson(String str) => DepartmentData.fromJson(json.decode(str));

class DepartmentData {
  DepartmentData({
    this.status,
    this.message,
    required this.departments,
  });

  dynamic status;
  dynamic message;
  List<Department> departments;

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
    status: json["status"],
    message: json["message"],
    departments: List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
  );
}

class Department {
  Department({
    required this.id,
    required this.name,
    required this.image,
  });

  String id;
  String name;
  String image;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["_id"],
    name: json["name"],
    image: json["image"],
  );
}
