import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/appointment_availability.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:http/http.dart' as http;


class AppointmentRepository {

  static Future<dynamic> checkAppointmentAvailability(
      String doctorId, String clinicId) async {
    print(jsonEncode({"doctorId": doctorId, "clinicId": clinicId}));
    var response = await ApiClient().postData(
      ApiConstant.checkAppointmentAvailability,
      jsonEncode({"doctorId": doctorId, "clinicId": clinicId}),
    );
    if (response is http.Response && response.statusCode == 200) {
      AvailableAppointmentData appointmentAvailabilityData =
          availableAppointmentDataFromJson(response.body);
      List<AppointmentDate> appointmentDataList =
          appointmentAvailabilityData.availableAppointmentDates;
      return appointmentDataList;
    } else if(response == "Exception") {
      print("Exception occurred while getting appointment data");
      return null;
    }else{
      return null;
    }
  }

  static Future<dynamic> createAppointmentForSelf(
      CreateAppointment createAppointment) async {
    var response = await ApiClient().postData(
      ApiConstant.createSelfAppointment,
      createSelfAppointmentToJson(createAppointment),
    );
    if (response is http.Response && response.statusCode == 201) {
      AppointmentData appointmentData = appointmentDataFromJson2(response.body);
      return appointmentData.appointment;
    } else if (response.statusCode == 404) {
      print("slots not available");
      return null;
    } else {
      return null;
    }
  }

  static Future<dynamic> createAppointmentForFamilyMember(
      CreateAppointment createAppointment) async {
    var response = await ApiClient().postData(
      ApiConstant.createFamilyMemberAppointment,
      createFamilyMemberAppointmentToJson(createAppointment),
    );
    if (response is http.Response && response.statusCode == 201) {
      AppointmentData appointmentData = appointmentDataFromJson2(response.body);
      return appointmentData.appointment;
    } else if (response.statusCode == 404) {
      print("slots not available");
      return null;
    } else {
      return null;
    }
  }

  static Future<dynamic> getAppointmentDetail(String appointmentId) async {
    var response = await ApiClient().getData(ApiConstant.getAppointmentDetail + appointmentId);
    if (response is http.Response && response.statusCode == 200) {
      AppointmentData appointmentData = appointmentDataFromJson2(response.body);
      Appointment appointment = appointmentData.appointment;
      return appointment;
    } else {
      return null;
    }
  }

  static Future<dynamic> getAllAppointments() async {
    var response = await ApiClient()
        .getData(ApiConstant.getAppointments + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      AppointmentsData appointmentsData = appointmentsDataFromJson(response.body);
      List<Appointment> appointments = appointmentsData.appointments;
      return appointments;
    } else {
      return null;
    }
  }

  static Future<dynamic> getUpcomingAppointments() async {
    var response = await ApiClient()
        .getData(ApiConstant.getUpcomingAppointments + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      AppointmentsData appointmentsData = appointmentsDataFromJson(response.body);
      List<Appointment> appointments = appointmentsData.appointments;
      return appointments;
    } else {
      return null;
    }
  }

  static Future<dynamic> cancelAppointment(String appointmentId) async {
    var response = await ApiClient().postData(
      ApiConstant.cancelAppointment, '{"appointmentId":"$appointmentId"}',
    );
    if (response is http.Response && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
