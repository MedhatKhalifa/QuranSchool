import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/search/search_page.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  final _introKey = GlobalKey<IntroductionScreenState>();
  String _status = 'Waiting...';
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      // 2. Pass that key to the `IntroductionScreen` `key` param
      key: _introKey,
      // onSkip: () {},
      // skip: Text('Done'),
      // showSkipButton: true,
      skipStyle: TextButton.styleFrom(alignment: Alignment.bottomCenter),
      globalFooter: Column(
        children: [
          Text(
            '@2023, MADRASET AL-QURAN, All Rights Reserved',
            style: TextStyle(fontSize: 7, color: Colors.white),
          ),
          SizedBox(height: sp(8)),
          Center(
            child: GestureDetector(
              onTap: () {
                myBottomBarCtrl.selectedIndBottomBar.value = 0;
                Get.to(HomePage());
              },
              child: SizedBox(
                // width: 100,
                // height: 100,
                child: Image.asset(
                  'assets/images/intro/intro_skip.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      pages: [
        PageViewModel(
          title: "",
          image: Image.asset(
            'assets/images/intro/intro1.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          //body: "",
          body: "",
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 1,
            //imageFlex: 10000000,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          image: Image.asset(
            'assets/images/intro/intro22.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          //body: "",
          bodyWidget: Column(
            children: [
              Text(
                'intro_11'.tr,
                style: TextStyle(
                    fontSize: 29,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'intro_11'.tr,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 3,
            imageFlex: 1,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          image: Image.asset(
            'assets/images/intro/intro33.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          //body: "",
          bodyWidget: Column(
            children: [
              Text(
                'intro_21'.tr,
                style: TextStyle(
                    fontSize: 29,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'intro_22'.tr,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 8,
            imageFlex: 1,
            safeArea: 100,
          ),
        ),
      ],
      showNextButton: false,
      showDoneButton: false,
    );
  }
}
