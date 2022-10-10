import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_detail.dart';
import 'package:careplus_patient/view/screens/authorised/doctor_detail.dart';
import 'package:careplus_patient/view/widgets/custom_container.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalDoctorList extends StatefulWidget {
  final List doctorsList;
  final bool bookAppointment;

  const HorizontalDoctorList({
    Key? key,
    this.doctorsList = const [],
    this.bookAppointment = false,
  }) : super(key: key);

  @override
  State<HorizontalDoctorList> createState() => _HorizontalDoctorListState();
}

class _HorizontalDoctorListState extends State<HorizontalDoctorList> {
  final appointmentController = Get.find<AppointmentController>();
  int _selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.doctorsList.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_DEFAULT,
        vertical: VERTICAL_PADDING_EXTRA_SMALL,
      ),
      separatorBuilder: (_, __) => SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (widget.bookAppointment) {
              setState(() {
                _selectedItem == index
                    ? _selectedItem = -1
                    : _selectedItem = index;
                _selectedItem == index
                    ? appointmentController.selectDoctor(widget.doctorsList[index])
                    : appointmentController.selectDoctor(null);
              });
            } else {
              appointmentController.selectDoctor(widget.doctorsList[index]);
              Get.to(() => DoctorDetailScreen(doctor: widget.doctorsList[index]));
            }
          },
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 35,
            padding: EdgeInsets.symmetric(
              vertical: VERTICAL_PADDING_EXTRA_SMALL,
              horizontal: HORIZONTAL_PADDING_SMALL,
            ),
            decoration: BoxDecoration(
              color: _selectedItem == index
                  ? Colors.greenAccent.shade700
                  : Colors.white,
              borderRadius: BorderRadius.circular(RADIUS_SMALL),
            ),
            child: widget.doctorsList.isEmpty
                ? null
                : Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 28,
                          decoration: BoxDecoration(
                            color: ITEM_BACKGOUND_COLOR,
                            borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              onError: (_, __) => print('error loading image'),
                              image: widget.doctorsList[index].photo == null
                                  ? Image.asset(doctorImage).image
                                  : Image.network(ApiConstant.getImage + widget.doctorsList[index].photo).image,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: VERTICAL_MARGIN_EXTRA_SMALL),
                      Expanded(
                        flex: 1,
                        child: AutoSizeText(
                          widget.doctorsList[index].fullName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: rubikBold.copyWith(
                            fontSize: FONT_SIZE_SMALL,
                            color: _selectedItem == index ? Colors.white : ITEM_NAME_COLOR,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.bookAppointment
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  AutoSizeText(
                                    widget.doctorsList[index].specialist,
                                    maxLines: 1,
                                    style: nunitoBold.copyWith(
                                      fontSize: FONT_SIZE_SMALL,
                                      color: _selectedItem == index ? Colors.white : ITEM_NAME_COLOR,
                                    ),
                                  ),
                                  PrimaryContainer(
                                    height: SizeConfig.blockSizeVertical * 2.5,
                                    width: SizeConfig.blockSizeHorizontal * 28,
                                    radius: RADIUS_EXTRA_SMALL,
                                    text: widget.doctorsList[index].department,
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  AutoSizeText(
                                    widget.doctorsList[index].availableClinics[0].clinicDetail.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: rubikRegular.copyWith(
                                      fontSize: FONT_SIZE_SMALL,
                                      color: ITEM_DESCRIPTION_COLOR,
                                    ),
                                  ),
                                  RatingWidget(
                                    averageRating: widget.doctorsList[index].averageRating ?? 0,
                                    reviewsCount: widget.doctorsList[index].reviewsCount ?? 0,
                                    iconSize: ICON_SIZE_DEFAULT,
                                    textFontSize: FONT_SIZE_EXTRA_SMALL,
                                    textColor: Colors.black,
                                  )
                                ],
                            ),
                      )
                  ],
                ),
          ),
        );
      },
    );
  }
}

class HorizontalClinicList extends StatefulWidget {
  final List<dynamic> clinicList;
  final bool bookAppointment;

  const HorizontalClinicList({
    Key? key,
    this.clinicList = const [],
    this.bookAppointment = false,
  }) : super(key: key);

  @override
  State<HorizontalClinicList> createState() => _HorizontalClinicListState();
}

class _HorizontalClinicListState extends State<HorizontalClinicList> {
  final appointmentController = Get.find<AppointmentController>();
  int _selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.clinicList.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_DEFAULT,
        vertical: VERTICAL_PADDING_EXTRA_SMALL,
      ),
      separatorBuilder: (_, __) => SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (widget.bookAppointment) {
              setState(() {
                _selectedItem == index ? _selectedItem = -1 : _selectedItem = index;
                _selectedItem == index
                    ? appointmentController.selectClinic(widget.clinicList[index])
                    : appointmentController.selectClinic(null);
              });
            } else {
              appointmentController.selectClinic(widget.clinicList[index]);
              Get.to(() => ClinicDetailScreen(clinicId: widget.clinicList[index].id));
            }
          },
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 35,
            padding: EdgeInsets.symmetric(
              vertical: VERTICAL_PADDING_EXTRA_SMALL,
              horizontal: HORIZONTAL_PADDING_SMALL,
            ),
            decoration: BoxDecoration(
              color: _selectedItem == index ? Colors.greenAccent.shade700 : Colors.white,
              borderRadius: BorderRadius.circular(RADIUS_SMALL),
            ),
            child: widget.clinicList.isEmpty ? null
                : Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 28,
                          decoration: BoxDecoration(
                            color: ITEM_BACKGOUND_COLOR,
                            borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                onError: (_, __) => print('error loading image'),
                                image: widget.clinicList[index].profilePhoto == null
                                    ? Image.asset(clinicImage).image
                                    : Image.network(ApiConstant.getImage + widget.clinicList[index].profilePhoto).image
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: VERTICAL_MARGIN_EXTRA_SMALL),
                      Expanded(
                        flex: 1,
                        child: AutoSizeText(
                          widget.clinicList[index].name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: rubikBold.copyWith(
                            fontSize: FONT_SIZE_SMALL,
                            color: _selectedItem == index ? Colors.white : ITEM_NAME_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(height: VERTICAL_MARGIN_EXTRA_SMALL),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.clinicList[index].address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: rubikRegular.copyWith(
                            fontSize: FONT_SIZE_EXTRA_SMALL,
                            color: _selectedItem == index ? Colors.white : ITEM_DESCRIPTION_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(height: VERTICAL_MARGIN_EXTRA_SMALL),
                      Expanded(
                        flex: 1,
                        child: RatingWidget(
                          averageRating: widget.clinicList[index].averageRating ?? 0,
                          reviewsCount: widget.clinicList[index].reviewsCount ?? 0,
                          iconSize: ICON_SIZE_DEFAULT,
                          textFontSize: FONT_SIZE_EXTRA_SMALL,
                          textColor: _selectedItem == index ? Colors.white : Colors.black,
                        ),
                      )
                    ],
                ),
          ),
        );
      },
    );
  }
}
