import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/department.dart';
import 'package:http/http.dart' as http;

class DepartmentRepository{

  static Future<dynamic> getAllDepartments() async{
    var response = await ApiClient().getData(ApiConstant.getDepartments);
    if(response is http.Response && response.statusCode==200){
      DepartmentData departmentData = departmentsFromJson(response.body);
      List<Department> departments = departmentData.departments;
      return departments;
    }else{
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }

}