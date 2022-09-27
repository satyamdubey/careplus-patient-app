import 'package:careplus_patient/controller/favourite_controller.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:careplus_patient/view/widgets/vertical_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteClinicsScreen extends StatefulWidget {
  const FavouriteClinicsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteClinicsScreen> createState() => _FavouriteClinicsScreenState();
}

class _FavouriteClinicsScreenState extends State<FavouriteClinicsScreen> {
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
              return favouriteController.isFavouriteClinicsLoaded
                  ? ClinicVerticalList(
                      clinicList: favouriteController.favouriteClinics,
                      isFavouriteList: true,
                      isLoaded: favouriteController.isFavouriteClinicsLoaded,
                    )
                  : const Center(child: CircularProgressIndicator());
            }),
          )
        ],
      ),
    );
  }
}
