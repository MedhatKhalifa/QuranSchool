import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class QuranPage2 extends StatefulWidget {
  const QuranPage2({super.key});

  @override
  State<QuranPage2> createState() => _QuranPage2State();
}

class _QuranPage2State extends State<QuranPage2> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://quran.ksu.edu.sa/m.php#aya=1_1'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true, 'Quran'.tr),
      body: WebViewWidget(controller: _controller),
    );
  }
}
