import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

import 'custom_icon.dart';

class CustomTextField extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool enabled;

  const CustomTextField({
    Key? key,
    this.enabled=true,
    required this.controller,
    this.keyboardType=TextInputType.text,
    required this.labelText,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIcon(iconData: iconData),
        SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
        Expanded(
          child: SizedBox(
            height: SizeConfig.blockSizeVertical*5,
            child: TextFormField(
              enabled: enabled,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
