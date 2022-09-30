import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/favourite_controller.dart';
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

class FavouriteClinicsScreen extends StatefulWidget {
  const FavouriteClinicsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteClinicsScreen> createState() => _FavouriteClinicsScreenState();
}

class _FavouriteClinicsScreenState extends State<FavouriteClinicsScreen> {
  final appointmentController = Get.find<AppointmentController>();
  final FavouriteController favouriteController = Get.find();

  @override
  void initState() {
    super.initState();
    favouriteController.getFavouriteClinicsFromRepository();
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
            title: 'My Favourite Clinics',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GetBuilder<FavouriteController>(builder: (_) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: favouriteController.isFavouriteClinicsLoaded
                    ? favouriteController.favouriteClinics.length
                    : favouriteController.favouriteClinics.length + 6,
                padding: EdgeInsets.symmetric(
                    horizontal: HORIZONTAL_PADDING_LARGE
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (BuildContext context, int index) {
                  return favouriteController.isFavouriteClinicsLoaded
                      ? _clinicItemLayout(favouriteController.favouriteClinics[index], index)
                      : const Skeleton(width: double.infinity, height: 85);
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _clinicItemLayout(Clinic clinic, int index){
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
                        style: nunitoBold.copyWith(
                            color: ITEM_NAME_COLOR, fontSize: FONT_SIZE_DEFAULT
                        ),
                      ),
                      ClinicFavouriteWidget(
                        position: index,
                        clinicId: clinic.id,
                        isFavourite: true,
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
