import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/doctor_reviews.dart';
import 'package:careplus_patient/view/widgets/custom_text_section.dart';
import 'package:careplus_patient/view/widgets/doctor_profile.dart';
import 'package:careplus_patient/view/widgets/horizontal_item_list.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'select_appointment_date.dart';


class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _screenBody(),
          _screenBottomButtons(context, appointmentController)
        ],
      ),
    );
  }

  Widget _screenBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 25,
          child: DoctorProfile(doctor: doctor),
        ),
        const Divider(
          height: 1,
          thickness: 1.5,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          child: _doctorDepartmentAndRating(),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 15,
          child: Center(
            child: CustomTextSection(
              title: 'About Doctor',
              text: doctor.about,
            ),
          ),
        ),
        SizedBox(
          height: VERTICAL_MARGIN_SMALL,
        ),
        Padding(
          padding: EdgeInsets.only(left: HORIZONTAL_PADDING_DEFAULT),
          child: Text(
            'Available Clinics',
            style: robotoBold.copyWith(
              color: SECONDARY_COLOR,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: VERTICAL_MARGIN_SMALL,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 28,
          child: ClinicsAvailable(
            availableClinics: doctor.availableClinics,
          ),
        ),
      ],
    );
  }

  Widget _doctorDepartmentAndRating() {
    return Row(
      children: [
        SizedBox(width: HORIZONTAL_PADDING_DEFAULT),
        Expanded(
          flex: 4,
          child: AutoSizeText(
            doctor.specialist,
            style: nunitoBold.copyWith(
              color: SECONDARY_COLOR,
              fontSize: FONT_SIZE_LARGE,
            ),
          ),
        ),
        const Spacer(flex: 2),
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: ()=>Get.to(()=>DoctorReviewsScreen(doctor: doctor)),
            child: RatingWidget(
              averageRating: doctor.averageRating,
              reviewsCount: doctor.reviewsCount,
              iconSize: ICON_SIZE_LARGE,
              textFontSize: FONT_SIZE_DEFAULT,
            ),
          ),
        ),
      ],
    );
  }

  Widget _screenBottomButtons(context, AppointmentController appointmentController) {
    return Column(
      children: [
        ActionRowButtons(
          onTapButton1: () => Navigator.of(context).pop(),
          button1Style: ActionRowButtonStyle.secondary,
          button2Style: ActionRowButtonStyle.secondary,
          onTapButton2: () async {
            if (appointmentController.selectedClinic != null) {
              EasyLoading.show(status: 'checking appointment availability');
              bool response = await appointmentController.getAvailableAppointmentDates();
              EasyLoading.dismiss();
              if(response){
                Get.to(() => const SelectAppointmentDateScreen());
              }else{
                Get.showSnackbar(const GetSnackBar(
                  message: "No appointment dates available",
                  duration: Duration(seconds: 2),
                ));
              }
            } else {
              Get.showSnackbar(const GetSnackBar(
                message: "Select Any Clinic",
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class ClinicsAvailable extends StatelessWidget {
  final List<AvailableClinic> availableClinics;

  const ClinicsAvailable({
    Key? key,
    required this.availableClinics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List clinicList = [];
    for (var element in availableClinics) {
      clinicList.add(element.clinicDetail);
    }
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: HorizontalClinicList(
        clinicList: clinicList,
        bookAppointment: true,
      ),
    );
  }
}
