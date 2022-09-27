import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool check;
  final String text;

  const CustomCheckBox({
    Key? key,
    required this.check,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 4,
      width: SizeConfig.blockSizeHorizontal * 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(RADIUS_DEFAULT),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(-1.22, 0),
            child: Container(
              height: double.infinity,
              width: SizeConfig.blockSizeHorizontal * 10,
              decoration: BoxDecoration(
                color: BACKGOUND_COLOR,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Visibility(
                visible: check,
                child: Icon(
                  Icons.check,
                  color: GRADIENT_COLOR,
                  size: ICON_SIZE_DEFAULT,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.5, 0),
            child: AutoSizeText(
              text,
              maxLines: 1,
              style: nunitoBold.copyWith(
                fontSize: FONT_SIZE_SMALL,
              ),
            ),
          )
        ],
      ),
    );
  }
}
