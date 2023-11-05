import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/chat/chat_controller.dart';
import 'package:quranschool/pages/chat/models/userChat_model.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

import 'chat_details.dart';
import 'firebase_api.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({Key? key}) : super(key: key);

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  final ChatController chatController = Get.put(ChatController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true, " People List "),
      body: Obx(() => chatController.isLoading.isTrue
          ? Center(
              child: LoadingBouncingGrid.circle(
                borderColor: mybrowonColor,
                backgroundColor: Colors.white,
                // borderSize: 3.0,
                // size: sp(20),
                // backgroundColor: Color(0xff112A04),
                //  duration: Duration(milliseconds: 500),
              ),
            )
          : ListView.builder(
              itemCount: chatController.studSubdata.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                  friendName: chatController
                                      .studSubdata[index].friendUsername,
                                  friendUid: chatController
                                      .studSubdata[index].friendtID,
                                  currentuserName: currentUserController
                                      .currentUser.value.username,
                                  currentuserid: currentUserController
                                      .currentUser.value.id
                                      .toString()),
                            ),
                          );
                        },
                        title: Text(
                            chatController.studSubdata[index].friendUsername),
                        subtitle: Text(
                            chatController.studSubdata[index].friendUsername)));
              })),
    );
  }
}
