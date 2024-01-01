// To parse this JSON data, do
//
//     final NotificationModel = NotificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelfromListofMap(
    List<Map<String, dynamic>> jsonList) {
  return jsonList
      .map<NotificationModel>((json) => NotificationModel.fromJson(json))
      .toList();
}

NotificationModel NotificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String NotificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.text = "",
    this.messageId = "",
    this.date = "",
    this.status = "",
  });

  String text;
  String date;
  String messageId;

  dynamic status;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        text: json["text"] ?? "",
        date: json["date"] ?? "",
        messageId: json["messageId"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "messageId": messageId,
        "status": status,
        "date": date,
      };

  NotificationModel copyWith({
    String messageId = "",
    String text = "",
    String status = "",
    String date = "",
  }) =>
      NotificationModel(
        messageId: messageId,
        text: text,
        status: status,
        date: date,
      );
}
