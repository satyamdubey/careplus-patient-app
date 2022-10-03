import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/notification.dart' as notify;
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class NotificationController extends GetxController{

  final List<notify.Notification> _notifications = [];
  
  List<notify.Notification> get notifications => _notifications;
  
  bool _isNotificationsLoaded = false;
  
  bool get isNotificationsLoaded => _isNotificationsLoaded;


  Future<void> seeNotification(String notificationId) async{
    var response = await ApiClient().getData('api/v1/patient/notification/see/$notificationId/');
    if(response is http.Response && response.statusCode==200){
      print('notification seen');
    }
  }
  
  
  Future<void> getAllNotifications() async{
    var response = await ApiClient().getData('${ApiConstant.getNotifications+StorageHelper.getUserId()}/10/1/');
    if(response is http.Response && response.statusCode==200){
      notify.NotificationData notificationData = notify.notificationDataFromJson(response.body);
      List<notify.Notification> notifications = notificationData.notifications;
      _notifications.assignAll(notifications);
    }
    _isNotificationsLoaded = true;
    update();
  }

}