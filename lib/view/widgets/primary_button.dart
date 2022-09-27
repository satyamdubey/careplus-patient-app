import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String text;
  final VoidCallback onTap;

  const PrimaryButton({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
            colors: [
              PRIMARY_COLOR_1,
              PRIMARY_COLOR_2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: nunitoBold.copyWith(
              color: Colors.white,
              fontSize: FONT_SIZE_DEFAULT,
            ),
          ),
        ),
      ),
    );
  }
}
