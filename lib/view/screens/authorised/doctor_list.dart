import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/doctor_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:careplus_patient/view/widgets/vertical_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentDoctorList extends StatefulWidget {
  final String departmentId;
  final String departmentName;

  const DepartmentDoctorList({
    Key? key,
    required this.departmentName,
    required this.departmentId,
  }) : super(key: key);

  @override
  State<DepartmentDoctorList> createState() => _DepartmentDoctorListState();
}

class _DepartmentDoctorListState extends State<DepartmentDoctorList> {
  final DoctorController doctorController = Get.find();
  final DoctorSearchController doctorSearchController = Get.find();

  @override
  void initState() {
    super.initState();
    doctorController.initDepartmentDoctorList();
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
          CustomAppBar(
            context: context,
            title: widget.departmentName,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: VERTICAL_PADDING_LARGE,
            ),
            child: GetBuilder<DoctorController>(
              builder: (_){
                doctorSearchController.searchFromList=doctorController.departmentDoctorsFromServer;
                return const DoctorSearchBar();
              },
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: GetBuilder<DoctorController>(builder: (_) {
              return doctorController.isDepartmentDoctorsLoaded
                  ? DoctorVerticalList(doctorList: doctorController.departmentDoctorsToClient)
                  : const Center(child: CircularProgressIndicator());
            }),
          )
        ],
      ),
    );
  }
}

class DoctorSearchBar extends StatefulWidget {
  const DoctorSearchBar({Key? key}) : super(key: key);

  @override
  State<DoctorSearchBar> createState() => _DoctorSearchBarState();
}


class _DoctorSearchBarState extends State<DoctorSearchBar> {

  final DoctorController doctorController = Get.find();
  final DoctorSearchController doctorSearchController = Get.find();

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
          SizedBox(width: 16),
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
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