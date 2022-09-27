import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class PrimaryContainer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String text;

  const PrimaryContainer({
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
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_EXTRA_SMALL,
      ),
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
        child: AutoSizeText(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nunitoBold.copyWith(
            color: Colors.white,
            fontSize: FONT_SIZE_DEFAULT,
          ),
        ),
      ),
    );
  }
}

class SecondaryContainer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String text;

  const SecondaryContainer({
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
        border: Border.all(color: SECONDARY_COLOR, width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nunitoBold.copyWith(
            color: Colors.white,
            fontSize: FONT_SIZE_DEFAULT,
          ),
        ),
      ),
    );
  }
}
