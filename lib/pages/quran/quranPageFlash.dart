import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPageAyaat.dart';
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
