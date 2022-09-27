import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/view/screens/authorised/home.dart';
import 'package:careplus_patient/view/screens/authorised/notification_list.dart';
import 'package:careplus_patient/view/screens/authorised/profile.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'my_appointments.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Widget> screens = [
    const HomeScreen(),
    const MyAppointmentsScreen(),
    const NotificationListScreen(),
    const ProfileScreen(),
  ];
  int activeIndex = 0;

  void updatePage(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: IndexedStack(
        index: activeIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: PRIMARY_COLOR_2,
        backgroundColor: Colors.transparent,
        height: 55,
        items: [
          _navItem(
            index: 0,
            name: AppLocalization.home,
            iconData: Icons.home_outlined,
          ),
          _navItem(
            index: 1,
            name: AppLocalization.appointment,
            iconData: Icons.calendar_today_outlined,
          ),
          _navItem(
            index: 2,
            name: AppLocalization.notification,
            iconData: Icons.notifications_outlined,
          ),
          _navItem(
            index: 3,
            name: AppLocalization.profile,
            iconData: Icons.person_outline,
          ),
        ],
        onTap: (int index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }

  _navItem({
    required int index,
    required String name,
    required IconData iconData,
  }) {
    return index == activeIndex
        ? Icon(
            iconData,
            color: Colors.white,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              Text(
                name,
                style: nunitoRegular.copyWith(
                  color: Colors.white,
                  fontSize: FONT_SIZE_SMALL,
                ),
              ),
            ],
          );
  }
}
