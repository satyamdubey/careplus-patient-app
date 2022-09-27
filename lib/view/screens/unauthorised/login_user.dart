import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/auth_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _numberController = TextEditingController();
  final authController = Get.find<AuthController>();

  showAuthStatus(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<AuthController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 15,
                  child: _topView(),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 10,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 25,
                  child: _centerView(),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 6,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 40,
                  child: _bottomView(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      children: [
        SizedBox(width: HORIZONTAL_PADDING_EXTRA_LARGE),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.blockSizeHorizontal * 24,
          child: Image.asset(
            carePlusLogo1,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: double.infinity,
          child: Image.asset(
            cloudImage,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  Widget _centerView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: VERTICAL_PADDING_EXTRA_SMALL,
            horizontal: HORIZONTAL_PADDING_SMALL,
          ),
          margin: EdgeInsets.only(left: HORIZONTAL_PADDING_EXTRA_LARGE),
          decoration: BoxDecoration(
            color: SECONDARY_COLOR,
            borderRadius: BorderRadius.circular(RADIUS_DEFAULT),
          ),
          child: Text(
            'INDIA (+91)',
            style: nunitoRegular.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: HORIZONTAL_PADDING_EXTRA_LARGE,
            right: HORIZONTAL_PADDING_EXTRA_LARGE,
            top: VERTICAL_PADDING_SMALL,
            bottom: VERTICAL_PADDING_LARGE,
          ),
          child: _loginTextField(),
        ),
        Center(
          child: InkWell(
            onTap: () {
              if(_numberController.text.length==10){
                authController.phoneNumber = _numberController.text;
                authController.authenticateWithPhoneNumber();
              }else{
                Get.showSnackbar(const GetSnackBar(
                  message: "Enter the correct phone number",
                  duration: Duration(seconds: 2),
                ));
              }
            },
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 40,
              padding: EdgeInsets.symmetric(
                vertical: VERTICAL_PADDING_EXTRA_SMALL,
              ),
              decoration: BoxDecoration(
                color: SECONDARY_COLOR,
                borderRadius: BorderRadius.circular(RADIUS_LARGE),
              ),
              alignment: Alignment.center,
              child: Text(
                'Get OTP',
                style: nunitoRegular.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: HORIZONTAL_PADDING_EXTRA_LARGE,
          ),
          child: Text(
            "OTP will be sent to your mobile number",
            textAlign: TextAlign.center,
            style: nunitoBold.copyWith(
              color: SECONDARY_COLOR,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 20,
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    bottomGradientBar2,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  loginUserImage,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      controller: _numberController,
      onChanged: (value){
        if(value.length==10 || value.isEmpty){
        FocusScope.of(context).unfocus();
      }},
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: 'Enter your mobile number',
        hintStyle: robotoMedium.copyWith(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: HORIZONTAL_PADDING_DEFAULT,
        ),
      ),
    );
  }
}
