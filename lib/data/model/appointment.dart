import 'dart:convert';

import 'package:careplus_patient/data/model/family_member.dart';

import 'clinic.dart';
import 'doctor.dart';

String createSelfAppointmentToJson(CreateAppointment data) => json.encode(data.selfAppointmentToJson());
String createFamilyMemberAppointmentToJson(CreateAppointment data) => json.encode(data.familyMemberAppointmentToJson());
AppointmentsData appointmentsDataFromJson(String str) => AppointmentsData.fromJson(json.decode(str));
AppointmentData appointmentDataFromJson1(String str) => AppointmentData.fromJson1(json.decode(str));
AppointmentData appointmentDataFromJson2(String str) => AppointmentData.fromJson2(json.decode(str));




class CreateAppointment {
  CreateAppointment({
    this.doctorId,
    this.clinicId,
    this.patientId,
    this.familyMemberId,
    this.bookingShift,
    this.bookingDate,
  });

  dynamic doctorId;
  dynamic clinicId;
  dynamic patientId;
  dynamic familyMemberId;
  dynamic bookingShift;
  dynamic bookingDate;

  Map<String, dynamic> selfAppointmentToJson() => {
    "doctorId": doctorId,
    "clinicId": clinicId,
    "patientId": patientId,
    "bookingSift": bookingShift,
    "bookingDate": bookingDate,
  };

  Map<String, dynamic> familyMemberAppointmentToJson() => {
    "doctorId": doctorId,
    "clinicId": clinicId,
    "patientId": patientId,
    "bookingSift": bookingShift,
    "bookingDate": bookingDate,
    "familyMemberId":familyMemberId,
  };
}

class AppointmentsData {
  AppointmentsData({
    this.status,
    this.message,
    this.appointments,
  });

  dynamic status;
  dynamic message;
  dynamic appointments;

  factory AppointmentsData.fromJson(Map<String, dynamic> json) => AppointmentsData(
    status: json["status"],
    message: json["message"],
    appointments: List<Appointment>.from(json["appointment"].map((x) => Appointment.fromJson1(x))),
  );
}

class AppointmentData {
  AppointmentData({
    this.status,
    this.message,
    required this.appointment,
  });

  dynamic status;
  dynamic message;
  Appointment appointment;

  factory AppointmentData.fromJson1(Map<String, dynamic> json) => AppointmentData(
    status: json["status"],
    message: json["message"],
    appointment: Appointment.fromJson1(json["appointment"]),
  );

  factory AppointmentData.fromJson2(Map<String, dynamic> json) => AppointmentData(
    status: json["status"],
    message: json["message"],
    appointment: Appointment.fromJson2(json["appointment"]),
  );
}

class Appointment {
  Appointment({
    this.id,
    this.doctor,
    this.clinic,
    this.patient,
    this.familyMember,
    this.bookingFor,
    this.bookingDate,
    this.bookingSift,
    this.status,
    this.slot,
    this.completed,
    this.meetHours,
    this.meetMinutes,
    this.canceledBy,
    this.trxStatus,
    this.transactionId,
  });

  dynamic id;
  dynamic doctor;
  dynamic clinic;
  dynamic patient;
  dynamic familyMember;
  dynamic bookingFor;
  dynamic bookingDate;
  dynamic bookingSift;
  dynamic status;
  dynamic slot;
  dynamic completed;
  dynamic meetHours;
  dynamic meetMinutes;
  dynamic canceledBy;
  dynamic trxStatus;
  dynamic transactionId;

  factory Appointment.fromJson1(Map<String, dynamic> json) => Appointment(
    id: json["_id"],
    doctor: json["doctor"],
    clinic: json["clinic"],
    patient: json["patient"],
    familyMember: json["familyMember"],
    bookingFor: json["bookingFor"],
    bookingDate: json["bookingDate"],
    bookingSift: json["bookingSift"],
    status: json["status"],
    slot: json["slot"],
    completed: json["completed"],
    meetHours: json["meetHours"],
    meetMinutes: json["meetMinutes"],
    canceledBy: json["canceledBy"],
    trxStatus: json["trxStatus"],
    transactionId: json["transactionId"]
  );

  factory Appointment.fromJson2(Map<String, dynamic> json) => Appointment(
      id: json["_id"],
      doctor: Doctor.fromJson(json["doctor"]),
      clinic: Clinic.fromJson2(json["clinic"]),
      patient: json["patient"],
      familyMember: json["familyMember"]!=null?FamilyMember.fromJson(json["familyMember"]):null,
      bookingFor: json["bookingFor"],
      bookingDate: json["bookingDate"],
      bookingSift: json["bookingSift"],
      status: json["status"],
      slot: json["slot"],
      completed: json["completed"],
      meetHours: json["meetHours"],
      meetMinutes: json["meetMinutes"],
      canceledBy: json["canceledBy"],
      trxStatus: json["trxStatus"],
      transactionId: json["transactionId"]
  );
}

