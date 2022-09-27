import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  final double height;
  final double width;
  final double radius;
  final String text;
  final VoidCallback onTap;
  final bool fillBackground;

  const SecondaryButton({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    required this.text,
    required this.onTap,
    this.fillBackground = false,
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool tapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() {
        tapDown = true;
      }),
      onTapUp: (_) => setState(() {
        tapDown = false;
      }),
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING_SMALL),
        decoration: BoxDecoration(
          color: widget.fillBackground ? SECONDARY_COLOR : Colors.white,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: tapDown ? WHITE_COLOR : SECONDARY_COLOR,
            width: 1.5,
          ),
          gradient: tapDown
              ? const LinearGradient(
                  colors: [PRIMARY_COLOR_1, PRIMARY_COLOR_2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
        ),
        child: Center(
          child: AutoSizeText(
            widget.text,
            style: nunitoBold.copyWith(
              color: tapDown ? WHITE_COLOR : SECONDARY_COLOR,
              fontSize: FONT_SIZE_DEFAULT,
            ),
          ),
        ),
      ),
    );
  }
}
