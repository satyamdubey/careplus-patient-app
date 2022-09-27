import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double iconSize;
  final double textFontSize;
  final Color textColor;
  final num averageRating;
  final num reviewsCount;

  const RatingWidget({
    Key? key,
    required this.iconSize,
    required this.textFontSize,
    this.textColor = Colors.black,
    required this.averageRating,
    required this.reviewsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: RATING_STAR_FILLED,
          size: ICON_SIZE_SMALL,
        ),
        Text(
          '${averageRating.toDouble()} ($reviewsCount reviews)',
          style: rubikRegular.copyWith(
            fontSize: textFontSize,
            color: textColor,
          ),
        )
      ],
    );
  }
}
