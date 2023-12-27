import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/chat/people_list.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:intl/intl.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/quran/selectionQuran.dart';
import 'package:quranschool/pages/search/search_page2.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';

class MybottomBar extends StatefulWidget {
  MybottomBar({
    Key? key,
  }) : super(key: key);

  @override
  _MybottomBarState createState() => _MybottomBarState();
}

class _MybottomBarState extends State<MybottomBar> {
  //final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Execute your function here before popping the screen
        // For example, you can call the checkUnreadMessages function
        chatController.getchatList();
        // Return true to allow the screen to be popped
        return true;
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserController.currentUser.value.id.toString())
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Text("Loading"),
              ),
            );
          }

          if (snapshot.hasData) {
            // var data;
            // // Update rxMsg.currentuserid in the document
            // FirebaseFirestore.instance
            //     .collection('chats')
            //     .doc(chatDocId)
            //     .update({
            //   'rxMsg.$currentuserid': FieldValue.serverTimestamp(),
            // });
            return Obx(() => ConvexAppBar.badge(
                  {1: 3 > 0 ? '' : ''},
                  backgroundColor: Colors.white,
                  style: TabStyle.textIn,
                  items: [
                    TabItem(
                      activeIcon: Icon(Icons.account_box),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                      title: 'home'.tr,
                    ),
                    TabItem(
                      //isIconBlend: true,

                      activeIcon: Icon(FlutterIslamicIcons.quran2),
                      icon: Icon(FlutterIslamicIcons.quran2,
                          color: Colors
                              .grey), //Image.asset("assets/icons/quran.png"),
                      title: 'quran'.tr,
                    ),
                    if (currentUserController.currentUser.value.userType !=
                        "teacher")
                      TabItem(
                        activeIcon: Icon(Icons.search),
                        icon: Icon(Icons.search, color: Colors.grey),
                        title: 'Search'.tr,
                      ),

                    TabItem(
                      activeIcon: Icon(Icons.play_arrow),
                      icon: Icon(Icons.play_arrow, color: Colors.grey),
                      title: 'Next_sesion'.tr,
                    ),

                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.chat),
                    //   label: 'Chats',
                    // ),
                  ],
                  initialActiveIndex:
                      myBottomBarCtrl.selectedIndBottomBar.value,
                  onTap: (index) {
                    myBottomBarCtrl.selectedIndBottomBar.value = index;
                    if (index == 0) {
                      Get.to(const HomePage());
                    } else if (index == 1) {
                      if (currentUserController.currentUser.value.userType ==
                          "teacher") {
                        chatController.getchatList();
                        Get.to(PeopleList());
                      } else {
                        Get.to(SearchPage2());
                      }
                    } else if (index == 2) {
                      mySesionController.getFirstSessionAfterNow();

                      Get.to(NextSession());

                      // subscribitionController.getSessionsbyteaherID(
                      //     currentUserController.currentUser.value.id,
                      //     currentUserController.currentUser.value.userType);
                      // Get.to(SessionsShow());

                      // Get.to(UserProfilePage(showbottombar: true));
                    } else if (index == 3) {
                      Get.to(const QuranSelection());
                    }
                  },
                ));
          } else {
            return Obx(() => ConvexAppBar.badge(
                  {1: 3 > 0 ? '' : ''},
                  backgroundColor: Colors.white,
                  style: TabStyle.textIn,
                  items: [
                    TabItem(
                      activeIcon: Icon(Icons.account_box),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                      title: 'home'.tr,
                    ),
                    TabItem(
                      activeIcon:
                          currentUserController.currentUser.value.userType ==
                                  "teacher"
                              ? Icon(Icons.message)
                              : Icon(Icons.search),
                      icon:

                          // Badge(
                          //     showBadge: cartController.cartIDList.length > 0,
                          //     badgeContent: Text(cartController.cartIDList.length.toString()),
                          //     child:

                          currentUserController.currentUser.value.userType ==
                                  "teacher"
                              ? Icon(Icons.message, color: Colors.grey)
                              : Icon(Icons.search, color: Colors.grey),

                      //  ),
                      title: 'Search'.tr,
                    ),

                    TabItem(
                      activeIcon: Icon(Icons.play_arrow),
                      icon: Icon(Icons.play_arrow, color: Colors.grey),
                      title: 'Next_sesion'.tr,
                    ),
                    TabItem(
                      //isIconBlend: true,

                      activeIcon: Icon(FlutterIslamicIcons.quran2),
                      icon: Icon(FlutterIslamicIcons.quran2,
                          color: Colors
                              .grey), //Image.asset("assets/icons/quran.png"),
                      title: 'quran'.tr,
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.chat),
                    //   label: 'Chats',
                    // ),
                  ],
                  initialActiveIndex:
                      myBottomBarCtrl.selectedIndBottomBar.value,
                  onTap: (index) {
                    myBottomBarCtrl.selectedIndBottomBar.value = index;
                    if (index == 0) {
                      Get.to(const HomePage());
                    } else if (index == 1) {
                      if (currentUserController.currentUser.value.userType ==
                          "teacher") {
                        chatController.getchatList();
                        Get.to(PeopleList());
                      } else {
                        Get.to(SearchPage2());
                      }
                    } else if (index == 2) {
                      mySesionController.getFirstSessionAfterNow();

                      Get.to(NextSession());

                      // subscribitionController.getSessionsbyteaherID(
                      //     currentUserController.currentUser.value.id,
                      //     currentUserController.currentUser.value.userType);
                      // Get.to(SessionsShow());

                      // Get.to(UserProfilePage(showbottombar: true));
                    } else if (index == 3) {
                      Get.to(const QuranSelection());
                    }
                  },
                ));
          }
        },
      ),
    );
  }
}
