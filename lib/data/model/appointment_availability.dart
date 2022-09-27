import 'dart:convert';

AvailableAppointmentData availableAppointmentDataFromJson(String str) => AvailableAppointmentData.fromJson(json.decode(str));

class AvailableAppointmentData {
  AvailableAppointmentData({
    this.status,
    this.message,
    this.availableAppointmentDates,
  });

  dynamic status;
  dynamic message;
  dynamic availableAppointmentDates;

  factory AvailableAppointmentData.fromJson(Map<String, dynamic> json) => AvailableAppointmentData(
    status: json["status"],
    message: json["message"],
    availableAppointmentDates: List<AppointmentDate>.from(json["data"].map((x) => AppointmentDate.fromJson(x))),
  );
}

class AppointmentDate {
  AppointmentDate({
    required this.date,
    required this.morning,
    required this.evening,
  });

  String date;
  AppointmentShift morning;
  AppointmentShift evening;

  factory AppointmentDate.fromJson(Map<String, dynamic> json) => AppointmentDate(
    date: json["date"],
    morning: AppointmentShift.fromJson(json["morning"]),
    evening: AppointmentShift.fromJson(json["evening"]),
  );
}

class AppointmentShift {
  AppointmentShift({
    required this.close,
    required this.availableSlots,
    required this.totalSlots,
    required this.startTime,
    required this.endTime,
  });

  bool close;
  int availableSlots;
  int totalSlots;
  int startTime;
  int endTime;

  factory AppointmentShift.fromJson(Map<String, dynamic> json) => AppointmentShift(
    close: json["close"],
    availableSlots: json["availableSlots"],
    totalSlots: json["totalSlots"],
    startTime: json["startTime"],
    endTime: json["endTime"],
  );
}
