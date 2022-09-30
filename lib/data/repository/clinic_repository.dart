import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:http/http.dart' as http;

class ClinicRepository {
  static Future<dynamic> getClinic(String clinicId) async {
    var response = await ApiClient().getData(ApiConstant.getClinic + clinicId);
    if (response is http.Response && response.statusCode == 200) {
      ClinicData clinicData = clinicFromJson(response.body);
      Clinic clinic = clinicData.clinic;
      return clinic;
    } else {
      return null;
    }
  }

  static Future<dynamic> getTopClinics() async {
    var response = await ApiClient()
        .getData(ApiConstant.topClinics + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      TopClinicsData topClinicsData = topClinicsFromJson(response.body);
      List<Clinic> topClinics = topClinicsData.clinics;
      return topClinics;
    } else {
      return null;
    }
  }

  static Future<dynamic> getNearByClinics(int limit, int page) async {
    var response = await ApiClient().getData(
        '${ApiConstant.nearByClinics}${StorageHelper.getUserId()}/$limit/$page');
    if (response is http.Response && response.statusCode == 200) {
      print(response.statusCode);
      NearByClinicsData nearByClinicsData = nearByClinicsFromJson(response.body);
      List<Clinic> nearByClinics = nearByClinicsData.clinics;
      return nearByClinics;
    } else {
      return null;
    }
  }
}
