import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData iconData;

  const CustomIcon({
    Key? key,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical*5,
      width: SizeConfig.blockSizeHorizontal*12,
      decoration: BoxDecoration(
        color: BACKGOUND_COLOR,
        borderRadius: BorderRadius.circular(
          RADIUS_EXTRA_SMALL,
        ),
      ),
      child: Icon(
        iconData,
        color: GRADIENT_COLOR,
        size: ICON_SIZE_DEFAULT,
      ),
    );
  }
}
