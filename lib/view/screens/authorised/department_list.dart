import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/department_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/data/model/department.dart';
import 'package:careplus_patient/view/screens/authorised/department_doctor_list.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentList extends StatefulWidget {
  const DepartmentList({Key? key}) : super(key: key);

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  final departmentController = Get.find<DepartmentController>();
  final DepartmentSearchController departmentSearchController = Get.find();

  @override
  void initState() {
    super.initState();
    departmentController.getDepartmentsFromRepository();
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
            title: AppLocalization.selectDepartment,
          ),
          const SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: HORIZONTAL_PADDING_LARGE,
            ),
            child: GetBuilder<DepartmentController>(
              builder: (_){
                departmentSearchController.searchFromList=departmentController.departmentListFromServer;
                return const DepartmentSearchBar();
              },
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: _departmentGrid(),
          )
        ],
      ),
    );
  }

  GetBuilder<DepartmentController> _departmentGrid() {
    return GetBuilder<DepartmentController>(builder: (_) {
      return departmentController.isDepartmentsLoaded
          ? GridView.builder(
              shrinkWrap: true,
              itemCount: departmentController.departmentListToClient.length,
              padding: EdgeInsets.symmetric(
                vertical: VERTICAL_PADDING_LARGE,
                horizontal: HORIZONTAL_PADDING_DEFAULT,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.75),
              itemBuilder: (BuildContext context, int index) {
                return DepartmentLayout(
                  department:
                      departmentController.departmentListToClient[index],
                );
              },
            )
          : const Center(child: CircularProgressIndicator());
    });
  }
}

class DepartmentLayout extends StatelessWidget {
  final Department department;

  const DepartmentLayout({Key? key, required this.department})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(() => DepartmentDoctorListScreen(
                departmentName: department.name,
                departmentId: department.id,
              )),
          child: Container(
            height: 75,
            width: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.network(ApiConstant.getImage + department.image).image,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          department.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
        ),
      ],
    );
  }
}

class DepartmentSearchBar extends StatefulWidget {
  const DepartmentSearchBar({Key? key}) : super(key: key);

  @override
  State<DepartmentSearchBar> createState() => _DepartmentSearchBarState();
}

class _DepartmentSearchBarState extends State<DepartmentSearchBar> {

  final DepartmentController departmentController = Get.find();
  final DepartmentSearchController departmentSearchController = Get.find();

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
              onTap: () {
                _searchController.clear();
              },
              onChanged: (String value) {
                departmentSearchController.searchDepartment(value);
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
