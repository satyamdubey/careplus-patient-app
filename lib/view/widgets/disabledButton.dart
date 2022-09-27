import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class DisabledButton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String text;

  const DisabledButton({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.shade600)
      ),
      child: Center(
        child: Text(
          text,
          style: nunitoBold.copyWith(
            color: Colors.grey.shade600,
            fontSize: FONT_SIZE_DEFAULT,
          ),
        ),
      ),
    );
  }
}
