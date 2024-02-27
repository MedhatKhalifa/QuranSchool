import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/chat/controller/chat_controller.dart';
import 'package:quranschool/pages/chat/models/studentsubscription_model.dart';
import 'package:quranschool/pages/chat/models/userChat_model.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

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

  final LoginController loginController = Get.put(LoginController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  // // Add a TextEditingController for the search query
  final TextEditingController searchController = TextEditingController();

// Function to filter friends based on search query in username or name
  List<StudSubModel> filterFriends(String query) {
    return chatController.studSubdata
        .where((friend) =>
            friend.friendUsername.toLowerCase().contains(query.toLowerCase()) ||
            friend.friendtName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Open Chat
  gotoChat(context, index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetail(
          friendName: chatController.filteredFriends[index].friendUsername,
          friendUid: chatController.filteredFriends[index].friendtID,
          currentuserName: currentUserController.currentUser.value.username,
          currentuserid: currentUserController.currentUser.value.id.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(HomePage());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        appBar: simplAppbar(false, "list".tr),
        body: Column(
          children: [
            // Add a TextField for search
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  // Update the list of friends when the search query changes
                  chatController.updateFilteredFriends(filterFriends(query));
                },
                decoration: InputDecoration(
                  labelText: 'search_name'.tr,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => chatController.isLoading.value
                    ? Center(
                        child: LoadingBouncingGrid.circle(
                          borderColor: mybrowonColor,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        itemCount: chatController.filteredFriends.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: Colors.green,
                            color:
                                chatController.filteredFriends[index].unreadMsg
                                    ? const Color.fromARGB(255, 210, 238, 225)
                                    : Colors.white,
                            child: ListTile(
                              onTap: () {
                                // loginController.getStudentProfile(chatController
                                //     .filteredFriends[index].friendtID);

                                gotoChat(context, index);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ChatDetail(
                                //       friendName: chatController
                                //           .filteredFriends[index].friendUsername,
                                //       friendUid: chatController
                                //           .filteredFriends[index].friendtID,
                                //       currentuserName: currentUserController
                                //           .currentUser.value.username,
                                //       currentuserid: currentUserController
                                //           .currentUser.value.id
                                //           .toString(),
                                //     ),
                                //   ),
                                // );
                              },
                              leading: chatController
                                          .filteredFriends[index].friendImage !=
                                      ""
                                  ? GestureDetector(
                                      onTap: () {
                                        loginController.getStudentProfile(
                                            chatController
                                                .filteredFriends[index]
                                                .friendtID);
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          'https://quraanshcool.pythonanywhere.com/media/${chatController.filteredFriends[index].friendImage}',
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        loginController.getStudentProfile(
                                            chatController
                                                .filteredFriends[index]
                                                .friendtID);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Image.asset(
                                            "assets/images/logo/logo.png",
                                            // width: sp(80),
                                            // height: sp(80),
                                            //color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),

                              // CircleAvatar(
                              //   backgroundImage: NetworkImage(
                              //     chatController
                              //         .filteredFriends[index].friendImage,
                              //   ),
                              // ),
                              title: GestureDetector(
                                onTap: () {
                                  loginController.getStudentProfile(
                                      chatController
                                          .filteredFriends[index].friendtID);
                                },
                                child: Text(
                                  chatController
                                      .filteredFriends[index].friendtName,
                                  style: TextStyle(
                                    color: chatController
                                            .filteredFriends[index].unreadMsg
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: chatController
                                            .filteredFriends[index].unreadMsg
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    //  decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                chatController
                                    .filteredFriends[index].friendUsername,
                                style: TextStyle(
                                  color: chatController
                                          .filteredFriends[index].unreadMsg
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: chatController
                                          .filteredFriends[index].unreadMsg
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.message,
                                  color: mybrowonColor,
                                ),
                                onPressed: () {
                                  gotoChat(context, index);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ChatDetail(
                                  //       friendName: chatController
                                  //           .filteredFriends[index]
                                  //           .friendUsername,
                                  //       friendUid: chatController
                                  //           .filteredFriends[index].friendtID,
                                  //       currentuserName: currentUserController
                                  //           .currentUser.value.username,
                                  //       currentuserid: currentUserController
                                  //           .currentUser.value.id
                                  //           .toString(),
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
