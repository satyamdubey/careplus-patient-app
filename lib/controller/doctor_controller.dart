import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/data/repository/doctor_repository.dart';
import 'package:get/get.dart';

class DoctorController extends GetxController {
  final List<Doctor> _topDoctors = [];
  List<Doctor> get topDoctors => _topDoctors;

  dynamic _doctor;
  dynamic get doctor => _doctor;

  bool _isTopDoctorsLoaded = false;
  bool _isDepartmentDoctorsLoaded = false;
  bool _isDoctorLoaded = false;

  bool get isTopDoctorsLoaded => _isTopDoctorsLoaded;
  bool get isDepartmentDoctorsLoaded => _isDepartmentDoctorsLoaded;
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


  initDepartmentDoctorList(){
    _departmentDoctorsFromServer.clear();
    _departmentDoctorsToClient.clear();
    _isDepartmentDoctorsLoaded=false;
  }

  final List<Doctor> _departmentDoctorsToClient = [];

  List<Doctor> get departmentDoctorsToClient => _departmentDoctorsToClient;

  set departmentDoctorsToClient(List<Doctor> doctorList){
    _departmentDoctorsToClient.assignAll(doctorList);
    update();
  }

  final List<Doctor> _departmentDoctorsFromServer = [];

  List<Doctor> get departmentDoctorsFromServer => _departmentDoctorsFromServer;


  Future<void> getDepartmentDoctorsFromRepository(departmentName) async {
    if (_isDepartmentDoctorsLoaded) {
      _isDepartmentDoctorsLoaded = false;
      update();
    }
    var response = await DoctorRepository.getDepartmentDoctors(departmentName);
    if (response != null) {
      _departmentDoctorsFromServer.addAll(response);
      _departmentDoctorsToClient.addAll(response);
    }
    _isDepartmentDoctorsLoaded = true;
    update();
  }
}
