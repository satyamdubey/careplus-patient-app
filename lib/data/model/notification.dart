import 'dart:convert';

NotificationData notificationDataFromJson(String str) => NotificationData.fromJson(json.decode(str));


class NotificationData {
  NotificationData({
    required this.status,
    required this.message,
    required this.notifications,
  });

  String status;
  String message;
  List<Notification> notifications;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    status: json["status"],
    message: json["message"],
    notifications: List<Notification>.from(json["notification"].map((x) => Notification.fromJson(x))),
  );
}

class Notification {
  Notification({
    required this.data,
    required this.id,
    required this.title,
    required this.body,
    required this.seen,
  });

  Data data;
  String id;
  String title;
  String body;
  bool seen;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    data: Data.fromJson(json["data"]),
    id: json["_id"],
    title: json["title"],
    body: json["body"],
    seen: json["seen"],
  );
}

class Data {
  Data({
    required this.status,
    required this.appointment,
  });

  String status;
  String appointment;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    appointment: json["appointment"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "appointment": appointment,
  };
}
