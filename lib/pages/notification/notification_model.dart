// To parse this JSON data, do
//
//     final NotificationModel = NotificationModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

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
    this.id = -1,
    this.title = "",
    this.text = "",
    this.createdAt = "",
    this.user = -1,
  });

  int id;
  String title;
  String text;
  String createdAt;
  int user;

  dynamic status;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] ?? -1,
        title: json["title"] ?? "",
        text: json["text"] ?? "",
        createdAt: json["createdAt"] ?? "",
        user: json["user"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "title": title,
        "createdAt": createdAt,
        "user": user,
      };

  NotificationModel copyWith(
          {int id = -1,
          String title = "",
          String text = "",
          String createdAt = "",
          int user = -1}) =>
      NotificationModel(
        id: id,
        title: title,
        text: text,
        createdAt: createdAt,
        user: user,
      );
}
