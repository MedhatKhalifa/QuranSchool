import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';

import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

class QuestionShow extends StatefulWidget {
  const QuestionShow({Key? key}) : super(key: key);

  @override
  State<QuestionShow> createState() => _QuestionShowState();
}

class _QuestionShowState extends State<QuestionShow> {
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  // // Add a TextEditingController for the search query
  final TextEditingController searchController = TextEditingController();

// // Function to filter friends based on search query in username or name
//   List<StudSubModel> filterFriends(String query) {
//     return chatController.studSubdata
//         .where((friend) =>
//             friend.friendUsername.toLowerCase().contains(query.toLowerCase()) ||
//             friend.friendtName.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }

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
        appBar: simplAppbar(true, "qna".tr),
        body: Column(
          children: [
            SizedBox(height: h(2)),
            Text('Popular_Questions'.tr),
            SizedBox(height: h(2)),
            // Add a TextField for search
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: searchController,
            //     onChanged: (query) {
            //       // Update the list of friends when the search query changes
            //       chatController.updateFilteredFriends(filterFriends(query));
            //     },
            //     decoration: InputDecoration(
            //       labelText: 'search_name'.tr,
            //       prefixIcon: Icon(Icons.search),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Obx(
                () => currentUserController.isQuesLoading.value == true
                    ? Center(
                        child: LoadingBouncingGrid.circle(
                          borderColor: mybrowonColor,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        itemCount: currentUserController.questionsList.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text(Get.locale?.languageCode == 'ar'
                                ? currentUserController
                                    .questionsList[index].questionAr!
                                : currentUserController
                                    .questionsList[index].question!),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Get.locale?.languageCode == 'ar'
                                    ? currentUserController
                                        .questionsList[index].answerAr!
                                    : currentUserController
                                        .questionsList[index].answer!),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        //bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
