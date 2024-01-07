import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:quranschool/pages/notification/notification_controller.dart';

class NotificationShow extends StatefulWidget {
  const NotificationShow({Key? key}) : super(key: key);

  @override
  State<NotificationShow> createState() => _NotificationShowState();
}

class _NotificationShowState extends State<NotificationShow> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  final LoginController loginController = Get.put(LoginController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  // // Add a TextEditingController for the search query
  final TextEditingController searchController = TextEditingController();
  String studentSubscriptionStatusValue = 'NotPaid';
  String query = '';
  @override
  void initState() {
    super.initState();
    checkNotificationPermissions();
  }

  Future<void> checkNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      // If notification permission is not granted, request it
      await Permission.notification.request();
      status = await Permission.notification.status;
      if (status != PermissionStatus.granted) {
        showPermissionDialog();
      }
    }
  }

  // ... (your existing methods)

  void showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Permission Required'),
          content: Text(
              'Notification permissions are required to receive push notifications.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

// Function to filter friends based on search query in username or name
  // List<StudSubModel> filterFriends() {
  //   return chatController.allsubdata
  //       .where((friend) =>
  //           (friend.friendUsername
  //                   .toLowerCase()
  //                   .contains(query.toLowerCase()) ||
  //               friend.friendtName
  //                   .toLowerCase()
  //                   .contains(query.toLowerCase())) &&
  //           friend.studentSubscriptionStatus
  //               .contains(studentSubscriptionStatusValue))
  //       .toList();
  // }

  // List<StudSubModel> filterFriendsPaid(String query) {
  //   return chatController.allsubdata
  //       .where((friend) => friend.studentSubscriptionStatus == query)
  //       .toList();
  // }

  // Function to filter friends based on search query and subscription status

  // Open Chat
  gotoChat(context, index) {}

  // myTextStyle(index) {
  //   return TextStyle(
  //     color: notificationController.allNotifications[index].studentSubscriptionStatus ==
  //             "Paid"
  //         ? Colors.black
  //         : Color.fromARGB(135, 64, 63, 63),
  //     fontWeight:
  //         notificationController.allNotifications[index].studentSubscriptionStatus ==
  //                 "Paid"
  //             ? FontWeight.bold
  //             : FontWeight.normal,
  //   );
  // }

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
        appBar: simplAppbar(true, "Notification".tr),
        body: Column(
          children: [
            // Add a TextField for search
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 3,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: TextField(
            //           controller: searchController,
            //           onChanged: (value) {
            //             // Update the list of friends when the search query changes
            //             setState(() {
            //               query = value;
            //             });

            //             chatController.updateFilteredFriends(filterFriends());
            //           },
            //           decoration: InputDecoration(
            //             labelText: 'search_name'.tr,
            //             prefixIcon: Icon(Icons.search),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //             foregroundColor: Colors.white,
            //             backgroundColor: studentSubscriptionStatusValue ==
            //                     'Paid'
            //                 ? mybrowonColor
            //                 : Colors.grey // Change this to the desired color
            //             ),
            //         onPressed: () {
            //           setState(() {
            //             if (studentSubscriptionStatusValue == 'Paid') {
            //               studentSubscriptionStatusValue = '';
            //             } else {
            //               studentSubscriptionStatusValue = 'Paid';
            //             }
            //           });
            //           chatController.updateFilteredFriends(filterFriends());
            //         },
            //         icon: Icon(Icons.filter_alt, color: Colors.white),
            //         label: Text('Paid'.tr),
            //       ),
            //     )
            //   ],
            // ),
            Expanded(
              child: Obx(
                () => notificationController.isLoading.value == true
                    ? Center(
                        child: LoadingBouncingGrid.circle(
                          borderColor: mybrowonColor,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : notificationController.allNotifications.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/notify.png', // Replace with your image path
                                  width: 200, // Adjust the width as needed
                                  height: 200, // Adjust the height as needed
                                ),
                                SizedBox(
                                    height:
                                        20), // Add spacing between image and text
                                Text('You Have No ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  'Notification Currently',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                notificationController.allNotifications.length,
                            itemBuilder: (context, index) {
                              return Text('');
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
