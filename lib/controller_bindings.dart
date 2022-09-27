import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/auth_controller.dart';
import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/controller/department_controller.dart';
import 'package:careplus_patient/controller/doctor_controller.dart';
import 'package:careplus_patient/controller/family_member_controller.dart';
import 'package:careplus_patient/controller/favourite_controller.dart';
import 'package:careplus_patient/controller/menu_option_controller.dart';
import 'package:careplus_patient/controller/my_appointments_controller.dart';
import 'package:careplus_patient/controller/notification_controller.dart';
import 'package:careplus_patient/controller/patient_controller.dart';
import 'package:careplus_patient/controller/promotion_controller.dart';
import 'package:careplus_patient/controller/review_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/controller/user_location_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => PromotionController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => MenuButtonController(), fenix: true);
    Get.lazyPut(() => DoctorController(), fenix: true);
    Get.lazyPut(() => ClinicController(), fenix: true);
    Get.lazyPut(() => DepartmentController(), fenix: true);
    Get.lazyPut(() => PatientController(), fenix: true);
    Get.lazyPut(() => FamilyMemberController(), fenix: true);
    Get.lazyPut(() => AppointmentController(), fenix: true);
    Get.lazyPut(() => MyAppointmentsController(), fenix: true);
    Get.lazyPut(() => ClinicSearchController(), fenix: true);
    Get.lazyPut(() => DepartmentSearchController(), fenix: true);
    Get.lazyPut(() => DoctorSearchController(), fenix: true);
    Get.lazyPut(() => ReviewController(), fenix: true);
    Get.lazyPut(() => FavouriteController(), fenix: true);
    Get.lazyPut(() => UserLocationController(), fenix: true);
  }

}