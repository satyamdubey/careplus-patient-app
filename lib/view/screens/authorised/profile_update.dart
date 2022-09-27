import 'dart:io';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/patient_controller.dart';
import 'package:careplus_patient/data/model/patient.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/view/widgets/custom_check_box.dart';
import 'package:careplus_patient/view/widgets/custom_icon.dart';
import 'package:careplus_patient/view/widgets/custom_text_field.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final patientController = Get.find<PatientController>();

  final _nameController = TextEditingController(text: StorageHelper.getUserName());
  final _ageController = TextEditingController(text: '${StorageHelper.getUserAge()}');
  final _addressController = TextEditingController(text: StorageHelper.getUserAddress());
  String _gender = StorageHelper.getUserGender();

  bool check = StorageHelper.getUserGender()=='male';

  @override
  void initState() {
    super.initState();
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
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 10),
            _profileFormFields(),
          ],
        ),
      ),
    );
  }

  Widget _profileFormFields() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_EXTRA_LARGE,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<PatientController>(builder: (_) {
            return _profilePic();
          }),
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
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_SMALL,
            text: 'Update',
            onTap: () async {
              EasyLoading.show(status: 'updating profile');
              var patientObj = await _createPatientObj();
              if (patientObj != null){
                bool result1 = await patientController.updatePatientDetails(patientObj);
                if(result1){
                  await EasyLoading.showToast('Patient details updated');
                }else{
                  await EasyLoading.showToast('Some error in updating profile');
                }
              }
              if(patientController.patientPhoto!=null){
                bool result2 = await patientController.updatePatientPhoto();
                if(result2){
                  await EasyLoading.showToast('Patient photo updated');
                }else{
                  await EasyLoading.showToast('Some error in updating photo');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _profilePic() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: ITEM_BACKGOUND_COLOR,
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: patientController.patientPhoto!=null
                  ? Image.file(File(patientController.patientPhoto)).image
                  : patientController.patientPhotoId!=null
                  ? Image.network(ApiConstant.getImage+patientController.patientPhotoId).image
                  : Image.asset(profilePic).image
            ),
          ),
        ),
        MaterialButton(
          height: 24,
          onPressed: () async => await _getImageFromGallery(),
          color: PRIMARY_COLOR_2,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Text('change'),
        )
      ],
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
                  if (!check) {
                    check = !check;
                    _gender = 'male';
                  }
                });
              },
              child: CustomCheckBox(
                check: check,
                text: AppLocalization.male,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (check) {
                    check = !check;
                    _gender = 'female';
                  }
                });
              },
              child: CustomCheckBox(
                check: !check,
                text: AppLocalization.female,
              ),
            ),
          ],
        );
      },
    );
  }

  _getImageFromGallery() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File pickedImageFile = File(pickedImage.path);
      var imageFileName = pickedImageFile.path
          .substring(pickedImageFile.path.lastIndexOf("/") + 1);
      final externalDir = await getExternalStorageDirectory();
      File localImage =
          await pickedImageFile.copy('${externalDir!.path}/$imageFileName');
      patientController.patientPhoto = localImage.path;
    }
  }

  Future<dynamic> _createPatientObj() async {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      return Patient(
          fullName: _nameController.text,
          age: int.parse(_ageController.text),
          gender: _gender,
          address: _addressController.text);
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Enter all the required data",
        duration: Duration(seconds: 2),
      ));
      return null;
    }
  }
}
