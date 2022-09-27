import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/patient.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PatientController extends GetxController{

  dynamic _patientPhoto;

  dynamic get patientPhoto => _patientPhoto;

  set patientPhoto(dynamic value) {
    _patientPhoto = value;
    update();
  }


  dynamic _patientPhotoId = StorageHelper.getUserPhotoId();

  dynamic get patientPhotoId => _patientPhotoId;

  set patientPhotoId(dynamic value){
    _patientPhotoId = value;
    update();
  }

  void updatePatientPhotoId(dynamic value) {
    _patientPhotoId = value;
    StorageHelper.setUserPhotoId(value);
    update();
  }


  Future<bool> updatePatientDetails(Patient patient) async{
    var response = await ApiClient().postData(ApiConstant.updateProfile+StorageHelper.getUserId(), patientToJson(patient));
    if(response is http.Response && response.statusCode==200){
      PatientData patientData = patientDataFromJson(response.body);
      _storePatientDetails(patientData.patient);
      return true;
    }else{
      print(response.body);
      return false;
    }
  }

  Future<bool> updatePatientPhoto() async{
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstant.baseUrl+ApiConstant.updatePhoto+StorageHelper.getUserId()));
    request.files.add(await http.MultipartFile.fromPath('file',_patientPhoto));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = jsonDecode(await response.stream.bytesToString());
      String photoId = responseData["photo"];
      updatePatientPhotoId(photoId);
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }

  _storePatientDetails(Patient patient) async{
    await StorageHelper.setUserId(patient.id);
    await StorageHelper.setUserName(patient.fullName);
    await StorageHelper.setUserAge(patient.age);
    await StorageHelper.setUserGender(patient.gender);
    await StorageHelper.setUserPhone(patient.phone);
    await StorageHelper.setUserAddress(patient.address);
    await StorageHelper.setUserLocationCoordinates(patient.location.coordinates);
  }

}