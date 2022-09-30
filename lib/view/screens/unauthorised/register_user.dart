import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/auth_controller.dart';
import 'package:careplus_patient/data/model/signup.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/services/location_service.dart';
import 'package:careplus_patient/services/notification_services.dart';
import 'package:careplus_patient/view/widgets/custom_check_box.dart';
import 'package:careplus_patient/view/widgets/custom_icon.dart';
import 'package:careplus_patient/view/widgets/custom_text_field.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final authController = Get.find<AuthController>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'male';

  bool check = false;
  bool _locationPermission=true;

  @override
  void initState(){
    super.initState();
    if(LocationService.permissionStatus!=PermissionStatus.granted){
       LocationService.requestLocationService().then((value) => _locationPermission=value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 15,
              child: Image.asset(
                topGradientBar,
                width: 1000,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 66,
              child: _centerView(),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 15,
              child: Image.asset(
                bottomGradientBar2,
                width: 1000,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerView() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_EXTRA_LARGE,
      ),
      child: Column(
        children: [
          _profilePic(),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          CustomTextField(
            controller: _nameController,
            labelText: AppLocalization.name,
            iconData: Icons.person,
          ),
          SizedBox(height: VERTICAL_MARGIN_DEFAULT),
          CustomTextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            labelText: AppLocalization.age,
            iconData: Icons.calendar_month_rounded,
          ),
          SizedBox(height: VERTICAL_MARGIN_DEFAULT),
          _genderFieldRow(),
          SizedBox(height: VERTICAL_MARGIN_DEFAULT),
          CustomTextField(
            controller: _addressController,
            labelText: AppLocalization.address,
            iconData: Icons.location_on,
          ),
          SizedBox(height: VERTICAL_MARGIN_LARGE),
          PrimaryButton(
            onTap: () async {
              if(!_locationPermission){
                EasyLoading.showToast('Location permission not provided');
                return;
              }
              var signup = await _createSignupObj();
              if (signup != null) {
                await authController.registerUser(signup);
              }
            },
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_SMALL,
            text: 'Next',
          ),
        ],
      ),
    );
  }

  Widget _profilePic() {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
        color: ITEM_BACKGOUND_COLOR,
        shape: BoxShape.circle,
      ),
      child: Image.asset(profilePic),
    );
  }

  Widget _genderFieldRow() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: [
            const CustomIcon(iconData: Icons.group),
            SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
            Text(
              AppLocalization.gender,
              style: nunitoBold.copyWith(
                color: Colors.grey,
                fontSize: FONT_SIZE_DEFAULT,
              ),
            ),
            SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (check) {
                    check = !check;
                    _gender = 'male';
                  }
                });
              },
              child: CustomCheckBox(
                check: !check,
                text: AppLocalization.male,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (!check) {
                    check = !check;
                    _gender = 'female';
                  }
                });
              },
              child: CustomCheckBox(
                check: check,
                text: AppLocalization.female,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _createSignupObj() async {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _gender.isNotEmpty) {
      return Signup(
        fullName: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _gender,
        address: _addressController.text,
        authToken: authController.firebaseUserTokenId,
        latitude: LocationService.locationData.latitude??0,
        longitude: LocationService.locationData.longitude??0,
        notificationsToken: PushNotificationService().token??''
      );
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Enter all the required data",
        duration: Duration(seconds: 2),
      ));
      return null;
    }
  }
}
