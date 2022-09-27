import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/family_member_controller.dart';
import 'package:careplus_patient/data/model/family_member.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/custom_check_box.dart';
import 'package:careplus_patient/view/widgets/custom_icon.dart';
import 'package:careplus_patient/view/widgets/custom_text_field.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class MemberDetailScreen extends StatefulWidget {
  final bool addPatientDetail;

  const MemberDetailScreen({Key? key, this.addPatientDetail = false})
      : super(key: key);

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  final familyMemberController = Get.find<FamilyMemberController>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();
  String _gender = 'Male';
  bool check = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        children: [
          _memberDetail(context),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          PrimaryButton(
            text: 'Done',
            height: SizeConfig.blockSizeVertical * 6,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_SMALL,
            onTap: () async{
              FocusScope.of(context).unfocus();
              _createFamilyMember();
            },
          ),
        ],
      ),
    );
  }

  Widget _memberDetail(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppBar(
          context: context,
          title: 'Add Family Member',
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: HORIZONTAL_PADDING_LARGE,
          ),
          child: Column(
            children: [
              const SizedBox(height: 25),
              CustomTextField(
                controller: _nameController,
                labelText: AppLocalization.name,
                iconData: Icons.person,
              ),
              const SizedBox(height: 25),
              CustomTextField(
                controller: _ageController,
                labelText: AppLocalization.age,
                keyboardType: TextInputType.number,
                iconData: Icons.calendar_month_rounded,
              ),
              const SizedBox(height: 25),
              CustomTextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                labelText: AppLocalization.phone,
                iconData: Icons.phone,
              ),
              const SizedBox(height: 25),
              StatefulBuilder(
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
                              _gender = 'Male';
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
                              _gender = 'Female';
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
              ),
              const SizedBox(height: 25),
              CustomTextField(
                labelText: 'Relationship',
                controller: _relationController,
                iconData: Icons.person,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createFamilyMember() async{
    if (_gender.isNotEmpty
        &&_nameController.text.isNotEmpty
        &&_ageController.text.isNotEmpty
        &&_phoneController.text.isNotEmpty
        &&_relationController.text.isNotEmpty){
      if(_ageController.text.length>=3){
        Get.showSnackbar(const GetSnackBar(
          message: "Enter your correct age",
          duration: Duration(seconds: 2),
        ));
        return null;
      }
      if(_phoneController.text.length!=10){
        Get.showSnackbar(const GetSnackBar(
          message: "Enter your correct mobile number",
          duration: Duration(seconds: 2),
        ));
        return null;
      }
      FamilyMember familyMember = FamilyMember(
        gender: _gender,
        name: _nameController.text,
        age: _ageController.text,
        phone: _phoneController.text,
        relationShip: _relationController.text,
      );

      EasyLoading.show(status: "Adding member");
      await familyMemberController.addFamilyMember(familyMember)
          .then((value){
        EasyLoading.dismiss();
        if(value){
          EasyLoading.showToast('Member Added');
          Navigator.of(context).pop();
        }else{
          EasyLoading.showToast('Some Problem Occurred adding member, try again');
        }
      });
    }else{
      Get.showSnackbar(const GetSnackBar(
        message: "Add All Details Properly",
        duration: Duration(seconds: 2),
      ));
    }
  }

}
