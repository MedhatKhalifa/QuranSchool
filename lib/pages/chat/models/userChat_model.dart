// To parse this JSON data, do
//
//     final UserChat = UserChatFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserChat UserChatFromJson(String str) => UserChat.fromJson(json.decode(str));

String UserChatToJson(UserChat data) => json.encode(data.toJson());

class UserChat {
  UserChat({
    this.image = "",
    this.name = "",
    this.userchatid = "",
    this.status = "",
    this.accountType = "student",
  });

  String image;
  String name;
  String userchatid;

  dynamic status;

  String accountType;

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
        image: json["image"] ?? "",
        name: json["name"] ?? "",
        userchatid: json["userchatid"] ?? "",
        status: json["status"] ?? "",
        accountType: json["accountType"] ?? "student",
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "userchatid": userchatid,
        "status": status,
        "accountType": accountType,
      };

  UserChat copyWith({
    String userchatid = "",
    String name = "",
    String status = "",
    String accountType = "",
  }) =>
      UserChat(
        userchatid: userchatid,
        name: name,
        status: status,
        accountType: accountType,
      );
// to read data of users ( Doc == one User )
  factory UserChat.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return UserChat(
      userchatid: doc.data()!["uid"],
      name: doc.data()!["name"],
    );
  }
}
