import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/patient.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PatientController extends GetxController {
  dynamic _patientPhoto;

  dynamic get patientPhoto => _patientPhoto;

  set patientPhoto(dynamic value) {
    _patientPhoto = value;
    update();
  }

  bool _isPatientDetailLoaded = false;

  bool get isPatientDetailLoaded => _isPatientDetailLoaded;

  dynamic _patientPhotoId;

  dynamic get patientPhotoId => _patientPhotoId;

  void updatePatientPhotoId(dynamic value) {
    _patientPhotoId = value;
    update();
  }

  Future<void> getPatientDetails() async {
    var response = await ApiClient()
        .getData(ApiConstant.getPatientDetail + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      PatientData patientData = patientDataFromJson(response.body);
      await _storePatientDetails(patientData.patient);
      _patientPhotoId = patientData.patient.photo;
    }
    _isPatientDetailLoaded = true;
    update();
  }

  Future<bool> updatePatientDetails(Patient patient) async {
    var response = await ApiClient().postData(
      ApiConstant.updateProfile + StorageHelper.getUserId(), patientToJson(patient));
    if (response is http.Response && response.statusCode == 200) {
      PatientData patientData = patientDataFromJson(response.body);
      _storePatientDetails(patientData.patient);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePatientPhoto() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstant.baseUrl +
            ApiConstant.updatePhoto +
            StorageHelper.getUserId()));
    request.files.add(await http.MultipartFile.fromPath('file', _patientPhoto));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = jsonDecode(await response.stream.bytesToString());
      String photoId = responseData["photo"];
      updatePatientPhotoId(photoId);
      return true;
    } else if (response.statusCode == 413) {
      EasyLoading.showToast('Photosize too large');
      return false;
    } else {
      return false;
    }
  }

  _storePatientDetails(Patient patient) async {
    await StorageHelper.setUserId(patient.id);
    await StorageHelper.setUserName(patient.fullName);
    await StorageHelper.setUserAge(patient.age);
    await StorageHelper.setUserGender(patient.gender);
    await StorageHelper.setUserPhone(patient.phone);
    await StorageHelper.setUserAddress(patient.address);
    await StorageHelper.setUserLocationCoordinates(
        patient.location.coordinates);
  }
}
