import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:quranschool/pages/home_page/profile_page_bottom.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

class ShowSubscriptionAll extends StatefulWidget {
  const ShowSubscriptionAll({Key? key}) : super(key: key);

  @override
  State<ShowSubscriptionAll> createState() => _ShowSubscriptionAllState();
}

class _ShowSubscriptionAllState extends State<ShowSubscriptionAll> {
  final ChatController chatController = Get.put(ChatController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  final LoginController loginController = Get.put(LoginController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  // // Add a TextEditingController for the search query
  final TextEditingController searchController = TextEditingController();
  String studentSubscriptionStatusValue = 'NotPaid';
  String query = '';
// Function to filter friends based on search query in username or name
  List<StudSubModel> filterFriends() {
    return chatController.allsubdata
        .where((friend) =>
            (friend.friendUsername
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                friend.friendtName
                    .toLowerCase()
                    .contains(query.toLowerCase())) &&
            friend.studentSubscriptionStatus
                .contains(studentSubscriptionStatusValue))
        .toList();
  }

  List<StudSubModel> filterFriendsPaid(String query) {
    return chatController.allsubdata
        .where((friend) => friend.studentSubscriptionStatus == query)
        .toList();
  }

  // Function to filter friends based on search query and subscription status

  // Open Chat
  gotoChat(context, index) {}

  myTextStyle(index) {
    return TextStyle(
      color: chatController.filteredFriends[index].studentSubscriptionStatus ==
              "Paid"
          ? Colors.black
          : Color.fromARGB(135, 64, 63, 63),
      fontWeight:
          chatController.filteredFriends[index].studentSubscriptionStatus ==
                  "Paid"
              ? FontWeight.bold
              : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        if (currentUserController.currentUser.value.id == -1) {
          myBottomBarCtrl.selectedIndBottomBar.value = 3;
        } else if (currentUserController.currentUser.value.userType ==
            "student") {
          myBottomBarCtrl.selectedIndBottomBar.value = 5;
        } else if (currentUserController.currentUser.value.userType ==
            "teacher") {
          myBottomBarCtrl.selectedIndBottomBar.value = 4;
        }
        Get.to(ProfilePageBottom());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        appBar: simplAppbar(true, "subscription_package".tr),
        body: Column(
          children: [
            // Add a TextField for search
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        // Update the list of friends when the search query changes
                        setState(() {
                          query = value;
                        });

                        chatController.updateFilteredFriends(filterFriends());
                      },
                      decoration: InputDecoration(
                        labelText: 'search_name'.tr,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: studentSubscriptionStatusValue ==
                                'Paid'
                            ? mybrowonColor
                            : Colors.grey // Change this to the desired color
                        ),
                    onPressed: () {
                      setState(() {
                        if (studentSubscriptionStatusValue == 'Paid') {
                          studentSubscriptionStatusValue = '';
                        } else {
                          studentSubscriptionStatusValue = 'Paid';
                        }
                      });
                      chatController.updateFilteredFriends(filterFriends());
                    },
                    icon: Icon(Icons.filter_alt, color: Colors.white),
                    label: Text('Paid'.tr),
                  ),
                )
              ],
            ),
            Expanded(
              child: Obx(
                () => chatController.isLoadingall.value == true
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
                            color: chatController.filteredFriends[index]
                                        .studentSubscriptionStatus ==
                                    "Paid"
                                ? const Color.fromARGB(255, 210, 238, 225)
                                : Color.fromARGB(255, 221, 195, 195),
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
                                        // loginController.getStudentProfile(
                                        //     chatController
                                        //         .filteredFriends[index]
                                        //         .friendtID);
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          // 'https://quraanshcool.pythonanywhere.com/media/${chatController.filteredFriends[index].friendImage}',
                                          'http://18.156.95.47//media/${chatController.filteredFriends[index].friendImage}',
                                        
                                        ),
                                      ),
                                    )
                                  : Container(
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

                              // CircleAvatar(
                              //   backgroundImage: NetworkImage(
                              //     chatController
                              //         .filteredFriends[index].friendImage,
                              //   ),
                              // ),
                              title: GestureDetector(
                                onTap: () {
                                  // loginController.getStudentProfile(
                                  //     chatController
                                  //         .filteredFriends[index].friendtID);
                                },
                                child: Text(
                                    chatController
                                        .filteredFriends[index].friendtName,
                                    style: myTextStyle(index)),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'date'.tr +
                                        " : " +
                                        DateFormat('yy/MM/dd').format(
                                            chatController
                                                .filteredFriends[index]
                                                .subscriptionDate),
                                    style: myTextStyle(index),
                                  ),
                                  Visibility(
                                    visible: currentUserController
                                            .currentUser.value.userType !=
                                        "teacher",
                                    child: Text(
                                        'package_price'.tr +
                                            ' : ' +
                                            chatController
                                                .filteredFriends[index]
                                                .actualPrice +
                                            ' ' +
                                            'EGP'.tr,
                                        style: myTextStyle(index)),
                                  ),
                                  Text(
                                      'No_of_sessions'.tr +
                                          ' : ' +
                                          chatController.filteredFriends[index]
                                              .sessionCount,
                                      style: myTextStyle(index)),
                                  Text(
                                      'remainingSessions'.tr +
                                          ' : ' +
                                          chatController.filteredFriends[index]
                                              .remainingSessions
                                              .toString(),
                                      style: myTextStyle(index)),
                                ],
                              ),
                              trailing: Text(
                                  chatController.filteredFriends[index]
                                      .studentSubscriptionStatus,
                                  style: myTextStyle(index)),
                              // trailing: IconButton(
                              //   icon: Icon(
                              //     Icons.message,
                              //     color: mybrowonColor,
                              //   ),
                              //   onPressed: () {
                              //     // gotoChat(context, index);
                              //   },
                              // ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),

        ///   bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
