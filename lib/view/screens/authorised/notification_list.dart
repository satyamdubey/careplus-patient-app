import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/notification_controller.dart';
import 'package:careplus_patient/data/model/notification.dart' as notify;
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/appointment_detail.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  NotificationController notificationController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await notificationController.getAllNotifications();
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    notificationController.getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: GetBuilder<NotificationController>(builder: (_) {
        return !notificationController.isNotificationsLoaded
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _appBar(),
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: _notifications(notificationController.notifications),
                    ),
                  )
                ],
              );
      }),
    );
  }

  Widget _notifications(List<notify.Notification> notifications) {
    return notifications.isEmpty
        ? SizedBox(
            height: SizeConfig.blockSizeVertical * 80,
            child: Center(child: Text('No Notifications', style: nunitoBold)))
        : ListView.separated(
            shrinkWrap: true,
            itemCount: notifications.length,
            padding: EdgeInsets.only(
              top: VERTICAL_PADDING_DEFAULT,
              bottom: VERTICAL_PADDING_LARGE * 2,
              left: HORIZONTAL_PADDING_DEFAULT,
              right: HORIZONTAL_PADDING_DEFAULT,
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                tileColor: Colors.grey.shade200,
                title: Text(
                  notifications[index].title,
                  style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
                ),
                subtitle: Text(
                  'Tap to check',
                  style: nunitoMedium.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
                onTap: () {
                  Get.to(
                    () => AppointmentDetailScreen(
                      appointmentId: notifications[index].data.appointment,
                      status: notifications[index].data.status,
                    ),
                  );
                },
              );
            },
          );
  }

  _appBar() {
    return Container(
      height: SizeConfig.blockSizeVertical * 7.5,
      alignment: const Alignment(0, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Text(
          'Notifications',
          style: nunitoBold.copyWith(
            color: Colors.white,
            fontSize: FONT_SIZE_LARGE,
          ),
        ),
      ),
    );
  }
}
