import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_list.dart';
import 'package:careplus_patient/view/screens/authorised/department_list.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/custom_divider.dart';
import 'package:careplus_patient/view/widgets/secondary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategory extends StatelessWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAppBar(
            context: context,
            title: AppLocalization.selectCategory,
          ),
          Text(
            'Please select category for booking appointment',
            style: nunitoBold,
          ),
          const CategoryOptions(),
          Image.asset(bookAppointmentImage),
        ],
      ),
    );
  }
}

class CategoryOptions extends StatelessWidget {
  const CategoryOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SecondaryButton(
          onTap: () => Get.to(() => const ClinicListScreen(title: 'Select Clinic')),
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.blockSizeHorizontal * 60,
          radius: RADIUS_SMALL,
          text: AppLocalization.clinic,
        ),
        CustomDivider(
          text: AppLocalization.or,
          height: 72,
          color: Colors.blue,
        ),
        SecondaryButton(
          onTap: () => Get.to(() => const DepartmentList()),
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.blockSizeHorizontal * 60,
          radius: RADIUS_SMALL,
          text: AppLocalization.department,
        ),
      ],
    );
  }
}
