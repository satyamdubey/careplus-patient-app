import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:flutter/material.dart';

class BestClinicProfile extends StatelessWidget {
  const BestClinicProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://architecturesideas.com/wp-content/uploads/2018/09/best-hospitals-7.jpg',
              ),
            ),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withOpacity(0.5),
                Colors.indigo.withOpacity(0.5),
                Colors.blue.withOpacity(0.5),
                Colors.black.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.00,
                0.25,
                0.50,
                1.00,
              ],
            ),
          ),
        ),
        Container(
          height: 200,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(
            vertical: VERTICAL_PADDING_EXTRA_SMALL,
            horizontal: VERTICAL_PADDING_EXTRA_SMALL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Intelligent Health Clinic",
                style: nunitoBold.copyWith(
                  color: Colors.white,
                  fontSize: FONT_SIZE_LARGE,
                ),
              ),
              RatingWidget(
                iconSize: ICON_SIZE_DEFAULT,
                textFontSize: FONT_SIZE_DEFAULT,
                textColor: Colors.white,
                averageRating: 0,
                reviewsCount: 0,
              )
            ],
          ),
        )
      ],
    );
  }
}
