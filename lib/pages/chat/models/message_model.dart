// To parse this JSON data, do
//
//     final MessageModel = MessageModelFromJson(jsonString);

import 'dart:convert';

MessageModel MessageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String MessageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.text = "",
    this.messageId = "",
    this.date = "",
    this.status = "",
  });

  String text;
  String date;
  String messageId;

  dynamic status;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
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

  MessageModel copyWith({
    String messageId = "",
    String text = "",
    String status = "",
    String date = "",
  }) =>
      MessageModel(
        messageId: messageId,
        text: text,
        status: status,
        date: date,
      );
}
