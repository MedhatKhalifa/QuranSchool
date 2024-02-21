import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('sure_exit'.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'.tr),
              ),
              TextButton(
                onPressed: () => exit(0), // Navigator.of(context).pop(true),
                child: Text('Yes'.tr),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        // drawer: Drawer(child: UserProfilePage(showbottombar: false)),
        appBar: simplAppbar(false, 'Home'.tr),
        body: ListView(
          children: [
            homePageController.homePage.value.image != ''
                ? ClipRRect(
                    //borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                    width: w(60),
                    height: h(60),
                    fit: BoxFit.fill,
                    imageUrl: homePageController.homePage.value.image
                            .contains('media')
                        ? '${homePageController.homePage.value.image}'
                        : db_url +
                            "media/" +
                            '${homePageController.homePage.value.image}',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.all(120),
                      child: LoadingBouncingGrid.circle(
                        borderColor: mybrowonColor,
                        backgroundColor: Colors.white,
                        // borderSize: 3.0,
                        // size: sp(20),
                        // backgroundColor: Color(0xff112A04),
                        //  duration: Duration(milliseconds: 500),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: w(60),
                      height: h(60),
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
            SizedBox(height: h(3)),
            ExpansionTile(
              textColor: Colors.black,
              initiallyExpanded: true,
              title: Center(
                child: Text(
                    Get.locale?.languageCode == 'ar'
                        ? homePageController.homePage.value.titleAr
                        : homePageController.homePage.value.titleEn,
                    style: TextStyle(color: Colors.black)),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      Get.locale?.languageCode == 'ar'
                          ? homePageController.homePage.value.contentAr
                          : homePageController.homePage.value.contentEn,
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: h(5)),
              ],
            )
          ],
        ),

        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String title;
  final String description;

  ExpandableText({required this.title, required this.description});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.description,
          maxLines: _expanded ? null : 3, // Display only 3 lines initially
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded; // Toggle expansion state
            });
          },
          child: Text(
            _expanded ? 'Show less' : 'Show more',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
