import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/menu_option_controller.dart';
import 'package:careplus_patient/controller/promotion_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/clinic_list.dart';
import 'package:careplus_patient/view/screens/authorised/my_appointments.dart';
import 'package:careplus_patient/view/screens/authorised/select_category.dart';
import 'package:careplus_patient/view/widgets/carousel.dart';
import 'package:careplus_patient/view/widgets/horizontal_item_list.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/secondary_button.dart';
import 'package:careplus_patient/view/widgets/user_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PromotionController promotionController = Get.find<PromotionController>();
  final AppointmentController appointmentController = Get.find<AppointmentController>();
  final MenuButtonController menuButtonController = Get.find<MenuButtonController>();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh()async{
    await promotionController.getTopPromotionsFromRepository();
    await promotionController.getBottomPromotionsFromRepository();
    await menuButtonController.loadMenuButtonsItems();
    if(mounted){
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }


  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: _homeBody(),
    );
  }

  Padding _homeBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING_LARGE),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Header(),
            const SizedBox(height: 25),
            const HomeSearchBar(),
            const SizedBox(height: 25),
            const TopPromotions(),
            const SizedBox(height: 20),
            const BookingButtons(),
            const SizedBox(height: 20),
            const MyAppointments(),
            const SizedBox(height: 25),
            const MenuButtons(),
            const SizedBox(height: 10),
            const MenuItems(),
            const SizedBox(height: 20),
            _title("Promotions"),
            const BottomPromotions(),
            const SizedBox(height: 70),
          ],
        ),
      ),
  );
  }

  Padding _title(String titleName) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
      child: Text(
        titleName,
        style: nunitoBold,
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const UserLocation(locationIconColor: Colors.red),
        Image.asset(carePlusLogo1, height: 30, width: 90),
      ],
    );
  }
}

class TopPromotions extends StatelessWidget {
  const TopPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PromotionController promotionController = Get.find<PromotionController>();
    promotionController.getTopPromotionsFromRepository();
    return GetBuilder<PromotionController>(
      builder: (_) {
        return promotionController.isTopPromotionsLoaded
            ? Carousel(height: 140, carouselItems: promotionController.topPromotions)
            : const Carousel(height: 140);
      },
    );
  }
}

class BookingButtons extends StatelessWidget {
  const BookingButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionRowButtons(
      onTapButton1: () {},
      button1Style: ActionRowButtonStyle.secondary,
      button1Name: AppLocalization.homeBookdiagnostic,
      onTapButton2: () => Get.to(() => const SelectCategory()),
      button2Name: AppLocalization.homeBookappointment,
      button2Style: ActionRowButtonStyle.secondary,
    );
  }
}

class MyAppointments extends StatefulWidget {
  const MyAppointments({Key? key}) : super(key: key);

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final _appointmentController = Get.find<AppointmentController>();

  @override
  void initState() {
    _appointmentController.getUpcomingAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: VERTICAL_PADDING_SMALL,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RADIUS_SMALL),
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
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(myAppointments),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GetBuilder<AppointmentController>(builder: (_) {
              int appointments =
                  _appointmentController.upcomingAppointmentList.length;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _appointmentController.isUpcomingAppointmentsLoaded
                        ? appointments == 0
                            ? "You have no upcoming appointments"
                            : "You have $appointments upcoming appointments"
                        : 'Getting your upcoming\nappointments...',
                    textAlign: TextAlign.center,
                    style: nunitoBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    height: 40,
                    width: 120,
                    radius: RADIUS_LARGE,
                    text: appointments == 0 ? "BookNow" : "See Now",
                    onTap: () {
                      appointments == 0
                        ? Get.to(() => const SelectCategory())
                        : Get.to(() => const MyAppointmentsScreen());
                    },
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class MenuButtons extends StatelessWidget {
  const MenuButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuOptionController = Get.find<MenuButtonController>();

    return GetBuilder<MenuButtonController>(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => menuOptionController.menuButtonNumber = 1,
            child: Text(
              'Top doctors',
              style: menuOptionController.menuButtonNumber == 1
                  ? nunitoBold.copyWith(color: SECONDARY_COLOR)
                  : nunitoMedium,
            ),
          ),
          InkWell(
            onTap: () => menuOptionController.menuButtonNumber = 2,
            child: Text(
              'Best clinics',
              style: menuOptionController.menuButtonNumber == 2
                  ? nunitoBold.copyWith(color: SECONDARY_COLOR)
                  : nunitoMedium,
            ),
          ),
          InkWell(
            onTap: () => menuOptionController.menuButtonNumber = 3,
            child: Text(
              'Nearby clinics',
              style: menuOptionController.menuButtonNumber == 3
                  ? nunitoBold.copyWith(color: SECONDARY_COLOR)
                  : nunitoMedium,
            ),
          ),
        ],
      );
    });
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuOptionController = Get.find<MenuButtonController>();
    return Container(
      height: SizeConfig.blockSizeVertical * 28,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RADIUS_SMALL),
        gradient: const LinearGradient(
          colors: [PRIMARY_COLOR_1, PRIMARY_COLOR_2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: GetBuilder<MenuButtonController>(builder: (_) {
          if (menuOptionController.menuButtonNumber == 1 &&
              menuOptionController.isItemsForMenuButton1Loaded) {
            return HorizontalDoctorList(
                doctorsList: menuOptionController.menuButton1Items);
          } else if (menuOptionController.menuButtonNumber == 2 &&
              menuOptionController.isItemsForMenuButton2Loaded) {
            return HorizontalClinicList(
                clinicList: menuOptionController.menuButton2Items);
          } else if (menuOptionController.menuButtonNumber == 3 &&
              menuOptionController.isItemsForMenuButton3Loaded) {
            return HorizontalClinicList(
                clinicList: menuOptionController.menuButton3Items);
          } else {
            return const HorizontalDoctorList();
          }
        },
      ),
    );
  }
}

class BottomPromotions extends StatelessWidget {
  const BottomPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final promotionController = Get.find<PromotionController>();
    promotionController.getBottomPromotionsFromRepository();
    return GetBuilder<PromotionController>(
      builder: (_) {
        return promotionController.isBottomPromotionsLoaded
            ? Carousel(height: 90, carouselItems: promotionController.bottomPromotions)
            : const Carousel(height: 90);
      },
    );
  }
}

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({Key? key}) : super(key: key);

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Get.to(()=>const ClinicListScreen(
        title: 'Search near by clinics',
      )),
      child: Container(
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
            Text(
              'Search',
              style: nunitoBold.copyWith(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
