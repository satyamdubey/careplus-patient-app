import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class RatingStar extends StatelessWidget {
  final rating;
  final iconSize;

  const RatingStar({
    Key? key,
    this.rating,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconSize,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: rating,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(width: 1),
        itemBuilder: (_, index) {
          return Icon(Icons.star, size: iconSize, color: Colors.amber);
        },
      ),
    );
  }
}
