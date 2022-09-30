import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/doctor_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/data/model/doctor.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/doctor_detail.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:careplus_patient/view/widgets/skeleton.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentDoctorListScreen extends StatefulWidget {
  final String departmentId;
  final String departmentName;

  const DepartmentDoctorListScreen({
    Key? key,
    required this.departmentName,
    required this.departmentId,
  }) : super(key: key);

  @override
  State<DepartmentDoctorListScreen> createState() => _DepartmentDoctorListScreenState();
}

class _DepartmentDoctorListScreenState extends State<DepartmentDoctorListScreen> {
  final doctorSearchController = Get.find<DepartmentDoctorSearchController>();
  final doctorController = Get.find<DoctorController>();
  final appointmentController = Get.find<AppointmentController>();

  @override
  void initState() {
    super.initState();
    doctorController.initDepartmentDoctorList(widget.departmentName);
    doctorController.getDepartmentDoctorsFromRepository(widget.departmentName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        children: [
          CustomAppBar(context: context, title: widget.departmentName),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING_LARGE),
            child: GetBuilder<DoctorController>(
              builder: (_){
                doctorSearchController.searchFromList=doctorController.departmentDoctorsFromServer;
                return const DepartmentDoctorSearchBar();
              },
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: GetBuilder<DoctorController>(builder: (_){
              return ListView.separated(
                shrinkWrap: true,
                controller: doctorController.departmentDoctorScrollController,
                itemCount: doctorController.isDepartmentDoctorsLoaded
                    ? doctorController.departmentDoctorsToClient.length
                    : doctorController.departmentDoctorsToClient.length + 6,
                padding: EdgeInsets.symmetric(
                  horizontal: HORIZONTAL_PADDING_LARGE,
                  vertical: VERTICAL_PADDING_LARGE,
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (BuildContext context, int index) {
                  return doctorController.isDepartmentDoctorsLoaded
                    ?  _doctorItemLayout(doctorController.departmentDoctorsToClient[index])
                    : const Skeleton(width: double.infinity, height: 85);
                },
              );
            }),
          )
        ],
      ),
    );
  }


  Widget _doctorItemLayout(Doctor doctor){
    return GestureDetector(
      onTap: () {
        appointmentController.selectDoctor(doctor);
        Get.to(() => DoctorDetailScreen(doctor: doctor));
      },
      child: Container(
        height: 85.0,
        padding: EdgeInsets.symmetric(
          vertical: VERTICAL_PADDING_EXTRA_SMALL,
          horizontal: HORIZONTAL_PADDING_SMALL,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
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
                  image: Image.network(ApiConstant.getImage + doctor.photo).image,
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
                  child: Text(
                    doctor.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: nunitoBold.copyWith(
                      color: ITEM_NAME_COLOR,
                      fontSize: FONT_SIZE_DEFAULT,
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingWidget(
                        averageRating: doctor.averageRating,
                        reviewsCount: doctor.reviewsCount,
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
  }

}

class DepartmentDoctorSearchBar extends StatefulWidget {
  const DepartmentDoctorSearchBar({Key? key}) : super(key: key);

  @override
  State<DepartmentDoctorSearchBar> createState() => _DepartmentDoctorSearchBarState();
}


class _DepartmentDoctorSearchBarState extends State<DepartmentDoctorSearchBar> {

  final DoctorController doctorController = Get.find();
  final DepartmentDoctorSearchController doctorSearchController = Get.find();

  final _searchController = TextEditingController(text: 'Search');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.white,
              onTap: (){
                _searchController.clear();
              },
              onChanged: (String value){
                doctorSearchController.searchDepartmentDoctor(value);
              },
              style: robotoRegular.copyWith(color: Colors.white),
              decoration: null,
            ),
          ),
        ],
      ),
    );
  }
}