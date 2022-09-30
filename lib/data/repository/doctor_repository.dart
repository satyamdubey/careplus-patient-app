import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:http/http.dart' as http;

class DoctorRepository {
  // getting individual doctor
  static Future<dynamic> getDoctor(String doctorId) async {
    var response = await ApiClient().getData(ApiConstant.getDoctor + doctorId);
    if (response is http.Response && response.statusCode == 200) {
      DoctorData doctorData = doctorFromJson(response.body);
      Doctor doctor = doctorData.doctor;
      return doctor;
    } else if (response == "Exception") {
      print('Exception while fetching doctor');
      return null;
    } else {
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }

  // getting top doctors
  static Future<dynamic> getTopDoctors() async {
    var response = await ApiClient()
        .getData(ApiConstant.topDoctors + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      TopDoctorsData topDoctorsData = topDoctorsFromJson(response.body);
      List<Doctor> topDoctors = topDoctorsData.topDoctors;
      return topDoctors;
    } else if (response == "Exception") {
      print('Exception while fetching top doctors');
      return null;
    } else {
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }

  // get doctor in particular department
  static Future<dynamic> getDepartmentDoctors(String departmentName) async {
    var response = await ApiClient().getData(
        '${ApiConstant.getDepartmentDoctors}${StorageHelper.getUserId()}/$departmentName');
    if (response is http.Response && response.statusCode == 200) {
      DepartmentDoctorsData departmentDoctorsData = departmentDoctorsFromJson(response.body);
      List<Doctor> departmentDoctors = departmentDoctorsData.departmentDoctors;
      return departmentDoctors;
    } else if (response == "Exception") {
      print('Exception while fetching department doctors');
      return null;
    } else {
      return null;
    }
  }

  // search nearby doctors
  static Future<dynamic> searchNearByDoctors(String doctorName) async {
    var response = await ApiClient().getData('${ApiConstant.searchNearbyDoctors+StorageHelper.getUserId()}/$doctorName');
    if (response is http.Response && response.statusCode == 200) {
      SearchNearByDoctorsData searchNearByDoctorsData = searchNearByDoctorsDataFromJson(response.body);
      List<Doctor> nearbyDoctors = searchNearByDoctorsData.nearByDoctors;
      print(nearbyDoctors.length);
      return nearbyDoctors;
    } else if (response == "Exception") {
      print('Exception while fetching department doctors');
      return null;
    } else {
      return null;
    }
  }

}
