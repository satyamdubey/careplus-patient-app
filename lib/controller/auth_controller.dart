import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/patient.dart';
import 'package:careplus_patient/data/model/signup.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/services/notification_services.dart';
import 'package:careplus_patient/view/screens/authorised/dashboard.dart';
import 'package:careplus_patient/view/screens/unauthorised/otp_verify.dart';
import 'package:careplus_patient/view/screens/unauthorised/register_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum AuthStatus {
  uninitialized,
  authenticating,
  otpSent,
  autoDetectingOtp,
  verifying,
  verified,
  checking,
  exist,
  register,
  authenticated,
  error,
}

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _statusMessage = 'uninitialized';
  AuthStatus _status = AuthStatus.uninitialized;

  dynamic _phoneNumber;
  dynamic _smsCode;
  dynamic _verificationId;
  dynamic _firebaseUserTokenId;


  dynamic get phoneNumber => _phoneNumber;

  set phoneNumber(dynamic value) {
    _phoneNumber = value;
    update();
  }

  set smsCode(dynamic value) {
    _smsCode = value;
  }

  dynamic get firebaseUserTokenId => _firebaseUserTokenId;


  Future<bool> isLoggedIn() async {
    return false;
  }


  // authenticate with phone number
  Future<void> authenticateWithPhoneNumber() async {
    String indianPhoneNumber = "+91 $_phoneNumber";
    _statusMessage = 'authenticating';
    _status = AuthStatus.authenticating;
    _showAuthStatus();

    // phone verification completed by detecting sms automatically
    Future<void> verificationCompleted(AuthCredential authCredential) async {
      _statusMessage = 'Auto detecting otp';
      _status = AuthStatus.autoDetectingOtp;
      _showAuthStatus();
      final userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);
      if (userCredential.user != null) {
        _verificationSuccessful(userCredential.user);
      } else {
        _statusMessage = 'Invalid code/invalid authentication';
        _status = AuthStatus.error;
        _showAuthStatus();
      }
    }

    // on phone verification failed
    void verificationFailed(FirebaseAuthException authException) {
      if (authException.message!.contains('not authorized')) {
        _statusMessage = 'Something has gone wrong, please try later';
        _status = AuthStatus.error;
      } else if (authException.message!.contains('Network')) {
        _statusMessage = 'Please check your internet connection and try again';
        _status = AuthStatus.error;
      } else {
        _statusMessage = 'Something has gone wrong, please try later';
        _status = AuthStatus.error;
      }
      _showAuthStatus();
    }

    // on sms code sent to device
    void codeSent(String verificationId, int? resendToken) {
      _verificationId = verificationId;
      _statusMessage = "Enter the otp sent to $_phoneNumber";
      _status = AuthStatus.otpSent;
      _showAuthStatus();
      Get.to(() => const OtpVerify());
    }

    // when sms is not automatically resolved (only android)
    void codeAutoRetrievalTimeout(String verificationId) {}

    // verify phone number
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: indianPhoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // login by entering otp manually on OTP verification page
  Future<void> manualLoginByOtp() async {
    if (_verificationId != null && _smsCode != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      _statusMessage = "verifying the OTP";
      _status = AuthStatus.verifying;
      _showAuthStatus();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          _verificationSuccessful(userCredential.user);
        }
      } on Exception catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast(
          'Entered OTP is incorrect',
          toastPosition: EasyLoadingToastPosition.bottom,
        );
      }
    }
  }

  // upon successful authentication
  void _verificationSuccessful(User? user) async {
    _statusMessage = "verification successful";
    _status = AuthStatus.verified;
    _showAuthStatus();
    _firebaseUserTokenId = await user!.getIdToken();
    _checkIfUserExist(await user.getIdToken());
  }

  _checkIfUserExist(String authToken) async {
    _statusMessage = "checking user";
    _status = AuthStatus.checking;
    _showAuthStatus();
    var response = await ApiClient().postData(
      ApiConstant.login,
      jsonEncode({"authToken":authToken, "notificationsToken":PushNotificationService().token})
    );

    if (response is http.Response && response.statusCode == 200) {
      _statusMessage = "Welcome back";
      _status = AuthStatus.exist;
      _showAuthStatus();
      PatientData patientData = patientDataFromJson(response.body);
      _storePatientDetails(patientData.patient);
      Get.offAll(() => const Dashboard());
    } else if (response is http.Response && response.statusCode == 404) {
      _statusMessage = "Please Register Yourself";
      _status = AuthStatus.register;
      _showAuthStatus();
      Get.offAll(() => const RegisterUser());
    } else {
      _statusMessage = "Some Unknown exception occurred, try again!";
      _status = AuthStatus.error;
      _showAuthStatus();
    }
  }

  Future<void> registerUser(Signup signup) async {
    EasyLoading.show(status: 'Registering...');
    var response =
        await ApiClient().postData(ApiConstant.signUp, signupToJson(signup));
    EasyLoading.dismiss();
    if (response is http.Response && response.statusCode == 200) {
      _statusMessage = "Already registered";
      _status = AuthStatus.register;
      _showAuthStatus();
      PatientData patientData = patientDataFromJson(response.body);
      _storePatientDetails(patientData.patient);
      Get.offAll(() => const Dashboard());
    } else if (response is http.Response && response.statusCode == 201) {
      _statusMessage = "Welcome to care plus";
      _status = AuthStatus.register;
      _showAuthStatus();
      PatientData patientData = patientDataFromJson(response.body);
      _storePatientDetails(patientData.patient);
      Get.offAll(() => const Dashboard());
    } else {
      _statusMessage = "Some Unknown exception occurred, try again!";
      _status = AuthStatus.error;
      _showAuthStatus();
    }
  }

  _storePatientDetails(Patient patient) async{
    await StorageHelper.setUserId(patient.id);
    await StorageHelper.setUserName(patient.fullName);
    await StorageHelper.setUserPhotoId(patient.photo);
    await StorageHelper.setUserAge(patient.age);
    await StorageHelper.setUserGender(patient.gender);
    await StorageHelper.setUserPhone(patient.phone);
    await StorageHelper.setUserAddress(patient.address);
    await StorageHelper.setUserLocationCoordinates(patient.location.coordinates);
  }

  _showAuthStatus() {
    switch (_status) {
      case AuthStatus.authenticating:
        EasyLoading.show(status: _statusMessage);
        break;

      case AuthStatus.otpSent:
        EasyLoading.dismiss();
        EasyLoading.showToast(
          _statusMessage,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        break;

      case AuthStatus.verifying:
        EasyLoading.show(status: _statusMessage);
        break;

      case AuthStatus.autoDetectingOtp:
        EasyLoading.show(status: _statusMessage);
        break;

      case AuthStatus.verified:
        EasyLoading.dismiss();
        EasyLoading.showToast(
          _statusMessage,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        break;

      case AuthStatus.checking:
        EasyLoading.show(status: _statusMessage);
        break;

      case AuthStatus.exist:
        EasyLoading.dismiss();
        EasyLoading.showToast(
          _statusMessage,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        break;

      case AuthStatus.register:
        EasyLoading.dismiss();
        EasyLoading.showToast(
          _statusMessage,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        break;

      case AuthStatus.error:
        EasyLoading.dismiss();
        EasyLoading.showToast(
          _statusMessage,
          toastPosition: EasyLoadingToastPosition.bottom,
        );
        break;

      default:
        EasyLoading.dismiss();
        break;
    }
  }
}
