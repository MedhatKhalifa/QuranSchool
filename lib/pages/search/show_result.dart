import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/search/controller/search_controller.dart';
import 'package:quranschool/pages/search/detail_search.dart';
import 'package:quranschool/pages/search/show_item.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';

class ShowResult extends StatefulWidget {
  const ShowResult({super.key});

  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  final SearchController1 searchController = Get.put(SearchController1());
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //categoryController.getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 230, 222, 222),
      // drawer: Drawer(child: UserProfilePage(showbottombar: false)),
      appBar: simplAppbar(true, 'search_result'.tr),
      body: Obx(() => searchController.teachers.isNotEmpty
          ? ListView.builder(
              itemCount: searchController.teachers.length,
              itemBuilder: (BuildContext ctx, index) {
                return Column(children: [
                  //  if (index == 0) mystepper(1),
                  GestureDetector(
                      onTap: () {
                        subscribitionController.selectedTeacher.value =
                            searchController.teachers[index];
                        print(subscribitionController.selectedTeacher.value);

                        Get.to(DetailSearchTeacher());
                      },
                      child: showitem(searchController.teachers[index])),
                  if (index < searchController.teachers.length - 1)
                    Divider(color: Colors.grey[300], thickness: sp(1)),
                ]);
              })
          : Text('no_data'.tr)),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
