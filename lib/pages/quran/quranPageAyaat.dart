import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/quran/pdfview2.dart';
import 'package:quranschool/pages/quran/quranPageFlash.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class QuranPageAyaat extends StatefulWidget {
  const QuranPageAyaat({super.key});

  @override
  State<QuranPageAyaat> createState() => _QuranPageAyaatState();
}

class _QuranPageAyaatState extends State<QuranPageAyaat> {
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
        Uri.parse('https://quran.ksu.edu.sa/m.php#aya=1_1'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Get.to(QuranPage());
              } else if (value == 'page2') {
                // Navigate to Page 2
                Get.to(PdfView2());
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'page1',
                child: Text('open_use_falsh'.tr),
              ),
              PopupMenuItem<String>(
                value: 'page3',
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
    );
  }
}
