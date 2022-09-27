import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

class CustomTextSection extends StatelessWidget {
  final String title;
  final String text;

  const CustomTextSection({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDivider(
          text: title,
          height: SizeConfig.blockSizeVertical * 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: VERTICAL_PADDING_SMALL,
          ),
          child: Text(
            text,
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
        ),
      ],
    );
  }
}
