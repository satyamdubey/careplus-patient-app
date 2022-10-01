import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/auth_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({Key? key}) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final _otpController = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topView(),
            SizedBox(
              height: SizeConfig.blockSizeVertical*1,
            ),
            _centerView(context),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: HORIZONTAL_PADDING_DEFAULT),
            child: SizedBox(
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 24,
              child: Image.asset(
                carePlusLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: VERTICAL_MARGIN_SMALL),
          Padding(
            padding: EdgeInsets.only(left: HORIZONTAL_PADDING_EXTRA_LARGE),
            child: Text(
              AppLocalization.otpVerificationTitle,
              style: nunitoBold.copyWith(
                color: Colors.red,
                fontSize: FONT_SIZE_OVER_LARGE,
              ),
            ),
          ),
          SizedBox(height: VERTICAL_MARGIN_SMALL),
          Padding(
            padding: EdgeInsets.only(left: HORIZONTAL_PADDING_EXTRA_LARGE),
            child: SizedBox(
              width: SizeConfig.blockSizeHorizontal * 60,
              child: Text(
                'We have sent you OTP to verify your mobile number',
                style: nunitoRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerView(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          _numberText(),
          SizedBox(height: VERTICAL_MARGIN_SMALL),
          _otpFields(context),
          SizedBox(height: VERTICAL_MARGIN_SMALL),
          _resendOtp(),
          SizedBox(height: VERTICAL_MARGIN_SMALL),
          PrimaryButton(
            onTap: () {
              authController.smsCode=_otpController.text;
              authController.manualLoginByOtp();
            },
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 50,
            radius: RADIUS_DEFAULT,
            text: 'Submit',
          )
        ],
      ),
    );
  }

  Widget _numberText() {
    return GetBuilder<AuthController>(builder: (_){
      return Text(
        '+91-${authController.phoneNumber}',
        style: nunitoBold,
      );
    });
  }

  Widget _otpFields(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_EXTRA_LARGE,
      ),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorColor: Colors.black,
        pinTheme: PinTheme(
          fieldHeight: 50,
          fieldWidth: 40,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(RADIUS_SMALL),
          activeColor: Colors.grey,
          selectedColor: Colors.grey,
          inactiveColor: Colors.grey,
          disabledColor: Colors.grey,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
        ),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        controller: _otpController,
        autoDisposeControllers: false,
        onChanged: (value) {
          setState(() {});
        },
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }

  Widget _resendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive OTP?",
          style: nunitoBold,
        ),
        const SizedBox(width: 5),
        InkWell(
          child: Text(
            AppLocalization.otpResendButtonText,
            style: nunitoBold.copyWith(
              color: SECONDARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
