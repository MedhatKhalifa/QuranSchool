// import 'package:badges/badges.dart' as badge;
// import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:quranschool/core/size_config.dart';
// import 'package:quranschool/pages/Auth/register/register_page.dart';
// import 'package:quranschool/pages/chat/people_list.dart';
// import 'package:quranschool/pages/home_page/view/home_page.dart';

// import 'package:quranschool/pages/quran/quranPage%20copy.dart';
// import 'package:quranschool/pages/quran/quranPage.dart';
// import 'package:quranschool/pages/quran/selectionQuran.dart';
// import 'package:quranschool/pages/search/search_page2.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quranschool/pages/sessions/nextSession.dart';
// import 'package:quranschool/pages/teacher/mystudent/showmyStudent.dart';
// import 'package:quranschool/pages/teacher/studentSearch/searchStudent.dart';
// import 'package:quranschool/pages/sessions/sessionsShow.dart';

// import '../../Auth/controller/currentUser_controller.dart';
// import '../../Auth/profile/profile_page.dart';

// import 'bottom_bar_controller.dart';

// import 'package:convex_bottom_bar/convex_bottom_bar.dart';

// final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
// final CurrentUserController currentUserController =
//     Get.put(CurrentUserController());

// class MybottomBar extends StatefulWidget {
//   const MybottomBar({super.key});

//   @override
//   State<MybottomBar> createState() => _MybottomBarState();
// }

// class _MybottomBarState extends State<MybottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     return mybottomBarWidget();
//   }
// }

// mybottomBarWidget() {
//   return Obx(() => ConvexAppBar.badge(
//         {1: 3 > 0 ? '' : ''},
//         backgroundColor: Colors.white,
//         style: TabStyle.textIn,
//         items: [
//           TabItem(
//             activeIcon: Icon(Icons.account_box),
//             icon: Icon(Icons.account_box, color: Colors.grey),
//             title: 'home'.tr,
//           ),
//           TabItem(
//             activeIcon:
//                 currentUserController.currentUser.value.userType == "teacher"
//                     ? Icon(Icons.message)
//                     : Icon(Icons.search),
//             icon:

//                 // Badge(
//                 //     showBadge: cartController.cartIDList.length > 0,
//                 //     badgeContent: Text(cartController.cartIDList.length.toString()),
//                 //     child:

//                 currentUserController.currentUser.value.userType == "teacher"
//                     ? Icon(Icons.message, color: Colors.grey)
//                     : Icon(Icons.search, color: Colors.grey),

//             //  ),
//             title: 'Search'.tr,
//           ),

//           TabItem(
//             activeIcon: Icon(Icons.play_arrow),
//             icon: Icon(Icons.play_arrow, color: Colors.grey),
//             title: 'Next_sesion'.tr,
//           ),
//           TabItem(
//             //isIconBlend: true,

//             activeIcon: Icon(FlutterIslamicIcons.quran2),
//             icon: Icon(FlutterIslamicIcons.quran2,
//                 color: Colors.grey), //Image.asset("assets/icons/quran.png"),
//             title: 'quran'.tr,
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.chat),
//           //   label: 'Chats',
//           // ),
//         ],
//         initialActiveIndex: myBottomBarCtrl.selectedIndBottomBar.value,
//         onTap: (index) {
//           myBottomBarCtrl.selectedIndBottomBar.value = index;
//           if (index == 0) {
//             Get.to(const HomePage());
//           } else if (index == 1) {
//             if (currentUserController.currentUser.value.userType == "teacher") {
//               chatController.getchatList();
//               Get.to(PeopleList());
//             } else {
//               Get.to(SearchPage2());
//             }
//           } else if (index == 2) {
//             mySesionController.getFirstSessionAfterNow();

//             Get.to(NextSession());

//             // subscribitionController.getSessionsbyteaherID(
//             //     currentUserController.currentUser.value.id,
//             //     currentUserController.currentUser.value.userType);
//             // Get.to(SessionsShow());

//             // Get.to(UserProfilePage(showbottombar: true));
//           } else if (index == 3) {
//             Get.to(const QuranSelection());
//           }
//         },
//       ));
// }

// mybottomBarWidget2() {
//   return Obx(() => BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home'.tr,
//           ),

//           BottomNavigationBarItem(
//             icon: badge.Badge(
//                 showBadge: cartController.cartIDList.length > 0,
//                 badgeContent: Text(cartController.cartIDList.length.toString()),
//                 child: Icon(Icons.remove_from_queue)),
//             label: 'Requst'.tr,
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Profile'.tr,
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.chat),
//           //   label: 'Chats',
//           // ),
//         ],
//         currentIndex: myBottomBarCtrl.selectedIndBottomBar.value,
//         onTap: (index) {
//           myBottomBarCtrl.selectedIndBottomBar.value = index;
//           if (index == 0) {
//             Get.to(const CategoryPage());
//           } else if (index == 1) {
//             Get.to(const OrderPage());
//           } else if (index == 2) {
//             Get.to(UserProfilePage(showbottombar: true));
//           } else if (index == 3) {
//             Get.to(const QuranSelection());
//           }
//         },
//       ));
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/chat/people_list.dart';
import 'package:quranschool/pages/common_widget/quick_common.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:intl/intl.dart';
import 'package:quranschool/pages/home_page/profile_page_bottom.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPageFlash.dart';
import 'package:quranschool/pages/quran/quranPageAyaat.dart';
import 'package:quranschool/pages/quran/quran_selection.dart';

import 'package:quranschool/pages/search/search_page.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/teacher/mystudent/showmyStudent.dart';
import 'dart:io' show Platform;

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

  void dispose() {
    currentUserController.currentUser.value.incomeMessage = false;
    super.dispose();
  }

  // tab function to nagiate based on user type and index value
  tabFunc(index) {
    myBottomBarCtrl.selectedIndBottomBar.value = index;

    // in case goting to chat page detele firebase doc that indicate that there is/are new message/s
    if (myBottomBarCtrl.selectedIndBottomBar.value == 4) {
      currentUserController.currentUser.value.incomeMessage = false;

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserController.currentUser.value.id.toString())
          .delete();
    }

    myBottomBarCtrl.selectedIndBottomBar.value = index;
    // index Zero Go to Home page for all users
    if (index == 0) {
      Get.to(const HomePage());
    }
    // index 1 Go to Quran Page for all users
    else if (index == 1) {
      Platform.isAndroid ? Get.to(QuranPage()) : Get.to(QuranSelection());
    }
    // index 2 Serach Page for teacher and Next Session for student as there is no search pagefor teachers
    else if (index == 2) {
      if (currentUserController.currentUser.value.userType != "teacher") {
        Get.to(SearchPage2());
      } else {
        mySesionController.getFirstSessionAfterNow();

        Get.to(NextSession());
      }
    }
    // index 3 will be next session for student and people list for users and people list for teacher  ,
    else if (index == 3) {
      if (currentUserController.currentUser.value.id == -1) {
        Get.to(ProfilePageBottom());
      } else if (currentUserController.currentUser.value.userType !=
          "teacher") {
        mySesionController.getFirstSessionAfterNow();

        Get.to(NextSession());
      } else {
        currentUserController.currentUser.value.incomeMessage = false;

        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserController.currentUser.value.id.toString())
            .delete();
        chatController.getchatList();
        Get.to(PeopleList());
      }
    }

    // index 4 ,  for student  , go to people list , for teacher go to ProfilePagebottom Note : there is no idex > 3 for non register users at this stage
    else if (index == 4) {
      if (currentUserController.currentUser.value.userType == "student") {
        currentUserController.currentUser.value.incomeMessage = false;

        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserController.currentUser.value.id.toString())
            .delete();
        chatController.getchatList();
        Get.to(PeopleList());
      } else if (currentUserController.currentUser.value.userType ==
          "teacher") {
        Get.to(ProfilePageBottom());
      }
    }
    // index for student only , go to profile page bottom
    else if (index == 5) {
      if (currentUserController.currentUser.value.userType == "student") {
        Get.to(ProfilePageBottom());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Execute your function here before popping the screen
        // For example, you can call the checkUnreadMessages function
        currentUserController.currentUser.value.incomeMessage = false;

        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserController.currentUser.value.id.toString())
            .delete();
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
                appBar: simplAppbar(false),
                body: Center(
                  child: LoadingBouncingGrid.circle(
                    borderColor: mybrowonColor,
                    backgroundColor: Colors.white,
                  ),
                ));
          }

          if ((snapshot.hasData && snapshot.data!.exists) ||
              currentUserController.currentUser.value.incomeMessage) {
            // var data;
            // // Update rxMsg.currentuserid in the document
            // FirebaseFirestore.instance
            //     .collection('chats')
            //     .doc(chatDocId)
            //     .update({
            //   'rxMsg.$currentuserid': FieldValue.serverTimestamp(),
            // });

            return Obx(() => ConvexAppBar.badge({1: 3 > 0 ? '' : ''},
                    backgroundColor: Colors.white,
                    style: TabStyle.react,
                    items: [
                      TabItem(
                        activeIcon: Icon(Icons.home),
                        icon: Icon(Icons.home, color: Colors.grey),
                        //  title: 'home'.tr,
                      ),

                      TabItem(
                        //isIconBlend: true,

                        activeIcon: Icon(FlutterIslamicIcons.quran2),
                        icon: Icon(FlutterIslamicIcons.quran2,
                            color: Colors
                                .grey), //Image.asset("assets/icons/quran.png"),
                        // title: 'quran'.tr,
                      ),
                      if (currentUserController.currentUser.value.userType !=
                          "teacher")
                        TabItem(
                          activeIcon: Icon(Icons.search),
                          icon: Icon(Icons.search, color: Colors.grey),

                          //  ),
                          //  title: 'Search'.tr,
                        ),
                      if (currentUserController.currentUser.value.id != -1)
                        TabItem(
                          activeIcon: Icon(Icons.play_lesson),
                          icon: Icon(Icons.play_lesson, color: Colors.grey),
                          //  title: 'Next_sesion'.tr,
                        ),
                      if (currentUserController.currentUser.value.id != -1)
                        TabItem(
                          activeIcon: Icon(Icons.people),
                          icon: NewMessageIndicator(),
                          // title: currentUserController
                          //             .currentUser.value.userType ==
                          //         "teacher"
                          //     ? 'stud'.tr
                          //     : 'tech'.tr,
                        ),
                      TabItem(
                        activeIcon: Icon(Icons.menu),
                        icon: Icon(Icons.menu, color: Colors.grey),
                        // title: 'setting'
                      ),
                      // BottomNavigationBarItem(
                      //   icon: Icon(Icons.chat),
                      //   label: 'Chats',
                      // ),
                    ],
                    initialActiveIndex: myBottomBarCtrl
                        .selectedIndBottomBar.value, onTap: (index) {
                  tabFunc(index);
                }));
          } else {
            return Obx(() => ConvexAppBar.badge(
                  {1: 3 > 0 ? '' : ''},
                  backgroundColor: Colors.white,
                  style: TabStyle.react,
                  activeColor: myorangeColor,
                  items: [
                    TabItem(
                      activeIcon: Icon(Icons.home),
                      icon: Icon(Icons.home, color: Colors.grey),
                      // title: 'home'.tr,
                    ),
                    TabItem(
                      //isIconBlend: true,

                      activeIcon: Icon(FlutterIslamicIcons.quran2),
                      icon: Icon(FlutterIslamicIcons.quran2,
                          color: Colors
                              .grey), //Image.asset("assets/icons/quran.png"),
                      //  title: 'Quran'.tr,
                    ),
                    if (currentUserController.currentUser.value.userType !=
                        "teacher")
                      TabItem(
                        activeIcon: Icon(Icons.search),
                        icon: Icon(Icons.search, color: Colors.grey),

                        //  ),
                        //  title: 'Search'.tr,
                      ),
                    if (currentUserController.currentUser.value.id != -1)
                      TabItem(
                        activeIcon: Icon(Icons.play_lesson_outlined),
                        icon: Icon(Icons.play_lesson_outlined,
                            color: Colors.grey),
                        // title: 'next_s'.tr,
                      ),
                    if (currentUserController.currentUser.value.id != -1)
                      TabItem(
                        activeIcon: Icon(Icons.people),
                        icon: Icon(Icons.people, color: Colors.grey),
                        //  title: 'list',
                      ),
                    TabItem(
                      activeIcon: Icon(Icons.menu),
                      icon: Icon(Icons.menu, color: Colors.grey),
                      //  title: 'setting'
                    ),
                  ],
                  initialActiveIndex:
                      myBottomBarCtrl.selectedIndBottomBar.value,
                  onTap: (index) {
                    tabFunc(index);
                  },
                ));
          }
        },
      ),
    );
  }
}
