import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/user_location_controller.dart';
import 'package:careplus_patient/view/screens/authorised/google_place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLocation extends StatefulWidget {
  final Color locationIconColor;

  const UserLocation({
    Key? key,
    required this.locationIconColor,
  }) : super(key: key);

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {

  final UserLocationController userLocationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(()=>const GooglePlaceScreen());
      },
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            colors: [
              PRIMARY_COLOR_1,
              PRIMARY_COLOR_2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Icon(
              Icons.location_on,
              color: widget.locationIconColor,
              size: ICON_SIZE_DEFAULT,
            ),
            const SizedBox(width: 5),
            GetBuilder<UserLocationController>(
              builder: (_){
                return Text(
                  userLocationController.userLocationName,
                  style: rubikBold.copyWith(
                    color: Colors.white,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                );
              },
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: ICON_SIZE_DEFAULT,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
