import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/appointment_availability.dart';
import 'package:careplus_patient/data/repository/appointment_repository.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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
    EasyLoading.show(status: 'checking appointment availability');
    var response = await AppointmentRepository.checkAppointmentAvailability(_selectedDoctor.id, _selectedClinic.id);
    EasyLoading.dismiss();
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
    if(_isAppointmentDetailLoaded){
      _isAppointmentDetailLoaded=false;
    }
    var response = await AppointmentRepository.getAppointmentDetail(appointmentId);
    if (response != null) {
      _appointmentDetail = response;
    }
    _isAppointmentDetailLoaded = true;
    update();
  }

  Future<void> getAllAppointments() async {
    if(_isAllAppointmentsLoaded){
      _isAllAppointmentsLoaded=false;
    }
    var response = await AppointmentRepository.getAllAppointments();
    if (response != null) {
      _allAppointmentList.assignAll(response);
    }
    _isAllAppointmentsLoaded = true;
    update();
  }

  Future<void> getUpcomingAppointments() async {
    if(_isUpcomingAppointmentsLoaded){
      _isUpcomingAppointmentsLoaded=false;
    }
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

}
