import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/view/screens/authorised/dashboard.dart';
import 'package:careplus_patient/view/screens/unauthorised/welcome_screen.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () {
        StorageHelper.getUserId() != null
            ? Get.offAll(() => const Dashboard())
            : Get.offAll(() => const WelcomeScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(carePlusLogo1),
            Text(
              AppLocalization.splashText,
              style: nunitoBold.copyWith(
                fontSize: FONT_SIZE_MEDIUM,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
