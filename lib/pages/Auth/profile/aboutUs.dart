import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/home_page/controller/home_controller.dart';

import '../../common_widget/mybottom_bar/my_bottom_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true),
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                Get.locale?.languageCode == 'ar'
                    ? homePageController.homePage.value.contentAr
                    : homePageController.homePage.value.contentEn,
                style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
