import 'package:careplus_patient/data/model/department.dart';
import 'package:careplus_patient/data/repository/department_repository.dart';
import 'package:get/get.dart';

class DepartmentController extends GetxController {

  final List<Department> _departmentListFromServer = [];

  List<Department> get departmentListFromServer => _departmentListFromServer;


  final List<Department> _departmentListToClient = [];

  List<Department> get departmentListToClient => _departmentListToClient;

  set departmentListToClient(List<Department> departments){
    _departmentListToClient.assignAll(departments);
    update();
  }


  bool _isDepartmentsLoaded = false;

  bool get isDepartmentsLoaded => _isDepartmentsLoaded;


  Future<void> getDepartmentsFromRepository() async {
    if (_isDepartmentsLoaded) {
      _isDepartmentsLoaded = false;
      update();
    }
    var response = await DepartmentRepository.getAllDepartments();
    if (response != null) {
      _departmentListFromServer.assignAll(response);
      _departmentListToClient.assignAll(response);
    }
    _isDepartmentsLoaded = true;
    update();
  }

}
