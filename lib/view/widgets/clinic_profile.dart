import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_reviews.dart';
import 'package:careplus_patient/view/widgets/custom_container.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class ClinicProfile extends StatelessWidget {
  final Clinic clinic;

  const ClinicProfile({Key? key, required this.clinic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 18,
          width: SizeConfig.blockSizeHorizontal * 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RADIUS_SMALL),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: clinic.profilePhoto != null
                  ? Image.network(ApiConstant.getImage + clinic.profilePhoto).image
                  : Image.asset(clinicImage).image,
            ),
          ),
        ),
        SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 19,
          width: SizeConfig.blockSizeHorizontal * 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                clinic.name,
                textAlign: TextAlign.center,
                style: rubikBold.copyWith(fontSize: FONT_SIZE_DEFAULT),
              ),
              SizedBox(height: VERTICAL_MARGIN_SMALL),
              PrimaryContainer(
                width: SizeConfig.blockSizeHorizontal * 40,
                height: SizeConfig.blockSizeVertical * 4,
                radius: RADIUS_EXTRA_SMALL,
                text: '${clinic.doctors.length} Doctors',
              ),
              SizedBox(height: VERTICAL_MARGIN_SMALL),
              PrimaryButton(
                onTap: (){
                  if(clinic.ratings.isNotEmpty){
                    Get.to(()=>ClinicReviewsScreen(clinic: clinic));
                  }else{
                    EasyLoading.showToast('No Reviews');
                  }
                },
                width: SizeConfig.blockSizeHorizontal * 40,
                height: SizeConfig.blockSizeVertical * 4,
                radius: RADIUS_EXTRA_SMALL,
                text: '${clinic.ratings.length} Reviews',
              ),
            ],
          ),
        )
      ],
    );
  }
}
