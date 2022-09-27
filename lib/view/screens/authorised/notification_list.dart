import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/notification_controller.dart';
import 'package:careplus_patient/data/model/notification.dart' as notify;
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {


  @override
  Widget build(BuildContext context) {
    NotificationController notificationController = Get.find();
    notificationController.getAllNotifications();

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
                  CustomAppBar(
                    context: context,
                    title: AppLocalization.notification,
                  ),
                  Expanded(
                    child: _notifications(notificationController.notifications),
                  )
                ],
              );
      }),
    );
  }

  Widget _notifications(List<notify.Notification> notifications) {
    return notifications.isEmpty
        ? SizedBox(
            height: SizeConfig.blockSizeVertical*30,
            child: const Center(child: Text('No Notifications'))
          )
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
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
                subtitle: Text(
                  'Appointment # ${notifications[index].data.appointment}',
                  style: nunitoMedium.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              );
            },
          );
  }
}
