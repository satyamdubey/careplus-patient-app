import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final BuildContext context;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical*7.5,
      alignment: const Alignment(0, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: ()=>Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 3),
          Text(
            title,
            style: nunitoBold.copyWith(
              color: Colors.white,
              fontSize: FONT_SIZE_LARGE,
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
