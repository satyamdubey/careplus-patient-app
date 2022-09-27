import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/controller/doctor_controller.dart';
import 'package:get/get.dart';

class MenuButtonController extends GetxController {
  final DoctorController doctorController = Get.find<DoctorController>();
  final ClinicController clinicController = Get.find<ClinicController>();

  Future<void> loadMenuButtonsItems() async{
    if(_isItemsForMenuButton1Loaded){
      _isItemsForMenuButton1Loaded=false;
      update();
    }
    if(_isItemsForMenuButton2Loaded){
      _isItemsForMenuButton2Loaded=false;
      update();
    }
    if(_isItemsForMenuButton3Loaded){
      _isItemsForMenuButton3Loaded=false;
      update();
    }
    await doctorController.getTopDoctorsFromRepository().then((_){
      _isItemsForMenuButton1Loaded=doctorController.isTopDoctorsLoaded;
      _menuButton1Items.assignAll(doctorController.topDoctors);
      update();
    });
    await clinicController.getTopClinicsFromRepository().then((_){
      _isItemsForMenuButton2Loaded=clinicController.isTopClinicsLoaded;
      _menuButton2Items.assignAll(clinicController.topClinics);
      update();
    });
    await clinicController.getNearByClinicsFromRepository().then((_){
      _isItemsForMenuButton3Loaded=clinicController.isNearByClinicsLoaded;
      _menuButton3Items.assignAll(clinicController.nearByClinics);
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadMenuButtonsItems();
  }


  int _menuButtonNumber = 1;

  int get menuButtonNumber => _menuButtonNumber;


  bool _isItemsForMenuButton1Loaded = false;

  bool _isItemsForMenuButton2Loaded = false;

  bool _isItemsForMenuButton3Loaded = false;

  bool get isItemsForMenuButton1Loaded => _isItemsForMenuButton1Loaded;

  bool get isItemsForMenuButton2Loaded => _isItemsForMenuButton2Loaded;

  bool get isItemsForMenuButton3Loaded => _isItemsForMenuButton3Loaded;


  final List<dynamic> _menuButton1Items = [];

  final List<dynamic> _menuButton2Items = [];

  final List<dynamic> _menuButton3Items = [];

  List<dynamic> get menuButton1Items => _menuButton1Items;

  List<dynamic> get menuButton2Items => _menuButton2Items;

  List<dynamic> get menuButton3Items => _menuButton3Items;


  set menuButtonNumber(int value) {
    if (value == 1) {
      _menuButtonNumber = value;
      _menuButton1Items.assignAll(doctorController.topDoctors);
      update();
    } else if (value == 2) {
      _menuButtonNumber = value;
      _menuButton2Items.assignAll(clinicController.topClinics);
      update();
    } else if (value == 3) {
      _menuButtonNumber = value;
      _menuButton3Items.assignAll(clinicController.nearByClinics);
      update();
    }
  }

}
