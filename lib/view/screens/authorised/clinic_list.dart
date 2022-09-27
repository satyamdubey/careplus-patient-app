import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/controller/favourite_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:careplus_patient/view/widgets/vertical_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicListScreen extends StatefulWidget {
  final String title;
  const ClinicListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> {
  final clinicController = Get.find<ClinicController>();
  final clinicSearchController = Get.find<ClinicSearchController>();
  final favouriteController = Get.find<FavouriteController>();

  @override
  void initState() {
    super.initState();
    clinicController.initClinicListScreen();
    clinicController.getNearByClinicsForListScreenFromRepository();
    favouriteController.getFavouriteClinicsFromRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: FutureBuilder(
        future: Future.wait([
          clinicController.getNearByClinicsFromRepository(),
          favouriteController.getFavouriteClinicsFromRepository()
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }else{
            return Column(
              children: [
                CustomAppBar(
                  context: context, title: widget.title
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: HORIZONTAL_PADDING_EXTRA_LARGE,
                  ),
                  child: GetBuilder<ClinicController>(
                    builder: (_){
                      clinicSearchController.searchFromList=
                          clinicController.nearByClinicsForListScreenFromServer;
                      return const ClinicSearchBar();
                    },
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: GetBuilder<ClinicController>(builder: (_) {
                    return clinicController.isNearByClinicsForListScreenLoaded
                      ? ClinicVerticalList(
                          clinicList: clinicController.nearByClinicsForListScreenToClient,
                          favouriteClinics: favouriteController.favouriteClinics,
                          isLoaded: clinicController.isNearByClinicsForListScreenLoaded,
                        )
                      : const Center(child: CircularProgressIndicator());
                  }),
                )
              ],
            );
          }
      }),
    );
  }
}


class ClinicSearchBar extends StatefulWidget {
  const ClinicSearchBar({Key? key}) : super(key: key);

  @override
  State<ClinicSearchBar> createState() => _ClinicSearchBarState();
}

class _ClinicSearchBarState extends State<ClinicSearchBar> {

  final ClinicSearchController clinicSearchController = Get.find();
  final ClinicController clinicController = Get.find();

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
              onTap: () => _searchController.clear(),
              onChanged: (String value){
                clinicSearchController.searchNearByClinic(value);
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

