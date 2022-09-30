import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/data/repository/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorController extends GetxController {

  bool _isTopDoctorsLoaded = false;
  bool _isDoctorLoaded = false;

  final List<Doctor> _topDoctors = [];
  List<Doctor> get topDoctors => _topDoctors;
  bool get isTopDoctorsLoaded => _isTopDoctorsLoaded;

  dynamic _doctor;
  dynamic get doctor => _doctor;
  bool get isDoctorLoaded => _isDoctorLoaded;


  Future<void> getTopDoctorsFromRepository() async {
    if (_isTopDoctorsLoaded) {
      _isTopDoctorsLoaded = false;
      update();
    }
    var response = await DoctorRepository.getTopDoctors();
    if (response != null) {
      _topDoctors.assignAll(response);
      _isTopDoctorsLoaded = true;
    }
    _isTopDoctorsLoaded = true;
    update();
  }

  Future<void> getDoctorFromRepository(String doctorId) async {
    if (_isDoctorLoaded) {
      _isDoctorLoaded = false;
      update();
    }
    var response = await DoctorRepository.getDoctor(doctorId);
    if (response != null) {
      _doctor = response;
    }
    _isDoctorLoaded = true;
    update();
  }

  // controller variables for department doctor list

  int _departmentDoctorPage = 1;
  int _departmentDoctorLimit = 10;
  final int _departmentDoctorIncrementBy = 10;

  String _departmentName = '';

  bool _isDepartmentDoctorsLoaded = false;

  bool get isDepartmentDoctorsLoaded => _isDepartmentDoctorsLoaded;


  final ScrollController _departmentDoctorScrollController = ScrollController();

  ScrollController get departmentDoctorScrollController {
    return _departmentDoctorScrollController;
  }

  void _onScrollDepartmentDoctorList() {
    if (_departmentDoctorScrollController.offset >= _departmentDoctorScrollController.position.maxScrollExtent &&
        !_departmentDoctorScrollController.position.outOfRange) {
      _departmentDoctorPage++;
      _departmentDoctorLimit = _departmentDoctorLimit + _departmentDoctorIncrementBy;
      _isDepartmentDoctorsLoaded = false;
      update();
      getDepartmentDoctorsFromRepository(_departmentName);
    }
  }

  initDepartmentDoctorList(String departmentName){
    _departmentDoctorPage=1;
    _departmentDoctorLimit=10;
    _departmentName=departmentName;
    _departmentDoctorsFromServer.clear();
    _departmentDoctorsToClient.clear();
    _isDepartmentDoctorsLoaded=false;
    _departmentDoctorScrollController.addListener(_onScrollDepartmentDoctorList);
  }

  final List<Doctor> _departmentDoctorsToClient = [];

  List<Doctor> get departmentDoctorsToClient => _departmentDoctorsToClient;

  final List<Doctor> _departmentDoctorsFromServer = [];

  List<Doctor> get departmentDoctorsFromServer => _departmentDoctorsFromServer;

  set departmentDoctorsToClient(List<Doctor> doctorList){
    _departmentDoctorsToClient.assignAll(doctorList);
    update();
  }

  Future<void> getDepartmentDoctorsFromRepository(departmentName) async {
    var response = await DoctorRepository.getDepartmentDoctors(departmentName);
    if (response != null) {
      _departmentDoctorsFromServer.addAll(response);
      _departmentDoctorsToClient.addAll(response);
    }
    _isDepartmentDoctorsLoaded = true;
    update();
  }


  // controller variables for nearby doctor list

  bool _isNearByDoctorsLoaded = true;

  bool get isNearByDoctorsLoaded => _isNearByDoctorsLoaded;

  initNearByDoctorList(){
    _nearByDoctorsToClient.clear();
    _isNearByDoctorsLoaded=false;
  }

  final List<Doctor> _nearByDoctorsToClient = [];

  List<Doctor> get nearByDoctorsToClient => _nearByDoctorsToClient;

  Future<void> searchNearByDoctorsFromRepository(String doctorName) async {
    _isNearByDoctorsLoaded=false;
    update();
    var response = await DoctorRepository.searchNearByDoctors(doctorName);
    if (response != null) {
      _nearByDoctorsToClient.assignAll(response);
    }
    _isNearByDoctorsLoaded = true;
    update();
  }

}



