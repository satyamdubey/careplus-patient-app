import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/controller/department_controller.dart';
import 'package:careplus_patient/controller/doctor_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/data/model/department.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:get/get.dart';

class ClinicSearchController extends GetxController {

  final ClinicController clinicController = Get.find();

  List<Clinic> _searchList = [];

  List<Clinic> _searchFromList = [];

  set searchFromList(List<Clinic> clinicList){
    _searchFromList.assignAll(clinicList);
  }

  searchNearByClinic(String searchText) {
    _searchList.assignAll(
      _searchFromList
          .where((element) => element.name.isCaseInsensitiveContains(searchText))
          .toList(),
    );
    clinicController.nearByClinicsForListScreenToClient=_searchList;
  }
}


class DepartmentSearchController extends GetxController {

  final DepartmentController departmentController = Get.find();

  List<Department> _searchList = [];

  List<Department> _searchFromList = [];

  set searchFromList(List<Department> departmentList){
    _searchFromList.assignAll(departmentList);
  }

  searchDepartment(String searchText){
    _searchList.assignAll(
      _searchFromList
          .where((element) => element.name.isCaseInsensitiveContains(searchText))
          .toList(),
    );
    departmentController.departmentListToClient=_searchList;
  }

}


class DepartmentDoctorSearchController extends GetxController {
  final DoctorController doctorController = Get.find();

  List<Doctor> _searchList = [];

  List<Doctor> _searchFromList = [];

  set searchFromList(List<Doctor> departmentList){
    _searchFromList.assignAll(departmentList);
    update();
  }

  searchDepartmentDoctor(String searchText){
    _searchList.assignAll(
      _searchFromList
          .where((element) => element.fullName.isCaseInsensitiveContains(searchText))
          .toList(),
    );
    doctorController.departmentDoctorsToClient=_searchList;
  }
}


class NearByDoctorSearchController extends GetxController {
  final DoctorController doctorController = Get.find();

  searchNearByDoctor(String searchText){
    doctorController.searchNearByDoctorsFromRepository(searchText);
  }
}


