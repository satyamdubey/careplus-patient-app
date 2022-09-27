import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_detail.dart';
import 'package:careplus_patient/view/screens/authorised/doctor_detail.dart';
import 'package:careplus_patient/view/widgets/favourite_widget.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:careplus_patient/view/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorVerticalList extends StatefulWidget {
  final List<Doctor> doctorList;
  final bool isFavouriteList;

  const DoctorVerticalList(
      {Key? key, required this.doctorList, this.isFavouriteList = false})
      : super(key: key);

  @override
  State<DoctorVerticalList> createState() => _DoctorVerticalListState();
}

class _DoctorVerticalListState extends State<DoctorVerticalList> {
  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.doctorList.length,
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_LARGE,
        vertical: VERTICAL_PADDING_LARGE,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            appointmentController.selectDoctor(widget.doctorList[index]);
            Get.to(() => DoctorDetailScreen(doctor: widget.doctorList[index]));
          },
          child: Container(
            height: 85.0,
            padding: EdgeInsets.symmetric(
              vertical: VERTICAL_PADDING_EXTRA_SMALL,
              horizontal: HORIZONTAL_PADDING_SMALL,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                RADIUS_EXTRA_SMALL,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.network(ApiConstant.getImage + widget.doctorList[index].photo).image,
                    ),
                  ),
                ),
                SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.doctorList[index].fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nunitoBold.copyWith(
                              color: ITEM_NAME_COLOR,
                              fontSize: FONT_SIZE_DEFAULT,
                            ),
                          ),
                          DoctorFavouriteWidget(
                            doctorId: widget.doctorList[index].id,
                            filled: widget.isFavouriteList,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingWidget(
                            averageRating: widget.doctorList[index].averageRating,
                            reviewsCount: widget.doctorList[index].reviewsCount,
                            iconSize: ICON_SIZE_LARGE,
                            textFontSize: FONT_SIZE_SMALL,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClinicVerticalList extends StatefulWidget {
  final List<Clinic> clinicList;
  final List<Clinic> favouriteClinics;
  final bool isFavouriteList;
  final bool isLoaded;

  const ClinicVerticalList(
      {Key? key,
      required this.clinicList,
      this.favouriteClinics = const [],
      this.isFavouriteList = false,
      required this.isLoaded,
      })
      : super(key: key);

  @override
  State<ClinicVerticalList> createState() => _ClinicVerticalListState();
}

class _ClinicVerticalListState extends State<ClinicVerticalList> {
  final appointmentController = Get.find<AppointmentController>();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.isLoaded
          ? widget.clinicList.length
          : widget.clinicList.length + 2,
      padding: EdgeInsets.symmetric(
        horizontal: HORIZONTAL_PADDING_LARGE,
        vertical: VERTICAL_PADDING_LARGE,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        return !widget.isLoaded
            ? const Skeleton(width: double.infinity, height: 85)
            : GestureDetector(
                onTap: () {
                  appointmentController.selectClinic(widget.clinicList[index]);
                  Get.to(() => ClinicDetailScreen(
                      clinicId: widget.clinicList[index].id)
                  );
                },
                child: Container(
                  height: 90.0,
                  padding: EdgeInsets.symmetric(
                    vertical: VERTICAL_PADDING_EXTRA_SMALL,
                    horizontal: HORIZONTAL_PADDING_SMALL,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(
                      RADIUS_EXTRA_SMALL,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 20,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(RADIUS_EXTRA_SMALL),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.network(ApiConstant.getImage + widget.clinicList[index].profilePhoto).image,
                          ),
                        ),
                      ),
                      SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.clinicList[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: nunitoBold.copyWith(
                                    color: ITEM_NAME_COLOR,
                                    fontSize: FONT_SIZE_DEFAULT,
                                  ),
                                ),
                                ClinicFavouriteWidget(
                                  position: index,
                                  clinicId: widget.clinicList[index].id,
                                  isFavourite: widget.isFavouriteList
                                      ? true
                                      : widget.favouriteClinics.any((clinic) => clinic.id == widget.clinicList[index].id),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 65,
                            child: AutoSizeText(
                              widget.clinicList[index].address,
                              maxLines: 2,
                              style: nunitoRegular.copyWith(fontSize: FONT_SIZE_EXTRA_SMALL),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingWidget(
                                  averageRating: widget.clinicList[index].averageRating,
                                  reviewsCount: widget.clinicList[index].reviewsCount,
                                  iconSize: ICON_SIZE_LARGE,
                                  textFontSize: FONT_SIZE_EXTRA_SMALL,
                                ),
                                Text(
                                  '${(widget.clinicList[index].distance / 1000).ceil()} kms away',
                                  style: nunitoRegular.copyWith(
                                    fontSize: FONT_SIZE_SMALL,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
