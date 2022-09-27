import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final double height;
  final Color color;

  const CustomDivider({
    Key? key,
    required this.text,
    required this.height,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: color,
              thickness: 1,
            ),
          ),
          const SizedBox(width: 5),
          Text(text, style: nunitoBold.copyWith(fontSize: 20)),
          const SizedBox(width: 5),
          Expanded(
            child: Divider(
              color: color,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
