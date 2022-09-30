import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/view/screens/unauthorised/login_user.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
            AppLocalization.welcomeText,
            style: nunitoBold.copyWith(
              color: Colors.red,
              fontSize: FONT_SIZE_OVER_LARGE,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: HORIZONTAL_PADDING_LARGE,
              vertical: VERTICAL_PADDING_EXTRA_LARGE,
            ),
            child: Text(
              AppLocalization.welcomeDescText,
              textAlign: TextAlign.center,
              style: nunitoRegular.copyWith(
                fontSize: FONT_SIZE_MEDIUM,
              ),
            ),
          ),
          const Spacer(flex: 3),
          Center(
            child: PrimaryButton(
              height: 50,
              width: 160,
              radius: 25,
              text: AppLocalization.welcomeButtonText,
              onTap: () => Get.to(() => const LoginUser()),
            ),
          ),
          const Spacer(flex: 2),
          Center(
            child: Image.asset(welcomeDoctor, fit: BoxFit.fill),
          ),
          Image.asset(
            bottomGradientBar,
            fit: BoxFit.fill,
            width: 1000,
          )
        ],
      ),
    );
  }
}
