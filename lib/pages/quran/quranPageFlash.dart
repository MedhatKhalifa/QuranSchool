import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPageAyaat.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    if (currentUserController.showTutorial.value.quran) {
      initTutorial();
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse('https://app.quranflash.com/book/Medina1?ar#/reader'),
      );
  }

  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  /// For Tutuorial
  ///
  final buttonKey = GlobalKey();
  TutorialCoachMark? tutorial;

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: "buttonKey",
        keyTarget: buttonKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "select different quran sources here".tr,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  late TutorialCoachMark tutorialCoachMark;
  void initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),

      /// alignSkip: Alignment.bottomRight,
      colorShadow: mybrowonColor,
      textSkip: "Don't show Again",
      paddingFocus: 10,
      opacityShadow: 0.8,
      //focusAnimationDuration: Duration(milliseconds: 30),
      // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      // onFinish: () {
      //   print("finish");
      // },
      // onClickTarget: (target) {
      //   print('onClickTarget: $target');
      // },
      // onClickTargetWithTapPosition: (target, tapDetails) {
      //   print("target: $target");
      //   print(
      //       "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      // },
      // onClickOverlay: (target) {
      //   print('onClickOverlay: $target');
      // },
      onSkip: () {
        currentUserController.showTutorial.value.quran = false;
        storeTutorialData(
            currentUserController.showTutorial.value, 'showTutorial');
        return true;
      },
    )..show(context: context);
  }

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
        appBar: AppBar(
          automaticallyImplyLeading: false,

          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //elevation: 0, // 2

          centerTitle: true,
          title: Text('Quran'.tr, style: const TextStyle(color: Colors.white)),
          actions: [
            PopupMenuButton<String>(
              key: buttonKey,
              onSelected: (value) {
                if (value == 'page1') {
                  // Navigate to Page 1
                  Get.to(QuranPageAyaat());
                } else if (value == 'page2') {
                  // Navigate to Page 2
                  Get.to(PdfView2());
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'page1',
                  child: Text('open_use_ayaat'.tr),
                ),
                PopupMenuItem<String>(
                  value: 'page2',
                  child: Text('open_use_file'.tr),
                ),
              ],
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: LoadingBouncingGrid.circle(
                  borderColor: mybrowonColor,
                  backgroundColor: Colors.white,
                ),
              )
            : WebViewWidget(controller: _controller),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
