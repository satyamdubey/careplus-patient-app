import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/controller/favourite_controller.dart';
import 'package:careplus_patient/controller/search_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_detail.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/favourite_widget.dart';
import 'package:careplus_patient/view/widgets/rating_widget.dart';
import 'package:careplus_patient/view/widgets/skeleton.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
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
  final appointmentController = Get.find<AppointmentController>();

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
            return ListView.separated(
              itemCount: 7,
              padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
              separatorBuilder: (_,__) => const SizedBox(height: 20),
              itemBuilder: (BuildContext context, int index) {
                return const Skeleton(width: double.infinity, height: 85);
              },
            );
          }
          return Column(
            children: [
              CustomAppBar(context: context, title: widget.title),
              const SizedBox(height: 20),
              GetBuilder<ClinicController>(
                builder: (_){
                  clinicSearchController.searchFromList =
                      clinicController.nearByClinicsForListScreenFromServer;
                  return const ClinicSearchBar();
                },
              ),
              const SizedBox(height: 2),
              Expanded(
                child: GetBuilder<ClinicController>(builder: (_) {
                  return ListView.separated(
                    shrinkWrap: true,
                    controller: clinicController.scrollController,
                    itemCount: clinicController.isNearByClinicsForListScreenLoaded
                      ? clinicController.nearByClinicsForListScreenToClient.length
                      : clinicController.nearByClinicsForListScreenToClient.length + 1,
                    padding: EdgeInsets.symmetric(
                      vertical: VERTICAL_PADDING_LARGE, horizontal: HORIZONTAL_PADDING_LARGE
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (BuildContext context, int index) {
                      return !clinicController.isNearByClinicsForListScreenLoaded
                        ? const Skeleton(width: double.infinity, height: 85)
                        : _clinicItemLayout(clinicController.nearByClinicsForListScreenToClient[index]);
                    },
                  );
                }),
              )
            ],
          );
      }),
    );
  }


  Widget _clinicItemLayout(Clinic clinic){
    return GestureDetector(
      onTap: () {
        appointmentController.selectClinic(clinic);
        Get.to(() => ClinicDetailScreen(clinicId: clinic.id)
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
                  image: Image.network(ApiConstant.getImage + clinic.profilePhoto).image,
                ),
              ),
            ),
            SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clinic.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: nunitoBold.copyWith(color: ITEM_NAME_COLOR, fontSize: FONT_SIZE_DEFAULT),
                      ),
                      ClinicFavouriteWidget(
                        clinicId: clinic.id,
                        isFavourite: favouriteController.favouriteClinics
                            .any((favouriteClinic) => favouriteClinic.id == clinic.id)
                      ),
                    ],
                  ),
                  AutoSizeText(
                    clinic.address,
                    maxLines: 2,
                    style: nunitoRegular.copyWith(fontSize: FONT_SIZE_EXTRA_SMALL),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingWidget(
                        averageRating: clinic.averageRating,
                        reviewsCount: clinic.reviewsCount,
                        textFontSize: FONT_SIZE_EXTRA_SMALL,
                        iconSize: ICON_SIZE_LARGE,
                      ),
                      Text(
                        '${(clinic.distance / 1000).ceil()} kms away',
                        style: nunitoRegular.copyWith(fontSize: FONT_SIZE_SMALL),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
      margin: EdgeInsets.symmetric(horizontal: 20),
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

