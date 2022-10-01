
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/patient_controller.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/view/screens/authorised/favourite_clinics.dart';
import 'package:careplus_patient/view/screens/authorised/profile_update.dart';
import 'package:careplus_patient/view/screens/authorised/webview.dart';
import 'package:careplus_patient/view/screens/unauthorised/welcome_screen.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final patientController = Get.find<PatientController>();

  @override
  void initState() {
    super.initState();
    patientController.getPatientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: GetBuilder<PatientController>(builder: (_){
        return patientController.isPatientDetailLoaded
          ? Column(
            children: [
              profileImageView(),
              Expanded(child: settingListView(context))
            ])
          : const Center(child:CircularProgressIndicator());
      }),
    );
  }

  Widget profileImageView() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: VERTICAL_PADDING_SMALL,
      ),
      decoration: const BoxDecoration(
        color: PROFILE_BACKGOUND_COLOR,
      ),
      child: Row(
        children: [
          SizedBox(width: HORIZONTAL_PADDING_LARGE),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: ITEM_BACKGOUND_COLOR,
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: patientController.patientPhotoId!=null
                    ? Image.network(ApiConstant.getImage+patientController.patientPhotoId).image
                    : Image.asset(profilePic).image,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello',
                style: nunitoBold.copyWith(
                  color: Colors.grey,
                  fontSize: FONT_SIZE_DEFAULT,
                ),
              ),
              Text(
                StorageHelper.getUserName(),
                style: nunitoBold.copyWith(
                  fontSize: FONT_SIZE_LARGE,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: ()async{
              await Get.to(()=>const ProfileUpdateScreen());
              patientController.patientPhoto=null;
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  settingListView(context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        vertical: VERTICAL_PADDING_DEFAULT,
        horizontal: HORIZONTAL_PADDING_LARGE,
      ),
      children: [
        settingWidget(
          Icons.person_outline,
          'Invite a friend',
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          () => Share.share('https://careplusco.in/\ncheck out careplus app'),
        ),
        const SizedBox(height: 25),
        settingWidget(
          Icons.favorite_outline,
          'Favourite clinics',
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          () => Get.to(() => const FavouriteClinicsScreen()),
        ),
        const SizedBox(height: 25),
        settingWidget(
          Icons.chat_bubble_outline,
          "Return & Refund",
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          ()=>Get.to(()=>const WebViewScreen(url: 'https://careplusco.in/return&refund')),
        ),
        const SizedBox(height: 25),
        settingWidget(
          Icons.help_center_outlined,
          'Terms & Conditions',
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          ()=>Get.to(()=>const WebViewScreen(url: 'https://careplusco.in/terms-condition')),
        ),
        const SizedBox(height: 25),
        settingWidget(
          Icons.note_outlined,
          'Privacy Policy',
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          ()=>Get.to(()=>const WebViewScreen(url: 'https://careplusco.in/privacy-policy')),
        ),
        const SizedBox(height: 25),
        settingWidget(
          Icons.logout,
          'Log out',
          Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE_DEFAULT,
            color: ARROW_ICON_COLOR,
          ),
          () {
            StorageHelper.clear();
            Get.offAll(const WelcomeScreen());
          },
        ),
        const SizedBox(height: 55),
      ],
    );
  }

  settingWidget(
    IconData iconData,
    String text,
    Widget trailingWidget,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 36,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
            ),
            child: Center(
              child: Icon(
                iconData,
                size: ICON_SIZE_DEFAULT,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Text(
            text,
            style: robotoRegular.copyWith(
              color: Colors.grey.shade500,
              fontSize: FONT_SIZE_MEDIUM,
            ),
          ),
          const Spacer(),
          trailingWidget
        ],
      ),
    );
  }
}
