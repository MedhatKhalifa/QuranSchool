import 'package:badges/badges.dart' as badge;
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/register/register_page.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

import 'package:quranschool/pages/quran/quranPage%20copy.dart';
import 'package:quranschool/pages/quran/quranPage.dart';
import 'package:quranschool/pages/quran/selectionQuran.dart';
import 'package:quranschool/pages/search/search_page2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/teacher/studentSearch/searchStudent.dart';
import 'package:quranschool/pages/sessions/sessionsShow.dart';

import '../../Auth/controller/currentUser_controller.dart';
import '../../Auth/profile/profile_page.dart';

import 'bottom_bar_controller.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
final CurrentUserController currentUserController =
    Get.put(CurrentUserController());

mybottomBarWidget() {
  return Obx(() => ConvexAppBar.badge(
        {1: 3 > 0 ? '' : ''},
        backgroundColor: Colors.white,
        style: TabStyle.textIn,
        items: [
          TabItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home, color: Colors.grey),
            title: 'home'.tr,
          ),
          TabItem(
            activeIcon: Icon(Icons.search),
            icon:

                // Badge(
                //     showBadge: cartController.cartIDList.length > 0,
                //     badgeContent: Text(cartController.cartIDList.length.toString()),
                //     child:

                Icon(Icons.search, color: Colors.grey),

            //  ),
            title: 'Search'.tr,
          ),

          TabItem(
            activeIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month, color: Colors.grey),
            title: 'calendar'.tr,
          ),
          TabItem(
            //isIconBlend: true,

            activeIcon: Icon(FlutterIslamicIcons.quran2),
            icon: Icon(FlutterIslamicIcons.quran2,
                color: Colors.grey), //Image.asset("assets/icons/quran.png"),
            title: 'quran'.tr,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        initialActiveIndex: myBottomBarCtrl.selectedIndBottomBar.value,
        onTap: (index) {
          myBottomBarCtrl.selectedIndBottomBar.value = index;
          if (index == 0) {
            Get.to(const HomePage());
          } else if (index == 1) {
            currentUserController.currentUser.value.userType == "teacher"
                ? Get.to(SearchStudent())
                : Get.to(SearchPage2());
          } else if (index == 2) {
            subscribitionController.getSessionsbyteaherID(
                currentUserController.currentUser.value.id,
                currentUserController.currentUser.value.userType);
            Get.to(SessionsShow());

            // Get.to(UserProfilePage(showbottombar: true));
          } else if (index == 3) {
            Get.to(const QuranSelection());
          }
        },
      ));
}

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
