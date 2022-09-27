import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserLocationController extends GetxController {
  dynamic _userLocationName = StorageHelper.getUserLocationName()??'Select Address';

  dynamic get userLocationName => _userLocationName;

  Future<void> setUserLocation(String locationName, List<String> locationCoordinates) async{
    await StorageHelper.setUserLocationName(locationName);
    await StorageHelper.setUserLocationCoordinates(locationCoordinates);
   _userLocationName = await StorageHelper.getUserLocationName();
    update();
  }

  Future<bool> updateUserLocation(String address, List<String> coordinates) async {
    Map postData = {
      "patientId": StorageHelper.getUserId(),
      "latitude": coordinates[0],
      "longitude": coordinates[1],
    };
    var response = await ApiClient().patchData(
      ApiConstant.updateLocation,
      jsonEncode(postData),
    );
    if (response is http.Response && response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }
}
