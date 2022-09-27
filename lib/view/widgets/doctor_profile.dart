import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

import 'custom_container.dart';

class DoctorProfile extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfile({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 19,
          width: SizeConfig.blockSizeHorizontal * 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RADIUS_DEFAULT),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: doctor.photo==null
                  ? Image.asset(doctorImage).image
                  :Image.network(ApiConstant.getImage+doctor.photo).image,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 19,
          width: SizeConfig.blockSizeHorizontal * 45,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                doctor.fullName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: rubikBold.copyWith(fontSize: FONT_SIZE_MEDIUM),
              ),
              Text(
                doctor.specialist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: rubikRegular.copyWith(),
              ),
              PrimaryContainer(
                height: SizeConfig.blockSizeVertical * 4,
                width: SizeConfig.blockSizeHorizontal * 40,
                radius: RADIUS_EXTRA_SMALL,
                text: '${doctor.experience}+ Exp.',
              ),
              PrimaryContainer(
                height: SizeConfig.blockSizeVertical * 4,
                width: SizeConfig.blockSizeHorizontal * 40,
                radius: RADIUS_EXTRA_SMALL,
                text: '${doctor.patient}+ Patients',
              ),
            ],
          ),
        )
      ],
    );
  }
}
