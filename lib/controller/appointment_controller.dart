import 'dart:convert';

import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/appointment_availability.dart';
import 'package:careplus_patient/data/repository/appointment_repository.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AppointmentController extends GetxController {

  dynamic _selectedDoctor;

  dynamic get selectedDoctor => _selectedDoctor;


  dynamic _selectedClinic;

  dynamic get selectedClinic => _selectedClinic;


  dynamic _selectedAppointmentDate;

  dynamic get selectedAppointmentDate => _selectedAppointmentDate;

  void selectAppointmentDate(dynamic value) {
    _selectedAppointmentDate = value;
  }


  dynamic _selectedAppointmentShift;

  dynamic get selectedAppointmentShift => _selectedAppointmentShift;

  void selectAppointmentShift(dynamic value) {
    _selectedAppointmentShift = value;
  }


  dynamic _selectedAppointmentShiftTime;

  dynamic get selectedAppointmentShiftTime => _selectedAppointmentShiftTime;

  void selectAppointmentShiftTime(dynamic value) {
    _selectedAppointmentShiftTime = value;
  }


  final List<AppointmentDate> _availableAppointmentDates = [];

  List<AppointmentDate> get availableAppointmentDates => _availableAppointmentDates;


  dynamic _appointmentDetail;

  dynamic get appointmentDetail => _appointmentDetail;


  final List<Appointment> _allAppointmentList = [];

  List<Appointment> get allAppointmentList => _allAppointmentList;


  final List<Appointment> _upcomingAppointmentList = [];

  List<Appointment> get upcomingAppointmentList => _upcomingAppointmentList;


  bool _isAppointmentDetailLoaded = false;

  bool get isAppointmentDetailLoaded => _isAppointmentDetailLoaded;


  bool _isAllAppointmentsLoaded = false;

  bool get isAllAppointmentsLoaded => _isAllAppointmentsLoaded;


  bool _isUpcomingAppointmentsLoaded = false;

  bool get isUpcomingAppointmentsLoaded => _isUpcomingAppointmentsLoaded;


  void selectDoctor(dynamic value) {
    _selectedDoctor = value;
    update();
  }

  void selectClinic(dynamic value) {
    _selectedClinic = value;
    update();
  }


  Future<bool> getAvailableAppointmentDates() async {
    var response = await AppointmentRepository.checkAppointmentAvailability(_selectedDoctor.id, _selectedClinic.id);
    if (response != null) {
      _availableAppointmentDates.assignAll(response);
      update();
      return true;
    } else {
      update();
      return false;
    }
  }

  Future<dynamic> createAppointmentForSelf() async {
    CreateAppointment createAppointment = CreateAppointment(
      clinicId: _selectedClinic.id,
      doctorId: _selectedDoctor.id,
      patientId: StorageHelper.getUserId(),
      bookingDate: _selectedAppointmentDate,
      bookingShift: _selectedAppointmentShift,
      bookingShiftTime: _selectedAppointmentShiftTime,
    );
    var response = await AppointmentRepository.createAppointmentForSelf(createAppointment);
    if(response!=null){
      _allAppointmentList.add(response);
      _upcomingAppointmentList.add(response);
       update();
    }
    return response;
  }

  Future<dynamic> createAppointmentForFamilyMember(String familyMemberId) async {
    CreateAppointment createAppointment = CreateAppointment(
      familyMemberId: familyMemberId,
      clinicId: _selectedClinic.id,
      doctorId: _selectedDoctor.id,
      patientId: StorageHelper.getUserId(),
      bookingDate: _selectedAppointmentDate,
      bookingShift: _selectedAppointmentShift,
      bookingShiftTime: _selectedAppointmentShiftTime,
    );
    var response = await AppointmentRepository.createAppointmentForFamilyMember(createAppointment);
    if(response!=null){
      _allAppointmentList.add(response);
      _upcomingAppointmentList.add(response);
      update();
    }
    return response;
  }

  Future<void> getAppointmentDetail(String appointmentId) async {
    _isAppointmentDetailLoaded=false;
    var response = await AppointmentRepository.getAppointmentDetail(appointmentId);
    if (response != null) {
      _appointmentDetail = response;
    }
    _isAppointmentDetailLoaded = true;
    update();
  }

  Future<void> getAllAppointments() async {
    _isAllAppointmentsLoaded=false;
    var response = await AppointmentRepository.getAllAppointments();
    if (response != null) {
      _allAppointmentList.assignAll(response);
    }
    _isAllAppointmentsLoaded = true;
    update();
  }

  Future<void> getUpcomingAppointments() async {
    _isUpcomingAppointmentsLoaded=false;
    var response = await AppointmentRepository.getUpcomingAppointments();
    if (response != null) {
      _upcomingAppointmentList.assignAll(response);
    }
    _isUpcomingAppointmentsLoaded = true;
    update();
  }

  Future<dynamic> cancelAppointment(String appointmentId) async{
    Appointment appointment = _allAppointmentList.singleWhere((element) => element.id==appointmentId);
    int appointmentIndex = _allAppointmentList.indexOf(appointment);
    var response = await AppointmentRepository.cancelAppointment(appointmentId);
    if (response != null) {
      _allAppointmentList[appointmentIndex].status="canceled";
      update();
      return true;
    } else {
      return false;
    }
  }
  
  Future<bool> checkDiscount() async{
    var response = await ApiClient().getData('api/v1/patient/get/discount/');
    if(response is http.Response && response.statusCode==200){
      return jsonDecode(response.body)["discount"]["free"];
    }else{
      return false;
    }
  }

}
