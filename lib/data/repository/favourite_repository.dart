import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:http/http.dart' as http;

class FavouriteRepository {

  static Future<dynamic> getFavouriteClinics() async {
    var response = await ApiClient()
        .getData(ApiConstant.getFavouriteClinics + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      FavouriteClinicsData favouriteClinicsData =
          favouriteClinicsFromJson(response.body);
      List<Clinic> favouriteClinics = favouriteClinicsData.clinics;
      return favouriteClinics;
    } else {
      return null;
    }
  }

  static Future<dynamic> toggleFavouriteClinic(String clinicId) async {
    var response = await ApiClient().postData(
      ApiConstant.toggleFavouriteClinic,
      jsonEncode({"clinicId":clinicId, "patientId":StorageHelper.getUserId()}),
    );
    if (response is http.Response && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
